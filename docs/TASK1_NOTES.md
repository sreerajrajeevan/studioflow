# Task 1 — Implementation Notes

## Implemented
- Premium design system: deep forest green `#1B3A2F`, charcoal `#232323`,
  ivory `#F7F3EB`, muted gold `#C9A96A` (sparingly). Serif brand wordmark,
  clean sans UI type, 48dp minimum touch targets, no emojis/gradients.
- Responsive shell: expanded sidebar ≥840dp, icon rail 600–839dp, phone
  fallback (top brand bar + bottom nav). All 9 destinations navigate.
- Dashboard: 5 stat cards (today's revenue, bills today, total employees,
  present today, pending salary), 4 quick actions, recent transactions,
  attendance summary — all **sample data, badged as such**, with the real
  `GetDashboardStatsUseCase` (Room flows) already written and ready.
- Placeholder screens for New Bill, Services, Billing History, Employees,
  Attendance, Salary, Reports, Settings — each states what's planned and
  that nothing real is created/charged yet.
- Room database `dpoise.db` v1: services, employees, bills, bill_lines,
  attendance, salaries (+ unique indexes for one attendance row per
  employee/day and one salary row per employee/month). DAOs expose Flows.
- Repositories (interfaces + Room impls), mappers, manual DI container,
  DashboardViewModel with StateFlow + error state.
- Tests: unit tests for salary maths, currency formatting and the
  sample-data flag; an instrumented smoke test asserting the dashboard
  renders with its SAMPLE label.
- CI: GitHub Actions debug build + unit tests + APK artifact.

## Deliberately NOT implemented (later tasks)
- Billing flow, bill persistence from UI, UPI QR generation/payment,
  receipt print/share.
- Service & employee create/edit UI.
- Attendance marking UI and salary calculation/payout recording.
- Reports queries/exports, settings persistence, backup/restore.
- Dark theme (light-only by design decision in Task 1).
- Release signing / Play publishing.

## Known issues / notes
- Local Gradle build could not run in the authoring sandbox (Java TCP to
  the Gradle daemon is blocked there — pre-existing environment rule,
  unrelated to this code). Verify via Android Studio or the CI workflow;
  treat the first green CI run as the full-compile gate.
- `fallbackToDestructiveMigration()` is acceptable only until the first
  real install ships; real migrations must be written from schema v2 on.
- No launcher artwork beyond a simple vector "D" mark — final brand asset
  from the business card should replace it before any store release.
- Phone bottom bar exposes 5 primary modules; the other 4 are reachable
  from dashboard quick actions/cards. Full 9-item navigation is the tablet
  pattern, per the brief.
