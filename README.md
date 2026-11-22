# StudioFlow — Salon & Grooming Studio Management Platform

White-label, offline-first studio management for Android tablets/phones
now, desktop and web later. One codebase serves any studio — name, logo,
colours, address, tax and UPI details are runtime configuration
(`StudioBranding`/`StudioProfile`), never hardcoded. **D POISE Groom
Studio** is the first customer and the demo preset.

## Current state (Task 1.6)

- **`flutter_app/` — the live product.** Flutter POS prototype: tablet
  3-pane billing, adaptive phone layout, demo checkout with a labelled
  DEMO QR placeholder, dashboard/attendance/employees/salary/history/
  reports/settings prototypes, white-label theming, owner/staff role
  preview. Billing core is financially correct by design: integer paise,
  one money engine, price snapshots, idempotent checkout (see
  `docs/BILLING_CORRECTNESS.md`).
- **`legacy-android/` — preserved Kotlin app** (Tasks 1 + 1.5), kept as the
  reference implementation. Do not build it; see
  `legacy-android/README-LEGACY.md`.
- **Docs:** `docs/MIGRATION_TO_FLUTTER.md` (decisions + what carries over),
  `docs/BACKEND_API_REQUIREMENTS.md` (future Spring Boot API),
  `docs/PERFORMANCE_REQUIREMENTS.md` (budgets + measurement protocol),
  `docs/INVOICE_SNAPSHOT.md` (invoice immutability rules).

## Not yet implemented

Real persistence (Drift), the backend + sync, real payment collection,
official invoice numbers (backend-assigned only), complete payroll.
Nothing in the demo pretends otherwise — sample data is badged, the QR is
a placeholder, and no bill is saved.

## Money rule

Money is **integer paise** everywhere, totals come only from the single
money engine, and a bill line's price is a snapshot from the moment it was
added. These are release-blocking rules, not conventions.
