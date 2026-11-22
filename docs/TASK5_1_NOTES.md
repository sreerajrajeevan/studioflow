# Task 5.1 — D POISE Black & Gold Redesign + New Billing Flow

## Branding
- The D POISE preset is now the black & gold design system from the
  brief: background #050505, surface #171717, elevated cards #202020,
  text #FFFFFF, secondary text #A8A8A8, gold accent #F5D442 (sampled
  to match the original logo), borders #383838. Gold is used for
  emphasis, active controls, prices and primary actions only.
- The green theme no longer exists in the D POISE preset. The
  white-label mechanism is unchanged: `StudioBranding.dark` (new,
  persisted) selects the dark builder in `ThemeConfig`; other presets
  keep the light system until their studio opts in.
- The ORIGINAL D POISE logo is used unmodified. Because the GitHub
  snapshot push is text-only, the PNG travels as base64 inside
  `lib/branding/poise_logo_data.dart` (byte-identical to the supplied
  file, sha256 c210090e…) and renders via `BrandLogo`. Only the D POISE
  preset references it; switching presets away from D POISE drops it.

## Flow (new)
Startup: native black splash (#050505 launch background) -> Flutter
splash view (original logo, no artificial delay) -> **Who's billing?**
-> **Customer Details** -> **Add Services** -> Checkout -> Invoice ->
New Bill returns to Who's billing?.

- Screen 1 lists ACTIVE employees only (repository-backed), large
  cards with photo-or-initials avatars and a gold selected state. The
  selection stores the employee ID (+ name snapshot) in the billing
  session. An unfinished bill surfaces a Resume card with its employee
  and customer intact. Empty state directs to Employees.
- Screen 2 has exactly three fields. Name required; mobile required,
  validated and normalized (`core/phone_validation.dart`: Indian
  10-digit, +91/91/0 prefixes accepted); notes optional (200 chars).
  Back preserves the employee selection.
- Screen 3 keeps the existing cart engine, price snapshots, draft
  autosave and bill panel; the header shows logo + employee + customer
  with Edit. New lines default to the session employee; per-line
  override remains in the bill panel. Tablet landscape keeps the
  persistent right-side bill summary.
- Checkout no longer re-asks for the customer: it shows the session
  customer (name, phone, billed-by) with an Edit action, and the
  snapshot is frozen from the session at finalization.

## Data (schema v6, additive, no destructive fallback)
- `bill_drafts` + `bills`: customer phone/notes, billing employee
  id/name. `studio_profiles`: dark flag.
- Migration v5 -> v6 adds columns only when missing (the bills table
  is created mid-chain from the current definition, so older-start
  databases may already carry them — checked via PRAGMA, never
  assumed).
- FOUND AND FIXED while wiring this: `DriftDraftStore` never persisted
  discount %, flat discount, tax, or per-line employee assignments
  (columns existed since v3 but the store did not write them), so a
  crash-recovered draft silently lost them. The store now round-trips
  the complete CartState, covered by a regression test.

## Verification
- flutter analyze: 0 errors, 0 warnings (info-level lints only).
- flutter test: 162/162 pass (144 preserved + 18 new: phone
  validation, session behaviour, full-session draft round-trip,
  invoice snapshot, dark theme values, v5->v6 migration, widget flow
  incl. validation errors, back-navigation, full bill -> New Bill,
  long-name overflow).
- Screenshots regenerated (test-engine renders of the real widgets):
  01 splash, 02 employee selection, 03 customer details, 04 mobile
  billing, 05 tablet billing, 06 checkout, 07 dashboard, 08
  attendance, 09 salary, 10 settings.
- APK: built by GitHub Actions (the sandbox cannot build APKs).

## Known limits
- Performance budgets remain unmeasured targets (no device here).
- Employee photos display when a photo file exists on the device;
  the photo picker UI is still the pre-existing gap from Task 4.
- The launcher icon in CI APKs is still the CI-generated placeholder.
