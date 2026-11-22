import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../domain/models.dart';

/// One bill line in the live cart.
///
/// PRICE SNAPSHOT RULE: [pricePaise] and [serviceName] are copied from the
/// catalog at the moment the service is FIRST added to this bill. Later
/// catalog price changes never alter an existing line — not even when the
/// same service is tapped again (the quantity grows, the snapshot stays).
class CartLine {
  const CartLine({
    required this.serviceId,
    required this.serviceName,
    required this.pricePaise,
    required this.durationMinutes,
    required this.quantity,
    this.employeeId,
    this.employeeName,
  });

  final String serviceId;
  final String serviceName;

  /// Snapshot price in paise — see the rule above.
  final int pricePaise;
  final int durationMinutes;
  final int quantity;

  /// Employee performing this service (Task 3), assigned in the bill
  /// panel. The name is snapshotted alongside the id so finalized
  /// invoices stay correct if the employee is later renamed.
  final String? employeeId;
  final String? employeeName;

  int get totalPaise => pricePaise * quantity;

  CartLine copyWith({
    int? quantity,
    String? employeeId,
    String? employeeName,
    bool clearEmployee = false,
  }) =>
      CartLine(
        serviceId: serviceId,
        serviceName: serviceName,
        pricePaise: pricePaise,
        durationMinutes: durationMinutes,
        quantity: quantity ?? this.quantity,
        employeeId: clearEmployee ? null : (employeeId ?? this.employeeId),
        employeeName:
            clearEmployee ? null : (employeeName ?? this.employeeName),
      );
}

/// Immutable cart state. Totals are ALWAYS derived through [MoneyEngine] —
/// the single calculation path — so no stale or divergent totals can exist.
class CartState {
  const CartState({
    this.draftId,
    this.lines = const [],
    this.discountPercent = 0,
    this.flatDiscountPaise = 0,
    this.taxBasisPoints = 0,
    this.billingEmployeeId,
    this.billingEmployeeName,
    this.customerName = '',
    this.customerPhone = '',
    this.customerNotes = '',
  });

  /// Unique id of this bill draft, assigned on the first add. Checkout
  /// submission is idempotent on this id. Null while the cart is empty.
  final String? draftId;

  /// Insertion-ordered lines — the bill panel reads top-to-bottom in the
  /// order services were first tapped.
  final List<CartLine> lines;

  /// Whole-percent discount (0–100) and flat discount in paise, applied
  /// by the money engine in its fixed order (percent, then flat, both
  /// clamped at the subtotal).
  final int discountPercent;
  final int flatDiscountPaise;

  /// Tax rate in basis points (e.g. 1800 = 18% GST), applied by the
  /// engine on the discounted amount.
  final int taxBasisPoints;

  /// Billing session (Task 5.1): the employee handling this bill,
  /// chosen on the "Who's billing?" screen. The ID is the identifier —
  /// the name rides along as a display/snapshot convenience. New lines
  /// default to this employee (per-line override stays available).
  final String? billingEmployeeId;
  final String? billingEmployeeName;

  /// Customer captured on the Customer Details screen. Name + mobile
  /// are required by the new flow; notes are optional. All three are
  /// stored on the draft and frozen into the invoice snapshot.
  final String customerName;
  final String customerPhone;
  final String customerNotes;

  /// True once the flow has captured anything worth persisting even
  /// with zero lines (an employee and/or a customer). The autosaver
  /// uses this: a session-only draft is real work, not an empty cart.
  bool get hasSession =>
      billingEmployeeId != null ||
      customerName.isNotEmpty ||
      customerPhone.isNotEmpty;

  bool get isEmpty => lines.isEmpty;
  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  /// Full totals via the money engine (validates every line).
  BillTotals get totals => MoneyEngine.calculate(
        lines: [
          for (final l in lines)
            PricedLine(pricePaise: l.pricePaise, quantity: l.quantity),
        ],
        discountPercent: discountPercent,
        flatDiscountPaise: flatDiscountPaise,
        taxBasisPoints: taxBasisPoints,
      );

