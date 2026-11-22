import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:studioflow/data/billing_repository.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/domain/repositories.dart';
import 'package:studioflow/features/billing/cart.dart';
import 'package:studioflow/features/billing/invoice_document.dart';

/// Task 3: finalized invoices — atomicity, idempotency, snapshots,
/// payments, voids, audit, history queries, documents.
void main() {
  const studio = StudioSnapshot(
    businessName: 'D POISE Groom Studio',
    tagline: 'Look sharp',
    address: 'MG Road, Kochi',
    phone: '9876543210',
    email: 'hello@dpoise.example',
    gstin: '32ABCDE1234F1Z5',
    upiId: 'dpoise@okhdfc',
    invoicePrefix: 'INV',
    invoiceFooter: 'Thank you!',
  );

  CartState cart({
    String draftId = 'draft_1',
    int discountPercent = 0,
    int flatDiscountPaise = 0,
    int taxBasisPoints = 0,
    List<CartLine> lines = const [
      CartLine(
        serviceId: 's1',
        serviceName: 'Haircut',
        pricePaise: 30000,
        durationMinutes: 30,
        quantity: 2,
        employeeId: 'emp_1',
        employeeName: 'Arun',
      ),
      CartLine(
        serviceId: 's2',
        serviceName: 'Beard Trim',
        pricePaise: 15000,
        durationMinutes: 15,
        quantity: 1,
      ),
    ],
  }) =>
      CartState(
        draftId: draftId,
        lines: lines,
        discountPercent: discountPercent,
        flatDiscountPaise: flatDiscountPaise,
        taxBasisPoints: taxBasisPoints,
      );

  group('finalization', () {
    late AppDatabase db;
    late DriftBillingRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftBillingRepository(db);
    });
    tearDown(() => db.close());

    test('totals come from the money engine (discount then tax)', () async {
      // Subtotal 75000; 10% discount = 7500; taxable 67500; 18% tax = 12150.
      final bill = await repo.finalizeDraft(
        cart: cart(discountPercent: 10, taxBasisPoints: 1800),
        studio: studio,
        studioPrimaryColor: 0xFF1B3A2F,
        payments: const [],
        actor: 'Owner',
      );
      expect(bill.subtotalPaise, 75000);
      expect(bill.discountPaise, 7500);
      expect(bill.taxPaise, 12150);
      expect(bill.totalPaise, 79650);
      expect(bill.paymentStatus, PaymentStatus.pending);
      expect(bill.status, FinalizedBillStatus.finalized);
      final year = DateTime.now().year;
      expect(bill.provisionalRef, 'INV-$year-0001');
      expect(bill.lines.first.employeeName, 'Arun');
    });

    test('discount rounding is half-up through the engine', () async {
      final bill = await repo.finalizeDraft(
        cart: cart(
          discountPercent: 10,
          lines: const [
            CartLine(
              serviceId: 's9',
              serviceName: 'Odd Price',
              pricePaise: 9999,
              durationMinutes: 10,
              quantity: 1,
            ),
          ],
        ),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      expect(bill.discountPaise, 1000, reason: '999.9 rounds half-up');
      expect(bill.totalPaise, 8999);
    });

    test('snapshots: later studio changes never rewrite the bill', () async {
      final bill = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0xFF1B3A2F,
        payments: const [],
        actor: 'Owner',
      );
      const renamed = StudioSnapshot(
        businessName: 'TOTALLY DIFFERENT NAME',
        invoicePrefix: 'XXX',
      );
      final other = await repo.finalizeDraft(
        cart: cart(draftId: 'draft_2'),
        studio: renamed,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      final reloaded = await repo.getBill(bill.id);
      expect(reloaded!.studio.businessName, 'D POISE Groom Studio');
      expect(reloaded.studio.gstin, '32ABCDE1234F1Z5');
      expect(other.studio.businessName, 'TOTALLY DIFFERENT NAME');
      expect(other.provisionalRef, startsWith('XXX-'));
    });

    test('idempotent: finalizing the same draft twice returns one bill',
        () async {
      final first = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      final second = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      expect(second.id, first.id);
      expect((await repo.listBills()).length, 1);
      // The sequence did not burn a number on the duplicate.
      final third = await repo.finalizeDraft(
        cart: cart(draftId: 'draft_2'),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      expect(third.localSeq, 2);
    });

    test('finalization consumes the draft in the same transaction',
        () async {
      final drafts = DriftDraftStore(db);
      await drafts.saveDraft(cart());
      expect(await drafts.loadDraft('draft_1'), isNotNull);
      await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      expect(await drafts.loadDraft('draft_1'), isNull);
    });

    test('atomic rollback: a failing payment insert leaves nothing behind',
        () async {
      final drafts = DriftDraftStore(db);
      await drafts.saveDraft(cart());
      const dup = PaymentDraft(
        id: 'pay_dup',
        method: PaymentMethod.cash,
        amountPaise: 10000,
      );
      await expectLater(
        repo.finalizeDraft(
          cart: cart(),
          studio: studio,
          studioPrimaryColor: 0,
          payments: const [dup, dup], // same PK twice -> mid-txn failure
          actor: 'Owner',
        ),
        throwsA(anything),
      );
      expect(await repo.listBills(), isEmpty, reason: 'no half bill');
      expect(
        await drafts.loadDraft('draft_1'),
        isNotNull,
        reason: 'the draft survives a failed finalization',
      );
      final counters = await db.select(db.invoiceCounters).get();
      expect(counters, isEmpty, reason: 'no sequence number burned');
    });

    test('overpayment and empty carts are rejected before writing', () async {
      await expectLater(
        repo.finalizeDraft(
          cart: cart(),
          studio: studio,
          studioPrimaryColor: 0,
          payments: const [
            PaymentDraft(
              id: 'p1',
              method: PaymentMethod.cash,
              amountPaise: 999999,
            ),
          ],
          actor: 'Owner',
        ),
        throwsArgumentError,
      );
      await expectLater(
        repo.finalizeDraft(
          cart: const CartState(draftId: 'dx'),
          studio: studio,
          studioPrimaryColor: 0,
          payments: const [],
          actor: 'Owner',
        ),
        throwsArgumentError,
      );
      expect(await repo.listBills(), isEmpty);
    });
  });

  group('payments', () {
    late AppDatabase db;
    late DriftBillingRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftBillingRepository(db);
    });
    tearDown(() => db.close());

    test('cash confirmed at checkout is stored as MANUAL confirmation',
        () async {
      final bill = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: [
          PaymentDraft(
            id: 'p1',
            method: PaymentMethod.cash,
            amountPaise: 75000,
            status: PaymentStatus.confirmedManual,
            confirmedBy: 'Owner',
            confirmedAt: DateTime(2026, 11, 22, 10, 30),
          ),
        ],
        actor: 'Owner',
      );
      expect(bill.paymentStatus, PaymentStatus.confirmedManual);
      final payment = bill.payments.single;
      expect(payment.status, PaymentStatus.confirmedManual);
      expect(payment.confirmedBy, 'Owner');
      expect(payment.confirmedAt, DateTime(2026, 11, 22, 10, 30));
    });

    test('split payments: UPI confirmed later from history', () async {
      final bill = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [
          PaymentDraft(
            id: 'p_cash',
            method: PaymentMethod.cash,
            amountPaise: 50000,
            status: PaymentStatus.confirmedManual,
            confirmedBy: 'Staff',
          ),
          PaymentDraft(
            id: 'p_upi',
            method: PaymentMethod.upi,
            amountPaise: 25000,
          ),
        ],
        actor: 'Staff',
      );
      expect(bill.paymentStatus, PaymentStatus.pending,
          reason: 'UPI part is unconfirmed — nothing auto-succeeds');
      final updated = await repo.confirmPayment(bill.id, 'p_upi',
          actor: 'Owner');
      expect(updated.paymentStatus, PaymentStatus.confirmedManual);
      final upi = updated.payments.firstWhere((p) => p.id == 'p_upi');
      expect(upi.confirmedBy, 'Owner');
      expect(upi.confirmedAt, isNotNull);
      // Double confirmation is rejected, not silently absorbed.
      await expectLater(
        repo.confirmPayment(bill.id, 'p_upi', actor: 'Owner'),
        throwsStateError,
      );
      final audit = await repo.auditFor(bill.id);
      expect(
        audit.map((e) => e.type),
        containsAllInOrder(['finalized', 'payment_confirmed']),
      );
    });
  });

  group('voiding and history', () {
    late AppDatabase db;
    late DriftBillingRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftBillingRepository(db);
    });
    tearDown(() => db.close());

    test('void preserves the record and writes an audit event', () async {
      final bill = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
        customerName: 'Aarav',
      );
      final voided = await repo.voidBill(
        bill.id,
        reason: 'Customer left before service',
        actor: 'Owner',
      );
      expect(voided.status, FinalizedBillStatus.voided);
      expect(voided.voidReason, 'Customer left before service');
      expect(voided.voidedBy, 'Owner');
      // Still listed (never deleted), findable via the voided filter.
      final all = await repo.listBills();
      expect(all.single.status, FinalizedBillStatus.voided);
      final onlyVoided =
          await repo.listBills(status: FinalizedBillStatus.voided);
      expect(onlyVoided, hasLength(1));
      final audit = await repo.auditFor(bill.id);
      expect(audit.map((e) => e.type), ['finalized', 'voided']);
      // Voiding twice / without a reason is rejected.
      await expectLater(
        repo.voidBill(bill.id, reason: 'again', actor: 'Owner'),
        throwsStateError,
      );
      await expectLater(
        repo.voidBill(bill.id, reason: '  ', actor: 'Owner'),
        throwsArgumentError,
      );
    });

    test('search by reference and customer; payment-status filter', () async {
      final a = await repo.finalizeDraft(
        cart: cart(),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
        customerName: 'Aarav Shah',
      );
      await repo.finalizeDraft(
        cart: cart(draftId: 'draft_2'),
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [
          PaymentDraft(
            id: 'p1',
            method: PaymentMethod.upi,
            amountPaise: 75000,
            status: PaymentStatus.confirmedManual,
            confirmedBy: 'Owner',
          ),
        ],
        actor: 'Owner',
        customerName: 'Imran',
      );
      expect(
        (await repo.listBills(query: a.provisionalRef.substring(0, 8)))
            .length,
        2, // both refs share the INV-YYYY- prefix chunk
      );
      expect((await repo.listBills(query: 'aarav')).single.customerName,
          'Aarav Shah');
      expect(
        (await repo.listBills(paymentStatus: PaymentStatus.pending)).length,
        1,
      );
      expect(
        (await repo.listBills(
                paymentStatus: PaymentStatus.confirmedManual))
            .length,
        1,
      );
      expect(
        (await repo.listBills(from: DateTime.now().add(
          const Duration(days: 1),
        )))
            .length,
        0,
        reason: 'date filter excludes future bills',
      );
    });
  });

  group('restart durability (file-backed)', () {
    test('finalized invoice + audit survive close/reopen', () async {
      final dir = await Directory.systemTemp.createTemp('sf_billing_');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/studioflow.db');

      var db = AppDatabase.forTesting(NativeDatabase(file));
      var repo = DriftBillingRepository(db);
      final bill = await repo.finalizeDraft(
        cart: cart(discountPercent: 10, taxBasisPoints: 1800),
        studio: studio,
        studioPrimaryColor: 0xFF1B3A2F,
        payments: const [
          PaymentDraft(
            id: 'p1',
            method: PaymentMethod.upi,
            amountPaise: 79650,
            status: PaymentStatus.confirmedManual,
            confirmedBy: 'Owner',
          ),
        ],
        actor: 'Owner',
      );
      await db.close();

      db = AppDatabase.forTesting(NativeDatabase(file));
      repo = DriftBillingRepository(db);
      final reloaded = await repo.getBill(bill.id);
      expect(reloaded, isNotNull);
      expect(reloaded!.totalPaise, 79650);
      expect(reloaded.provisionalRef, bill.provisionalRef);
      expect(reloaded.lines, hasLength(2));
      expect(reloaded.paymentStatus, PaymentStatus.confirmedManual);
      expect((await repo.auditFor(bill.id)).single.type, 'finalized');
      final version =
          await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 5);
      await db.close();
    });
  });

  group('invoice documents', () {
    test('text receipt + PDF render the finalized facts', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = DriftBillingRepository(db);
      final longStudio = StudioSnapshot(
        businessName: 'A' * 60,
        address: 'Some very long address line, Kochi, Kerala 682001',
        phone: '9876543210',
        invoicePrefix: 'INV',
        invoiceFooter: 'Thank you, visit again!',
      );
      final bill = await repo.finalizeDraft(
        cart: cart(
          lines: const [
            CartLine(
              serviceId: 's1',
              serviceName:
                  'Premium Signature Hair Spa Ritual With Head Massage',
              pricePaise: 30000,
              durationMinutes: 60,
              quantity: 1,
              employeeName: 'Arun Kumar',
            ),
          ],
        ),
        studio: longStudio,
        studioPrimaryColor: 0xFF1B3A2F,
        payments: const [],
        actor: 'Owner',
      );
      final doc = InvoiceDocument.fromBill(bill);
      final text = formatTextReceipt(doc);
      expect(text, contains('A' * 60));
      expect(text, contains('Premium Signature Hair Spa Ritual'));
      expect(text, contains('Arun Kumar'));
      expect(text, contains(bill.provisionalRef));
      expect(text, contains('PAYMENT PENDING'));
      expect(text, contains('not an official invoice number'));
      final pdf = await buildInvoicePdf(doc);
      expect(pdf.length, greaterThan(500));
      expect(String.fromCharCodes(pdf.take(4)), '%PDF');
    });

    test('UPI payload requires the studio merchant configuration', () {
      expect(
        buildUpiPayload(
          upiId: null,
          payeeName: 'Studio',
          amountPaise: 10000,
          note: 'x',
        ),
        isNull,
      );
      expect(
        buildUpiPayload(
          upiId: 'studio@okhdfc',
          payeeName: '',
          amountPaise: 10000,
          note: 'x',
        ),
        isNull,
      );
      final payload = buildUpiPayload(
        upiId: 'studio@okhdfc',
        payeeName: 'D POISE',
        amountPaise: 30050,
        note: 'Bill draft_1',
      );
      expect(payload, contains('pa=studio%40okhdfc'));
      expect(payload, contains('am=300.50'));
    });
  });

  group('schema migration v2 -> v3', () {
    test('a v2 database upgrades with drafts intact', () async {
      final dir = await Directory.systemTemp.createTemp('sf_mig3_');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/v2.db';
      final raw = sqlite3.sqlite3.open(path);
      raw.execute('''
        CREATE TABLE "bill_drafts" ("draft_id" TEXT NOT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("draft_id"));
        CREATE TABLE "draft_lines" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "draft_id" TEXT NOT NULL REFERENCES bill_drafts (draft_id) ON DELETE CASCADE, "service_id" TEXT NOT NULL, "service_name" TEXT NOT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "quantity" INTEGER NOT NULL, "position" INTEGER NOT NULL, UNIQUE ("draft_id", "service_id", "price_paise"));
        CREATE TABLE "employees" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "role" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "salary_type" TEXT NOT NULL DEFAULT 'monthly', "monthly_salary_paise" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), PRIMARY KEY ("id"));
        CREATE TABLE "service_categories" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "sort_order" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), PRIMARY KEY ("id"));
        CREATE TABLE "services" ("id" TEXT NOT NULL, "category_id" TEXT NOT NULL REFERENCES service_categories (id) ON DELETE RESTRICT, "name" TEXT NOT NULL, "description" TEXT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "is_extra" INTEGER NOT NULL DEFAULT 0 CHECK ("is_extra" IN (0, 1)), "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), "sort_order" INTEGER NOT NULL DEFAULT 0, "created_at" INTEGER NOT NULL DEFAULT 0, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        CREATE TABLE "studio_profiles" ("id" INTEGER NOT NULL, "business_name" TEXT NOT NULL, "tagline" TEXT NULL, "logo_path" TEXT NULL, "primary_color" INTEGER NOT NULL, "secondary_color" INTEGER NOT NULL, "address" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "email" TEXT NULL, "gstin" TEXT NULL, "upi_id" TEXT NULL, "upi_payee_name" TEXT NULL, "currency_code" TEXT NOT NULL DEFAULT 'INR', "invoice_prefix" TEXT NOT NULL DEFAULT 'INV', "invoice_footer" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        CREATE TABLE "sync_metadata" ("key" TEXT NOT NULL, "value" TEXT NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("key"));
        CREATE INDEX idx_draft_lines_draft ON draft_lines (draft_id);
        CREATE INDEX idx_drafts_updated ON bill_drafts (updated_at);
        CREATE INDEX idx_services_active ON services (is_active);
        CREATE INDEX idx_services_category ON services (category_id);
        INSERT INTO bill_drafts VALUES ('d1', 1700000000, 1700000000);
        INSERT INTO draft_lines (draft_id, service_id, service_name, price_paise, duration_minutes, quantity, position)
          VALUES ('d1', 's1', 'Haircut', 30000, 30, 2, 0);
        PRAGMA user_version = 2;
      ''');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      final version =
          await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 5);
      final draft = await DriftDraftStore(db).loadDraft('d1');
      expect(draft, isNotNull);
      expect(draft!.totalPaise, 60000);
      expect(draft.discountPercent, 0, reason: 'new columns default to 0');
      // And the upgraded database can finalize immediately.
      final bill = await DriftBillingRepository(db).finalizeDraft(
        cart: draft,
        studio: studio,
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      expect(bill.totalPaise, 60000);
    });
  });
}
