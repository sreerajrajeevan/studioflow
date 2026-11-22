# Task 5 — Monthly payroll: notes (2026-11-22)

## Delivered
- Salary screen is real: month navigation, live preview (clearly
  labelled "not a payroll yet"), draft creation, per-employee detail
  (counts incl. unmarked shown separately, payable days, basis,
  overtime stepper, bonus/deduction adjustments), approval dialog
  with incomplete-attendance acknowledgement, payments per line,
  void/revision, monthly summary (gross / advances / other
  deductions / net / paid / outstanding / carry-forward), and a
  shareable text + PDF salary statement.
- Payroll rules editor: basis, half-day %, paid/unpaid toggles for
  leave/absent/unmarked, weekly off + holidays, overtime multiplier.
  Example defaults are labelled as such; first approval is blocked
  until the owner reviews and confirms them.
- Schema v5 (additive): payroll_settings, payroll_runs,
  payroll_lines, payroll_adjustments, payroll_payments,
  payroll_audit_events, payroll_advance_links. Unique constraints:
  (period, version) per run, (run, employee) per line, advance id
  as link primary key (double-consumption impossible).

## Verification (real runs, 2026-11-22)
- `flutter test`: **144/144 passed** — 124 preserved (schema-version
  assertions moved to v5; salary golden regenerated) plus 20 new
  payroll tests with independently computed exact-paise figures:
  leap-February monthly (₹2,586,207 earnings on ₹30,000), paid-leave
  variant, fixed-30 (₹25,000), working-days (full ₹30,000), daily
  wage (₹20,000), rule-change repricing, idempotent draft, review
  gate, incomplete-attendance gate, advances deducted exactly once
  (₹1,800 example; ledger untouched; second approval impossible),
  reversal netting, partial→paid settlement with idempotent +
  overpay-rejected payments, negative net → carry-forward,
  post-approval immutability (salary/attendance/rule edits),
  revision releasing advances, paid-run void/revise rejection,
  overtime (₹3,103.45 on the Feb fixture) + adjustments locking
  after approval, settings persistence, staff route invisibility,
  file-backed restart, and a genuine v4→v5 migration.
- `flutter analyze`: 0 errors, 0 warnings.
- APK: attempted; failed at the Gradle wrapper download with the
  sandbox's documented Java SSL restriction. CI remains the build
  path once the repo exists.

## Design decisions worth knowing
- Reversal dating interplay: Task 4 dates reversals on the day they
  are recorded, so an October advance reversed in November claws
  back through November payroll (negative advance total adds back).
  Same-month advance + reversal nets to zero. Both behaviors are
  covered by tests/docs rather than hidden.
- A run whose total net is 0 (fully over-deducted) is marked Paid
  at approval — there is no balance left to settle; its
  carry-forward stays visible.
- Creating a draft when an approved run exists for the period
  returns the approved run instead of spawning a competitor.

## Known limitations
- Carry-forward balances are displayed, not auto-applied to the
  next period (owner adds a matching adjustment — see PAYROLL.md).
- Payroll is single-device; no synchronization is claimed.
- Role gating is a UI preview until backend authentication.
- Employee eligibility for a period = active employees plus anyone
  with attendance/advances that month (so a departed employee still
  gets their final payroll).

## Recommended next task
Owner's choice — expenses, appointments, or the backend. The local
product (catalog, billing, people, attendance, advances, payroll)
is functionally complete for single-device studio use.
