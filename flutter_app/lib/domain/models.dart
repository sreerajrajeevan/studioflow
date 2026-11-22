import 'package:flutter/foundation.dart';

import '../core/payroll_engine.dart';

export '../core/payroll_engine.dart'
    show PayrollRules, PayrollCounts, PayrollComputation, SalaryBasis;

/// Domain models — same shapes as the Kotlin generation (legacy-android),
/// so the future backend contract is unchanged. Money is integer paise.

@immutable
class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePaise,
    required this.durationMinutes,
    this.isActive = true,
    this.categoryId,
    this.description,
    this.sortOrder = 0,
  });

  final String id;
  final String name;

  /// Category display name (denormalized for rendering).
  final String category;

  /// Stable category id (slug). Null for purely in-memory sample items.
  final String? categoryId;
  final int pricePaise;
  final int durationMinutes;
  final bool isActive;
  final String? description;

  /// Display order within the category (persisted; owner-arrangeable).
  final int sortOrder;

  ServiceItem copyWith({
    String? name,
    String? category,
    String? categoryId,
    int? pricePaise,
    int? durationMinutes,
    bool? isActive,
    String? description,
    int? sortOrder,
  }) =>
      ServiceItem(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        categoryId: categoryId ?? this.categoryId,
        pricePaise: pricePaise ?? this.pricePaise,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        isActive: isActive ?? this.isActive,
        description: description ?? this.description,
        sortOrder: sortOrder ?? this.sortOrder,
      );
}

/// A service category (Task 2). Ids are stable slugs: renaming a category
/// changes its display name only, never the id services point at.
@immutable
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String id;
  final String name;
  final int sortOrder;
  final bool isActive;

  ServiceCategory copyWith({String? name, int? sortOrder, bool? isActive}) =>
      ServiceCategory(
        id: id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
      );
}

