# Task 2 — Editable service catalog: notes (2026-11-22)

## Delivered
- **Services screen** (`/services`, More group): tablet = category
  panel (add/rename/reorder/activate) + searchable service list with
  Add Service, per-service active switch, edit dialog, and a Reorder
  mode (drag within a category). Phone = category chips + list +
  floating Add button. Prices are typed as INR text and parsed to
  integer paise without floating point (`core/price_parse.dart`).
- **Catalog rules** in the repository: duplicate active names per
  category rejected (trim/case-normalized, incl. on reactivation),
  price/name/duration validation with owner-readable errors, stable
  category ids across renames, inactive categories hidden from
  billing, persistent ordering for categories and services.
- **Reactive billing**: every mutation refreshes the billing catalog
  provider — New Bill shows new prices/services with no restart.
- **Snapshot policy change (per Task 2 §5)**: cart lines are keyed by
  (service, snapshot price). A re-tap after a price change opens a
  separate line instead of merging into the old-price line. This
  SUPERSEDES the Task 1.6 merge behaviour; the one affected stress
  test was updated to assert the new policy, and the bill panel
  steppers now act on exact lines.
- **Schema v2** with a real migration (description + created_at;
  draft_lines unique key widened, table rebuilt with all rows copied).

## Verification (real runs, 2026-11-22)
- `flutter test`: **94/94 passed** — the 76 from Task 1.7 (with the
  snapshot-policy test and two schema-version assertions updated as
  described) plus 18 new: price parsing, catalog CRUD, duplicates,
  category rename/reassign/order, inactive-category billing exclusion,
  300-service catalog, file-backed restart, deactivation vs open
  draft, two-price draft round-trip, reactive catalog refresh, the
  v1→v2 migration on a genuine v1 database, and Services-screen
  widget tests (owner controls, staff read-only + honesty note,
  search filtering).
- `flutter analyze`: 0 errors, 0 warnings.
- Bugs caught by tests this task: (1) SQLite cannot add a column with
  a CURRENT_TIMESTAMP default — migration now adds created_at with a
  constant default and backfills from updated_at; (2) the seed left
  every sortOrder at 0, silently reordering the billing tiles
  alphabetically — seed now writes the curated order and new services
  append to their category's end.
- APK: `flutter build apk --debug` attempted; failed at the Gradle
  wrapper download with the sandbox's documented Java SSL restriction
  (`javax.net.ssl.SSLException: Unsupported or unrecognized SSL
  message`). CI (`flutter-ci.yml`, unchanged) remains the build path
  once the repo exists.

## Known limitations
- Reordering is drag-based within one category at a time (select the
  category, tap Reorder). Cross-category moves happen via the edit
  dialog's category dropdown.
- Category deletion is intentionally absent: deactivate instead, so
  historical drafts and future invoices keep their references.
- Staff restrictions are UI-level only (labelled as such in the app).

## Recommended next task
Wire the Employees screen to the (already implemented and tested)
employee repository, then attendance — or move to finalized invoices
with backend-assigned numbers if billing depth matters more.
