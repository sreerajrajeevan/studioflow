import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// StudioFlow local database (Drift + SQLite) — schema v1.
///
/// Design rules (docs/PERSISTENCE.md):
/// - Money is integer paise everywhere; totals are NEVER stored — they are
///   derived through the money engine from the stored lines, so a recovered
///   draft cannot disagree with its own lines.
/// - Draft lines store SNAPSHOT name + price copied at first add; the
///   catalog can change or even delete a service without rewriting a draft.
/// - Foreign keys are enforced (PRAGMA in [AppDatabase] setup); draft lines
///   cascade-delete with their draft; a category that still has services
///   cannot be deleted.
/// - Migrations are explicit and step-by-step. There is NO destructive
///   fallback — a failed migration must fail loudly, never wipe a studio's
///   data.

/// Singleton studio profile (id is always 1). Mirrors StudioBranding field
/// for field so the future backend payload matches the Kotlin generation.
class StudioProfiles extends Table {
  IntColumn get id => integer()();
  TextColumn get businessName => text().withLength(min: 1, max: 120)();
  TextColumn get tagline => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  IntColumn get primaryColor => integer()();
  IntColumn get secondaryColor => integer()();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().nullable()();
  TextColumn get gstin => text().nullable()();
  TextColumn get upiId => text().nullable()();
  TextColumn get upiPayeeName => text().nullable()();
  TextColumn get currencyCode => text().withDefault(const Constant('INR'))();
  TextColumn get invoicePrefix =>
      text().withDefault(const Constant('INV'))();
  TextColumn get invoiceFooter => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ServiceCategoryRow')
class ServiceCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Services extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId =>
      text().references(ServiceCategories, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get description => text().nullable()();
  IntColumn get pricePaise => integer()();
  IntColumn get durationMinutes =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isExtra =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EmployeeRow')
class Employees extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get role => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get salaryType =>
      text().withDefault(const Constant('monthly'))();
  IntColumn get monthlySalaryPaise =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  // Added in schema v4 (Task 4) — nullable so pre-v4 rows stay valid.
  DateTimeColumn get joiningDate => dateTime().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One employee's attendance for one studio-local date (yyyy-MM-dd in
/// the studio timezone, initially Asia/Kolkata). At most ONE record
/// per employee per date — corrections UPDATE the row and are audited
/// in [AttendanceAuditEvents]. "Not marked" is the ABSENCE of a row;
/// nobody is auto-marked absent.
@DataClassName('AttendanceRow')
class AttendanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get employeeId =>
      text().references(Employees, #id, onDelete: KeyAction.restrict)();
  TextColumn get dateKey => text()();
  TextColumn get status =>
      text()(); // present | absent | half_day | leave
  TextColumn get markedBy => text()();
  DateTimeColumn get markedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, dateKey},
      ];
}

/// Append-only audit for attendance marking and corrections.
@DataClassName('AttendanceAuditRow')
class AttendanceAuditEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get employeeId => text()();
  TextColumn get dateKey => text()();
  TextColumn get oldStatus => text().nullable()();
  TextColumn get newStatus => text()();
  TextColumn get actor => text()();
  DateTimeColumn get createdAt => dateTime()();
}