@immutable
class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.role,
    this.phone = '',
    this.salaryType = SalaryType.monthly,
    this.monthlySalaryPaise = 0,
    this.isActive = true,
    this.joiningDate,
    this.photoPath,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final SalaryType salaryType;

  /// Base salary in integer paise — per month for [SalaryType.monthly],
  /// per day for [SalaryType.daily]. Payroll math lives in Task 5;
  /// this task only stores the rate faithfully.
  final int monthlySalaryPaise;
  final bool isActive;
  final DateTime? joiningDate;

  /// Local file path of an optional profile photo (picker wiring is a
  /// later concern; the field is stored end-to-end).
  final String? photoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Employee copyWith({
    String? name,
    String? role,
    String? phone,
    SalaryType? salaryType,
    int? monthlySalaryPaise,
    bool? isActive,
    DateTime? joiningDate,
    String? photoPath,
  }) =>
      Employee(
        id: id,
        name: name ?? this.name,
        role: role ?? this.role,
        phone: phone ?? this.phone,
        salaryType: salaryType ?? this.salaryType,
        monthlySalaryPaise: monthlySalaryPaise ?? this.monthlySalaryPaise,
        isActive: isActive ?? this.isActive,
        joiningDate: joiningDate ?? this.joiningDate,
        photoPath: photoPath ?? this.photoPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

/// One employee's attendance for one studio-local date. "Not marked"
/// is represented by the ABSENCE of a record, never by a status.
@immutable
class AttendanceRecord {
  const AttendanceRecord({
    required this.employeeId,
    required this.dateKey,
    required this.status,
    required this.markedBy,
    required this.markedAt,
    required this.updatedAt,
  });

  final String employeeId;

  /// Studio-local date, 'yyyy-MM-dd' (Asia/Kolkata).
  final String dateKey;
  final AttendanceStatus status;
  final String markedBy;
  final DateTime markedAt;
  final DateTime updatedAt;
}

/// An attendance marking/correction audit entry.
@immutable
class AttendanceAuditEntry {
  const AttendanceAuditEntry({
    required this.employeeId,
    required this.dateKey,
    this.oldStatus,
    required this.newStatus,
    required this.actor,
    required this.createdAt,
  });

  final String employeeId;
  final String dateKey;
  final AttendanceStatus? oldStatus;
  final AttendanceStatus newStatus;
  final String actor;
  final DateTime createdAt;
}

/// Counts for one employee in one month — the payroll-prep summary
/// (Task 5 consumes this; no salary math happens here). [unmarked]
/// counts elapsed days of the month with no record: for the current
/// month, up to today (studio-local); for past months, the whole
/// month; future months report 0 elapsed.
@immutable
class MonthlyAttendanceSummary {
  const MonthlyAttendanceSummary({
    required this.employeeId,
    required this.year,
    required this.month,
    required this.present,
    required this.absent,
    required this.halfDays,
    required this.leave,
    required this.unmarked,
  });

  final String employeeId;
  final int year;
  final int month;
  final int present;
  final int absent;
  final int halfDays;
  final int leave;
  final int unmarked;
}

enum AdvanceMethod { cash, upi, other }

/// A salary advance ledger entry (Task 4). Immutable: corrections are
/// separate reversal entries whose [reversalOfId] points here. An
/// entry's signed contribution to the ledger is +amount normally and
/// −amount for a reversal entry.
@immutable
class SalaryAdvance {
  const SalaryAdvance({
    required this.id,
    required this.employeeId,
    required this.amountPaise,
    required this.businessDateKey,
    required this.recordedAt,
    required this.method,
    this.notes,
    required this.recordedBy,
    this.reversalOfId,
  });

  final String id;
  final String employeeId;
  final int amountPaise;

  /// Studio-local business date, 'yyyy-MM-dd'.
  final String businessDateKey;
  final DateTime recordedAt;
  final AdvanceMethod method;
  final String? notes;
  final String recordedBy;

  /// Non-null when THIS entry reverses the entry with that id.
  final String? reversalOfId;

  bool get isReversal => reversalOfId != null;

  /// +amount for a normal advance, −amount for its reversal.
  int get signedPaise => isReversal ? -amountPaise : amountPaise;
}

enum SalaryType { monthly, daily }

enum AttendanceStatus { present, absent, halfDay, leave }

enum PaymentMethod { upi, cash, card }

enum BillStatus { paid, pending, cancelled, refunded }

@immutable
class BillLine {
  const BillLine({
    required this.serviceId,
    required this.serviceName,
    required this.pricePaise,
    this.quantity = 1,
    this.employeeId,
    this.employeeName,
    this.durationMinutes = 0,
  });

  final String serviceId;

  /// Copied at sale time — later catalog edits never rewrite a bill.
  final String serviceName;
  final int pricePaise;
  final int quantity;
  final String? employeeId;
  final String? employeeName;
  final int durationMinutes;

  int get lineTotalPaise => pricePaise * quantity;

  BillLine copyWith({int? quantity}) => BillLine(
        serviceId: serviceId,
        serviceName: serviceName,
        pricePaise: pricePaise,
        quantity: quantity ?? this.quantity,
        employeeId: employeeId,
        employeeName: employeeName,
        durationMinutes: durationMinutes,
      );
}

/// Immutable studio details frozen onto a bill at creation time.
/// See legacy-android/docs/INVOICE_SNAPSHOT.md for the full rule set.
@immutable
class StudioSnapshot {
  const StudioSnapshot({
    required this.businessName,
    this.tagline,
    this.address = '',
    this.phone = '',
    this.email,
    this.gstin,
    this.upiId,
    this.invoicePrefix = 'INV',
    this.invoiceFooter,
  });

  final String businessName;
  final String? tagline;
  final String address;
  final String phone;
  final String? email;
  final String? gstin;
  final String? upiId;
  final String invoicePrefix;
  final String? invoiceFooter;
}

/// Payment status — deliberately separate from the payment METHOD.
/// Manual confirmation is a human saying "I received it"; it is never
/// provider verification, and the two are never conflated in storage
/// or on the invoice.
enum PaymentStatus { pending, confirmedManual, verifiedProvider }

enum FinalizedBillStatus { finalized, voided }

/// One payment against a finalized bill (split payments = several).
@immutable
class BillPayment {
  const BillPayment({
    required this.id,
    required this.method,
    required this.amountPaise,
    this.status = PaymentStatus.pending,
    this.confirmedBy,
    this.confirmedAt,
    required this.createdAt,
  });

  final String id;
  final PaymentMethod method;
  final int amountPaise;
  final PaymentStatus status;
  final String? confirmedBy;
  final DateTime? confirmedAt;
  final DateTime createdAt;
}

/// An append-only audit record for a bill.
@immutable
class BillingAuditEvent {
  const BillingAuditEvent({
    required this.type,
    required this.actor,
    this.detail = '',
    required this.createdAt,
  });

  /// finalized | payment_confirmed | voided
  final String type;
  final String actor;
  final String detail;
  final DateTime createdAt;
}

/// A finalized, immutable invoice (Task 3). All studio/service values
/// are snapshots; [provisionalRef] is a local reference only — the
/// official number is assigned by the future backend.
@immutable
class FinalizedBill {
  const FinalizedBill({
    required this.id,
    required this.provisionalRef,
    required this.localSeq,
    required this.draftId,
    this.customerName = '',
    this.customerPhone = '',
    this.customerNotes = '',
    this.billingEmployeeId,
    this.billingEmployeeName,
    required this.studio,
    required this.studioPrimaryColor,
    required this.lines,
    required this.payments,
    required this.subtotalPaise,
    required this.discountPercent,
    required this.flatDiscountPaise,
    required this.discountPaise,
    required this.taxBasisPoints,
    required this.taxPaise,
    required this.totalPaise,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    required this.finalizedAt,
    this.voidedAt,
    this.voidReason,
    this.voidedBy,
  });

  /// Globally unique internal id.
  final String id;

  /// Local provisional reference, e.g. INV-2026-0007. NOT an official
  /// invoice number.
  final String provisionalRef;
  final int localSeq;

  /// The draft this bill was finalized from — its idempotency key.
  final String draftId;
  final String customerName;

  /// Customer phone/notes and the billing employee (Task 5.1),
  /// snapshotted at finalization. The employee NAME is the historical
  /// record; the id links back to the employee where still present.
  final String customerPhone;
  final String customerNotes;
  final String? billingEmployeeId;
  final String? billingEmployeeName;
  final StudioSnapshot studio;
  final int studioPrimaryColor;
  final List<BillLine> lines;
  final List<BillPayment> payments;
  final int subtotalPaise;
  final int discountPercent;
  final int flatDiscountPaise;
  final int discountPaise;
  final int taxBasisPoints;
  final int taxPaise;
  final int totalPaise;
  final FinalizedBillStatus status;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final DateTime finalizedAt;
  final DateTime? voidedAt;
  final String? voidReason;
  final String? voidedBy;

  /// Sum of payments recorded against this bill.
  int get paidPaise => payments.fold(0, (sum, p) => sum + p.amountPaise);

  /// Sum of CONFIRMED payments (manual or provider-verified).
  int get confirmedPaise => payments
      .where((p) => p.status != PaymentStatus.pending)
      .fold(0, (sum, p) => sum + p.amountPaise);
}

@immutable
class Bill {
  const Bill({
    required this.id,

    /// Null until the backend assigns the official number. Never invent one
    /// locally — offline bills stay "pending sync".
    this.invoiceNumber,
    required this.customerName,
    this.lines = const [],
    this.discountPaise = 0,
    required this.totalPaise,
    this.paymentMethod = PaymentMethod.cash,
    this.status = BillStatus.paid,
    required this.createdAt,
    this.studioSnapshot,
  });

  final String id;
  final String? invoiceNumber;
  final String customerName;
  final List<BillLine> lines;
  final int discountPaise;
  final int totalPaise;
  final PaymentMethod paymentMethod;
  final BillStatus status;
  final DateTime createdAt;
  final StudioSnapshot? studioSnapshot;
}

// ---------------------------------------------------------------------------
// Payroll (Task 5)
// ---------------------------------------------------------------------------

enum PayrollRunStatus { draft, approved, partiallyPaid, paid, voided }

/// One payroll run for one period. Figures live on its lines; the run
/// carries the workflow state and, once approved, the frozen rules.
class PayrollRun {
  const PayrollRun({
    required this.id,
    required this.periodKey,
    required this.version,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.rulesSnapshot,
    this.approvedBy,
    this.approvedAt,
    this.voidReason,
  });

  final String id;

  /// 'yyyy-MM' in studio-local time.
  final String periodKey;
  final int version;
  final PayrollRunStatus status;

  /// Rules frozen at approval; null while a draft.
  final PayrollRules? rulesSnapshot;
  final String createdBy;
  final DateTime createdAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? voidReason;
}

/// One employee's payroll line — a snapshot once the run is approved.
class PayrollLine {
  const PayrollLine({
    required this.id,
    required this.runId,
    required this.employeeId,
    required this.employeeName,
    required this.salaryType,
    required this.ratePaise,
    required this.counts,
    required this.payableUnitsBp,
    required this.basisDays,
    required this.earningsPaise,
    required this.overtimeUnitsBp,
    required this.overtimePaise,
    required this.bonusPaise,
    required this.deductionsPaise,
    required this.advancesPaise,
    required this.grossPaise,
    required this.netPaise,
    required this.carryForwardPaise,
    required this.paidPaise,
  });

  final String id;
  final String runId;
  final String employeeId;
  final String employeeName;
  final SalaryType salaryType;

  /// Monthly salary or daily wage, by [salaryType] — integer paise.
  final int ratePaise;
  final PayrollCounts counts;
  final int payableUnitsBp;
  final int basisDays;
  final int earningsPaise;
  final int overtimeUnitsBp;
  final int overtimePaise;

  /// Bonuses/incentives total.
  final int bonusPaise;

  /// Non-advance deductions total.
  final int deductionsPaise;

  /// Net advances deducted by this line (exactly once — advance
  /// links enforce it). May be negative when a previously deducted
  /// advance was reversed in this period.
  final int advancesPaise;
  final int grossPaise;
  final int netPaise;

  /// Deductions that exceeded gross — carried forward explicitly,
  /// never a silent negative net.
  final int carryForwardPaise;
  final int paidPaise;

  int get remainingPaise => netPaise - paidPaise;
}

/// An owner-entered bonus/incentive or non-advance deduction on a
/// draft payroll line.
class PayrollAdjustment {
  const PayrollAdjustment({
    required this.id,
    required this.runId,
    required this.lineId,
    required this.isBonus,
    required this.amountPaise,
    required this.label,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String runId;
  final String lineId;
  final bool isBonus;
  final int amountPaise;
  final String label;
  final String createdBy;
  final DateTime createdAt;
}

/// A salary settlement payment. NOT an advance — advances are money
/// given before payroll; payments settle an approved payroll.
class PayrollPayment {
  const PayrollPayment({
    required this.id,
    required this.runId,
    required this.lineId,
    required this.employeeId,
    required this.amountPaise,
    required this.paidAt,
    required this.method,
    required this.recordedBy,
    this.notes,
  });

  final String id;
  final String runId;
  final String lineId;
  final String employeeId;
  final int amountPaise;
  final DateTime paidAt;

  /// cash | upi | bank | other
  final String method;
  final String recordedBy;
  final String? notes;
}

/// The studio's payroll rules plus review state.
class PayrollSettingsState {
  const PayrollSettingsState({
    required this.rules,
    required this.updatedAt,
    this.reviewedAt,
  });

  final PayrollRules rules;

  /// When the owner reviewed and confirmed the rules. Approval of a
  /// first payroll is blocked until this is set.
  final DateTime? reviewedAt;
  final DateTime updatedAt;

  bool get isReviewed => reviewedAt != null;
}

/// A live (unpersisted) payroll preview for one employee: computed
/// from current attendance, rules and unconsumed advances.
class PayrollPreviewLine {
  const PayrollPreviewLine({
    required this.employee,
    required this.counts,
    required this.basisDays,
    required this.advancesPaise,
    required this.computation,
  });

  final Employee employee;
  final PayrollCounts counts;
  final int basisDays;

  /// Net signed total of this period's unconsumed advances.
  final int advancesPaise;
  final PayrollComputation computation;

  /// Attendance has elapsed days with no record — the owner must see
  /// this before approving.
  bool get incompleteAttendance => counts.unmarked > 0;

  /// No salary/rate on file for this employee.
  bool get missingRate => employee.monthlySalaryPaise <= 0;
}
