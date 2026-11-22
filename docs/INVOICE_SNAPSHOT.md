# Invoice Snapshot Design (Task 1.5)

## Rule

A historical invoice must render **exactly** as it was issued. Changing the
studio name, logo, address, phone, GSTIN, UPI details, invoice prefix/footer
— or a service's price — afterwards must never alter it.

## How it is enforced

1. **Studio snapshot on every bill.** `Bill` carries a `StudioSnapshot`
   (business name, tagline, address, phone, email, GSTIN, logo path, UPI id,
   payee name, invoice prefix, invoice footer) copied from the live
   `StudioProfile` at the moment the bill is created
   (`StudioSnapshot.from(profile)`).
2. **Persisted as columns, not a reference.** Schema v2 stores the snapshot
   as `snapshot*` columns on the `bills` table (added by `MIGRATION_1_2`).
   There is deliberately **no foreign key** from a bill to `studio_profile`:
   joining at render time would silently apply today's profile to old bills.
3. **Line items are copies too.** `BillLine` already stores `serviceName`
   and `priceInPaise` as values (not just a `serviceId`), so catalog price
   edits never rewrite old bills. The billing task must keep this rule:
   copy name + price into the line at sale time.
4. **Logo caveat.** The snapshot stores the logo *path*. If the studio
   replaces its logo, the old file must not be deleted while any bill
   references it. LogoStorage currently deletes a replaced logo only from
   Settings/Setup flows; the billing task must switch logo replacement to
   keep prior files (they are small) or copy the logo file per era.
   **Requirement for Task 2:** before enabling logo replacement alongside
   real bills, make `LogoStorage.delete` reference-aware or stop deleting.
5. **Bill numbers** are generated from the snapshot's prefix + a stored
   sequence; the prefix on the bill never changes even if Settings changes.

## Migration requirements for the billing task

- New bills must always write all `snapshot*` columns (non-null business
  name at minimum) in the same transaction as the bill + lines insert.
- A DAO test must prove: create bill → edit profile → re-read bill →
  snapshot unchanged.
- Pre-v2 bills (none in production) have null snapshots; the invoice
  renderer must fall back to "details unavailable" text, never to the live
  profile.
