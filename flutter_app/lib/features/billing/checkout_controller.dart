import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Checkout submission state machine.
///
/// DUPLICATE-SUBMISSION RULE: completion is single-flight. While a
/// submission is [processing] — or has already [completed] for the current
/// draft — further taps/calls are ignored and return false. This prevents
/// accidental double-finalization without ever blocking intentional repeat
/// service additions (those happen in the cart, not here).
///
/// In production, [complete] wraps the BillingRepository.submit call with
/// the cart's draft id as the idempotency key: a retry after a network
/// failure re-sends the SAME draft id, and the backend returns the original
/// bill instead of creating a duplicate.
enum CheckoutStatus { idle, processing, completed }

class CheckoutController extends StateNotifier<CheckoutStatus> {
  CheckoutController() : super(CheckoutStatus.idle);

  /// Runs [action] exactly once per draft. Returns true when this call
  /// performed the submission, false when it was ignored as a duplicate.
  Future<bool> complete(Future<void> Function() action) async {
    if (state != CheckoutStatus.idle) return false;
    state = CheckoutStatus.processing;
    try {
      await action();
      state = CheckoutStatus.completed;
      return true;
    } catch (_) {
      // A failed submission returns to idle so the SAME draft can retry —
      // no partial state, no lost bill.
      state = CheckoutStatus.idle;
      rethrow;
    }
  }

  /// Called when a new bill draft begins (cart cleared / new first add).
  void resetForNewDraft() => state = CheckoutStatus.idle;
}

final checkoutControllerProvider =
    StateNotifierProvider<CheckoutController, CheckoutStatus>(
  (ref) => CheckoutController(),
);
