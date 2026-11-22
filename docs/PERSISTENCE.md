# StudioFlow persistence — schema, migrations, crash recovery

Task 1.7. Implementation: `flutter_app/lib/data/` (`database.dart`,
`repositories_impl.dart`, `providers.dart`).

## Schema v5 (Drift + SQLite, file `studioflow.db`)

(v5 added payroll: settings, runs, lines, adjustments, payments,
audit, advance links — see PAYROLL.md.)

(v3 added finalized billing — see BILLING.md. v4 added employee
joining/photo/timestamps, attendance_records + attendance audit, and
the salary_advances ledger — see PEOPLE_ATTENDANCE_ADVANCES.md.)

(v2 added in Task 2: `services.description` + `services.created_at`,
and the draft_lines unique key widened to (draft, service, price) so a
draft can hold one service at two snapshot prices. The v1 → v2 upgrade
is data-preserving and test-covered; see CATALOG_MANAGEMENT.md.)

| Table | Contents | Key constraints |
|---|---|---|
| `studio_profiles` | Singleton (id = 1) studio profile/branding: name, tagline, logo path, brand colours (ARGB ints), address, phone, email, GSTIN, UPI id + payee, currency, invoice prefix/footer, timestamps | PK id |
| `service_categories` | Category id (slug of name), name, sort order, active flag | PK id |
| `services` | Service id, category FK, name, **price in integer paise**, duration, extra flag, active flag, sort order, updated-at | FK category → RESTRICT on delete; indexes on category and active |
| `employees` | Employee id, name, role, phone, salary type, monthly salary paise, active flag | PK id |
| `bill_drafts` | Unfinished bills: draft id, created/updated timestamps | PK draft id |
| `draft_lines` | Draft lines: draft FK, service id (plain text — NOT an FK), **snapshot name + snapshot price paise**, duration, quantity, position | FK draft → CASCADE on delete; UNIQUE (draft, service); index on draft |
| `sync_metadata` | Key/value local sync bookkeeping (device id, last-sync markers) for the future backend | PK key |

Rules baked into the schema:

- **Totals are never stored.** A draft's total is re-derived through the
  money engine from its stored lines, so a recovered draft cannot
  disagree with itself.
- **Draft ≠ invoice.** Drafts live in their own tables, carry no invoice
  number and no payment state, and are freely editable/deletable.
  Finalized invoices will be owned by the backend.
- **Snapshots.** Draft lines copy name + price at first add; catalog
  changes (even deleting the service) never rewrite a draft.
- **Foreign keys are enforced** (`PRAGMA foreign_keys = ON` in
  `beforeOpen` — SQLite defaults it off per connection).

## Migrations

- `schemaVersion` is explicit (currently 1). Upgrades are step-by-step,
  data-preserving hops in `AppDatabase.migration.onUpgrade`; each future
  version adds one hop.
- There is **no destructive fallback, ever**: an undefined hop throws and
  the old database stays untouched. A studio's data is worth more than a
  clean start.
- Code generation (`database.g.dart`) is checked in and CI verifies it is
  current (`build_runner build` + `git diff --exit-code`).

## Crash-safe drafts

- Every cart change schedules a save 300 ms later (debounced; rapid taps
  don't write per tap). Writes are sequential — a change during a save
  re-queues, never overlaps.
- A save is ONE transaction: draft row upsert + delete old lines + insert
  all lines. An interrupted write (crash, power loss, constraint failure)
  rolls back completely — a half-written bill can never be recovered,
  because it never existed.
- Lines are validated through the money engine BEFORE writing; a corrupt
  cart cannot reach the database.
- On startup, the most recent draft is restored into the cart with its
  original draft id, quantities and snapshot prices. Other drafts are
  listed in the billing screen's Drafts sheet (resume / delete).
- Emptying the cart (clear, or checkout completion) deletes the draft —
  a finished bill never resurrects.
- The bill panel states the truth about persistence: "Saving draft…" →
  "Draft saved on this device" only AFTER the write completes; failures
  show "Draft not saved — tap to retry". There is no silent auto-retry
  loop; the next edit or the retry tap re-attempts.
- All database work runs off the UI thread (Drift background isolate on
  device); tap handlers do no synchronous storage work, and the catalog
  is served from memory after first load.

## Repository architecture

Widgets depend on interfaces (`domain/repositories.dart`, `DraftStore`),
never on SQL. Implementations are Drift-backed today; the Spring Boot
sync implementation will sit behind the same seams, with the backend
authoritative for finalized invoices and local SQLite as cache/outbox.
