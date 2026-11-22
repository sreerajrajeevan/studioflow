import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/core/format.dart';

void main() {
  group('inr formatting (Indian grouping, integer paise)', () {
    test('whole rupees have no decimals', () {
      expect(inr(30000), '₹300');
      expect(inr(0), '₹0');
      expect(inr(120000), '₹1,200');
    });
    test('Indian grouping for large amounts', () {
      expect(inr(1245000), '₹12,450');
      expect(inr(18430000), '₹1,84,300');
      expect(inr(10000000), '₹1,00,000');
    });
    test('paise remainder shows two decimals', () {
      expect(inr(15050), '₹150.50');
      expect(inr(99), '₹0.99');
    });
    test('negatives are prefixed', () {
      expect(inr(-50000), '-₹500');
    });
  });
}
