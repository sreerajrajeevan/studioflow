# Task 1.7 — Offline persistence & crash recovery: notes (2026-11-22)

## Delivered
- **Drift database** (`lib/data/database.dart`, schema v1): studio
  profile, categories, services, employees, bill drafts, draft lines,
  sync metadata. Foreign keys enforced, indexes on category/active/
  draft/updated-at, UNIQUE (draft, service) per draft. Money stays
  integer paise; totals are never stored — always re-derived through the
  money engine. Full design: `docs/PERSISTENCE.md`.
- **Migrations**: explicit `schemaVersion`, step-by-step `onUpgrade`
  (throws on an undefined hop), **no destructive fallback anywhere**.
  `database.g.dart` is checked in; CI verifies codegen is current.
- **Repositories** behind the existing interfaces
  (`lib/data/repositories_impl.dart`): DriftStudioConfigRepository,
  DriftServiceRepository, DriftEmployeeRepository, plus a `DraftStore`
  seam for unfinished bills. Widgets never touch SQL.
- **Crash-safe drafts**: debounced (300 ms) sequential autosave; each
  save is a single transaction (draft + lines), pre-validated by the
  money engine; startup restores the most recent draft with its original
  id, quantities and snapshot prices; a Drafts sheet (billing header
  button with count badge) lists/resumes/deletes saved drafts; emptying
  the cart deletes its draft so finished bills never resurrect.
- **Honest save state** in the bill panel: Saving… → "Draft saved on
  this device" only after the write lands; failure shows a tappable
  retry. No silent auto-retry loop.
- **Branding persistence**: Settings edits now save to the profile table
  ("Saved on this device"); the saved profile loads at startup. Catalog
  is served from the database after first load (in-memory sample is the
  instant first frame and the offline fallback). First run seeds the
  SAMPLE catalog + staff (idempotent, marked in sync_metadata).

## Verification (real runs, 2026-11-22)
- `flutter analyze`: 0 errors, 0 warnings (21 info notices, same
  SDK-transition class as 1.6).
- `flutter test`: **76/76 passed** — all 55 Task 1.6 tests preserved,
  plus 21 new persistence tests: schema/index/FK shape, profile
  round-trip, catalog/employee CRUD, seed idempotency, FK restrict +
  cascade, 3-service recovery with engine-derived total, snapshot price
  surviving a catalog change, duplicate-id upsert, multiple drafts
  ordering, 100 rapid selections persisted, 50-line round-trip, invalid
  lines rejected pre-write, mid-transaction failure persisting nothing,
  and a file-backed close/reopen durability test.
- Golden screenshots regenerated (billing header gained the drafts
  button; panel footer copy updated).
- Bugs caught by tests during this task: (1) widget tests initially hit
  the real device database — fixed with a shared seeded in-memory test
  database override; (2) the new save-status row could overflow the
  360 dp bill panel — text is now flexible/ellipsized.

## Android build status
`flutter build apk --debug` was attempted in the sandbox and failed at
the Gradle wrapper stage, before compilation:
`javax.net.ssl.SSLException: Unsupported or unrecognized SSL message`
(broken pipe) while downloading the Gradle distribution — the sandbox's
documented Java-network restriction (the Gradle daemon's localhost TCP
is likewise blocked). The build is therefore verified by CI instead:
`.github/workflows/flutter-ci.yml` runs pub get, codegen freshness,
analyze, the full test suite, and `flutter build apk --debug` on
ubuntu-latest with Flutter 3.50.0 + JDK 17, uploading the debug APK as
an artifact. (The repo still needs to be created by Sree for CI to run.)

## Performance implications
- Tap handlers do zero storage work; the cart is pure in-memory state.
- Autosave is debounced and sequential; on device, Drift runs in a
  background isolate, so writes never block the UI thread.
- The catalog loads once from SQLite into memory; search/filter stay
  in-memory (the p95 ≤ 100 ms cached-search budget is unaffected).
- The p95 hardware budgets remain unmeasured targets (no device in the
  sandbox) — unchanged from Task 1.6.

## Known issues / limits
- Employees, attendance and payroll screens still render their sample
  providers; the employee repository is implemented and tested, and
  wiring those screens to it is a small follow-up (billing-critical
  paths — catalog, drafts, profile — are fully wired).
- Draft recovery restores the most recent draft automatically; older
  drafts need one tap in the Drafts sheet.
- If the database cannot be opened at startup, the app still opens on
  in-memory demo state (a POS that opens beats one that doesn't); the
  save-status line will show draft saves failing rather than hiding it.

## Next task (as commissioned)
Editable service catalog with business-specific prices and categories.
