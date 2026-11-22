import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/app/state.dart';
import 'package:studioflow/branding/studio_branding.dart';
import 'package:studioflow/core/theme.dart';
import 'package:studioflow/main.dart';
import 'test_database.dart';

/// Layout, navigation, role and theme tests.
/// Golden PNGs from these same surfaces are kept in screenshots/ as the
/// Task 1.6 visual deliverables (rendered by the Flutter test engine).
void main() {
  late Override dbOverride;

  setUpAll(() async {
    dbOverride = await seededTestDatabase();
  });

  Future<void> pumpApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
    );
    await tester.pumpAndSettle();
  }


  /// Drives the Task 5.1 flow from startup to the services screen:
  /// splash forwards to employee selection, pick the first employee,
  /// enter a valid customer, continue to billing.
  Future<void> driveToServices(WidgetTester tester) async {
    expect(find.text("Who's billing?"), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('employee_card_emp_1')));
    await tester.pumpAndSettle();
    expect(find.text('Customer Details'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('customer_name_field')),
      'Test Customer',
    );
    await tester.enterText(
      find.byKey(const ValueKey('customer_phone_field')),
      '98765 43210',
    );
    await tester.tap(find.byKey(const ValueKey('continue_to_billing')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('service_grid')), findsOneWidget);
  }

  testWidgets('tablet landscape: 3-pane POS with visible bill panel',
      (tester) async {
    await pumpApp(tester, const Size(1280, 800));
    await driveToServices(tester);
    expect(find.text('Current bill'), findsOneWidget);
    expect(find.text('Haircut'), findsOneWidget);
    expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
    // Checkout disabled on an empty bill.
    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('checkout_button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('tablet portrait: grid + sticky bill summary, no clipped panel',
      (tester) async {
    await pumpApp(tester, const Size(800, 1280));
    await driveToServices(tester);
    expect(find.text('Haircut'), findsOneWidget);
    expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
    expect(find.text('No items yet'), findsOneWidget);
  });

  testWidgets('mobile: dedicated composition with bottom summary',
      (tester) async {
    await pumpApp(tester, const Size(390, 844));
    await driveToServices(tester);
    expect(find.text('Haircut'), findsOneWidget);
    expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
  });

  testWidgets('tapping a service updates the bill total immediately',
      (tester) async {
    await pumpApp(tester, const Size(1280, 800));
    await driveToServices(tester);
    await tester.tap(find.byKey(const ValueKey('service_tile_svc_haircut')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('qty_badge_svc_haircut')), findsOneWidget);
    expect(find.text('₹300'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('service_tile_svc_haircut')));
    await tester.pumpAndSettle();
    expect(find.text('₹600'), findsWidgets);
  });

  testWidgets('navigation: rail switches to Attendance', (tester) async {
    await pumpApp(tester, const Size(1280, 800));
    await tester.tap(find.text('Attendance').first);
    await tester.pumpAndSettle();
    // Task 4: attendance is real — the daily marking view loads the
    // seeded team from Drift (no more demo subtitle).
    expect(find.text('Daily marking'), findsOneWidget);
    expect(find.text('Arun Kumar'), findsOneWidget);
  });

  testWidgets('staff preview hides Salary, Reports and Settings',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbOverride,
          roleProvider.overrideWith((ref) => AppRole.staff),
        ],
        child: const StudioFlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    // Open the More sheet — admin destinations must not be offered.
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsNothing);
    expect(find.text('Reports'), findsNothing);
    expect(find.text('Settings'), findsNothing);
    expect(find.text('Employees'), findsNothing);
  });

  testWidgets('rotation: cart survives an orientation change',
      (tester) async {
    await pumpApp(tester, const Size(1280, 800));
    await driveToServices(tester);
    await tester.tap(find.byKey(const ValueKey('service_tile_svc_haircut')));
    await tester.pumpAndSettle();
    expect(find.text('₹300'), findsWidgets);
    // Rotate to portrait — layout adapts, the bill must NOT clear.
    tester.view.physicalSize = const Size(800, 1280);
    await tester.pumpAndSettle();
    expect(find.text('₹300'), findsWidgets);
    expect(find.text('1 item'), findsOneWidget);
    expect(find.byKey(const ValueKey('view_bill_button')), findsOneWidget);
    // And back to landscape.
    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('qty_badge_svc_haircut')), findsOneWidget);
  });

  test('dynamic theme: scheme is built from the studio branding', () {
    final ocean = dpoiseDemoBranding.copyWith(
      primaryColor: const Color(0xFF14486B),
      secondaryColor: const Color(0xFF7FB3D5),
    );
    final theme = ThemeConfig.buildTheme(ocean);
    expect(theme.colorScheme.primary, const Color(0xFF14486B));
    expect(theme.colorScheme.secondary, const Color(0xFF7FB3D5));
  });

  test('dynamic theme: too-light primaries are deepened for readability', () {
    // The light-theme readability rule: the D POISE preset is dark
    // now (Task 5.1), so exercise the light path explicitly.
    final pale = dpoiseDemoBranding.copyWith(
      primaryColor: const Color(0xFFFFE066),
      dark: false,
    );
    final theme = ThemeConfig.buildTheme(pale);
    expect(
      ThemeConfig.meetsAa(
        const Color(0xFFFBF9F4),
        theme.colorScheme.primary,
      ),
      isTrue,
    );
  });
}