  int get subtotalPaise => totals.subtotalPaise;
  int get discountPaise => totals.discountPaise;
  int get taxPaise => totals.taxPaise;

  /// Total via the money engine (validates every line on the way).
  int get totalPaise => totals.totalPaise;

  CartState copyWith({
    String? draftId,
    List<CartLine>? lines,
    int? discountPercent,
    int? flatDiscountPaise,
    int? taxBasisPoints,
    String? billingEmployeeId,
    String? billingEmployeeName,
    bool clearBillingEmployee = false,
    String? customerName,
    String? customerPhone,
    String? customerNotes,
  }) =>
      CartState(
        draftId: draftId ?? this.draftId,
        lines: lines ?? this.lines,
        discountPercent: discountPercent ?? this.discountPercent,
        flatDiscountPaise: flatDiscountPaise ?? this.flatDiscountPaise,
        taxBasisPoints: taxBasisPoints ?? this.taxBasisPoints,
        billingEmployeeId: clearBillingEmployee
            ? null
            : (billingEmployeeId ?? this.billingEmployeeId),
        billingEmployeeName: clearBillingEmployee
            ? null
            : (billingEmployeeName ?? this.billingEmployeeName),
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        customerNotes: customerNotes ?? this.customerNotes,
      );

  /// Total quantity of a service across ALL price variants (the billing
  /// tile badge). A service can appear on several lines when its catalog
  /// price changed mid-bill — see the snapshot policy on [CartNotifier].
  int quantityOf(String serviceId) {
    var total = 0;
    for (final line in lines) {
      if (line.serviceId == serviceId) total += line.quantity;
    }
    return total;
  }

  /// Quantity of one specific (service, snapshot price) line.
  int quantityOfLine(String serviceId, int pricePaise) {
    for (final line in lines) {
      if (line.serviceId == serviceId && line.pricePaise == pricePaise) {
        return line.quantity;
      }
    }
    return 0;
  }
}

