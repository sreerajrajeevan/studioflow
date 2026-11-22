# Monthly payroll (Task 5)

## Rules (Payroll settings)
The studio's rules live in one settings row and are edited from
Salary → Payroll rules:
- Monthly basis: calendar days / fixed 30 / working days (month days
  minus weekly-offs and holidays).
- Half-day pay (0/25/50/75/100%), paid/unpaid leave, paid/unpaid
  absences, paid/unpaid unmarked days — each is an explicit studio
  choice; the app never silently assumes absence or leave is unpaid.
- Weekly off (weekday or none) + paid flag; studio holidays
  (date list) + paid flag; overtime multiplier (1.0×/1.5×/2.0×).
The shipped defaults are EXAMPLES. Approval of the first payroll is
blocked until the owner opens the rules, ticks "I have reviewed
these rules for my studio", and saves — the review timestamp is
stored. Later rule changes apply to new drafts; approved payrolls
keep the rules they were approved with (rules JSON is frozen onto
the run).

## Calculation (core/payroll_engine.dart)
Pure integer math. Day-units are basis points (10000 = 1 day);
every division rounds half-up exactly once.
- Counts come from attendance over ELAPSED studio-local days:
  marked statuses first; unmarked elapsed days fall into the
  weekly-off bucket on the configured weekday, the holiday bucket
  when listed, else UNMARKED (shown separately from absences).
- Monthly earnings = salary × payableUnits / (basisDays × 10000).
- Daily earnings = dailyRate × payableUnits / 10000.
- Overtime = rate × overtimeUnits × multiplier / (basis × 10000²).
- Gross = earnings + overtime + bonuses/incentives.
- Net = gross − advances − other deductions, floored at 0; any
  excess becomes an explicit CARRY-FORWARD on the line.
- A negative advance total is possible and meaningful: an advance
  deducted in an earlier payroll and reversed in this period adds
  the amount back into this period's pay.

## Advances: exactly once
Approval links each consumed advance to its payroll line in the
SAME transaction (payroll_advance_links, advance id is the primary
key). An advance therefore cannot be deducted by two runs — a
conflict aborts the approval. Voiding a run deletes its links and
releases the advances. The advance ledger itself is never modified
by payroll.

## Workflow
Draft → (owner approves; incomplete attendance requires an explicit
acknowledgement) → Approved → Partially paid → Paid (only when the
lines' payments settle the net). Draft creation is idempotent, and
creating a draft never competes with an approved run for the same
period. A second approval for a period is rejected. Approved runs
with no payments can be REVISED: the old run is voided with an audit
entry, its advances are released, and a version+1 draft is created.
Paid/partially-paid runs cannot be voided or revised — corrections
then belong in the next period's adjustments.

## Snapshots & privacy
Approved lines freeze employee name, salary type/rate, counts,
rules, and every figure. Later salary, attendance or rule edits
never rewrite them (test-proven). Payroll screens and statements
are owner-only; the router blocks the staff role from /payroll and
the screen itself shows a privacy notice. Role gating remains a UI
preview until backend authentication exists.

## Salary payments vs advances
Payments settle an approved payroll (cash/UPI/bank/other, partial
allowed, idempotent on payment id, overpayment rejected). They are
a separate table from advances and never mixed.

## Carry-forward
Over-deducted amounts are stored on the line and shown in the
summary and statement. They are NOT auto-applied to the next month
yet — the owner sees the balance and can add a matching deduction
adjustment next period. (Deliberate: silently auto-deducting across
periods would hide money movement.)

## Multi-device note (future)
Payroll runs/lines/payments carry stable ids and audit events, so a
future backend can sync them; the backend will be authoritative for
approved payrolls, mirroring the invoice model. Nothing in this
task claims synchronization exists today.