/// A salary advance: money given to an employee before payday
/// (Task 4). The ledger is IMMUTABLE — corrections are reversal rows
/// ([reversalOfId] points at the original; a partial unique index
/// guarantees an advance can be reversed at most once). Advances are
/// completely separate from customer billing payments.
@DataClassName('AdvanceRow')
class SalaryAdvances extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId =>
      text().references(Employees, #id, onDelete: KeyAction.restrict)();
  IntColumn get amountPaise => integer()();
  TextColumn get businessDateKey => text()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get method => text()(); // cash | upi | other
  TextColumn get notes => text().nullable()();
  TextColumn get recordedBy => text()();
  TextColumn get reversalOfId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// An UNFINISHED bill. Deliberately a different table from finalized
/// invoices (which the future backend owns): a draft has no invoice
/// number, no payment state, and can be edited or deleted freely.
class BillDrafts extends Table {
  TextColumn get draftId => text()();
  IntColumn get discountPercent =>
      integer().withDefault(const Constant(0))();
  IntColumn get discountFlatPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get taxBasisPoints =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {draftId};
}

class DraftLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get draftId =>
      text().references(BillDrafts, #draftId, onDelete: KeyAction.cascade)();

  /// Plain text, NOT a foreign key: the line must survive catalog edits
  /// and deletions — it carries its own snapshot below.
  TextColumn get serviceId => text()();
  TextColumn get serviceName => text()();
  IntColumn get pricePaise => integer()();
  IntColumn get durationMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get quantity => integer()();
  TextColumn get employeeId => text().nullable()();
  TextColumn get employeeName => text().nullable()();
  IntColumn get position => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        // One line per (service, snapshot price): if the catalog price
        // changes mid-bill, the new selection becomes its own line rather
        // than merging into the older-price snapshot (Task 2 policy).
        {draftId, serviceId, pricePaise},
      ];
}

/// A FINALIZED invoice (Task 3). Immutable financial record: every
/// display-relevant studio and service value is a snapshot taken at
/// finalization, so later profile/catalog edits can never rewrite
/// history. [provisionalRef] is a LOCAL reference only — official
/// invoice numbers are assigned by the future backend (see
/// docs/BILLING.md for the migration path). [draftId] is unique: it is
/// the idempotency key that makes repeated finalization return the
/// original bill instead of duplicating it.
@DataClassName('BillRow')
class Bills extends Table {
  TextColumn get id => text()();
  TextColumn get provisionalRef => text()();
  IntColumn get localSeq => integer()();
  TextColumn get draftId => text().unique()();
  TextColumn get customerName => text().withDefault(const Constant(''))();
  // Studio snapshot
  TextColumn get snapshotBusinessName => text()();
  TextColumn get snapshotTagline => text().nullable()();
  TextColumn get snapshotAddress => text().withDefault(const Constant(''))();
  TextColumn get snapshotPhone => text().withDefault(const Constant(''))();
  TextColumn get snapshotEmail => text().nullable()();
  TextColumn get snapshotGstin => text().nullable()();
  TextColumn get snapshotUpiId => text().nullable()();
  TextColumn get snapshotInvoiceFooter => text().nullable()();
  IntColumn get snapshotPrimaryColor => integer()();
  // Money (integer paise, engine-derived at finalization)
  IntColumn get subtotalPaise => integer()();
  IntColumn get discountPercent => integer()();
  IntColumn get discountFlatPaise => integer()();
  IntColumn get discountPaise => integer()();
  IntColumn get taxBasisPoints => integer()();
  IntColumn get taxPaise => integer()();
  IntColumn get totalPaise => integer()();
  // Lifecycle
  TextColumn get status => text()(); // finalized | voided
  TextColumn get paymentStatus =>
      text()(); // pending | confirmed_manual | verified_provider
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get finalizedAt => dateTime()();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().nullable()();
  TextColumn get voidedBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One line of a finalized bill — snapshot name/price, quantity, and
/// the assigned employee (id + name snapshot) where applicable.
@DataClassName('BillLineRow')
class BillLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get billId =>
      text().references(Bills, #id, onDelete: KeyAction.cascade)();
  TextColumn get serviceId => text()();
  TextColumn get serviceName => text()();
  IntColumn get pricePaise => integer()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(0))();
  IntColumn get quantity => integer()();
  TextColumn get employeeId => text().nullable()();
  TextColumn get employeeName => text().nullable()();
  IntColumn get position => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {billId, position},
      ];
}