/// Cart operations — pure, sequential state transitions. Rapid consecutive
/// taps are applied one by one in event order; a [StateNotifier] never
/// drops or merges them.
///
/// PRICE-SNAPSHOT POLICY (Task 2, deterministic): a line is identified by
/// (serviceId, snapshotPrice). Tapping a service increments the line whose
/// snapshot equals the CURRENT catalog price. If the catalog price changed
/// since the service was first added, the tap creates a SEPARATE line at
/// the new price — the existing line keeps its original snapshot, and the
/// two prices are never silently merged. Steppers in the bill panel act
/// on a specific line via the *Line operations.
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  /// Tapping a service tile: increments the line at the service's
  /// CURRENT price, or appends a new line snapshotting that price.
  void addService(ServiceItem service) {
    MoneyEngine.validateLine(service.pricePaise, 1);
    final index = state.lines.indexWhere(
      (l) => l.serviceId == service.id && l.pricePaise == service.pricePaise,
    );
    if (index == -1) {
      state = state.copyWith(
        draftId: state.draftId ?? newDraftId(),
        lines: [
          ...state.lines,
          CartLine(
            serviceId: service.id,
            serviceName: service.name,
            pricePaise: service.pricePaise,
            durationMinutes: service.durationMinutes,
            quantity: 1,
            // The billing-session employee performs new services by
            // default (Task 5.1); the bill panel can override per line.
            employeeId: state.billingEmployeeId,
            employeeName: state.billingEmployeeName,
          ),
        ],
      );
    } else {
      incrementLine(service.id, service.pricePaise);
    }
  }

  /// Steps one specific (service, snapshot price) line up.
  void incrementLine(String serviceId, int pricePaise) {
    state = state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.serviceId == serviceId && line.pricePaise == pricePaise)
            line.copyWith(
              quantity: line.quantity + 1 > MoneyLimits.maxQuantity
                  ? MoneyLimits.maxQuantity
                  : line.quantity + 1,
            )
          else
            line,
      ],
    );
  }

  /// Steps one specific line down; the final unit removes that line.
  void decrementLine(String serviceId, int pricePaise) {
    final lines = <CartLine>[
      for (final line in state.lines)
        if (line.serviceId != serviceId || line.pricePaise != pricePaise)
          line
        else if (line.quantity > 1)
          line.copyWith(quantity: line.quantity - 1),
    ];
    state = state.copyWith(
      draftId: lines.isEmpty ? null : state.draftId,
      lines: lines,
    );
  }

  /// Removes one specific line entirely.
  void removeLineAt(String serviceId, int pricePaise) {
    final lines = state.lines
        .where((l) => l.serviceId != serviceId || l.pricePaise != pricePaise)
        .toList();
    state = state.copyWith(
      draftId: lines.isEmpty ? null : state.draftId,
      lines: lines,
    );
  }

  /// Legacy single-id step-up: acts on the FIRST line of the service.
  /// The bill panel uses [incrementLine] for exact line control.
  void increment(String serviceId) {
    final index = state.lines.indexWhere((l) => l.serviceId == serviceId);
    if (index == -1) return;
    final line = state.lines[index];
    incrementLine(line.serviceId, line.pricePaise);
  }

  /// Legacy single-id step-down on the FIRST line of the service;
  /// decreasing its final unit removes that line.
  void decrement(String serviceId) {
    final index = state.lines.indexWhere((l) => l.serviceId == serviceId);
    if (index == -1) return;
    final line = state.lines[index];
    decrementLine(line.serviceId, line.pricePaise);
  }

  /// Removes ALL lines of the service (every price variant).
  void removeLine(String serviceId) {
    final lines =
        state.lines.where((l) => l.serviceId != serviceId).toList();
    state = state.copyWith(
      draftId: lines.isEmpty ? null : state.draftId,
      lines: lines,
    );
  }

  /// Assigns (or clears) the employee performing one exact line.
  void setLineEmployee(
    String serviceId,
    int pricePaise, {
    String? employeeId,
    String? employeeName,
  }) {
    state = state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.serviceId == serviceId && line.pricePaise == pricePaise)
            employeeId == null
                ? line.copyWith(clearEmployee: true)
                : line.copyWith(
                    employeeId: employeeId,
                    employeeName: employeeName,
                  )
          else
            line,
      ],
    );
  }

  /// Sets the whole-percent discount (0–100). Owner-authorized in the
  /// UI; the engine clamps the result at the subtotal regardless.
  void setDiscountPercent(int percent) {
    if (percent < 0 || percent > 100) {
      throw ArgumentError.value(percent, 'percent', 'must be 0..100');
    }
    state = state.copyWith(discountPercent: percent);
  }

  void setFlatDiscountPaise(int paise) {
    if (paise < 0) {
      throw ArgumentError.value(paise, 'paise', 'must not be negative');
    }
    state = state.copyWith(flatDiscountPaise: paise);
  }

  void setTaxBasisPoints(int bp) {
    if (bp < 0 || bp > 10000) {
      throw ArgumentError.value(bp, 'bp', 'must be 0..10000');
    }
    state = state.copyWith(taxBasisPoints: bp);
  }

  /// Starts (or updates) the billing session: who is billing. Assigns
  /// a draft id when the session is the first thing captured, so the
  /// session itself is autosaved before any service is added.
  void setBillingEmployee(String employeeId, String employeeName) {
    state = state.copyWith(
      draftId: state.draftId ?? newDraftId(),
      billingEmployeeId: employeeId,
      billingEmployeeName: employeeName,
    );
  }

  void clearBillingEmployee() {
    state = state.copyWith(clearBillingEmployee: true);
  }

  /// Stores the customer captured by the Customer Details screen.
  void setCustomer({
    required String name,
    required String phone,
    String notes = '',
  }) {
    state = state.copyWith(
      draftId: state.draftId ?? newDraftId(),
      customerName: name.trim(),
      customerPhone: phone.trim(),
      customerNotes: notes.trim(),
    );
  }

  void clear() => state = const CartState();

  /// Replaces the cart with a recovered/resumed draft (crash recovery on
  /// startup, or the receptionist picking a saved draft). The draft keeps
  /// its id, so further edits keep saving to the same draft.
  void restore(CartState draft) => state = draft;
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
