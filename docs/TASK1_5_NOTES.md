# Task 1.5 — White-Label Refactor Notes

## What changed

- **Product identity:** StudioFlow. Package/applicationId intentionally
  unchanged (`com.dpoise.groomstudio`) — renaming would break installs and
  the Room database identity for the first customer. App label, product
  strings, Application class (`StudioFlowApp`), theme entry points
  (`StudioFlowTheme`, `StudioTypography`, `StudioShapes`) and the nav host
  are product-neutral. "D POISE" now exists ONLY in the demo preset
  (`BrandPresets.dpoiseDemo`), demo-related helper copy, and docs.
- **StudioProfile:** domain model + Room entity (single row, id = 1) with
  name, tagline, logo path, primary/secondary colours (ARGB), address,
  phone, email, GSTIN, UPI id + payee name, currency (INR), invoice prefix,
  invoice footer, created/updated timestamps. Repository + Flow; a null
  profile is the first-run gate.
- **Migration 1 → 2:** creates `studio_profile`, adds 11 `snapshot*`
  columns to `bills`. Destructive fallback REMOVED. DB file name kept
  (`dpoise.db`) so the migration actually runs on Task 1 installs.
- **Onboarding wizard:** 5 steps (details → logo → branding → UPI →
  confirm), per-step validation, skip allowed for logo/UPI, demo preset on
  the branding step, summary + theme preview before finishing. No internet,
  no account.
- **Dynamic branding:** `studioColorScheme()` builds the Material 3 scheme
  from the profile's colours (not wallpaper dynamic colour). `Branding`
  derives on-colours by WCAG contrast, deepens too-light primaries until
  AA with ivory text, and tints containers. Sidebar name/tagline/logo,
  dashboard greeting and accents all read the live profile.
- **Logo:** system photo picker (no storage permission) → copied into
  `files/logos/` by `LogoStorage`; DB stores only the path. Rendered by
  `StudioLogo` with initial-tile fallback.
- **Settings:** placeholder replaced with a functional Business Settings
  screen — Business Details, Branding (logo + colours + preview), Billing
  Configuration (prefix, INR display, footer, snapshot note), Payment
  Details (UPI), Data Management (honest backup placeholder). Saves persist
  and re-theme immediately.
- **Invoice safety:** snapshot model + columns + `docs/INVOICE_SNAPSHOT.md`
  with the billing task's requirements (incl. the logo-file retention rule).
- **Commercial extension points:** interfaces only
  (`domain/commercial/ExtensionPoints.kt`) for licence, backup, sync,
  branches — nothing implemented, nothing enforced, no fake protection.

## Tests

- Unit: `WhiteLabelTest` (name/UPI/GSTIN/prefix/hex validation, preset
  behaviour incl. non-demo presets never renaming the business, snapshot
  frozen after profile edit, form→profile normalisation),
  `BrandingTest` (contrast ratio, on-colour choice, AA deepening),
  plus the Task 1 `ModelTest`.
- Instrumented: `MigrationTest` (v1 bills survive 1→2, profile table
  created, old bills get null snapshot), `ProfilePersistenceTest`
  (profile survives DB close/reopen), `OnboardingSmokeTest`
  (fresh install → wizard; set-up device → dashboard).

## Known issues / honest limits

- Local Gradle build still cannot run in the authoring sandbox (Java TCP
  daemon block — pre-existing environment rule). Verification done:
  pure-Kotlin core type-check + full-source parse scan; full compile is
  gated on the first CI run / Android Studio build.
- Instrumented tests need an emulator or device; CI compiles them
  (`assembleAndroidTest`) but does not execute them.
- Logo replacement deletes the previous logo file. Fine while no real
  bills exist; must become reference-aware before billing ships (see
  INVOICE_SNAPSHOT.md §4).
- Currency is INR-only by design in v1; the profile field exists so other
  currencies can be enabled without a schema change.
