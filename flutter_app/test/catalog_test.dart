import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:studioflow/core/price_parse.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/providers.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/domain/repositories.dart';
import 'package:studioflow/features/billing/cart.dart';

/// Task 2: editable catalog — validation, categories, ordering,
/// migration, snapshot policy, persistence.
void main() {
  group('INR price parsing (integer only, never a double)', () {
    test('valid amounts', () {
      expect(parseInrToPaise('300'), 30000);
      expect(parseInrToPaise('300.5'), 30050);
      expect(parseInrToPaise('300.50'), 30050);
      expect(parseInrToPaise('₹1,500'), 150000);
      expect(parseInrToPaise('  0  '), 0);
      expect(parseInrToPaise('0.99'), 99);
    });

    test('invalid amounts are rejected', () {
      for (final bad in [
        '',
        'abc',
        '10.999', // three decimals
        '-50',
        '1.2.3',
        '.5',
        '300.',
        '99999999', // ₹9,99,999.99+ — above the price cap in paise terms
        '1000001', // ₹10,00,001 > maxPricePaise (₹10,00,000)
      ]) {
        expect(parseInrToPaise(bad), isNull, reason: '"$bad" must be invalid');
      }
    });
  });

  group('catalog repository', () {
    late AppDatabase db;
    late DriftServiceRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftServiceRepository(db);
    });
    tearDown(() => db.close());

    ServiceItem svc(
      String id,
      String name,
      String category, {
      int price = 10000,
      bool active = true,
      String? categoryId,
    }) =>
        ServiceItem(
          id: id,
          name: name,
          category: category,
          categoryId: categoryId,
          pricePaise: price,
          durationMinutes: 30,
          isActive: active,
        );

    test('add, edit price, deactivate, reactivate', () async {
      await repo.upsert(svc('s1', 'Haircut', 'Hair', price: 30000));
      var active = await repo.listActive();
      expect(active.single.pricePaise, 30000);

      await repo.upsert(svc('s1', 'Haircut', 'Hair', price: 35000));
      active = await repo.listActive();
      expect(active.single.pricePaise, 35000, reason: 'edit persisted');

      await repo.deactivate('s1');
      expect(await repo.listActive(), isEmpty);
      expect((await repo.listAll()).single.isActive, isFalse);

      await repo.reactivate('s1');
      expect((await repo.listActive()).single.pricePaise, 35000);
    });

    test('duplicate active names in a category are rejected (trim/case)',
        () async {
      await repo.upsert(svc('s1', 'Haircut', 'Hair'));
      await expectLater(
        repo.upsert(svc('s2', '  HAIRCUT ', 'Hair')),
        throwsA(isA<CatalogValidationException>()),
      );
      // Same name in a DIFFERENT category is fine.
      await repo.upsert(svc('s3', 'Haircut', 'Beard'));
      // An INACTIVE namesake does not block a new active one.
      await repo.deactivate('s1');
      await repo.upsert(svc('s4', 'haircut', 'Hair'));
      // But reactivating the old one now collides and is rejected.
      await expectLater(
        repo.reactivate('s1'),
        throwsA(isA<CatalogValidationException>()),
      );
    });

    test('validation: empty name, negative price, over-cap price, long name',
        () async {
      await expectLater(
        repo.upsert(svc('s1', '   ', 'Hair')),
        throwsA(isA<CatalogValidationException>()),
      );
      await expectLater(
        repo.upsert(svc('s1', 'Cut', 'Hair', price: -1)),
        throwsA(isA<CatalogValidationException>()),
      );
      await expectLater(
        repo.upsert(svc('s1', 'Cut', 'Hair', price: 100000001)),
        throwsA(isA<CatalogValidationException>()),
      );
      await expectLater(
        repo.upsert(svc('s1', 'x' * 81, 'Hair')),
        throwsA(isA<CatalogValidationException>()),
      );
      // Exactly 80 characters is allowed.
      await repo.upsert(svc('s1', 'x' * 80, 'Hair'));
      expect((await repo.listActive()).single.name, hasLength(80));
    });

    test('categories: create, rename keeps services, duplicate rejected',
        () async {
      await repo.upsertCategory(
        const ServiceCategory(id: 'hair', name: 'Hair'),
      );
      await repo.upsert(svc('s1', 'Haircut', 'Hair', categoryId: 'hair'));
      await repo.upsertCategory(
        const ServiceCategory(id: 'hair', name: 'Hair & Care'),
      );
      final item = (await repo.listActive()).single;
      expect(item.category, 'Hair & Care', reason: 'rename flows through');
      expect(item.categoryId, 'hair', reason: 'id is stable across rename');
      await expectLater(
        repo.upsertCategory(
          const ServiceCategory(id: 'other', name: ' hair & care '),
        ),
        throwsA(isA<CatalogValidationException>()),
      );
    });

    test('reassigning a service to another category', () async {
      await repo.upsert(svc('s1', 'Head Massage', 'Hair'));
      await repo.upsert(svc('s1', 'Head Massage', 'Facial'));
      final item = (await repo.listAll()).single;
      expect(item.category, 'Facial');
      expect(item.categoryId, 'facial');
    });

    test('inactive category hides its services from billing only', () async {
      await repo.upsert(svc('s1', 'Haircut', 'Hair'));
      await repo.upsert(svc('s2', 'Beard Trim', 'Beard'));
      await repo.setCategoryActive('hair', false);
      final billable = await repo.listActive();
      expect(billable.map((s) => s.id), ['s2']);
      expect((await repo.listAll()).length, 2, reason: 'nothing deleted');
      await repo.setCategoryActive('hair', true);
      expect((await repo.listActive()).length, 2);
    });

    test('category and service ordering persist', () async {
      await repo.upsert(svc('s1', 'Alpha', 'Hair'));
      await repo.upsert(svc('s2', 'Beta', 'Hair'));
      await repo.upsert(svc('s3', 'Gamma', 'Beard'));
      await repo.reorderServices(['s2', 's1']);
      await repo.reorderCategories(['beard', 'hair']);
      final ordered = await repo.listActive();
      expect(
        ordered.map((s) => s.id).toList(),
        ['s3', 's2', 's1'],
        reason: 'category order first, then service order within it',
      );
      final categories = await repo.listCategories();
      expect(categories.map((c) => c.id).toList(), ['beard', 'hair']);
    });

    test('large catalog: 300 services stay ordered and complete', () async {
      for (var i = 0; i < 300; i++) {
        await repo.upsert(svc('bulk_$i', 'Service $i', 'Bulk'));
      }
      final all = await repo.listActive();
      expect(all.length, 300);
      final filtered =
          all.where((s) => s.name.toLowerCase().contains('service 29'));
      expect(filtered.length, 11, reason: 'in-memory search stays correct');
    });
  });

  group('persistence across restart (file-backed)', () {
    test('catalog, order and drafts survive close/reopen', () async {
      final dir = await Directory.systemTemp.createTemp('sf_catalog_');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/studioflow.db');

      var db = AppDatabase.forTesting(NativeDatabase(file));
      var repo = DriftServiceRepository(db);
      await repo.upsert(
        const ServiceItem(
          id: 's1',
          name: 'Haircut',
          category: 'Hair',
          categoryId: 'hair',
          pricePaise: 30000,
          durationMinutes: 30,
          description: 'Classic cut',
        ),
      );
      final drafts = DriftDraftStore(db);
      const cart = CartState(
        draftId: 'draft_keep',
        lines: [
          CartLine(
            serviceId: 's1',
            serviceName: 'Haircut',
            pricePaise: 30000,
            durationMinutes: 30,
            quantity: 2,
          ),
        ],
      );
      await drafts.saveDraft(cart);
      await db.close();

      db = AppDatabase.forTesting(NativeDatabase(file));
      repo = DriftServiceRepository(db);
      final restored = (await repo.listActive()).single;
      expect(restored.description, 'Classic cut');
      expect(restored.pricePaise, 30000);
      final draft = await DriftDraftStore(db).loadDraft('draft_keep');
      expect(draft, isNotNull);
      expect(draft!.totalPaise, 60000);
      await db.close();
    });
  });

  group('deactivation and price changes vs open drafts', () {
    test('draft keeps snapshot when service is edited + deactivated',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = DriftServiceRepository(db);
      await repo.upsert(
        const ServiceItem(
          id: 's1',
          name: 'Haircut',
          category: 'Hair',
          categoryId: 'hair',
          pricePaise: 30000,
          durationMinutes: 30,
        ),
      );
      final drafts = DriftDraftStore(db);
      const cart = CartState(
        draftId: 'draft_open',
        lines: [
          CartLine(
            serviceId: 's1',
            serviceName: 'Haircut',
            pricePaise: 30000,
            durationMinutes: 30,
            quantity: 1,
          ),
        ],
      );
      await drafts.saveDraft(cart);

      await repo.upsert(
        const ServiceItem(
          id: 's1',
          name: 'Haircut Deluxe',
          category: 'Hair',
          categoryId: 'hair',
          pricePaise: 35000,
          durationMinutes: 30,
        ),
      );
      await repo.deactivate('s1');

      final restored = await drafts.loadDraft('draft_open');
      expect(restored, isNotNull);
      expect(restored!.lines.single.pricePaise, 30000);
      expect(restored.lines.single.serviceName, 'Haircut');
      expect(await repo.listActive(), isEmpty);
    });

    test('a draft round-trips the same service at two snapshot prices',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final drafts = DriftDraftStore(db);
      const cart = CartState(
        draftId: 'draft_two_prices',
        lines: [
          CartLine(
            serviceId: 's1',
            serviceName: 'Haircut',
            pricePaise: 30000,
            durationMinutes: 30,
            quantity: 1,
          ),
          CartLine(
            serviceId: 's1',
            serviceName: 'Haircut',
            pricePaise: 35000,
            durationMinutes: 30,
            quantity: 2,
          ),
        ],
      );
      await drafts.saveDraft(cart);
      final restored = await drafts.loadDraft('draft_two_prices');
      expect(restored, isNotNull);
      expect(restored!.lines, hasLength(2));
      expect(restored.totalPaise, 30000 + 2 * 35000);
    });
  });

  group('reactive billing catalog', () {
    test('catalog provider reflects repository changes after refresh',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      final repo = container.read(serviceRepositoryProvider);
      await repo.upsert(
        const ServiceItem(
          id: 's1',
          name: 'Haircut',
          category: 'Hair',
          categoryId: 'hair',
          pricePaise: 30000,
          durationMinutes: 30,
        ),
      );
      await container.read(catalogProvider.notifier).refreshFromRepository();
      expect(container.read(catalogProvider).single.pricePaise, 30000);

      await repo.upsert(
        const ServiceItem(
          id: 's1',
          name: 'Haircut',
          category: 'Hair',
          categoryId: 'hair',
          pricePaise: 42500,
          durationMinutes: 30,
        ),
      );
      await container.read(catalogProvider.notifier).refreshFromRepository();
      expect(
        container.read(catalogProvider).single.pricePaise,
        42500,
        reason: 'billing sees the new price without a restart',
      );
    });
  });

  group('schema migration v1 -> v2', () {
    test('data survives; two price variants become storable', () async {
      final dir = await Directory.systemTemp.createTemp('sf_migrate_');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/v1.db';

      // Build a genuine v1 database with raw DDL (the exact schema the
      // Task 1.7 build created) and one draft + one service.
      final raw = sqlite3.sqlite3.open(path);
      raw.execute('''
        CREATE TABLE "bill_drafts" ("draft_id" TEXT NOT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("draft_id"));
        CREATE TABLE "draft_lines" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "draft_id" TEXT NOT NULL REFERENCES bill_drafts (draft_id) ON DELETE CASCADE, "service_id" TEXT NOT NULL, "service_name" TEXT NOT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "quantity" INTEGER NOT NULL, "position" INTEGER NOT NULL, UNIQUE ("draft_id", "service_id"));
        CREATE TABLE "employees" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "role" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "salary_type" TEXT NOT NULL DEFAULT 'monthly', "monthly_salary_paise" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), PRIMARY KEY ("id"));
        CREATE TABLE "service_categories" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "sort_order" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), PRIMARY KEY ("id"));
        CREATE TABLE "services" ("id" TEXT NOT NULL, "category_id" TEXT NOT NULL REFERENCES service_categories (id) ON DELETE RESTRICT, "name" TEXT NOT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "is_extra" INTEGER NOT NULL DEFAULT 0 CHECK ("is_extra" IN (0, 1)), "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), "sort_order" INTEGER NOT NULL DEFAULT 0, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        CREATE TABLE "studio_profiles" ("id" INTEGER NOT NULL, "business_name" TEXT NOT NULL, "tagline" TEXT NULL, "logo_path" TEXT NULL, "primary_color" INTEGER NOT NULL, "secondary_color" INTEGER NOT NULL, "address" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "email" TEXT NULL, "gstin" TEXT NULL, "upi_id" TEXT NULL, "upi_payee_name" TEXT NULL, "currency_code" TEXT NOT NULL DEFAULT 'INR', "invoice_prefix" TEXT NOT NULL DEFAULT 'INV', "invoice_footer" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        CREATE TABLE "sync_metadata" ("key" TEXT NOT NULL, "value" TEXT NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("key"));
        CREATE INDEX idx_draft_lines_draft ON draft_lines (draft_id);
        CREATE INDEX idx_drafts_updated ON bill_drafts (updated_at);
        CREATE INDEX idx_services_active ON services (is_active);
        CREATE INDEX idx_services_category ON services (category_id);
        INSERT INTO service_categories VALUES ('hair', 'Hair', 0, 1);
        INSERT INTO services VALUES ('s1', 'hair', 'Haircut', 30000, 30, 0, 1, 0, 1700000000);
        INSERT INTO bill_drafts VALUES ('d1', 1700000000, 1700000000);
        INSERT INTO draft_lines (draft_id, service_id, service_name, price_paise, duration_minutes, quantity, position)
          VALUES ('d1', 's1', 'Haircut', 30000, 30, 1, 0);
        PRAGMA user_version = 1;
      ''');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      final version =
          await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 6,
          reason: 'opening continues through the v2 -> v3 -> v4 -> v5 hops');

      final repo = DriftServiceRepository(db);
      final service = (await repo.listActive()).single;
      expect(service.name, 'Haircut');
      expect(service.description, isNull, reason: 'new column starts empty');

      final drafts = DriftDraftStore(db);
      final draft = await drafts.loadDraft('d1');
      expect(draft, isNotNull);
      expect(draft!.totalPaise, 30000, reason: 'v1 draft survived upgrade');

      // The widened unique key now allows the second price variant.
      await drafts.saveDraft(
        const CartState(
          draftId: 'd1',
          lines: [
            CartLine(
              serviceId: 's1',
              serviceName: 'Haircut',
              pricePaise: 30000,
              durationMinutes: 30,
              quantity: 1,
            ),
            CartLine(
              serviceId: 's1',
              serviceName: 'Haircut',
              pricePaise: 35000,
              durationMinutes: 30,
              quantity: 1,
            ),
          ],
        ),
      );
      expect((await drafts.loadDraft('d1'))!.lines, hasLength(2));
    });
  });
}
