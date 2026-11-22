import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:studioflow/branding/studio_branding.dart';
import 'package:studioflow/core/phone_validation.dart';
import 'package:studioflow/core/theme.dart';
import 'package:studioflow/data/billing_repository.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/features/billing/cart.dart';
import 'package:studioflow/features/billing/invoice_document.dart';
import 'package:studioflow/features/services/sample_catalog.dart';
import 'package:studioflow/main.dart';
import 'test_database.dart';

/// Task 5.1: black & gold redesign + the employee -> customer ->
/// services billing flow. Session capture, persistence, snapshots,
/// validation, theme, migration and the end-to-end widget flow.
void main() {
  group('phone validation', () {
    test('accepts and normalizes Indian mobile formats', () {
      expect(normalizeIndianMobile('9876543210'), '9876543210');
      expect(normalizeIndianMobile('98765 43210'), '9876543210');
      expect(normalizeIndianMobile('+91 98765 43210'), '9876543210');
      expect(normalizeIndianMobile('919876543210'), '9876543210');
      expect(normalizeIndianMobile('09876543210'), '9876543210');
    });

    test('rejects invalid numbers', () {
      expect(normalizeIndianMobile(''), isNull);
      expect(normalizeIndianMobile('1234567890'), isNull); // starts 1
      expect(normalizeIndianMobile('987654321'), isNull); // 9 digits
      expect(normalizeIndianMobile('98765432109'), isNull); // 11, no 0
      expect(normalizeIndianMobile('abcdefghij'), isNull);
      expect(normalizeIndianMobile('+1 2025550123'), isNull);
    });
  });

  group('billing session on the cart', () {
    test('selecting an employee starts a persistable session', () {
      final cart = CartNotifier();
      expect(cart.state.draftId, isNull);
      expect(cart.state.hasSession, isFalse);
      cart.setBillingEmployee('emp_1', 'Arun Kumar');
      expect(cart.state.draftId, isNotNull);
      expect(cart.state.hasSession, isTrue);
      expect(cart.state.billingEmployeeId, 'emp_1');
    });

    test('new lines default to the session employee; override still works',
        () {
      final cart = CartNotifier();
      cart.setBillingEmployee('emp_1', 'Arun Kumar');
      cart.addService(SampleCatalog.services
          .firstWhere((s) => s.id == 'svc_haircut'));
      expect(cart.state.lines.single.employeeId, 'emp_1');
      expect(cart.state.lines.single.employeeName, 'Arun Kumar');
      cart.setLineEmployee('svc_haircut', 30000,
          employeeId: 'emp_2', employeeName: 'Deepak Raj');
      expect(cart.state.lines.single.employeeId, 'emp_2');
    });

    test('customer capture trims and stores all three fields', () {
      final cart = CartNotifier();
      cart.setCustomer(
          name: '  Ajay Kumar ', phone: ' 9876543210 ', notes: ' VIP ');
      expect(cart.state.customerName, 'Ajay Kumar');
      expect(cart.state.customerPhone, '9876543210');
      expect(cart.state.customerNotes, 'VIP');
    });
  });

  group('draft persistence of the full session (schema v6)', () {
    test('session, discounts, tax and line employees round-trip', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final store = DriftDraftStore(db);
      final cart = CartNotifier();
      cart.setBillingEmployee('emp_1', 'Arun Kumar');
      cart.setCustomer(
          name: 'Ajay Kumar', phone: '9876543210', notes: 'First visit');
      cart.addService(SampleCatalog.services
          .firstWhere((s) => s.id == 'svc_haircut'));
      cart.setDiscountPercent(10);
      cart.setFlatDiscountPaise(500);
      cart.setTaxBasisPoints(1800);
      await store.saveDraft(cart.state);

      final loaded = await store.loadDraft(cart.state.draftId!);
      expect(loaded, isNotNull);
      expect(loaded!.billingEmployeeId, 'emp_1');
      expect(loaded.billingEmployeeName, 'Arun Kumar');
      expect(loaded.customerName, 'Ajay Kumar');
      expect(loaded.customerPhone, '9876543210');
      expect(loaded.customerNotes, 'First visit');
      expect(loaded.discountPercent, 10);
      expect(loaded.flatDiscountPaise, 500);
      expect(loaded.taxBasisPoints, 1800);
      expect(loaded.lines.single.employeeId, 'emp_1');
      expect(loaded.totalPaise, cart.state.totalPaise);
    });
  });

  group('invoice snapshot carries the session', () {
    test('phone, notes and billing employee are frozen on the bill',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final cart = CartState(
        draftId: 'draft_51',
        billingEmployeeId: 'emp_1',
        billingEmployeeName: 'Arun Kumar',
        customerName: 'Ajay Kumar',
        customerPhone: '9876543210',
        customerNotes: 'First visit',
        lines: const [
          CartLine(
            serviceId: 's1',
            serviceName: 'Haircut',
            pricePaise: 30000,
            durationMinutes: 30,
            quantity: 1,
            employeeId: 'emp_1',
            employeeName: 'Arun Kumar',
          ),
        ],
      );
      const studio = StudioSnapshot(
        businessName: 'D POISE',
        address: '',
        phone: '',
        invoicePrefix: 'DP',
      );
      final bill = await DriftBillingRepository(db).finalizeDraft(
        cart: cart,
        studio: studio,
        studioPrimaryColor: 0xFFF5D442,
        payments: const [],
        actor: 'Owner',
        customerName: cart.customerName,
      );
      expect(bill.customerPhone, '9876543210');
      expect(bill.customerNotes, 'First visit');
      expect(bill.billingEmployeeId, 'emp_1');
      expect(bill.billingEmployeeName, 'Arun Kumar');
      final doc = InvoiceDocument.fromBill(bill);
      final text = formatTextReceipt(doc);
      expect(text, contains('9876543210'));
      expect(text, contains('Arun Kumar'));
    });
  });

  group('black & gold theme', () {
    test('the D POISE preset builds the dark scheme from the brief', () {
      final theme = ThemeConfig.buildTheme(dpoiseDemoBranding);
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, const Color(0xFF050505));
      expect(theme.colorScheme.primary, const Color(0xFFF5D442));
      expect(theme.colorScheme.surface, const Color(0xFF171717));
      expect(theme.cardTheme.color, const Color(0xFF222222));
      expect(theme.colorScheme.outline, const Color(0xFF363636));
      expect(theme.colorScheme.onSurface, const Color(0xFFFFFFFF));
      expect(theme.colorScheme.onSurfaceVariant, const Color(0xFFA9A9A9));
      // The old green must not appear anywhere in the D POISE scheme.
      expect(theme.colorScheme.primary, isNot(const Color(0xFF1B3A2F)));
      expect(theme.scaffoldBackgroundColor, isNot(const Color(0xFF1B3A2F)));
    });

    test('light presets still build the light scheme (white-label)', () {
      final ocean = dpoiseDemoBranding.copyWith(
        primaryColor: const Color(0xFF14486B),
        dark: false,
      );
      final theme = ThemeConfig.buildTheme(ocean);
      expect(theme.brightness, Brightness.light);
    });

    test('the preset carries the original logo, unmodified bytes', () {
      expect(dpoiseDemoBranding.logoAssetPath, poiseLogoAssetKey);
      expect(dpoiseDemoBranding.dark, isTrue);
    });
  });

  group('schema migration v5 -> v6', () {
    test('a v5 database upgrades; session columns default cleanly',
        () async {
      final dir = await Directory.systemTemp.createTemp('sf_mig6_');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/v5.db';
      final raw = sqlite3.sqlite3.open(path);
      raw.execute('''
        CREATE TABLE "bill_drafts" ("draft_id" TEXT NOT NULL, "discount_percent" INTEGER NOT NULL DEFAULT 0, "discount_flat_paise" INTEGER NOT NULL DEFAULT 0, "tax_basis_points" INTEGER NOT NULL DEFAULT 0, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("draft_id"));
        CREATE TABLE "draft_lines" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "draft_id" TEXT NOT NULL REFERENCES bill_drafts (draft_id) ON DELETE CASCADE, "service_id" TEXT NOT NULL, "service_name" TEXT NOT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "quantity" INTEGER NOT NULL, "employee_id" TEXT NULL, "employee_name" TEXT NULL, "position" INTEGER NOT NULL, UNIQUE ("draft_id", "service_id", "price_paise"));
        CREATE TABLE "studio_profiles" ("id" INTEGER NOT NULL, "business_name" TEXT NOT NULL, "tagline" TEXT NULL, "logo_path" TEXT NULL, "primary_color" INTEGER NOT NULL, "secondary_color" INTEGER NOT NULL, "address" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "email" TEXT NULL, "gstin" TEXT NULL, "upi_id" TEXT NULL, "upi_payee_name" TEXT NULL, "currency_code" TEXT NOT NULL DEFAULT 'INR', "invoice_prefix" TEXT NOT NULL DEFAULT 'INV', "invoice_footer" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        INSERT INTO bill_drafts VALUES ('d1', 5, 0, 0, 1700000000, 1700000000);
        PRAGMA user_version = 5;
      ''');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      final version =
          await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 6);
      final draft = await DriftDraftStore(db).loadDraft('d1');
      expect(draft, isNotNull);
      expect(draft!.discountPercent, 5);
      expect(draft.customerName, '');
      expect(draft.billingEmployeeId, isNull);
    });
  });

  group('widget flow', () {
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

    testWidgets('startup lands on employee selection, not the dashboard',
        (tester) async {
      await pumpApp(tester, const Size(390, 844));
      expect(find.text("Who's billing?"), findsOneWidget);
      expect(find.text('Arun Kumar'), findsOneWidget);
    });

    testWidgets('customer validation blocks bad input with clear errors',
        (tester) async {
      await pumpApp(tester, const Size(390, 844));
      await tester.tap(find.byKey(const ValueKey('employee_card_emp_1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('continue_to_billing')));
      await tester.pumpAndSettle();
      expect(find.text('Enter the customer name.'), findsOneWidget);
      expect(find.text('Enter the mobile number.'), findsOneWidget);
      await tester.enterText(
          find.byKey(const ValueKey('customer_name_field')), 'Ajay');
      await tester.enterText(
          find.byKey(const ValueKey('customer_phone_field')), '12345');
      await tester.tap(find.byKey(const ValueKey('continue_to_billing')));
      await tester.pumpAndSettle();
      expect(
          find.text('Enter a valid 10-digit mobile number.'), findsOneWidget);
      expect(find.byKey(const ValueKey('service_grid')), findsNothing);
    });

    testWidgets('back from customer details preserves the employee',
        (tester) async {
      await pumpApp(tester, const Size(390, 844));
      await tester.tap(find.byKey(const ValueKey('employee_card_emp_2')));
      await tester.pumpAndSettle();
      expect(find.text('Billing: Vijay Menon'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('customer_back')));
      await tester.pumpAndSettle();
      expect(find.text("Who's billing?"), findsOneWidget);
      // The selected employee card still shows its selected state.
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets(
        'full flow: bill completes and New Bill returns to employee selection',
        (tester) async {
      await pumpApp(tester, const Size(1280, 800));
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
      await tester.tap(find.byKey(const ValueKey('checkout_button')));
      await tester.pumpAndSettle();
      expect(find.text('Checkout'), findsOneWidget);
      // The session customer is shown at checkout (not re-typed).
      expect(find.text('Ajay Kumar'), findsWidgets);
      await tester.ensureVisible(
          find.byKey(const ValueKey('complete_payment_button')));
      await tester.pumpAndSettle();
      await tester.tap(
          find.byKey(const ValueKey('complete_payment_button')));
      await tester.pumpAndSettle();
      // Invoice is shown; New Bill starts the next customer.
      expect(find.byKey(const ValueKey('new_bill_button')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('new_bill_button')));
      await tester.pumpAndSettle();
      expect(find.text("Who's billing?"), findsOneWidget);
    });

    testWidgets('long employee and customer names do not overflow',
        (tester) async {
      await pumpApp(tester, const Size(390, 844));
      await tester.tap(find.byKey(const ValueKey('employee_card_emp_1')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('customer_name_field')),
        'A Very Long Customer Name That Keeps Going',
      );
      await tester.enterText(
          find.byKey(const ValueKey('customer_phone_field')), '9876543210');
      await tester.tap(find.byKey(const ValueKey('continue_to_billing')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('service_grid')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
