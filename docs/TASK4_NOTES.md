# Task 4 — Employees, attendance & advances: notes (2026-11-22)

## Delivered
- Employees screen is real: owner CRUD (name, role, phone, joining
  date, monthly/daily salary in paise), activate/deactivate switch,
  staff read-only view without salary data. Nobody can be deleted.
- Attendance screen: daily marking with four large status buttons per
  employee (writes persist before the UI claims "Saved"), day
  navigation for corrections, and a month calendar with per-employee
  summary chips (present/absent/half/leave/unmarked) and tap-to-
  correct day cells — all corrections audited.
- Advances screen (owner-only, new /advances destination): rapid
  entry (employee, amount, business date, cash/UPI/other, notes),
  monthly total for the selected employee, full ledger list, and
  reversal with confirmation. Double-tap safe (single-flight +
  idempotent ids).
- Billing's per-line employee picker already read the real employee
  repository; it now reflects Employees-screen edits and
  deactivations immediately (provider invalidation on save/toggle).
- Payroll prep: MonthlyAttendanceSummary + advance period totals are
  exposed as repository APIs for Task 5. No payroll math, no
  hardcoded leave/deduction rules.

## Verification (real runs, 2026-11-22)
- `flutter test`: **124/124 passed** — 109 preserved (schema-version
  assertions moved to v4; the attendance navigation widget test now
  asserts the real screen) plus 15 new: Kolkata date conversion
  incl. month boundary, employee CRUD/validation/restart, one-
  record-per-day with audited correction, invalid-date rejection,
  monthly summaries (leap February; current-month unmarked rule),
  the brief's ₹500+₹1,000+₹300 = ₹1,800 November example, duplicate
  advance idempotency, reversal netting + double-reversal rejection,
  file-backed advance durability, invoice employee snapshot after
  rename, and a genuine v3→v4 migration.
- `flutter analyze`: 0 errors, 0 warnings.
- APK: attempted; failed at the Gradle wrapper download with the
  sandbox's documented Java SSL restriction. CI remains the build
  path once the repo exists.

## Real bugs caught by tests this task
1. Migration index ordering: the v2→v3 hop called the shared index
   builder, which (after v4) referenced attendance tables that don't
   exist yet at that step — would have broken upgrades from real v2
   databases. Index creation is now split per schema version.
2. A blanket text replace briefly duplicated the new tables into the
   ServiceCategories definition — caught by analyze immediately.

## Known limitations
- Profile photo: the field is stored end-to-end, but there is no
  photo picker UI yet (needs an image-picker dependency decision).
- Attendance/advances are local to this device; nothing here claims
  multi-device synchronization (that arrives with the backend).
- Role gating remains a UI preview until backend authentication.

## Recommended next task
Task 5 — monthly payroll: configurable rules (paid/unpaid leave,
half-day treatment, daily vs monthly, overtime, commissions) over
this task's summaries and advance ledger.
