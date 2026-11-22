import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/branding/brand_logo.dart';
import 'package:studioflow/core/motion.dart';
import 'package:studioflow/core/theme.dart';
import 'package:studioflow/branding/studio_branding.dart';
import 'package:studioflow/data/providers.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/features/billing/employee_select_screen.dart';
import 'package:studioflow/main.dart';
import 'test_database.dart';

/// Task 5.2: safe-area behaviour, compact employee rows, lazy lists,
/// and the motion system's reduced-motion contract.
void main() {
  group('safe area (edge-to-edge)', () {
    late Override dbOverride;

    setUpAll(() async {
      dbOverride = await seededTestDatabase();
    });

    Future<void> pumpApp(
      WidgetTester tester,
      Size size, {
      required double topInset,
      required double bottomInset,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      tester.view.viewPadding = FakeViewPadding(
        top: topInset,
        bottom: bottomInset,
      );
      tester.view.padding = FakeViewPadding(
        top: topInset,
        bottom: bottomInset,
      );
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('phone: header clears the status bar, bar clears the '
        'gesture area', (tester) async {
      await pumpApp(tester, const Size(390, 844), topInset: 48, bottomInset: 34);
      // The topmost shell control (drafts button in the header) must
      // start below the 48dp status-bar inset — this is the exact
      // overlap Sree photographed on his phone.
      final draftsTop =
          tester.getTopLeft(find.byKey(const ValueKey('drafts_button'))).dy;
      expect(draftsTop, greaterThanOrEqualTo(48));
      // Bottom navigation content sits above the gesture inset.
      final moreBottom =
          tester.getBottomLeft(find.text('More')).dy;
      expect(moreBottom, lessThanOrEqualTo(844 - 34));
      expect(find.text("Who's billing?"), findsOneWidget);
    });

    testWidgets('tablet rail: the rail branding clears the status bar',
        (tester) async {
      await pumpApp(tester, const Size(1280, 800),
          topInset: 48, bottomInset: 0);
      final railLogoTop =
          tester.getTopLeft(find.byType(BrandLogo).first).dy;
      expect(railLogoTop, greaterThanOrEqualTo(48));
    });

    testWidgets('no insets: layout is unchanged (no double padding)',
        (tester) async {
      await pumpApp(tester, const Size(390, 844), topInset: 0, bottomInset: 0);
      final draftsTop =
          tester.getTopLeft(find.byKey(const ValueKey('drafts_button'))).dy;
      // Only the design spacing (14) + IconButton centring — no phantom
      // system padding is invented when the device reports none.
      expect(draftsTop, lessThan(30));
    });
  });

  group('employee selection rows', () {
    testWidgets('compact rows are 76-92dp tall', (tester) async {
      final dbOverride = await seededTestDatabase();
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
      );
      await tester.pumpAndSettle();
      final height =
          tester.getSize(find.byKey(const ValueKey('employee_card_emp_1'))).height;
      expect(height, inInclusiveRange(76, 92));
    });

    testWidgets('long lists render lazily and scroll fully', (tester) async {
      final many = [
        for (var i = 1; i <= 30; i++)
          Employee(
            id: 'emp_$i',
            name: 'Employee $i',
            role: 'Stylist',
            salaryType: SalaryType.monthly,
            monthlySalaryPaise: 100000,
          ),
      ];
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            staffListProvider.overrideWith((ref) async => many),
          ],
          child: MaterialApp(
            theme: ThemeConfig.buildTheme(dpoiseDemoBranding),
            home: const Scaffold(body: EmployeeSelectScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('employee_card_emp_1')), findsOneWidget);
      // Lazy: the 30th row is not built until scrolled into view.
      expect(find.byKey(const ValueKey('employee_card_emp_30')), findsNothing);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('employee_card_emp_30')),
        120,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('employee_card_emp_30')), findsOneWidget);
    });
  });

  group('motion system', () {
    Future<Duration> probe(WidgetTester tester, {required bool reduced}) async {
      late Duration captured;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: Builder(
              builder: (context) {
                captured = Motion.durationOf(context, Motion.standard);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      return captured;
    }

    testWidgets('durations resolve to zero under reduced motion',
        (tester) async {
      expect(await probe(tester, reduced: true), Duration.zero);
      expect(await probe(tester, reduced: false), Motion.standard);
    });

    test('motion tokens match the brief', () {
      expect(Motion.fast, const Duration(milliseconds: 120));
      expect(Motion.standard, const Duration(milliseconds: 200));
      expect(Motion.emphasis, const Duration(milliseconds: 300));
      expect(Motion.fast.inMilliseconds, inInclusiveRange(100, 150));
      expect(Motion.standard.inMilliseconds, inInclusiveRange(180, 250));
      expect(Motion.emphasis.inMilliseconds, inInclusiveRange(250, 350));
    });
  });

  group('keyboard insets', () {
    testWidgets('customer details survives the keyboard opening',
        (tester) async {
      final dbOverride = await seededTestDatabase();
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('employee_card_emp_1')));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 336);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const ValueKey('customer_name_field')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // The button sits below the fold with the keyboard open; the
      // form scrolls to it without overflow or layout jumps.
      await tester.drag(find.byType(ListView), const Offset(0, -320));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('continue_to_billing')), findsOneWidget);
    });
  });
}
