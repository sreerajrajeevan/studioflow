# Billing Correctness & Reliability (release-blocking)

Priority order for this product: **financial correctness → data durability
→ billing responsiveness → operational usability → visual effects.**

## Money rules (implemented in `flutter_app/lib/core/money.dart`)

1. **One engine.** `MoneyEngine` computes every total. Widgets never do
   money arithmetic.
2. **Integer paise only.** No `double` in any amount, discount or tax path.
3. **Rounding (explicit):** percentages round **half-up** to the nearest
   paise, computed once per bill — never per line.
4. **Fixed order:** subtotal → percentage discount → flat discount →
   tax (basis points) on the discounted amount → total.
5. **Never negative:** combined discount clamps at the subtotal.
6. **Validation caps** (`MoneyLimits`): price ≤ ₹10,00,000, quantity
   1–999, ≤ 200 lines, subtotal ≤ ₹1,00,00,000. Violations throw instead of
   silently mis-billing. Dart's 64-bit ints plus these caps keep every
   intermediate product far from overflow, and the subtotal is checked
   incrementally.
7. **Price snapshots:** a cart/bill line copies name + price when the
   service is first added. Catalog edits never change an open or issued
   bill (unit-tested).
8. **Bill identity:** every draft gets a unique client draft id at first
   add; checkout submission is idempotent on it. Official invoice numbers
   are assigned ONLY by the backend.
9. **Idempotent finalization:** `CheckoutController` is single-flight —
   duplicate taps/submissions are ignored; a failed submission returns to
   idle so the same draft retries with the same id (unit-tested).
10. **No fake success:** payment success is shown only after manual
    confirmation or authenticated provider verification. The Task 1.6 demo
    says "sample transaction" in plain words and collects nothing.
11. **Audit trail (backend task):** finalized bills, discounts, voids and
    refunds are append-only records; voids/refunds are new entries that
    reference the original bill, never edits to it.

## Reliability test matrix

| Case | Where proven | Status |
|---|---|---|
| 100 rapid service selections | `cart_stress_test` (unit) | ✅ automated |
| Repeated taps on the same service | `cart_stress_test` | ✅ automated |
| 100+ services in the catalog (search) | `cart_stress_test` (150-service filter) | ✅ logic; device scroll perf pending hardware |
| Cart with 50 line items | `cart_stress_test` | ✅ automated |
| Screen rotation keeps the cart | `widget_layout_test` | ✅ automated |
| Duplicate checkout submission | `cart_stress_test` (single-flight) | ✅ automated |
| Failed submission → same draft retries | `cart_stress_test` | ✅ automated |
| Catalog price change mid-bill | `cart_stress_test` (snapshot) | ✅ automated |
| Switching apps during billing | Draft autosaves transactionally; startup recovery restores it (Task 1.7, `persistence_test`) | ✅ automated (process-death/device confirmation still pending hardware) |
| Low-memory recovery | File-backed restart test: profile + draft survive close/reopen with totals intact (Task 1.7) | ✅ automated (device confirmation pending hardware) |
| Unexpected termination during finalization | Interrupted-write test: a failure mid-transaction persists nothing — no half-written bill (Task 1.7) | ✅ automated |
| Internet disconnection / reconnection during checkout | Local finalization needs no network at all (Task 3); backend sync still ⏳ backend task | ✅ local / ⏳ sync |
| Crash during finalization (local) | Single-transaction finalize; duplicate-payment-PK rollback test leaves no bill, no burned sequence, draft intact (Task 3) | ✅ automated |
| Duplicate finalization of one draft | Idempotency on draft id — second finalize returns the original bill (Task 3) | ✅ automated |
| Duplicate API responses | Backend returns original bill for a known draft id (idempotency) | ⏳ backend task |
| Two devices, conflicting operations | Server-side rules in BACKEND_API_REQUIREMENTS.md | ⏳ backend task |

**Gate:** production billing does not ship until the ⏳ rows have passing
tests. No money or billing data may be silently lost or duplicated —
any test that finds otherwise blocks release.
