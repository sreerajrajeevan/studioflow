import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/app/state.dart';
import 'package:studioflow/features/services/services_screen.dart';

import 'test_database.dart';

/// Task 2: the Services management screen — owner controls vs the
/// read-only staff preview, and live search filtering.
void main() {
  late Override dbOverride;

  setUpAll(() async {
    dbOverride = await seededTestDatabase();
  });

  Future<void> pumpScreen(WidgetTester tester, {required bool owner}) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbOverride,
          if (!owner) roleProvider.overrideWith((ref) => AppRole.staff),
        ],
        child: const MaterialApp(home: Scaffold(body: ServicesScreen())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('owner sees the seeded catalog with editing controls',
      (tester) async {
    await pumpScreen(tester, owner: true);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Haircut'), findsWidgets);
    expect(find.text('Add service'), findsWidgets);
    expect(find.byType(Switch), findsWidgets);
    expect(find.text('Categories'), findsOneWidget);
  });

  testWidgets('staff get a read-only view with the honesty note',
      (tester) async {
    await pumpScreen(tester, owner: false);
    expect(find.textContaining('not secure authentication'), findsOneWidget);
    expect(find.text('Add service'), findsNothing);
    expect(find.byType(Switch), findsNothing);
    expect(find.text('Haircut'), findsWidgets, reason: 'staff can view');
  });

  testWidgets('search filters the list', (tester) async {
    await pumpScreen(tester, owner: true);
    await tester.enterText(
      find.byKey(const ValueKey('services_search')),
      'gold',
    );
    await tester.pumpAndSettle();
    expect(find.text('Gold Facial'), findsWidgets);
    expect(find.text('Beard Trim'), findsNothing);
  });
}
