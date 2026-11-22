# Task 3 — Billing & invoice management: notes (2026-11-22)

## Delivered
- Full local billing workflow: per-line employee assignment in the
  bill panel, owner-authorized discount (percent + flat) and GST rate
  applied through the money engine, checkout with cash/UPI/card and
  split payments, manual payment confirmation (who + when stored),
  atomic idempotent finalization, receipt view, PDF + text sharing,
  and a real billing history (search, date/payment-status filters,
  pending-payment confirmation, owner void with reason + audit).
- Schema v3 (bills, bill_lines, payments, invoice_counters,
  billing_audit_events; draft discount/tax/employee columns) with a
  data-preserving, test-covered migration from v2.
- Provisional local references (INV-YYYY-NNNN) labelled as such on
  every invoice; internal ids are globally unique and permanent.
  Server-numbering migration path documented in docs/BILLING.md.
- UPI QR only from the studio's own Settings merchant config,
  amount-prefilled, with on-screen honesty that a QR is not proof of
  payment and may not trigger the soundbox. No QR at all when the
  merchant config is incomplete.

## Verification (real runs, 2026-11-22)
- `flutter test`: **109/109 passed** — all 94 previous tests (schema
  version assertions moved to v3; the v1-migration test now asserts
  the chain continues to v3; checkout golden regenerated for the new
  screen) plus 15 new billing tests: engine totals with discount +
  tax, half-up discount rounding, studio snapshot immutability,
  idempotent double-finalize, draft consumption, mid-transaction
  rollback (duplicate payment PK: no bill, no burned sequence, draft
  intact), overpayment/empty rejection, manual cash confirmation,
  split UPI payment confirmed later from history, void + audit,
  history search/filters, file-backed restart durability, long-name
  documents, PDF magic bytes, UPI payload gating, v2→v3 migration.
- `flutter analyze`: 0 errors, 0 warnings.
- APK: attempted; failed at the Gradle wrapper download with the
  sandbox's documented Java SSL restriction. CI remains the build
  path once the repo exists.

## Bugs caught by tests during the task
- The new employee-assignment control overflowed the bill panel by
  80 px at phone widths — its label is now flexible/ellipsized.
- The v3 table block initially missed registration in the Drift
  database (anchor mismatch) — caught by analyze before any test ran.

## Known limitations
- Discount/tax editing is gated by the owner ROLE PREVIEW (labelled
  in-app as not secure authentication), like all role gating until
  backend sign-in exists.
- Provider-verified payment status exists in the model but nothing
  can set it yet — by design; it arrives with a real payment provider.
- Bluetooth thermal printing is not implemented; the fixed-width
  text receipt is the layout abstraction a driver would consume.
- Dashboard/reports still show their labelled sample data; pointing
  them at the billing repository is a small follow-up.

## Recommended next task
Wire Employees + Attendance for real (the employee repository already
exists), or reports from the new billing data — owner's choice.
