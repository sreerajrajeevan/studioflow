import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:studioflow/core/studio_time.dart';
import 'package:studioflow/data/billing_repository.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/people_repository.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/domain/models.dart';
import 'package:studioflow/features/billing/cart.dart';

/// Task 4: employees, attendance (Kolkata dates, one-per-day,
/// audited corrections), and the salary advance ledger.
void main() {
  group('studio time (Asia/Kolkata)', () {
    test('UTC instants map to the correct Kolkata date', () {
      // 19:00 UTC = 00:30 IST next day.
      expect(
        StudioTime.dateKeyOf(DateTime.utc(2026, 11, 22, 19, 0)),
        '2026-11-23',
      );
      // 18:29 UTC = 23:59 IST same day.
      expect(
        StudioTime.dateKeyOf(DateTime.utc(2026, 11, 22, 18, 29)),
        '2026-11-22',
      );
      // Month boundary: 2026-01-31 19:30 UTC = 2026-02-01 01:00 IST.
      expect(
        StudioTime.dateKeyOf(DateTime.utc(2026, 1, 31, 19, 30)),
        '2026-02-01',
      );
      expect(StudioTime.daysInMonth(2024, 2), 29, reason: 'leap year');
      expect(StudioTime.daysInMonth(2026, 2), 28);
    });
  });

  group('employees', () {
    late AppDatabase db;
    late DriftEmployeeRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftEmployeeRepository(db);
    });
    tearDown(() => db.close());

    test('create, edit, deactivate, reactivate — never deleted', () async {
      await repo.upsert(const Employee(
        id: 'e1',
        name: 'Rahul',
        role: 'Barber',
        phone: '9812345678',
        salaryType: SalaryType.daily,
        monthlySalaryPaise: 80000,
        joiningDate: null,
      ));
      var all = await repo.listAll();
      expect(all.single.name, 'Rahul');
      expect(all.single.salaryType, SalaryType.daily);

      await repo.upsert(all.single.copyWith(
        name: 'Rahul Sharma',
        monthlySalaryPaise: 90000,
      ));
      all = await repo.listAll();
      expect(all.single.name, 'Rahul Sharma');
      expect(all.single.monthlySalaryPaise, 90000);
      expect(all.single.createdAt, isNotNull);
      expect(all.single.updatedAt, isNotNull);

      await repo.setActive('e1', false);
      expect(await repo.listActive(), isEmpty);
      expect((await repo.listAll()).single.isActive, isFalse,
          reason: 'deactivated, not deleted');
      await repo.setActive('e1', true);
      expect((await repo.listActive()).single.name, 'Rahul Sharma');
    });

    test('validation rejects empty names and negative salaries', () async {
      await expectLater(
        repo.upsert(const Employee(id: 'x', name: '  ', role: '')),
        throwsArgumentError,
      );
      await expectLater(
        repo.upsert(const Employee(
          id: 'x',
          name: 'Ok',
          role: '',
          monthlySalaryPaise: -1,
        )),
        throwsArgumentError,
      );
    });

    test('joining date and photo path round-trip; restart durability',
        () async {
      final dir = await Directory.systemTemp.createTemp('sf_emp_');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/db.sqlite');
      var database = AppDatabase.forTesting(NativeDatabase(file));
      var repository = DriftEmployeeRepository(database);
      await repository.upsert(Employee(
        id: 'e9',
        name: 'Meera',
        role: 'Stylist',
        joiningDate: DateTime(2025, 6, 15),
        photoPath: '/photos/meera.jpg',
      ));
      await database.close();

      database = AppDatabase.forTesting(NativeDatabase(file));
      repository = DriftEmployeeRepository(database);
      final loaded = await repository.getById('e9');
      expect(loaded!.joiningDate, DateTime(2025, 6, 15));
      expect(loaded.photoPath, '/photos/meera.jpg');
      final version =
          await database.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 6);
      await database.close();
    });
  });

  group('attendance', () {
    late AppDatabase db;
    late DriftAttendanceRepository repo;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftAttendanceRepository(db);
      await DriftEmployeeRepository(db).upsert(
        const Employee(id: 'e1', name: 'Rahul', role: 'Barber'),
      );
    });
    tearDown(() => db.close());

    test('one record per employee per date; corrections are audited',
        () async {
      await repo.mark(
        employeeId: 'e1',
        dateKey: '2026-11-05',
        status: AttendanceStatus.present,
        actor: 'Owner',
      );
      await repo.mark(
        employeeId: 'e1',
        dateKey: '2026-11-05',
        status: AttendanceStatus.halfDay,
        actor: 'Staff',
      );
      final records = await repo.recordsForDate('2026-11-05');
      expect(records.length, 1, reason: 'still exactly one record');
      expect(records['e1']!.status, AttendanceStatus.halfDay);
      final audit = await repo.auditFor('e1', '2026-11-05');
      expect(audit.length, 2);
      expect(audit[0].oldStatus, isNull);
      expect(audit[0].newStatus, AttendanceStatus.present);
      expect(audit[1].oldStatus, AttendanceStatus.present);
      expect(audit[1].newStatus, AttendanceStatus.halfDay);
      expect(audit[1].actor, 'Staff');
      final rows = await db.select(db.attendanceRecords).get();
      expect(rows.length, 1, reason: 'the table itself holds one row');
    });

    test('invalid dates are rejected', () async {
      await expectLater(
        repo.mark(
          employeeId: 'e1',
          dateKey: '2026-02-30',
          status: AttendanceStatus.present,
          actor: 'Owner',
        ),
        throwsArgumentError,
      );
    });

    test('monthly summary counts states and unmarked elapsed days',
        () async {
      // February 2024 (leap, 29 days) is fully in the past.
      for (final (day, status) in [
        (1, AttendanceStatus.present),
        (2, AttendanceStatus.present),
        (3, AttendanceStatus.halfDay),
        (4, AttendanceStatus.leave),
        (5, AttendanceStatus.absent),
      ]) {
        await repo.mark(
          employeeId: 'e1',
          dateKey: '2024-02-${day.toString().padLeft(2, '0')}',
          status: status,
          actor: 'Owner',
        );
      }
      final summary = await repo.monthlySummary('e1', 2024, 2);
      expect(summary.present, 2);
      expect(summary.halfDays, 1);
      expect(summary.leave, 1);
      expect(summary.absent, 1);
      expect(summary.unmarked, 29 - 5,
          reason: 'past month: every unrecorded day is unmarked');
    });

    test('current month counts unmarked only up to today', () async {
      final today = StudioTime.todayKey();
      final (y, m, d) = StudioTime.parseKey(today);
      await repo.mark(
        employeeId: 'e1',
        dateKey: today,
        status: AttendanceStatus.present,
        actor: 'Owner',
      );
      final summary = await repo.monthlySummary('e1', y, m);
      expect(summary.present, 1);
      expect(summary.unmarked, d - 1,
          reason: 'future days of this month are not unmarked');
    });
  });

  group('salary advances', () {
    late AppDatabase db;
    late DriftAdvanceRepository repo;

    SalaryAdvance advance({
      String id = 'adv_1',
      int paise = 50000,
      String date = '2026-11-05',
    }) =>
        SalaryAdvance(
          id: id,
          employeeId: 'e1',
          amountPaise: paise,
          businessDateKey: date,
          recordedAt: DateTime(2026, 11, 5, 10),
          method: AdvanceMethod.cash,
          recordedBy: 'Owner',
        );

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = DriftAdvanceRepository(db);
      await DriftEmployeeRepository(db).upsert(
        const Employee(id: 'e1', name: 'Rahul', role: 'Barber'),
      );
    });
    tearDown(() => db.close());

    test('the brief\'s example: 500 + 1000 + 300 = ₹1,800 for November',
        () async {
      await repo.record(advance(id: 'a1', paise: 50000, date: '2026-11-05'));
      await repo.record(advance(id: 'a2', paise: 100000, date: '2026-11-12'));
      await repo.record(advance(id: 'a3', paise: 30000, date: '2026-11-18'));
      await repo.record(advance(id: 'a4', paise: 99900, date: '2026-10-31'));
      final november = await repo.totalForPeriod(
        'e1',
        fromKey: '2026-11-01',
        toKey: '2026-11-30',
      );
      expect(november, 180000, reason: 'October entry excluded');
    });

    test('duplicate submission (same id) records only once', () async {
      await repo.record(advance());
      final again = await repo.record(advance());
      expect(again.id, 'adv_1');
      expect((await repo.listForEmployee('e1')).length, 1);
    });

    test('reversal nets the ledger to zero and preserves both entries',
        () async {
      await repo.record(advance());
      final reversal = await repo.reverse('adv_1', actor: 'Owner');
      expect(reversal.isReversal, isTrue);
      expect(reversal.amountPaise, 50000);
      final entries = await repo.listForEmployee('e1');
      expect(entries.length, 2, reason: 'original + reversal both kept');
      expect(
        await repo.totalForPeriod('e1',
            fromKey: '2026-11-01', toKey: '2026-11-30'),
        0,
      );
      // Double reversal and reversing a reversal are both rejected.
      await expectLater(repo.reverse('adv_1', actor: 'Owner'),
          throwsStateError);
      await expectLater(
        repo.reverse(reversal.id, actor: 'Owner'),
        throwsStateError,
      );
    });

    test('non-positive amounts are rejected', () async {
      await expectLater(
        repo.record(advance(paise: 0)),
        throwsArgumentError,
      );
    });

    test('advances survive a database restart (file-backed)', () async {
      final dir = await Directory.systemTemp.createTemp('sf_adv_');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/db.sqlite');
      var database = AppDatabase.forTesting(NativeDatabase(file));
      var repository = DriftAdvanceRepository(database);
      await DriftEmployeeRepository(database).upsert(
        const Employee(id: 'e1', name: 'Rahul', role: 'Barber'),
      );
      await repository.record(advance());
      await database.close();

      database = AppDatabase.forTesting(NativeDatabase(file));
      repository = DriftAdvanceRepository(database);
      final entries = await repository.listForEmployee('e1');
      expect(entries.single.amountPaise, 50000);
      await database.close();
    });
  });

  group('billing integration', () {
    test('invoice keeps the employee snapshot after a rename', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final employees = DriftEmployeeRepository(db);
      await employees.upsert(
        const Employee(id: 'e1', name: 'Rahul', role: 'Barber'),
      );
      final billing = DriftBillingRepository(db);
      final bill = await billing.finalizeDraft(
        cart: const CartState(
          draftId: 'd1',
          lines: [
            CartLine(
              serviceId: 's1',
              serviceName: 'Haircut',
              pricePaise: 30000,
              durationMinutes: 30,
              quantity: 1,
              employeeId: 'e1',
              employeeName: 'Rahul',
            ),
          ],
        ),
        studio: const StudioSnapshot(businessName: 'Studio'),
        studioPrimaryColor: 0,
        payments: const [],
        actor: 'Owner',
      );
      await employees.upsert(
        const Employee(id: 'e1', name: 'Rahul Sharma', role: 'Barber'),
      );
      final reloaded = await billing.getBill(bill.id);
      expect(reloaded!.lines.single.employeeName, 'Rahul',
          reason: 'finalized invoices keep the original snapshot');
      // Deactivated employees disappear from new-bill selection.
      await employees.setActive('e1', false);
      expect(await employees.listActive(), isEmpty);
    });
  });

  group('schema migration v3 -> v4', () {
    test('a v3 database upgrades; employees survive, attendance works',
        () async {
      final dir = await Directory.systemTemp.createTemp('sf_mig4_');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/v3.db';
      final raw = sqlite3.sqlite3.open(path);
      raw.execute('''
        CREATE TABLE "employees" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "role" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "salary_type" TEXT NOT NULL DEFAULT 'monthly', "monthly_salary_paise" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), PRIMARY KEY ("id"));
        CREATE TABLE "service_categories" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "sort_order" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), PRIMARY KEY ("id"));
        CREATE TABLE "services" ("id" TEXT NOT NULL, "category_id" TEXT NOT NULL, "name" TEXT NOT NULL, "description" TEXT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "is_extra" INTEGER NOT NULL DEFAULT 0 CHECK ("is_extra" IN (0, 1)), "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), "sort_order" INTEGER NOT NULL DEFAULT 0, "created_at" INTEGER NOT NULL DEFAULT 0, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        CREATE TABLE "studio_profiles" ("id" INTEGER NOT NULL, "business_name" TEXT NOT NULL, "tagline" TEXT NULL, "logo_path" TEXT NULL, "primary_color" INTEGER NOT NULL, "secondary_color" INTEGER NOT NULL, "address" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "email" TEXT NULL, "gstin" TEXT NULL, "upi_id" TEXT NULL, "upi_payee_name" TEXT NULL, "currency_code" TEXT NOT NULL DEFAULT 'INR', "invoice_prefix" TEXT NOT NULL DEFAULT 'INV', "invoice_footer" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
        CREATE TABLE "bill_drafts" ("draft_id" TEXT NOT NULL, "discount_percent" INTEGER NOT NULL DEFAULT 0, "discount_flat_paise" INTEGER NOT NULL DEFAULT 0, "tax_basis_points" INTEGER NOT NULL DEFAULT 0, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("draft_id"));
        CREATE TABLE "draft_lines" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "draft_id" TEXT NOT NULL, "service_id" TEXT NOT NULL, "service_name" TEXT NOT NULL, "price_paise" INTEGER NOT NULL, "duration_minutes" INTEGER NOT NULL DEFAULT 0, "quantity" INTEGER NOT NULL, "employee_id" TEXT NULL, "employee_name" TEXT NULL, "position" INTEGER NOT NULL, UNIQUE ("draft_id", "service_id", "price_paise"));
        CREATE TABLE "bills" ("id" TEXT NOT NULL, "created_at" INTEGER NOT NULL DEFAULT 0, "payment_status" TEXT NOT NULL DEFAULT 'pending', PRIMARY KEY ("id"));
        CREATE TABLE "bill_lines" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "bill_id" TEXT NOT NULL);
        CREATE TABLE "payments" ("id" TEXT NOT NULL, "bill_id" TEXT NOT NULL DEFAULT '', PRIMARY KEY ("id"));
        CREATE TABLE "invoice_counters" ("key" TEXT NOT NULL, "value" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("key"));
        CREATE TABLE "billing_audit_events" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "bill_id" TEXT NULL, "draft_id" TEXT NULL, "type" TEXT NOT NULL, "actor" TEXT NOT NULL, "detail" TEXT NOT NULL DEFAULT '', "created_at" INTEGER NOT NULL);
        CREATE TABLE "sync_metadata" ("key" TEXT NOT NULL, "value" TEXT NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("key"));
        INSERT INTO employees VALUES ('e1', 'Rahul', 'Barber', '', 'monthly', 3000000, 1);
        PRAGMA user_version = 3;
      ''');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      final version =
          await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 6);
      final employee = await DriftEmployeeRepository(db).getById('e1');
      expect(employee!.name, 'Rahul');
      expect(employee.joiningDate, isNull,
          reason: 'pre-v4 rows have no joining date — nullable by design');
      await DriftAttendanceRepository(db).mark(
        employeeId: 'e1',
        dateKey: '2026-11-22',
        status: AttendanceStatus.present,
        actor: 'Owner',
      );
      expect(
        (await DriftAttendanceRepository(db).recordsForDate('2026-11-22'))
            .length,
        1,
      );
    });
  });
}
