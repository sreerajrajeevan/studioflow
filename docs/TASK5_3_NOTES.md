# Task 5.3 — Billing Cart Quantity & Remove Controls

The controls existed in the cart engine and in the tablet panel, but
on a phone the bill was effectively hidden: the summary bar read as
static text, the sheet's steppers were small, and there was NO way to
remove a line outright (the cart's remove operation had no button).
This task fixes discoverability and control, presentation layer only —
no money-engine, finalization, payment or schema changes.

## What changed (lib/features/billing/bill_panel.dart)

- **Per-line remove**: every bill line now has a trash button wired to
  the existing `removeLineAt(serviceId, pricePaise)` — it deletes
  exactly that (service, snapshot-price) line and nothing else.
- **48dp touch targets**: the − / + steppers grew from 40dp to the
  48dp minimum; the remove button is 48dp too. A widget test measures
  all three.
- **Screen-reader labels**: steppers and remove carry explicit
  semantics — "Decrease quantity of Haircut", "Increase quantity of
  Haircut", "Remove Haircut from bill" — and the quantity announces
  itself ("Quantity 2"). Tooltips alone were not enough: they land in
  the semantics tooltip field, not the label, so explicit Semantics
  wrappers were added.
- **Mobile "View Bill"**: the sticky summary now shows a gold,
  labelled "· View Bill ⌃" action inside its tap zone (the whole zone
  is one 48dp+ target with the semantics label "View bill, N items,
  total ₹X"). Tapping opens the same full BillPanel in a sheet —
  lines, steppers, remove, discount/tax, Clear, total, Checkout.
  An earlier attempt put a separate View Bill button beside Checkout;
  it overflowed narrow screens, so the label lives in the summary
  zone itself (with a scale-down guard for large font settings).
- **Sheet inset**: the sheet's panel now respects the bottom system
  inset (SafeArea) so its Checkout never sits in the gesture area.
- **Feedback**: stepper/remove taps fire the same subtle selection
  haptic as the rest of the app; totals update in the same frame as
  the state change — nothing is animated before the number.

Behaviour already correct and now covered by tests: minus at
quantity 1 removes the line; plus/minus act on the exact
(service, snapshot price) line, so two prices of one service stay
separate lines; Clear asks for confirmation ("Clear this bill?" /
Keep bill / Clear bill) in both the sheet and the tablet panel;
emptying the bill shows the empty state and disables Checkout;
quantities round-trip through the crash-safe draft store.

## Verification

- flutter analyze: 0 errors, 0 warnings.
- flutter test: 182/182 (170 preserved + 11 new in
  test/task53_test.dart + 1 new screenshot). New coverage: cart-level
  minus-at-one, remove-only-that-line, snapshot separation, 25 rapid
  taps up and down, clear; draft save/restore of quantities across
  two price lines; mobile sheet end-to-end (open via View Bill, plus,
  minus, minus-removes, remove button, clear confirm + cancel, empty
  state disables Checkout, 48dp target measurement, semantics
  labels); tablet panel controls without a sheet.
- Screenshots: 11_mobile_bill_expanded.png (new) and the regenerated
  05_tablet_billing.png show the finished controls; all 11 shots
  regenerated (test-engine renders of the real widgets).
- APK: GitHub Actions (the sandbox cannot build APKs).