/// A payment against a bill. Method and status are separate axes:
/// a UPI payment can be pending, manually confirmed, or (future)
/// provider-verified. Split payments are multiple rows per bill.
/// Manual confirmation records WHO confirmed and WHEN — it is never
/// labelled provider verification.
@DataClassName('PaymentRow')
class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get billId =>
      text().references(Bills, #id, onDelete: KeyAction.cascade)();
  TextColumn get method => text()(); // cash | upi | card
  IntColumn get amountPaise => integer()();
  TextColumn get status =>
      text()(); // pending | confirmed_manual | verified_provider
  TextColumn get confirmedBy => text().nullable()();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Monotonic counters (provisional invoice sequence). Incremented
/// inside the finalization transaction, so a rolled-back finalize
/// never burns a number.
class InvoiceCounters extends Table {
  TextColumn get key => text()();
  IntColumn get value => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Append-only billing audit trail: finalizations, payment
/// confirmations, voids. Rows are never updated or deleted.
@DataClassName('AuditEventRow')
class BillingAuditEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get billId => text().nullable()();
  TextColumn get draftId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get actor => text()();
  TextColumn get detail => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
}

/// Payroll settings singleton (Task 5): the studio's payroll rules as
/// JSON (see PayrollRules), plus when the owner reviewed them.
/// Approval of a first payroll is blocked until reviewedAt is set.
class PayrollSettings extends Table {
  IntColumn get id => integer()();
  TextColumn get rulesJson => text()();
  DateTimeColumn get reviewedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One payroll run for one period ('yyyy-MM'). At most one run per
/// period may be approved at a time (enforced transactionally); a
/// revision voids the old run and creates version + 1.
@DataClassName('PayrollRunRow')
class PayrollRuns extends Table {
  TextColumn get id => text()();
  TextColumn get periodKey => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// draft | approved | partially_paid | paid | voided
  TextColumn get status => text()();
  TextColumn get rulesJson => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get approvedBy => text().nullable()();
  DateTimeColumn get approvedAt => dateTime().nullable()();
  TextColumn get voidReason => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {periodKey, version},
      ];
}

/// One employee's frozen payroll line. All figures are snapshots:
/// later salary or attendance edits never rewrite an approved line.
@DataClassName('PayrollLineRow')
class PayrollLines extends Table {
  TextColumn get id => text()();
  TextColumn get runId =>
      text().references(PayrollRuns, #id, onDelete: KeyAction.cascade)();
  TextColumn get employeeId => text()();
  TextColumn get employeeName => text()();
  TextColumn get salaryType => text()(); // monthly | daily
  IntColumn get ratePaise => integer()();
  IntColumn get presentDays => integer().withDefault(const Constant(0))();
  IntColumn get halfDays => integer().withDefault(const Constant(0))();
  IntColumn get leaveDays => integer().withDefault(const Constant(0))();
  IntColumn get absentDays => integer().withDefault(const Constant(0))();
  IntColumn get unmarkedDays => integer().withDefault(const Constant(0))();
  IntColumn get weeklyOffDays => integer().withDefault(const Constant(0))();
  IntColumn get holidayDays => integer().withDefault(const Constant(0))();
  IntColumn get payableUnitsBp => integer().withDefault(const Constant(0))();
  IntColumn get basisDays => integer().withDefault(const Constant(1))();
  IntColumn get earningsPaise => integer().withDefault(const Constant(0))();
  IntColumn get overtimeUnitsBp =>
      integer().withDefault(const Constant(0))();
  IntColumn get overtimePaise => integer().withDefault(const Constant(0))();
  IntColumn get bonusPaise => integer().withDefault(const Constant(0))();
  IntColumn get deductionsPaise => integer().withDefault(const Constant(0))();
  IntColumn get advancesPaise => integer().withDefault(const Constant(0))();
  IntColumn get grossPaise => integer().withDefault(const Constant(0))();
  IntColumn get netPaise => integer().withDefault(const Constant(0))();
  IntColumn get carryForwardPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get paidPaise => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {runId, employeeId},
      ];
}

/// Owner-entered bonuses/incentives and non-advance deductions.
/// Mutable only while the run is a draft.
@DataClassName('PayrollAdjustmentRow')
class PayrollAdjustments extends Table {
  TextColumn get id => text()();
  TextColumn get runId =>
      text().references(PayrollRuns, #id, onDelete: KeyAction.cascade)();
  TextColumn get lineId =>
      text().references(PayrollLines, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()(); // bonus | deduction
  IntColumn get amountPaise => integer()();
  TextColumn get label => text()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Salary settlement payments — distinct from salary advances.
/// Idempotent on id; a run is Paid only when its lines are settled.
@DataClassName('PayrollPaymentRow')
class PayrollPayments extends Table {
  TextColumn get id => text()();
  TextColumn get runId =>
      text().references(PayrollRuns, #id, onDelete: KeyAction.cascade)();
  TextColumn get lineId =>
      text().references(PayrollLines, #id, onDelete: KeyAction.cascade)();
  TextColumn get employeeId => text()();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get method => text()(); // cash | upi | bank | other
  TextColumn get notes => text().nullable()();
  TextColumn get recordedBy => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PayrollAuditRow')
class PayrollAuditEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get runId => text()();
  TextColumn get type => text()();
  TextColumn get actor => text()();
  TextColumn get detail => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Which advances a payroll run consumed. The advance id is the
/// primary key, so an advance can be consumed by AT MOST ONE run —
/// double-consumption is impossible at the database level. Voiding
/// a run deletes its links and releases the advances.
@DataClassName('PayrollAdvanceLinkRow')
class PayrollAdvanceLinks extends Table {
  TextColumn get advanceId => text()();
  TextColumn get runId =>
      text().references(PayrollRuns, #id, onDelete: KeyAction.cascade)();
  TextColumn get lineId =>
      text().references(PayrollLines, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get linkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {advanceId};
}

/// Local synchronization bookkeeping for the future backend (device id,
/// last-sync markers, pending-push counters). No finalized-invoice data
/// lives here — the backend is authoritative for those.
class SyncMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  StudioProfiles,
  ServiceCategories,
  Services,
  Employees,
  BillDrafts,
  DraftLines,
  Bills,
  BillLines,
  Payments,
  InvoiceCounters,
  BillingAuditEvents,
  AttendanceRecords,
  AttendanceAuditEvents,
  SalaryAdvances,
  PayrollSettings,
  PayrollRuns,
  PayrollLines,
  PayrollAdjustments,
  PayrollPayments,
  PayrollAuditEvents,
  PayrollAdvanceLinks,
  SyncMetadata,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// The on-device database: a background isolate runs the queries so the
  /// UI thread never waits on disk.
  factory AppDatabase.device() {
    return AppDatabase(LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/studioflow.db');
      return NativeDatabase.createInBackground(file);
    }));
  }

  /// Tests: in-memory or file-backed, caller's choice.
  factory AppDatabase.forTesting(QueryExecutor executor) =>
      AppDatabase(executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
          await _createV4Indexes();
        },
        onUpgrade: (m, from, to) async {
          // Migrations are explicit, step-by-step, and data-preserving.
          // An undefined hop throws — the database is NEVER wiped or
          // recreated as a fallback, so a failed upgrade leaves the
          // studio's data exactly as it was.
          var version = from;
          while (version < to) {
            switch (version) {
              case 1:
                await _migrate1To2(m);
                version = 2;
              case 2:
                await _migrate2To3(m);
                version = 3;
              case 3:
                await _migrate3To4(m);
                version = 4;
              case 4:
                await _migrate4To5(m);
                version = 5;
              default:
                throw StateError(
                  'No migration defined from schema v$version to v$to',
                );
            }
          }
        },
        beforeOpen: (details) async {
          // Foreign-key enforcement is per-connection in SQLite and OFF
          // by default — without this the references are decoration.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// v1 -> v2 (Task 2): services gain description + created-at; the
  /// draft_lines unique key widens to (draft, service, price) so one
  /// draft can hold the same service at two snapshot prices. The table
  /// rebuild copies every row — no draft is lost in the upgrade.
  Future<void> _migrate1To2(Migrator m) async {
    await m.addColumn(services, services.description);
    // created_at cannot go through addColumn: SQLite refuses to add a
    // column whose default is non-constant (CURRENT_TIMESTAMP). Add it
    // with a constant default instead and backfill existing rows from
    // their updated_at — the closest truthful creation time available.
    await customStatement(
      'ALTER TABLE services ADD COLUMN "created_at" '
      'INTEGER NOT NULL DEFAULT 0',
    );
    await customStatement(
      'UPDATE services SET created_at = updated_at',
    );
    await customStatement('''
      CREATE TABLE draft_lines_new (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "draft_id" TEXT NOT NULL REFERENCES bill_drafts (draft_id) ON DELETE CASCADE,
        "service_id" TEXT NOT NULL,
        "service_name" TEXT NOT NULL,
        "price_paise" INTEGER NOT NULL,
        "duration_minutes" INTEGER NOT NULL DEFAULT 0,
        "quantity" INTEGER NOT NULL,
        "position" INTEGER NOT NULL,
        UNIQUE ("draft_id", "service_id", "price_paise")
      )''');
    await customStatement('''
      INSERT INTO draft_lines_new
        (id, draft_id, service_id, service_name, price_paise,
         duration_minutes, quantity, position)
      SELECT id, draft_id, service_id, service_name, price_paise,
             duration_minutes, quantity, position
      FROM draft_lines''');
    await customStatement('DROP TABLE draft_lines');
    await customStatement(
      'ALTER TABLE draft_lines_new RENAME TO draft_lines',
    );
    await customStatement(
      'CREATE INDEX idx_draft_lines_draft ON draft_lines (draft_id)',
    );
  }

  /// v2 -> v3 (Task 3): finalized billing — five new tables, and the
  /// draft tables gain discount/tax/employee columns. Purely additive;
  /// every existing draft survives.
  Future<void> _migrate2To3(Migrator m) async {
    await m.createTable(bills);
    await m.createTable(billLines);
    await m.createTable(payments);
    await m.createTable(invoiceCounters);
    await m.createTable(billingAuditEvents);
    await m.addColumn(billDrafts, billDrafts.discountPercent);
    await m.addColumn(billDrafts, billDrafts.discountFlatPaise);
    await m.addColumn(billDrafts, billDrafts.taxBasisPoints);
    await m.addColumn(draftLines, draftLines.employeeId);
    await m.addColumn(draftLines, draftLines.employeeName);
    await _createIndexes();
  }

  /// v3 -> v4 (Task 4): employee fields (joining date, photo,
  /// timestamps — all nullable for existing rows), attendance records
  /// + audit, and the salary advance ledger. Purely additive.
  Future<void> _migrate4To5(Migrator m) async {
    await m.createTable(payrollSettings);
    await m.createTable(payrollRuns);
    await m.createTable(payrollLines);
    await m.createTable(payrollAdjustments);
    await m.createTable(payrollPayments);
    await m.createTable(payrollAuditEvents);
    await m.createTable(payrollAdvanceLinks);
  }

  Future<void> _migrate3To4(Migrator m) async {
    await m.addColumn(employees, employees.joiningDate);
    await m.addColumn(employees, employees.photoPath);
    await m.addColumn(employees, employees.createdAt);
    await m.addColumn(employees, employees.updatedAt);
    await m.createTable(attendanceRecords);
    await m.createTable(attendanceAuditEvents);
    await m.createTable(salaryAdvances);
    await _createV4Indexes();
  }

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_services_category '
      'ON services (category_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_services_active '
      'ON services (is_active)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_draft_lines_draft '
      'ON draft_lines (draft_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_drafts_updated '
      'ON bill_drafts (updated_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bills_created '
      'ON bills (created_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bills_payment_status '
      'ON bills (payment_status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bill_lines_bill '
      'ON bill_lines (bill_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_payments_bill '
      'ON payments (bill_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_audit_bill '
      'ON billing_audit_events (bill_id)',
    );
  }

  /// Indexes for the v4 tables — created only by the v3 -> v4 hop and
  /// by onCreate. (Index creation must never reference tables that do
  /// not exist yet at the current migration step.)
  Future<void> _createV4Indexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_attendance_employee '
      'ON attendance_records (employee_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_advances_employee '
      'ON salary_advances (employee_id)',
    );
    // An advance can be reversed at most once.
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_advances_one_reversal '
      'ON salary_advances (reversal_of_id) '
      'WHERE reversal_of_id IS NOT NULL',
    );
  }
}
