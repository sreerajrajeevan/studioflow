# Migration Decision Record — Kotlin/Compose → Flutter (Task 1.6)

## Decision

The StudioFlow product moves to **Flutter** as the single codebase for
Android tablet/phone now, and Windows/macOS/Web later. The Kotlin app is
**preserved, not deleted**, under `legacy-android/` and is not rebuilt.

## Why

- One codebase for tablet, phone, desktop and web POS terminals.
- The product's centre of gravity is a fast touch billing UI; Flutter's
  widget model and hot, consistent rendering suit large-tile POS layouts.
- White-label theming, Riverpod state and GoRouter navigation map cleanly
  onto the architecture already proven in the Kotlin version.

## Repository state note

`~/workspace/dpoise` was **not a Git repository** when this task started
(files only — no commits exist to preserve). Preservation is therefore by
directory: the complete Kotlin project (app module, Gradle files, CI
workflow) moved unchanged into `legacy-android/`. If/when this folder is
pushed to GitHub, both histories start from that first commit; nothing was
rewritten or discarded.

## What carries over from the Kotlin app (reusable assets)

### Domain models (ported to Dart, same shapes)
- `StudioProfile` → `StudioBranding`/`StudioProfile`: business name,
  tagline, logo path, primary/secondary colours (ARGB), address, phone,
  email, GSTIN, UPI id + payee name, currency (INR), invoice prefix/footer,
  timestamps. Single-studio-per-install in v1.
- `ServiceItem` (price in **paise, integer**), `Employee`, `Bill` +
  `BillLine` (line stores copied service name + price), `AttendanceRecord`,
  `SalaryRecord` (net = base − deductions + bonus; pending = net − paid).
- `StudioSnapshot`: immutable copy of studio details frozen onto each bill
  at creation time.

### Database constraints that remain binding in any future persistence
- Money is integer paise — never float/double.
- One attendance row per employee per day (unique index).
- One salary row per employee per month+year (unique index).
- Bills own their lines (cascade delete); snapshot columns on bills are
  never updated after insert.
- Migrations must be explicit — **no destructive fallback, ever**.
- Sample/demo data is never written to the production database.

### Design system (ported)
- Premium minimal POS look: deep forest `#1B3A2F`, charcoal `#232323`,
  ivory `#F7F3EB`, muted gold `#C9A96A` as the *demo preset* only.
- Serif brand wordmark, clean sans UI type, ≥48dp touch targets, no emoji
  navigation, no decorative gradients, minimal shadows.
- Dynamic branding: profile colours build the Material 3 scheme;
  foregrounds auto-derived for WCAG contrast; too-light primaries deepened.
- Responsive shells: expanded sidebar ≥840dp, icon rail 600–839dp, phone
  top bar + bottom nav (Kotlin) → Flutter POS uses rail + centre + bill
  panel on landscape tablets (Task 1.6 layout).

### Requirements that remain binding
- Offline-first for billing/attendance; no internet needed at the counter.
- First-run setup before use; settings editable later; no account in v1.
- Invoices render from their snapshot, never from the live profile.
- Demo payment QR is a labelled placeholder until the studio's real
  merchant (soundbox provider) configuration is verified. Payments are
  never routed to our own account.
- Official invoice numbers are assigned by the future backend, not locally.

## What does NOT carry over
- Room schema/code, Compose UI code, Kotlin view models — reference only.
- The Kotlin CI workflow (kept inside `legacy-android/.github` for the
  record; the Flutter app gets its own).

## Flutter architecture (this task)

```
flutter_app/lib/
  core/        theme (ThemeConfig), responsive breakpoints, formatters, result types
  branding/    StudioBranding model, presets (D POISE demo), branding provider
  features/
    billing/   POS screen (tablet 3-pane / mobile adaptive), cart state, checkout demo
    dashboard/ attendance/ employees/ payroll/ history/ reports/ settings/
    services/  sample catalog data + repository interface
  domain/      repository interfaces (studio, service, billing, employee,
               attendance, payroll, payment adapter) — persistence later
  app/         GoRouter routes, role preview state, app shell
```

State: Riverpod. Navigation: GoRouter. Persistence: Drift/SQLite is the
chosen stack for the next task — interfaces are defined now, demo state is
in-memory in this task (clearly labelled). Networking: Dio reserved for the
future Spring Boot backend (see `docs/BACKEND_API_REQUIREMENTS.md`).
No Firebase. Freezed/json_serializable are used only where they earn their
keep (branding + catalog models); hand-written immutable classes elsewhere
to keep the demo build lean.
