import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/core/money.dart';

void main() {
  group('MoneyEngine — the single calculation path', () {
    test('subtotal is exact integer arithmetic', () {
      final totals = MoneyEngine.calculate(lines: const [
        PricedLine(pricePaise: 30000, quantity: 2), // Haircut ×2
        PricedLine(pricePaise: 15000, quantity: 1), // Beard Trim
        PricedLine(pricePaise: 120000, quantity: 1), // Gold Facial
      ]);
      expect(totals.subtotalPaise, 195000);
      expect(totals.discountPaise, 0);
      expect(totals.taxPaise, 0);
      expect(totals.totalPaise, 195000);
    });

    test('empty bill totals zero', () {
      final totals = MoneyEngine.calculate(lines: const []);
      expect(totals.totalPaise, 0);
    });

    test('percentage discount rounds half-up to the nearest paise', () {
      // 10% of ₹100.05 (10005 paise) = 1000.5 paise -> 1001 (half-up).
      expect(MoneyEngine.percentOf(10005, 10), 1001);
      // 10% of 10004 = 1000.4 -> 1000.
      expect(MoneyEngine.percentOf(10004, 10), 1000);
      // Exact case stays exact.
      expect(MoneyEngine.percentOf(30000, 10), 3000);
    });

    test('tax uses basis points with half-up rounding', () {
      // 18% GST on ₹450.00 = ₹81.00 exactly.
      expect(MoneyEngine.basisPointsOf(45000, 1800), 8100);
      // 2.5% of 10005 = 250.125 -> 250.
      expect(MoneyEngine.basisPointsOf(10005, 250), 250);
      // 2.5% of 10010 = 250.25 -> 250; of 10030 = 250.75 -> 251.
      expect(MoneyEngine.basisPointsOf(10030, 250), 251);
    });

    test('order: percent discount, then flat, then tax on discounted amount',
        () {
      final totals = MoneyEngine.calculate(
        lines: const [PricedLine(pricePaise: 100000, quantity: 1)], // ₹1,000
        discountPercent: 10, // −₹100
        flatDiscountPaise: 5000, // −₹50
        taxBasisPoints: 1800, // 18% on ₹850 = ₹153
      );
      expect(totals.subtotalPaise, 100000);
      expect(totals.discountPaise, 15000);
      expect(totals.taxPaise, 15300);
      expect(totals.totalPaise, 100300);
    });

    test('discount larger than the bill clamps — total never negative', () {
      final totals = MoneyEngine.calculate(
        lines: const [PricedLine(pricePaise: 10000, quantity: 1)],
        flatDiscountPaise: 999999,
      );
      expect(totals.discountPaise, 10000);
      expect(totals.totalPaise, 0);
    });

    test('100% discount yields a zero bill, not a negative one', () {
      final totals = MoneyEngine.calculate(
        lines: const [PricedLine(pricePaise: 45000, quantity: 3)],
        discountPercent: 100,
        taxBasisPoints: 1800,
      );
      expect(totals.totalPaise, 0);
      expect(totals.taxPaise, 0);
    });

    group('validation rejects corrupt input instead of mis-billing', () {
      test('negative price', () {
        expect(
          () => MoneyEngine.calculate(
              lines: const [PricedLine(pricePaise: -1, quantity: 1)]),
          throwsArgumentError,
        );
      });
      test('zero quantity', () {
        expect(
          () => MoneyEngine.calculate(
              lines: const [PricedLine(pricePaise: 100, quantity: 0)]),
          throwsArgumentError,
        );
      });
      test('quantity above cap', () {
        expect(
          () => MoneyEngine.calculate(lines: const [
            PricedLine(pricePaise: 100, quantity: MoneyLimits.maxQuantity + 1),
          ]),
          throwsArgumentError,
        );
      });
      test('price above cap', () {
        expect(
          () => MoneyEngine.calculate(lines: const [
            PricedLine(pricePaise: MoneyLimits.maxPricePaise + 1, quantity: 1),
          ]),
          throwsArgumentError,
        );
      });
      test('negative flat discount', () {
        expect(
          () => MoneyEngine.calculate(
            lines: const [PricedLine(pricePaise: 100, quantity: 1)],
            flatDiscountPaise: -5,
          ),
          throwsArgumentError,
        );
      });
      test('subtotal above the safety cap is refused, not overflowed', () {
        expect(
          () => MoneyEngine.calculate(lines: const [
            PricedLine(pricePaise: MoneyLimits.maxPricePaise, quantity: 999),
            PricedLine(pricePaise: MoneyLimits.maxPricePaise, quantity: 999),
          ]),
          throwsArgumentError,
        );
      });
      test('percent out of range', () {
        expect(() => MoneyEngine.percentOf(1000, 101), throwsArgumentError);
        expect(() => MoneyEngine.basisPointsOf(1000, 10001),
            throwsArgumentError);
      });
    });

    test('draft ids are unique across rapid creation', () {
      final ids = <String>{for (var i = 0; i < 5000; i++) newDraftId()};
      expect(ids.length, 5000);
    });
  });
}
