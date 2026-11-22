# Employees, attendance & salary advances (Task 4)

## Employees
Real Drift records (schema v4 added joining date, photo path,
created/updated timestamps — nullable, so pre-v4 rows stay valid).
Owners add/edit/deactivate; staff see names and roles only. Employees
are NEVER deleted: deactivation preserves attendance, advances and
invoice history, and finalized invoices keep the name snapshot taken
at billing time.

## Attendance
- Dates are STUDIO-LOCAL (Asia/Kolkata, fixed UTC+05:30 — India has
  no DST), stored as 'yyyy-MM-dd' keys via `core/studio_time.dart`.
  Device timezone never decides the business date.
- One record per employee per date (database unique key). Marking is
  an upsert; changing a status is a CORRECTION and appends an audit
  entry (old status → new status, actor, time) in the same
  transaction.
- "Not marked" is the absence of a record. Nobody is ever auto-marked
  absent.
- Monthly summary (payroll prep for Task 5): present / absent /
  half-day / leave counts, plus UNMARKED = elapsed days with no
  record (whole month for past months, up to today for the current
  month, zero for future months).
- The month calendar allows corrections for any day; they flow
  through the same audited path.

## Salary advances
- A separate ledger (`salary_advances`) — never mixed with customer
  billing payments.
- Entries are immutable. A mistake is corrected by a REVERSAL entry
  pointing at the original; a partial unique index guarantees at most
  one reversal per advance, and a reversal cannot itself be reversed.
- Recording is idempotent on the entry id (double-tap safe).
- Net period total = sum of signed entries (reversals subtract) —
  this is the figure Task 5 payroll will deduct ONCE; an advance is
  not a salary expense and must not be double-counted.
- Advances screen is owner-only (salary-sensitive); the router's role
  guard enforces the same rule as the shell.

## Payroll preparation (for Task 5)
Stored and ready: salary type (monthly/daily) + base rate in paise,
full attendance history with leave as its own classification,
monthly summaries, and the advance ledger. NO salary rules are
hardcoded here: whether leave is paid, how half-days count, overtime
and commissions are Task 5 configuration, not assumptions baked into
this data.

## Schema v4 migration notes
Additive only: 4 nullable employee columns; new tables
attendance_records, attendance_audit_events, salary_advances.
Index creation is split by schema version — a migration step only
creates indexes for tables that exist at that step (a real bug the
v1/v2 fixture tests caught during this task: the 2→3 hop tried to
index v4 tables). Upgrade correctness is test-covered from genuine
v1, v2 and v3 fixtures.
