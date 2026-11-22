import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:studioflow/branding/studio_branding.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/features/billing/cart.dart';

CartState draftOf(String id, List<CartLine> lines) =>
    CartState(draftId: id, lines: lines);

CartLine line(String serviceId, int pricePaise, int quantity) => CartLine(
      serviceId: serviceId,
      serviceName: 'Svc $serviceId',
      pricePaise: pricePaise,
      durationMinutes: 15,
      quantity: quantity,
    );

void main() {
  late AppDatabase db;
  late DriftStudioConfigRepository config;
  late DriftServiceRepository services;
  late DriftEmployeeRepository employees;
  late DriftDraftStore drafts;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    config = DriftStudioConfigRepository(db);
    services = DriftServiceRepository(db);
    employees = DriftEmployeeRepository(db);
    drafts = DriftDraftStore(db);
  });

  tearDown(() async => db.close());

  group('database initialization', () {
    test('creates all tables and indexes at schema v5', () async {
      final tables = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table'",
          )
          .get();
      final names = tables.map((r) => r.read<String>('name')).toSet();
      expect(
        names,
        containsAll([
          'studio_profiles',
          'service_categories',
          'services',
          'employees',
          'bill_drafts',
          'draft_lines',
          'bills',
          'bill_lines',
          'payments',
          'invoice_counters',
          'billing_audit_events',
          'attendance_records',
          'attendance_audit_events',
          'salary_advances',
          'payroll_settings',
          'payroll_runs',
          'payroll_lines',
          'payroll_adjustments',
          'payroll_payments',
          'payroll_audit_events',
          'payroll_advance_links',
          'sync_metadata',
        ]),
      );
      final indexes = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='index'",
          )
          .get();
      final indexNames = indexes.map((r) => r.read<String>('name')).toSet();
      expect(
        indexNames,
        containsAll([
          'idx_services_category',
          'idx_draft_lines_draft',
          'idx_drafts_updated',
        ]),
      );
      final version =
          await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 5);
    });

    test('foreign keys are enforced', () async {
      final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(fk.read<int>('foreign_keys'), 1);
    });
  });

  group('studio profile persistence', () {
    test('empty database loads null', () async {
      expect(await config.load(), isNull);
    });

    test('save then load round-trips every field', () async {
      const branding = StudioBranding(
        businessName: 'Glow Studio',
        tagline: 'Look sharp',
        primaryColor: Colors.teal,
        secondaryColor: Colors.amber,
        address: '12 MG Road',
        phone: '9876543210',
        email: 'hi@glow.example',
        gstin: '32ABCDE1234F1Z5',
        upiId: 'glow@okhdfc',
        upiPayeeName: 'Glow Studio',
        invoicePrefix: 'GLW',
        invoiceFooter: 'Thank you!',
      );
      await config.save(branding);
      final loaded = await config.load();
      expect(loaded, isNotNull);
      expect(loaded!.businessName, 'Glow Studio');
      expect(loaded.tagline, 'Look sharp');
      // Persistence stores ARGB ints; compare the stored values, not the
      // MaterialColor swatch objects.
      expect(loaded.primaryColor.toARGB32(), Colors.teal.toARGB32());
      expect(loaded.secondaryColor.toARGB32(), Colors.amber.toARGB32());
      expect(loaded.gstin, '32ABCDE1234F1Z5');
      expect(loaded.upiId, 'glow@okhdfc');
      expect(loaded.invoicePrefix, 'GLW');
      expect(loaded.invoiceFooter, 'Thank you!');
    });

    test('saving twice keeps one row with the latest values', () async {
      await config.save(dpoiseDemoBranding);
      await config.save(
        dpoiseDemoBranding.copyWith(businessName: 'Renamed Studio'),
      );
      final rows = await db.select(db.studioProfiles).get();
      expect(rows, hasLength(1));
      expect((await config.load())!.businessName, 'Renamed Studio');
    });
  });

  group('catalog and employees', () {
    test('seed populates the sample catalog and staff once', () async {
      await seedSampleDataIfEmpty(db);
      final catalog = await services.listActive();
      expect(catalog, hasLength(10));
      expect(catalog.first.category, 'Hair');
      expect(catalog.map((s) => s.name), contains('Haircut'));
      expect(await employees.listActive(), hasLength(5));
      // Idempotent: a second seed changes nothing.
      await seedSampleDataIfEmpty(db);
      expect(await services.listActive(), hasLength(10));
      final meta = await (db.select(db.syncMetadata)
            ..where((t) => t.key.equals('seeded_sample_data')))
          .get();
      expect(meta, hasLength(1));
    });

    test('upsert adds a service under a new category; deactivate hides it',
        () async {
      await services.upsert(
        const ServiceItem(
          id: 'svc_manicure',
          name: 'Manicure',
          category: 'Nails',
          pricePaise: 49900,
          durationMinutes: 30,
        ),
      );
      var catalog = await services.listActive();
      expect(catalog.singleWhere((s) => s.id == 'svc_manicure').category,
          'Nails');
      await services.deactivate('svc_manicure');
      catalog = await services.listActive();
      expect(catalog.map((s) => s.id), isNot(contains('svc_manicure')));
    });

    test('employee salary type round-trips', () async {
      await employees.upsert(
        const Employee(
          id: 'emp_x',
          name: 'Daily Dan',
          role: 'Assistant',
          salaryType: SalaryType.daily,
          monthlySalaryPaise: 0,
        ),
      );
      final list = await employees.listActive();
      expect(list.single.salaryType, SalaryType.daily);
    });
  });

  group('referential integrity', () {
    test('a service cannot reference a missing category', () async {
      expect(
        () => db.into(db.services).insert(
              ServicesCompanion.insert(
                id: 'svc_bad',
                categoryId: 'no_such_category',
                name: 'Bad',
                pricePaise: 100,
                updatedAt: DateTime.now(),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('a category with services cannot be deleted', () async {
      await seedSampleDataIfEmpty(db);
      expect(
        () => (db.delete(db.serviceCategories)
              ..where((t) => t.id.equals('hair')))
            .go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test('deleting a draft cascades to its lines', () async {
      await drafts.saveDraft(
        draftOf('draft-cascade', [line('a', 10000, 1), line('b', 20000, 2)]),
      );
      await drafts.deleteDraft('draft-cascade');
      final lines = await db.select(db.draftLines).get();
      expect(lines, isEmpty);
      expect(await drafts.loadDraft('draft-cascade'), isNull);
    });
  });

  group('crash-safe drafts', () {
    test('three services recover with quantities and total intact',
        () async {
      final cart = CartNotifier()
        ..addService(
          const ServiceItem(
            id: 'svc_haircut',
            name: 'Haircut',
            category: 'Hair',
            pricePaise: 30000,
            durationMinutes: 30,
          ),
        )
        ..addService(
          const ServiceItem(
            id: 'svc_beard_trim',
            name: 'Beard Trim',
            category: 'Hair',
            pricePaise: 15000,
            durationMinutes: 15,
          ),
        )
        ..addService(
          const ServiceItem(
            id: 'svc_haircut',
            name: 'Haircut',
            category: 'Hair',
            pricePaise: 30000,
            durationMinutes: 30,
          ),
        );
      await drafts.saveDraft(cart.state);
      final recovered = await drafts.loadDraft(cart.state.draftId!);
      expect(recovered, isNotNull);
      expect(recovered!.lines, hasLength(2));
      expect(recovered.quantityOf('svc_haircut'), 2);
      expect(recovered.quantityOf('svc_beard_trim'), 1);
      // 2 x 30000 + 1 x 15000, derived through the money engine.
      expect(recovered.totalPaise, 75000);
      expect(recovered.draftId, cart.state.draftId);
    });

    test('snapshot price survives a later catalog price change', () async {
      await drafts.saveDraft(draftOf('draft-snap', [line('svc_x', 30000, 1)]));
      await services.upsert(
        const ServiceItem(
          id: 'svc_x',
          name: 'Svc svc_x',
          category: 'Hair',
          pricePaise: 45000,
          durationMinutes: 15,
        ),
      );
      final recovered = await drafts.loadDraft('draft-snap');
      expect(recovered!.lines.single.pricePaise, 30000);
      expect(recovered.totalPaise, 30000);
    });

    test('re-saving the same draft id updates in place (no duplicates)',
        () async {
      await drafts.saveDraft(draftOf('draft-dup', [line('a', 10000, 1)]));
      await drafts.saveDraft(draftOf('draft-dup', [line('a', 10000, 5)]));
      final all = await drafts.listDrafts();
      expect(all, hasLength(1));
      expect(all.single.quantityOf('a'), 5);
      final rows = await db.select(db.draftLines).get();
      expect(rows, hasLength(1));
    });

    test('multiple drafts coexist, most recently saved first', () async {
      await drafts.saveDraft(draftOf('draft-1', [line('a', 10000, 1)]));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await drafts.saveDraft(draftOf('draft-2', [line('b', 20000, 1)]));
      final all = await drafts.listDrafts();
      expect(all.map((d) => d.draftId), ['draft-2', 'draft-1']);
    });

    test('100 rapid selections persist as one line of quantity 100',
        () async {
      final cart = CartNotifier();
      const service = ServiceItem(
        id: 'svc_haircut',
        name: 'Haircut',
        category: 'Hair',
        pricePaise: 30000,
        durationMinutes: 30,
      );
      for (var i = 0; i < 100; i++) {
        cart.addService(service);
      }
      await drafts.saveDraft(cart.state);
      final recovered = await drafts.loadDraft(cart.state.draftId!);
      expect(recovered!.quantityOf('svc_haircut'), 100);
      expect(recovered.totalPaise, 100 * 30000);
    });

    test('50 distinct lines round-trip', () async {
      final lines = [
        for (var i = 0; i < 50; i++) line('svc_$i', 10000 + i * 137, (i % 3) + 1),
      ];
      final state = draftOf('draft-50', lines);
      await drafts.saveDraft(state);
      final recovered = await drafts.loadDraft('draft-50');
      expect(recovered!.lines, hasLength(50));
      expect(recovered.totalPaise, state.totalPaise);
    });

    test('invalid lines are rejected before anything is written', () async {
      // Quantity 0 violates the engine's quantity >= 1 rule; a negative
      // price violates price >= 0. (A price of exactly 0 is legitimate —
      // a free service — and is NOT rejected.)
      await expectLater(
        drafts.saveDraft(draftOf('draft-bad', [line('a', 10000, 0)])),
        throwsArgumentError,
      );
      await expectLater(
        drafts.saveDraft(draftOf('draft-bad2', [line('a', -100, 1)])),
        throwsArgumentError,
      );
      expect(await drafts.listDrafts(), isEmpty);
    });

    test(
        'a write that fails mid-transaction persists nothing (interrupted '
        'write recovery)', () async {
      // Two lines with the same service id violate the unique
      // (draft_id, service_id) key on the SECOND insert — after the draft
      // row and first line were already written inside the transaction.
      final bad = draftOf('draft-atomic', [
        line('same', 10000, 1),
        line('same', 10000, 1),
      ]);
      await expectLater(drafts.saveDraft(bad), throwsA(anything));
      // The whole transaction rolled back: no draft, no lines.
      expect(await drafts.loadDraft('draft-atomic'), isNull);
      expect(await db.select(db.billDrafts).get(), isEmpty);
      expect(await db.select(db.draftLines).get(), isEmpty);
    });

    test('saving a draft without an id is rejected', () async {
      await expectLater(
        drafts.saveDraft(const CartState()),
        throwsArgumentError,
      );
    });
  });

  group('file-backed durability (restart simulation)', () {
    test('profile and draft survive closing and reopening the database',
        () async {
      final dir = await Directory.systemTemp.createTemp('sf_test_');
      final file = File('${dir.path}/studioflow.db');
      try {
        var reopen = AppDatabase.forTesting(NativeDatabase(file));
        await DriftStudioConfigRepository(reopen).save(
          dpoiseDemoBranding.copyWith(businessName: 'Persisted Studio'),
        );
        await DriftDraftStore(reopen).saveDraft(
          draftOf('draft-restart', [
            line('svc_haircut', 30000, 2),
            line('svc_facial', 60000, 1),
          ]),
        );
        await reopen.close();

        reopen = AppDatabase.forTesting(NativeDatabase(file));
        final profile = await DriftStudioConfigRepository(reopen).load();
        expect(profile!.businessName, 'Persisted Studio');
        final recovered =
            await DriftDraftStore(reopen).loadDraft('draft-restart');
        expect(recovered, isNotNull);
        expect(recovered!.itemCount, 3);
        expect(recovered.totalPaise, 2 * 30000 + 60000);
        final version =
            await reopen.customSelect('PRAGMA user_version').getSingle();
        expect(version.read<int>('user_version'), 5);
        await reopen.close();
      } finally {
        await dir.delete(recursive: true);
      }
    });
  });
}
