# StudioFlow (Flutter)

White-label salon & grooming studio management platform — the Flutter
generation of StudioFlow (Task 1.6). The Kotlin app it succeeds is preserved
in `../legacy-android/`; migration decisions live in
`../docs/MIGRATION_TO_FLUTTER.md`.

## What this build is

An **interactive UI prototype** with a financially-correct billing core:

- Tablet-first POS: navigation rail + service grid + always-visible bill
  panel (landscape), adaptive portrait and phone compositions.
- Working cart demo: tap to add, steppers, price snapshots, integer-paise
  totals via the single `MoneyEngine` (`lib/core/money.dart`).
- Checkout demo with a clearly labelled **DEMO QR placeholder** — no real
  payment QR, no payment collected, no bill persisted.
- Prototype screens: Dashboard, Attendance, Employees, Salary, History,
  Reports, Settings — all sample data badged SAMPLE.
- White-label theming: `StudioBranding` drives the whole Material 3 theme;
  D POISE is the demo preset. Settings edits re-theme live.
- Owner/Staff **role preview** (UI only, not authentication).

## What this build is not

- No persistence yet (Drift/SQLite is the declared next step; repository
  interfaces are in `lib/domain/repositories.dart`).
- No backend (Spring Boot API designed in `../docs/BACKEND_API_REQUIREMENTS.md`).
- No real payments, no official invoice numbers (backend-assigned).

## Billing correctness

Release-blocking rules and the test matrix live in
`../docs/BILLING_CORRECTNESS.md`; performance budgets and the measurement
protocol in `../docs/PERFORMANCE_REQUIREMENTS.md`. Run the proof suite:

```
flutter analyze
flutter test
flutter build apk --debug
```

Screenshots in `screenshots/` are rendered from the real app widgets by
the Flutter test engine (`test/screenshots_test.dart`, `--update-goldens`).
