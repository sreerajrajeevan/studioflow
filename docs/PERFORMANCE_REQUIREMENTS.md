# Performance Budgets & Measurement Protocol (Task 1.6 + POS requirement)

These are **budgets, not results**. Nothing in this document claims a
target has been met — see "Current status" at the bottom.

## Budgets (low-to-mid-range Android reference device, profile/release build)

| Interaction | Budget (p95) |
|---|---|
| Service tap → visible cart update | ≤ 50 ms |
| Total recomputation + display | ≤ 50 ms |
| Local checkout screen transition | ≤ 150 ms |
| Cached service search results | ≤ 100 ms |
| Scrolling | no sustained jank at realistic catalog sizes (100+ services) |

## How the design defends the budgets

- **Catalog is local.** Services render from the in-memory cached catalog
  (Drift cache in the persistence task). Adding a service NEVER touches the
  network or disk — `CartNotifier.addService` is pure in-memory state.
- **Narrow rebuilds.** Service tiles watch only their own quantity
  (`cartProvider.select(quantityOf)`); the catalog column holds search/
  category in local state; only the bill panel + summary watch the total.
  The whole billing screen never rebuilds for a tap.
- **Totals are O(lines)** integer additions via `MoneyEngine` — no
  allocation-heavy recomputation, no floating point.
- **Lazy grids** (`GridView.builder`), stable `ValueKey`s on tiles, lines
  and badges; no input-delaying animations on the billing path.
- **No blocking I/O on the UI thread** — there is no I/O at all on the
  billing path in this task; persistence (next task) writes drafts via
  Drift asynchronously off the tap path.

## Measurement protocol (when hardware is available)

1. Reference device: record model, SoC, RAM, Android version.
2. Build: `flutter build apk --profile` (or `--release`), install, cold start.
3. Use Flutter DevTools timeline / `SchedulerBinding` frame timings in a
   dedicated benchmark harness screen that performs: 100 scripted service
   taps, a 150-service catalog scroll, 20 checkout transitions, 50 searches.
4. Report p50 and p95 per interaction, plus dropped-frame counts, test
   conditions, and any budget failures with the identified bottleneck.
5. A missed budget blocks the billing feature from being called complete
   until fixed or explicitly re-budgeted by the owner.

## Current status (honest)

- **Not measured on hardware.** The authoring sandbox has no Android
  device or emulator, and its Gradle daemon is blocked, so no profile-mode
  device numbers exist yet. No result is claimed.
- Logic-level timing of the money engine/cart can be run on the host
  (`flutter test`) but host VM timings are NOT device p95 numbers and are
  never reported as such.
- First hardware pass is a gating item for the persistence/billing task.
