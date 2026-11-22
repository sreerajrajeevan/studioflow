import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/core/money.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/features/billing/cart.dart';
import 'package:studioflow/features/billing/checkout_controller.dart';
import 'package:studioflow/features/services/sample_catalog.dart';

/// Reliability cases from the billing-correctness requirements that can be
/// proven in unit tests today. Device/backend cases (app-switch, crash,
/// disconnection, two-device conflicts) are tracked in
/// docs/BILLING_CORRECTNESS.md — they are NOT claimed as passed here.
void main() {
  group('Cart reliability', () {
    late ProviderContainer container;
    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    CartNotifier notifier() => container.read(cartProvider.notifier);
    CartState state() => container.read(cartProvider);

    test('100 rapid selections on one service land exactly (qty 100)', () {
      final haircut =
          SampleCatalog.services.firstWhere((s) => s.id == 'svc_haircut');
      for (var i = 0; i < 100; i++) {
        notifier().addService(haircut);
      }
      expect(state().quantityOf('svc_haircut'), 100);
      expect(state().totalPaise, 100 * 30000);
    });

    test('100 rapid mixed selections across the catalog stay exact', () {
      for (var round = 0; round < 10; round++) {
        for (final service in SampleCatalog.services) {
          notifier().addService(service);
        }
      }
      final expected = SampleCatalog.services
              .fold(0, (sum, s) => sum + s.pricePaise) *
          10;
      expect(state().itemCount, 100);
      expect(state().totalPaise, expected);
    });

    test('cart with 50 distinct lines totals exactly', () {
      for (var i = 0; i < 50; i++) {
        notifier().addService(ServiceItem(
          id: 'svc_gen_$i',
          name: 'Generated $i',
          category: 'Test',
          pricePaise: 10000 + i * 137, // awkward paise values on purpose
          durationMinutes: 10,
        ));
      }
      var expected = 0;
      for (var i = 0; i < 50; i++) {
        expected += 10000 + i * 137;
      }
      expect(state().lines.length, 50);
      expect(state().totalPaise, expected);
    });

    test(
        'PRICE SNAPSHOT (Task 2 policy): a catalog price change never '
        'alters an open bill, and a re-tap at the new price opens a '
        'SEPARATE line instead of merging into the old snapshot', () {
      const before = ServiceItem(
        id: 'svc_snap',
        name: 'Snap Service',
        category: 'Hair',
        pricePaise: 30000,
        durationMinutes: 30,
      );
      const afterPriceChange = ServiceItem(
        id: 'svc_snap', // same service, catalog now charges more
        name: 'Snap Service',
        category: 'Hair',
        pricePaise: 35000,
        durationMinutes: 30,
      );
      notifier().addService(before);
      notifier().addService(afterPriceChange); // tap again after price change
      // The Task 1.6 behaviour merged this tap into the ₹300 line
      // (quantity 2, total ₹600). Task 2 §5 supersedes that policy:
      // both snapshots are preserved as separate lines.
      expect(state().lines, hasLength(2));
      final oldLine = state().lines.first;
      expect(oldLine.pricePaise, 30000, reason: 'original snapshot intact');
      expect(oldLine.quantity, 1);
      final newLine = state().lines.last;
      expect(newLine.pricePaise, 35000, reason: 'new selection, new price');
      expect(newLine.quantity, 1);
      expect(state().quantityOf('svc_snap'), 2);
      expect(state().totalPaise, 30000 + 35000);
      // A further tap at the CURRENT price merges into the ₹350 line only.
      notifier().addService(afterPriceChange);
      expect(state().lines, hasLength(2));
      expect(state().quantityOfLine('svc_snap', 35000), 2);
      expect(state().quantityOfLine('svc_snap', 30000), 1);
      expect(state().totalPaise, 30000 + 2 * 35000);
    });

    test('quantity clamps at the validated cap instead of overflowing', () {
      final haircut =
          SampleCatalog.services.firstWhere((s) => s.id == 'svc_haircut');
      notifier().addService(haircut);
      for (var i = 0; i < MoneyLimits.maxQuantity + 50; i++) {
        notifier().increment('svc_haircut');
      }
      expect(state().quantityOf('svc_haircut'), MoneyLimits.maxQuantity);
    });

    test('draft id is stable for a draft and resets when the bill empties',
        () {
      final haircut =
          SampleCatalog.services.firstWhere((s) => s.id == 'svc_haircut');
      notifier().addService(haircut);
      final first = state().draftId;
      expect(first, isNotNull);
      notifier().addService(haircut);
      expect(state().draftId, first, reason: 'same draft, same id');
      notifier().clear();
      expect(state().draftId, isNull);
      notifier().addService(haircut);
      expect(state().draftId, isNot(first),
          reason: 'a new bill gets a new idempotency key');
    });

    test('catalog search over 150 services returns the right matches', () {
      final bigCatalog = <ServiceItem>[
        for (var i = 0; i < 150; i++)
          ServiceItem(
            id: 'svc_big_$i',
            name: i % 10 == 0 ? 'Hair Treatment $i' : 'Service $i',
            category: 'Hair',
            pricePaise: 10000,
            durationMinutes: 10,
          ),
      ];
      final matches = bigCatalog
          .where((s) => s.name.toLowerCase().contains('hair'))
          .toList();
      expect(matches.length, 15);
    });
  });

  group('Checkout single-flight (duplicate submission prevention)', () {
    test('a second completion while processing is ignored', () async {
      final controller = CheckoutController();
      var runs = 0;
      Future<void> slowAction() async {
        runs++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
      }

      final first = controller.complete(slowAction);
      final second = await controller.complete(slowAction);
      expect(second, isFalse, reason: 'duplicate tap must not re-submit');
      expect(await first, isTrue);
      expect(runs, 1);
      expect(controller.state, CheckoutStatus.completed);
    });

    test('completion after completion is ignored until reset', () async {
      final controller = CheckoutController();
      expect(await controller.complete(() async {}), isTrue);
      expect(await controller.complete(() async {}), isFalse);
      controller.resetForNewDraft();
      expect(await controller.complete(() async {}), isTrue);
    });

    test('a failed submission returns to idle — the same draft can retry',
        () async {
      final controller = CheckoutController();
      await expectLater(
        controller.complete(() async => throw StateError('network down')),
        throwsStateError,
      );
      expect(controller.state, CheckoutStatus.idle);
      expect(await controller.complete(() async {}), isTrue);
    });
  });
}
