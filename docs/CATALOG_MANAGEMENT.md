# Service catalog management (Task 2)

## Where things live
- Screen: `flutter_app/lib/features/services/services_screen.dart`
  (route `/services`, in the shell's More group; hidden from the Staff
  role preview, and the router guard blocks direct navigation).
- State: `CatalogAdminNotifier` (`lib/data/providers.dart`) — loads all
  categories + all services, applies mutations through the repository,
  then refreshes the billing catalog so New Bill reflects changes
  immediately.
- Rules: `DriftServiceRepository` (`lib/data/repositories_impl.dart`).
- Price entry parsing: `lib/core/price_parse.dart` — string → integer
  paise with NO floating point anywhere in the path.

## Rules enforced by the repository
- Names: non-empty after trim, ≤ 80 chars (categories ≤ 60).
- Prices: integer paise, validated by the money engine (≥ 0, ≤ cap).
- **No two ACTIVE services with the same normalized name in one
  category** (normalization: trim, lowercase, collapse whitespace).
  An inactive namesake doesn't block; reactivating into a collision is
  rejected with an owner-readable message.
- Category ids are stable slugs: renaming changes the display name
  only, so services never lose their category.
- An INACTIVE category's services are excluded from billing
  (`listActive`) but remain in the catalog (`listAll`) — deactivation
  is never deletion.
- Ordering: category sortOrder, then service sortOrder, then name.
  Reorders persist sortOrder = position × 10 in one transaction.
  Brand-new services append to the end of their category.
- The seeded sample catalog is a first-run starter template only; it
  is written once (when the categories table is empty) and NEVER
  re-applied over a studio's own catalog on upgrades.

## The price-snapshot policy (billing safety)
A cart line is identified by **(serviceId, snapshotPrice)**:
- Tapping a tile increments the line whose snapshot equals the CURRENT
  catalog price.
- If the price changed since the service was added, the tap opens a
  SEPARATE line at the new price. The existing line keeps its original
  snapshot — the two are never merged, and the bill panel's steppers
  act on the exact line (service + price).
- Deactivating or renaming a service never rewrites an open draft:
  drafts store their own snapshot name + price.
- Draft persistence supports this: `draft_lines` is unique on
  (draft, service, price) since schema v2.

## Schema v2 changes (Task 2 migration)
- `services.description` (nullable) and `services.created_at` added.
- `draft_lines` rebuilt with the widened unique key; every row copied.
- `created_at` is added with a constant default and backfilled from
  `updated_at` (SQLite cannot add a column with a CURRENT_TIMESTAMP
  default). Migration is data-preserving; there is still no destructive
  fallback. A genuine v1 database → v2 upgrade is covered by an
  automated test built from the exact v1 DDL.

## Permissions honesty
Owner/Staff is a local UI preview. The Services screen hides editing
controls from Staff and says so on screen ("not secure
authentication"). Real enforcement requires backend authentication;
the repository contracts are unchanged by role, ready for server-side
authorization later.
