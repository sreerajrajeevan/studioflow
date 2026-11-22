import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_database.dart';
import 'package:studioflow/features/billing/cart.dart';
import 'package:studioflow/features/services/sample_catalog.dart';
import 'package:studioflow/main.dart';

/// Screenshot deliverables for Task 1.6, rendered by the Flutter test
/// engine from the REAL app widgets (not mockups). Output lands in
/// screenshots/ via `flutter test --update-goldens test/screenshots_test.dart`
/// with the files renamed by the task script. Golden comparisons are not
/// asserted here — these tests exist to render the surfaces.
void main() {
  late Override dbOverride;

  setUpAll(() async {
    dbOverride = await seededTestDatabase();
    // Load the real Roboto + Material Icons fonts from the Flutter SDK so
    // the renders show actual text and icons instead of the test engine's
    // placeholder boxes. Skipped silently on machines where the SDK fonts
    // are not found (renders then fall back to placeholder glyphs).
    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    if (flutterRoot != null) {
      final fontsDir = '$flutterRoot/bin/cache/artifacts/material_fonts';
      Future<void> load(String family, String file) async {
        final f = File('$fontsDir/$file');
        if (await f.exists()) {
          final loader = FontLoader(family)
            ..addFont(Future.value(ByteData.view(
                (await f.readAsBytes()).buffer)));
          await loader.load();
        }
      }

      await load('Roboto', 'Roboto-Regular.ttf');
      await load('Roboto', 'Roboto-Medium.ttf');
      await load('Roboto', 'Roboto-Bold.ttf');
      await load('MaterialIcons', 'MaterialIcons-Regular.otf');
    }
  });

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(overrides: [dbOverride], child: const StudioFlowApp()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shot: tablet landscape billing', (tester) async {
    await pumpAt(tester, const Size(1280, 800));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/01_tablet_landscape_billing.png'),
    );
  });

  testWidgets('shot: tablet portrait billing', (tester) async {
    await pumpAt(tester, const Size(800, 1280));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/02_tablet_portrait_billing.png'),
    );
  });

  testWidgets('shot: mobile billing', (tester) async {
    await pumpAt(tester, const Size(390, 844));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/03_mobile_billing.png'),
    );
  });

  testWidgets('shot: checkout', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(overrides: [dbOverride]);
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);
    notifier.addService(
        SampleCatalog.services.firstWhere((s) => s.id == 'svc_haircut'));
    notifier.addService(
        SampleCatalog.services.firstWhere((s) => s.id == 'svc_gold_facial'));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const StudioFlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkout_button')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/04_checkout_demo_qr.png'),
    );
  });

  testWidgets('shot: dashboard', (tester) async {
    await pumpAt(tester, const Size(1280, 800));
    await tester.tap(find.text('Dashboard').first);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/05_dashboard.png'),
    );
  });

  testWidgets('shot: attendance', (tester) async {
    await pumpAt(tester, const Size(1280, 800));
    await tester.tap(find.text('Attendance').first);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/06_attendance.png'),
    );
  });

  testWidgets('shot: salary', (tester) async {
    await pumpAt(tester, const Size(1280, 800));
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/07_salary.png'),
    );
  });

  testWidgets('shot: settings', (tester) async {
    await pumpAt(tester, const Size(1280, 800));
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/08_settings.png'),
    );
  });
}
