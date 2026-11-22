import '../branding/studio_branding.dart';
import '../features/billing/cart.dart';
import 'models.dart';

/// Repository interfaces — the seam between UI/state and data.
/// Task 1.6 ships in-memory demo implementations behind these interfaces;
/// the next tasks plug Drift (local cache/outbox) and Dio (Spring Boot API)
/// implementations in without touching feature code.

abstract interface class StudioConfigRepository {
  Future<StudioBranding?> load();
  Future<void> save(StudioBranding branding);
  Stream<StudioBranding?> watch();
}

/// A catalog rule was violated (duplicate name, invalid price, ...).
/// Carries a message written for the studio owner, not a stack trace.
class CatalogValidationException implements Exception {
  CatalogValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class ServiceRepository {
  /// Active services in ACTIVE categories, in display order — exactly
  /// what the billing screen may sell.
  Future<List<ServiceItem>> listActive();

  /// Every service including inactive ones (management screen).
  Future<List<ServiceItem>> listAll();

  /// Validates (name, price, duplicate-active-name-in-category) and
  /// inserts or updates. Throws [CatalogValidationException].
  Future<void> upsert(ServiceItem service);

  Future<void> deactivate(String serviceId);
  Future<void> reactivate(String serviceId);

  Future<List<ServiceCategory>> listCategories();

  /// Creates or renames a category. Throws [CatalogValidationException]
  /// on an empty or duplicate (normalized) name.
  Future<void> upsertCategory(ServiceCategory category);

  Future<void> setCategoryActive(String categoryId, bool active);

  /// Persists display order: the ids' list position becomes sortOrder.
  Future<void> reorderCategories(List<String> orderedIds);
  Future<void> reorderServices(List<String> orderedIds);
}

/// One payment to record at finalization (checkout collects these;
/// confirmation may happen now or later from billing history).
class PaymentDraft {
  const PaymentDraft({
    required this.id,
    required this.method,
    required this.amountPaise,
    this.status = PaymentStatus.pending,
    this.confirmedBy,
    this.confirmedAt,
  });

  final String id;
  final PaymentMethod method;
  final int amountPaise;
  final PaymentStatus status;
  final String? confirmedBy;
  final DateTime? confirmedAt;
}

abstract interface class BillingRepository {
  /// Atomically finalizes a cart draft into an immutable invoice:
  /// totals are recomputed through the money engine, the bill, lines,
  /// payments and audit event are written in ONE transaction, and the
  /// draft is deleted in the same transaction. IDEMPOTENT on the
  /// draft id — finalizing the same draft twice returns the original
  /// bill. The provisional reference is local-only.
  Future<FinalizedBill> finalizeDraft({
    required CartState cart,
    required StudioSnapshot studio,
    required int studioPrimaryColor,
    required List<PaymentDraft> payments,
    required String actor,
    String customerName = '',
  });

  Future<List<FinalizedBill>> listBills({
    String? query,
    PaymentStatus? paymentStatus,
    FinalizedBillStatus? status,
    DateTime? from,
    DateTime? to,
    int limit = 200,
  });

  Future<FinalizedBill?> getBill(String id);

  /// Voids a finalized bill with a reason and an audit record. Bills
  /// are never deleted.
  Future<FinalizedBill> voidBill(
    String billId, {
    required String reason,
    required String actor,
  });

  /// Manually confirms one pending payment (records who + when) and
  /// recomputes the bill's payment status. Never marks anything as
  /// provider-verified.
  Future<FinalizedBill> confirmPayment(
    String billId,
    String paymentId, {
    required String actor,
  });

  Future<List<BillingAuditEvent>> auditFor(String billId);
}

abstract interface class EmployeeRepository {
  Future<List<Employee>> listActive();
  Future<List<Employee>> listAll();
  Future<Employee?> getById(String id);
  Future<void> upsert(Employee employee);
  Future<void> setActive(String id, bool isActive);
}

abstract interface class AttendanceRepository {
  /// Records for one studio-local date, keyed by employee id.
  Future<Map<String, AttendanceRecord>> recordsForDate(String dateKey);

  /// All records in a month (optionally for one employee).
  Future<List<AttendanceRecord>> recordsForMonth(
    int year,
    int month, {
    String? employeeId,
  });

  /// Marks (or corrects) one employee's attendance for one date.
  /// Exactly one record exists per employee per date; changing an
  /// existing record writes an audit entry with the old status.
  /// Nothing is ever auto-marked.
  Future<AttendanceRecord> mark({
    required String employeeId,
    required String dateKey,
    required AttendanceStatus status,
    required String actor,
  });

  Future<MonthlyAttendanceSummary> monthlySummary(
    String employeeId,
    int year,
    int month,
  );

