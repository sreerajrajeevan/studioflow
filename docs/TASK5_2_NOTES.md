# Task 5.2 — Premium UI Refinement, Safe-Area Fix & Motion System

Presentation layer only. No billing calculation, database, payroll or
invoice-structure changes.

## The status-bar overlap — root cause and fix

Root cause: the app targets SDK 36, so Android 15+ draws it
edge-to-edge whether it asks or not. The shell's screens are bare
widgets (no AppBar, no Scaffold of their own) inside the shell's
Scaffold, and NOTHING applied the system top inset — content began at
y=0, under the clock and notification icons. Widget tests never caught
it because the test view reports zero insets.

Fix, applied once for every screen:

- `lib/app/app_scaffold.dart` — `ShellInsets`, the documented inset
  policy: top + landscape-cutout sides applied at the shell; bottom
  deliberately NOT applied there (each bottom-edge element — the
  navigation bar, the bill summary bar, sheets — pads itself, so
  nothing is ever padded twice). Screens add design spacing only.
- `main()` opts into `SystemUiMode.edgeToEdge` explicitly so older
  Android versions behave identically to Android 15+.
- `ThemeConfig.overlayStyle(brightness)` + an `AnnotatedRegion` at the
  app root give transparent bars with theme-matched icon contrast for
  ALL screens (previously only screens with an AppBar got a style).
- The custom bottom bar paints its background through the gesture
  area while its content pads by the real bottom inset.

Tests (test/task52_test.dart) pump the real app with a fake 48dp
status-bar inset and a 34dp gesture inset and assert the header and
the bottom bar clear them, on phone AND on the tablet rail; a zero-
inset case proves no phantom padding is invented.

## Employee selection

- Phones: compact premium ROWS (84dp) in a lazy ListView.builder —
  circular initials/photo avatar, bold name, muted role, chevron;
  the session's selected employee gets a gold accent line, gold border
  and gold check. Tap = ink feedback + selection haptic + immediate
  navigation (no confirmation, no animation delay).
- Tablets: fixed-height (168dp) grid cards — no more stretched,
  mostly-empty tiles.
- Header is compact (38dp logo + studio name), title "Who's billing?",
  subtitle "Choose an employee to start."

## Design system updates (D POISE preset)

Elevated surface #222222, borders #363636, secondary text #A9A9A9
(background #050505, surface #171717, gold #F5D442 unchanged). Card
radius calmed to 14. Gold stays reserved for selection, prices,
primary actions and active navigation.

## Motion system (lib/core/motion.dart)

Tokens: fast 120ms / standard 200ms / emphasis 300ms, easeOutCubic.
Applied to: page transitions (a short fade + 12px settle via
FadeSlidePageTransitionsBuilder in both themes), the bottom-bar
indicator glide and label emphasis, the selected-employee accent,
the quantity-badge acknowledgement, and the bill-total change
(AnimatedSwitcher — the new value renders immediately; the fade never
delays it). Every duration resolves through Motion.durationOf, which
returns zero under reduced motion (MediaQuery.disableAnimations).
Animations never gate input; haptics are fire-and-forget.

## Bottom navigation

Replaced the stock Material bar with a custom refined bar: 58dp
content row, 23dp icons, 11px labels, a slim 20×3 gold indicator
above the active item, hairline top border, integrated with the black
theme on dark and charcoal on light.

## Verification

- flutter analyze: 0 errors, 0 warnings.
- flutter test: 170/170 (162 preserved + 8 new: safe-area phone/rail/
  zero-inset, row height, lazy long lists, motion tokens + reduced
  motion, keyboard-inset survival).
- Screenshots regenerated for all 10 views (test-engine renders of
  the real widgets).
- APK: GitHub Actions (the sandbox cannot build APKs).

## Honest limits

- No physical device or emulator exists in this environment, so the
  safe-area fix is proven by inset-injected widget tests and the
  renders above — Sree's phone remains the final check, as before.
- Performance budgets are still unmeasured targets; this task added
  no profiling numbers because there is no device to profile on.
  The motion work is deliberately cheap (opacity/transform on small
  elements, no full-screen animations, no work in build methods).
