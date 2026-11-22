import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/features/billing/cart.dart';
import 'package:studioflow/features/services/sample_catalog.dart';
import 'package:studioflow/main.dart';
import 'test_database.dart';

/// Task 5.3: bill quantity & remove controls — cart semantics, the
/// mobile expanded bill sheet, the tablet panel, clear confirmation,
/// and draft restore of updated quantities.
void main() {
  final haircut =
      SampleCatalog.services.firstWhere((s) => s.id == 'svc_haircut');
  final beard =
      SampleCatalog.services.firstWhere((s) => s.id == 'svc_beard_trim');

  group('cart quantity operations', () {
    test('minus at quantity one removes the line', () {
      final cart = CartNotifier();
      cart.addService(haircut);
      expect(cart.state.lines, hasLength(1));
      cart.decrementLine('svc_haircut', 30000);
      expect(cart.state.lines, isEmpty);
      expect(cart.state.totalPaise, 0);
    });

    test('remove deletes only that line; totals update immediately', () {
      final cart = CartNotifier();
      cart.addService(haircut);
      cart.addService(beard);
      cart.incrementLine('svc_haircut', 30000);
      expect(cart.state.totalPaise, 30000 * 2 + 15000);
      cart.removeLineAt('svc_haircut', 30000);
      expect(cart.state.lines, hasLength(1));
      expect(cart.state.lines.single.serviceId, 'svc_beard_trim');
      expect(cart.state.totalPaise, 15000);
    });

    test('snapshot prices stay separate lines; steppers hit the exact line',
        () {
      final cart = CartNotifier();
      cart.addService(haircut); // ₹300 snapshot
      cart.addService(haircut.copyWith(pricePaise: 35000)); // ₹350 snapshot
      expect(cart.state.lines, hasLength(2));
      cart.incrementLine('svc_haircut', 35000);
      final dearer =
          cart.state.lines.firstWhere((l) => l.pricePaise == 35000);
      final cheaper =
          cart.state.lines.firstWhere((l) => l.pricePaise == 30000);
      expect(dearer.quantity, 2);
      expect(cheaper.quantity, 1);
      expect(cart.state.totalPaise, 35000 * 2 + 30000);
      cart.removeLineAt('svc_haircut', 30000);
      expect(cart.state.lines.single.pricePaise, 35000);
    });

    test('rapid repeated taps accumulate exactly', () {
      final cart = CartNotifier();
      cart.addService(haircut);
      for (var i = 0; i < 24; i++) {
        cart.incrementLine('svc_haircut', 30000);
      }
      expect(cart.state.lines.single.quantity, 25);
      for (var i = 0; i < 25; i++) {
        cart.decrementLine('svc_haircut', 30000);
      }
      expect(cart.state.lines, isEmpty);
    });

    test('clear empties the bill', () {
      final cart = CartNotifier();
      cart.addService(haircut);
      cart.addService(beard);
      cart.clear();
      expect(cart.state.lines, isEmpty);
      expect(cart.state.isEmpty, isTrue);
    });
  });

  group('draft restore keeps updated quantities', () {
    test('quantities and separate price lines round-trip', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final store = DriftDraftStore(db);
      final cart = CartNotifier();
      cart.setBillingEmployee('emp_1', 'Arun Kumar');
      cart.addService(haircut);
      cart.incrementLine('svc_haircut', 30000);
      cart.incrementLine('svc_haircut', 30000);
      cart.addService(haircut.copyWith(pricePaise: 35000));
      await store.saveDraft(cart.state);

      final loaded = await store.loadDraft(cart.state.draftId!);
      expect(loaded, isNotNull);
      expect(loaded!.lines, hasLength(2));
      expect(
        loaded.lines.firstWhere((l) => l.pricePaise == 30000).quantity,
        3,
      );
      expect(
        loaded.lines.firstWhere((l) => l.pricePaise == 35000).quantity,
        1,
      );
      expect(loaded.totalPaise, 30000 * 3 + 35000);
    });
  });

  group('widget: mobile expanded bill', () {
    late Override dbOverride;

    setUpAll(() async {
      dbOverride = await seededTestDatabase();
    });

    Future<void> toServicesWithItems(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('employee_card_emp_1')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('customer_name_field')), 'Ajay Kumar');
      await tester.enterText(
          find.byKey(const ValueKey('customer_phone_field')), '9876543210');
      await tester.tap(find.byKey(const ValueKey('continue_to_billing')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('service_tile_svc_haircut')));
      await tester.pumpAndSettle();
    }

    testWidgets('View Bill opens the sheet; steppers and remove work there',
        (tester) async {
      await toServicesWithItems(tester);
      expect(find.byKey(const ValueKey('view_bill_button')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('view_bill_button')));
      await tester.pumpAndSettle();
      // The expanded bill shows the line with all required controls.
      expect(find.text('Current bill'), findsOneWidget);
      expect(find.byKey(const ValueKey('inc_svc_haircut_30000')), findsOneWidget);
      expect(find.byKey(const ValueKey('dec_svc_haircut_30000')), findsOneWidget);
      expect(
          find.byKey(const ValueKey('remove_svc_haircut_30000')), findsOneWidget);
      // Screen-reader labels name the service.
      expect(find.bySemanticsLabel('Increase quantity of Haircut'),
          findsOneWidget);
      expect(find.bySemanticsLabel('Remove Haircut from bill'), findsOneWidget);
      // Plus: quantity and total update immediately.
      await tester.tap(find.byKey(const ValueKey('inc_svc_haircut_30000')));
      await tester.pumpAndSettle();
      expect(find.text('₹600'), findsWidgets);
      // Minus back to one, then minus again removes the line entirely.
      await tester.tap(find.byKey(const ValueKey('dec_svc_haircut_30000')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('dec_svc_haircut_30000')));
      await tester.pumpAndSettle();
      expect(find.text('Tap a service to start the bill'), findsOneWidget);
      final checkout = tester.widget<FilledButton>(
          find.byKey(const ValueKey('checkout_button')).last);
      expect(checkout.onPressed, isNull);
    });

    testWidgets('remove button deletes the line from the sheet',
        (tester) async {
      await toServicesWithItems(tester);
      await tester.tap(find.byKey(const ValueKey('service_tile_svc_beard_trim')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('view_bill_button')));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const ValueKey('remove_svc_haircut_30000')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('line_svc_haircut_30000')), findsNothing);
      expect(find.byKey(const ValueKey('line_svc_beard_trim_15000')),
          findsOneWidget);
    });

    testWidgets('clear bill asks for confirmation first', (tester) async {
      await toServicesWithItems(tester);
      await tester.tap(find.byKey(const ValueKey('view_bill_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      expect(find.text('Clear this bill?'), findsOneWidget);
      // Cancelling keeps the bill intact.
      await tester.tap(find.text('Keep bill'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('line_svc_haircut_30000')),
          findsOneWidget);
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear bill'));
      await tester.pumpAndSettle();
      expect(find.text('Tap a service to start the bill'), findsOneWidget);
    });

    testWidgets('stepper touch targets are at least 48dp', (tester) async {
      await toServicesWithItems(tester);
      await tester.tap(find.byKey(const ValueKey('view_bill_button')));
      await tester.pumpAndSettle();
      for (final key in [
        const ValueKey('inc_svc_haircut_30000'),
        const ValueKey('dec_svc_haircut_30000'),
        const ValueKey('remove_svc_haircut_30000'),
      ]) {
        final size = tester.getSize(find.byKey(key));
        expect(size.width, greaterThanOrEqualTo(48), reason: '$key width');
        expect(size.height, greaterThanOrEqualTo(48), reason: '$key height');
      }
    });
  });

  group('widget: tablet persistent panel', () {
    testWidgets('panel is visible with working controls, no sheet needed',
        (tester) async {
      final dbOverride = await seededTestDatabase();
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('employee_card_emp_1')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('customer_name_field')), 'Ajay Kumar');
      await tester.enterText(
          find.byKey(const ValueKey('customer_phone_field')), '9876543210');
      await tester.tap(find.byKey(const ValueKey('continue_to_billing')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('service_tile_svc_haircut')));
      await tester.pumpAndSettle();
      // The right-hand panel is already there — no View Bill on tablet.
      expect(find.byKey(const ValueKey('view_bill_button')), findsNothing);
      expect(find.byKey(const ValueKey('inc_svc_haircut_30000')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('inc_svc_haircut_30000')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('bill_total')))
            .data,
        '₹600',
      );
      await tester
          .tap(find.byKey(const ValueKey('remove_svc_haircut_30000')));
      await tester.pumpAndSettle();
      expect(find.text('Tap a service to start the bill'), findsOneWidget);
    });
  });
}
