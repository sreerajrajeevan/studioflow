import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/features/billing/cart.dart';
import 'package:studioflow/features/services/sample_catalog.dart';

void main() {
  group('Cart', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    CartNotifier notifier() => container.read(cartProvider.notifier);
    CartState state() => container.read(cartProvider);

    final haircut = SampleCatalog.services.firstWhere((s) => s.id == 'svc_haircut');
    final beardTrim = SampleCatalog.services.firstWhere((s) => s.id == 'svc_beard_trim');

    test('starts empty with zero total', () {
      expect(state().isEmpty, isTrue);
      expect(state().totalPaise, 0);
      expect(state().itemCount, 0);
    });

    test('adding a service creates one line with quantity 1', () {
      notifier().addService(haircut);
      expect(state().lines.length, 1);
      expect(state().quantityOf('svc_haircut'), 1);
      expect(state().totalPaise, 30000); // ₹300 in paise
    });

    test('tapping the same service again increments quantity', () {
      notifier().addService(haircut);
      notifier().addService(haircut);
      notifier().addService(haircut);
      expect(state().lines.length, 1);
      expect(state().quantityOf('svc_haircut'), 3);
      expect(state().totalPaise, 90000);
    });

    test('different services create separate lines; total is exact paise', () {
      notifier().addService(haircut); // 30000
      notifier().addService(beardTrim); // 15000
      notifier().addService(beardTrim); // 15000
      expect(state().lines.length, 2);
      expect(state().itemCount, 3);
      expect(state().totalPaise, 60000);
    });

    test('decrement lowers quantity and updates total', () {
      notifier().addService(haircut);
      notifier().addService(haircut);
      notifier().decrement('svc_haircut');
      expect(state().quantityOf('svc_haircut'), 1);
      expect(state().totalPaise, 30000);
    });

    test('decrementing the final unit removes the line', () {
      notifier().addService(haircut);
      notifier().decrement('svc_haircut');
      expect(state().isEmpty, isTrue);
      expect(state().totalPaise, 0);
    });

    test('removeLine drops a line regardless of quantity', () {
      notifier().addService(haircut);
      notifier().addService(haircut);
      notifier().addService(beardTrim);
      notifier().removeLine('svc_haircut');
      expect(state().lines.length, 1);
      expect(state().totalPaise, 15000);
    });

    test('clear empties the whole bill', () {
      notifier().addService(haircut);
      notifier().addService(beardTrim);
      notifier().clear();
      expect(state().isEmpty, isTrue);
      expect(state().totalPaise, 0);
    });

    test('decrement on an absent service is a safe no-op', () {
      notifier().decrement('svc_haircut');
      expect(state().isEmpty, isTrue);
    });
  });
}