  Future<List<AttendanceAuditEntry>> auditFor(
    String employeeId,
    String dateKey,
  );
}

abstract interface class AdvanceRepository {
  /// Records an advance. IDEMPOTENT on the advance id: re-submitting
  /// the same id returns the stored entry instead of duplicating it.
  Future<SalaryAdvance> record(SalaryAdvance advance);

  /// Creates a reversal entry for an advance. The original is never
  /// modified or deleted. Reversing twice, or reversing a reversal,
  /// is rejected.
  Future<SalaryAdvance> reverse(
    String advanceId, {
    required String actor,
    String? notes,
  });

  /// Ledger entries (including reversals) in a business-date range,
  /// newest first.
  Future<List<SalaryAdvance>> listForEmployee(
    String employeeId, {
    String? fromKey,
    String? toKey,
  });

  /// Net advances in a business-date range (reversals subtract).
  Future<int> totalForPeriod(
    String employeeId, {
    required String fromKey,
    required String toKey,
  });
}

/// Payment provider seam. The production adapter talks to the STUDIO'S OWN
/// merchant setup (their UPI PSP/soundbox provider) — customer payments are
/// never routed to a StudioFlow account.
abstract interface class PaymentProviderAdapter {
  /// Returns an opaque payload to render as a QR for [amountPaise], or null
  /// when no verified merchant configuration exists yet.
  Future<String?> upiPayload({
    required int amountPaise,
    required String note,
  });

  /// Demo adapter: deliberately returns a placeholder marker, never a real
  /// payable VPA payload.
  factory PaymentProviderAdapter.demo() => _DemoPaymentAdapter();
}

class _DemoPaymentAdapter implements PaymentProviderAdapter {
  @override
  Future<String?> upiPayload({
    required int amountPaise,
    required String note,
  }) async {
    // NOT a payment payload. The checkout UI renders this marker as a
    // clearly labelled DEMO QR placeholder.
    return 'DEMO-QR-PLACEHOLDER';
  }
}

/// Monthly payroll (Task 5). All money integer paise; all state
/// changes transactional; approval is idempotent and consumes each
/// salary advance exactly once (database-enforced links).
abstract interface class PayrollRepository {
  /// Current rules + review state (defaults created on first read).
  Future<PayrollSettingsState> getSettings();

  /// Saves rules. [markReviewed] records the owner's review — the
  /// first payroll cannot be approved before that.
  Future<void> saveSettings(
    PayrollRules rules, {
    required bool markReviewed,
  });

  /// Live preview for a period from current attendance/rules and
  /// unconsumed advances. Nothing is persisted.
  Future<List<PayrollPreviewLine>> preview(String periodKey);

  /// Returns the period's existing draft, or creates one (stable id,
  /// no duplicates) with lines computed from the current preview.
  Future<PayrollRun> getOrCreateDraft(String periodKey, String actor);

  Future<PayrollRun?> getRun(String runId);
  Future<List<PayrollRun>> listRuns({String? periodKey});
  Future<List<PayrollLine>> linesFor(String runId);
  Future<List<PayrollAdjustment>> adjustmentsFor(String runId);
  Future<List<PayrollPayment>> paymentsFor(String runId);

  /// Recomputes a draft's lines from live attendance/rules,
  /// preserving overtime and adjustments. Draft only.
  Future<void> refreshDraft(String runId);

  /// Sets a draft line's overtime (day-units in basis points).
  Future<void> setOvertime(String runId, String employeeId, int unitsBp);

  /// Adds a bonus/deduction to a draft line. Idempotent on
  /// [adjustment.id].
  Future<PayrollAdjustment> addAdjustment(PayrollAdjustment adjustment);

  /// Removes an adjustment from a draft line.
  Future<void> removeAdjustment(String adjustmentId);

  /// Approves a draft: freezes rules + figures, links the period's
  /// advances (each consumed exactly once), and requires the rules
  /// to have been reviewed. Throws if attendance is incomplete and
  /// [acknowledgeIncomplete] is false.
  Future<PayrollRun> approve(
    String runId,
    String actor, {
    bool acknowledgeIncomplete = false,
  });

  /// Records a salary settlement payment (idempotent on id). Never
  /// lets paid exceed the line's net; flips the run to partially
  /// paid / paid as the balance settles.
  Future<PayrollPayment> recordPayment(PayrollPayment payment);

  /// Voids a draft or an approved-but-unpaid run, releasing its
  /// advance links. Paid/partially-paid runs cannot be voided.
  Future<void> voidRun(String runId, String actor, String reason);

  /// Voids an approved, unpaid run and creates the next-version
  /// draft for the same period. Returns the new draft.
  Future<PayrollRun> revise(String runId, String actor);
}
