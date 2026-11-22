/// THE money engine for StudioFlow. Every bill total in the app is computed
/// here — widgets and view models never do their own money arithmetic.
///
/// Rules (release-blocking, see docs/BILLING_CORRECTNESS.md):
/// - Integer paise only. No double ever touches a bill amount.
/// - Rounding: percentage amounts round HALF-UP to the nearest paise,
///   computed once per bill (never per line), in a fixed order:
///   subtotal → percentage discount → flat discount → tax on the
///   discounted amount → total.
/// - Totals can never go negative: discounts clamp at the subtotal.
/// - Inputs are validated against hard caps; violations throw
///   [ArgumentError] instead of silently producing a wrong bill.
/// - Dart ints are 64-bit; the caps below keep every intermediate product
///   far inside range, and the running subtotal is overflow-checked.
library;

import 'dart:math';

/// Hard validation caps. Generous for a grooming studio, small enough to
/// catch corrupt input and keep arithmetic safely in range.
abstract final class MoneyLimits {
  /// ₹10,00,000 per service — a data-entry error beyond this, not a price.
  static const maxPricePaise = 100000000;

  /// Max units of one service on a single bill line.
  static const maxQuantity = 999;

  /// Max distinct lines on one bill.
  static const maxLines = 200;

  /// ₹1,00,00,000 — sanity ceiling for a single bill's subtotal.
  static const maxSubtotalPaise = 1000000000;
}

/// One priced line as the engine sees it: price is the SNAPSHOT taken when
/// the service was added to the bill, never a live catalog lookup.
class PricedLine {
  const PricedLine({required this.pricePaise, required this.quantity});

  final int pricePaise;
  final int quantity;

  int get totalPaise => pricePaise * quantity;
}

/// The full, deterministic breakdown of a bill.
class BillTotals {
  const BillTotals({
    required this.subtotalPaise,
    required this.discountPaise,
    required this.taxPaise,
    required this.totalPaise,
  });

  final int subtotalPaise;

  /// Combined discount actually applied (after clamping at the subtotal).
  final int discountPaise;
  final int taxPaise;

  /// subtotal − discount + tax. Guaranteed >= 0.
  final int totalPaise;
}

abstract final class MoneyEngine {
  /// Percentage of an amount, rounded half-up to the nearest paise.
  /// [percent] is a whole percent (0–100). Amount must be >= 0.
  static int percentOf(int amountPaise, int percent) {
    _check(amountPaise >= 0, 'amount must not be negative');
    _check(percent >= 0 && percent <= 100, 'percent must be 0–100');
    // Half-up: add half the divisor before integer division.
    return (amountPaise * percent + 50) ~/ 100;
  }

  /// Basis-point variant for tax rates like 18% or 2.5% (250 bps),
  /// rounded half-up to the nearest paise.
  static int basisPointsOf(int amountPaise, int basisPoints) {
    _check(amountPaise >= 0, 'amount must not be negative');
    _check(basisPoints >= 0 && basisPoints <= 10000, 'bps must be 0–10000');
    return (amountPaise * basisPoints + 5000) ~/ 10000;
  }

  /// Validates a single line's inputs. Throws [ArgumentError] on violation.
  static void validateLine(int pricePaise, int quantity) {
    _check(pricePaise >= 0, 'price must not be negative');
    _check(pricePaise <= MoneyLimits.maxPricePaise, 'price exceeds cap');
    _check(quantity >= 1, 'quantity must be at least 1');
    _check(quantity <= MoneyLimits.maxQuantity, 'quantity exceeds cap');
  }

  /// Computes a bill deterministically.
  ///
  /// Order of operations (fixed, documented, tested):
  /// 1. subtotal = Σ price × qty (each line validated; running total
  ///    overflow-checked against [MoneyLimits.maxSubtotalPaise])
  /// 2. percentage discount on the subtotal (half-up)
  /// 3. flat discount added; combined discount clamps at the subtotal
  /// 4. tax (basis points) on the discounted amount (half-up)
  /// 5. total = subtotal − discount + tax (never negative)
  static BillTotals calculate({
    required List<PricedLine> lines,
    int discountPercent = 0,
    int flatDiscountPaise = 0,
    int taxBasisPoints = 0,
  }) {
    _check(lines.length <= MoneyLimits.maxLines, 'too many lines');
    _check(flatDiscountPaise >= 0, 'flat discount must not be negative');

    var subtotal = 0;
    for (final line in lines) {
      validateLine(line.pricePaise, line.quantity);
      subtotal += line.totalPaise;
      _check(subtotal <= MoneyLimits.maxSubtotalPaise,
          'subtotal exceeds cap — refusing to compute an unsafe bill');
    }

    var discount = percentOf(subtotal, discountPercent) + flatDiscountPaise;
    if (discount > subtotal) discount = subtotal; // never negative totals

    final taxable = subtotal - discount;
    final tax = basisPointsOf(taxable, taxBasisPoints);
    final total = taxable + tax;
    _check(total >= 0, 'total must not be negative');

    return BillTotals(
      subtotalPaise: subtotal,
      discountPaise: discount,
      taxPaise: tax,
      totalPaise: total,
    );
  }

  static void _check(bool condition, String message) {
    if (!condition) throw ArgumentError(message);
  }
}

/// Client-side identifier for a bill draft. Unique per draft so checkout
/// submission can be idempotent: the same draft id is retried, never a new
/// bill. (Production swaps this for a UUID v4; the format is opaque either
/// way. Official invoice numbers still come only from the backend.)
int _draftSequence = 0;
final _draftRandom = Random.secure();

String newDraftId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final seq = _draftSequence++;
  final random = _draftRandom.nextInt(1 << 32);
  return 'draft-${now.toRadixString(36)}-${seq.toRadixString(36)}-${random.toRadixString(36)}';
}
