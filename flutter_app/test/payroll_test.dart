import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:studioflow/app/state.dart';
import 'package:studioflow/core/payroll_engine.dart';
import 'package:studioflow/core/studio_time.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/payroll_repository.dart';
import 'package:studioflow/data/people_repository.dart';
import 'package:studioflow/data/repositories_impl.dart';
import 'package:studioflow/domain/models.dart';

/// Task 5 payroll tests. All expected figures are exact paise,
/// computed independently of the engine (see TASK5_NOTES.md).
void main() {
  late AppDatabase db;
  late DriftEmployeeRepository employees;
  late DriftAttendanceRepository attendance;
  late DriftAdvanceRepository advances;
  late DriftPayrollRepository payroll;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    employees = DriftEmployeeRepository(db);
    attendance = DriftAttendanceRepository(db);
    advances = DriftAdvanceRepository(db);
    payroll = DriftPayrollRepository(db);
  });

  tearDown(() async => db.close());

  Future<void> addEmployee({
    String id = 'emp_1',
    String name = 'Rahul',
    SalaryType type = SalaryType.monthly,
    int ratePaise = 3000000, // ₹30,000
  }) =>
      employees.upsert(
        Employee(
          id: id,
          name: name,
          role: 'Stylist',
          salaryType: type,
          monthlySalaryPaise: ratePaise,
        ),
      );

  /// Feb 2024 fixture: 20 present, 2 half days, 2 leave, 1 absent;
  /// the 4 Sundays stay unmarked (weekly-off bucket).
  Future<void> markFebruary(String employeeId) async {
    const present = [
      1, 2, 3, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23,
    ];
    for (final day in present) {
      await attendance.mark(
        employeeId: employeeId,
        dateKey: '2024-02-${day.toString().padLeft(2, '0')}',
        status: AttendanceStatus.present,
        actor: 'Owner',
      );
    }
    for (final day in [24, 26]) {
      await attendance.mark(
        employeeId: employeeId,
        dateKey: '2024-02-$day',
        status: AttendanceStatus.halfDay,
        actor: 'Owner',
      );
    }
    for (final day in [27, 28]) {
      await attendance.mark(
        employeeId: employeeId,
        dateKey: '2024-02-$day',
        status: AttendanceStatus.leave,
        actor: 'Owner',
      );
    }
    await attendance.mark(
      employeeId: employeeId,
      dateKey: '2024-02-29',
      status: AttendanceStatus.absent,
      actor: 'Owner',
    );
  }

  Future<void> addAdvance(
    String id,
    String employeeId,
    int paise,
    String dateKey,
  ) =>
      advances.record(
        SalaryAdvance(
          id: id,
          employeeId: employeeId,
          amountPaise: paise,
          businessDateKey: dateKey,
          recordedAt: DateTime(2026, 1, 1),
          method: AdvanceMethod.cash,
          recordedBy: 'Owner',
        ),
      );

  Future<void> reviewRules() =>
      payroll.saveSettings(PayrollRules(), markReviewed: true);

  group('payroll preview calculations', () {
    test('monthly, calendar basis, leap February — exact paise',
        () async {
      await addEmployee();
      await markFebruary('emp_1');
      final lines = await payroll.preview('2024-02');
      final line = lines.single;
      expect(line.counts.present, 20);
      expect(line.counts.halfDays, 2);
      expect(line.counts.leave, 2);
      expect(line.counts.absent, 1);
      expect(line.counts.weeklyOff, 4, reason: 'Feb 2024 Sundays');
      expect(line.counts.unmarked, 0);
      // Units: 20 + 2×0.5 + 4 weekly-off = 25 days of 29.
      expect(line.computation.payableUnitsBp, 250000);
      expect(line.computation.earningsPaise, 2586207);
      expect(line.computation.netPaise, 2586207);
      expect(line.incompleteAttendance, isFalse);
    });

    test('paid leave changes earnings exactly', () async {
      await addEmployee();
      await markFebruary('emp_1');
      await payroll.saveSettings(
        PayrollRules().copyWith(leaveIsPaid: true),
        markReviewed: false,
      );
      final line = (await payroll.preview('2024-02')).single;
      expect(line.computation.payableUnitsBp, 270000);
      expect(line.computation.earningsPaise, 2793103);
    });

    test('fixed-30 and working-days bases', () async {
      await addEmployee();
      await markFebruary('emp_1');
      await payroll.saveSettings(
        PayrollRules().copyWith(basis: SalaryBasis.fixed30),
        markReviewed: false,
      );
      var line = (await payroll.preview('2024-02')).single;
      expect(line.computation.earningsPaise, 2500000);
      await payroll.saveSettings(
        PayrollRules().copyWith(basis: SalaryBasis.workingDays),
        markReviewed: false,
      );
      line = (await payroll.preview('2024-02')).single;
      expect(line.basisDays, 25, reason: '29 days − 4 Sundays');
      expect(line.computation.earningsPaise, 3000000,
          reason: 'every working day covered = full salary');
    });

    test('daily-wage employee: rate × payable units', () async {
      await addEmployee(type: SalaryType.daily, ratePaise: 80000);
      await markFebruary('emp_1');
      final line = (await payroll.preview('2024-02')).single;
      expect(line.computation.earningsPaise, 2000000);
    });

    test('rule changes reprice the preview (nothing is cached stale)',
        () async {
      await addEmployee();
      await markFebruary('emp_1');
      final before = (await payroll.preview('2024-02')).single;
      await payroll.saveSettings(
        PayrollRules().copyWith(halfDayMultiplierBp: 10000),
        markReviewed: false,
      );
      final after = (await payroll.preview('2024-02')).single;
      expect(after.computation.payableUnitsBp,
          before.computation.payableUnitsBp + 10000);
    });
  });

  group('draft, approval and payments (October 2026)', () {
    // No attendance marked: Sundays (4) are paid weekly offs, the
    // other 27 elapsed days are unmarked. Monthly ₹31,000 →
    // earnings exactly ₹4,000 (4,00,000 paise... 400000 paise).
    Future<PayrollRun> approvedRun() async {
      await reviewRules();
      final draft = await payroll.getOrCreateDraft('2026-10', 'Owner');
      return payroll.approve(draft.id, 'Owner',
          acknowledgeIncomplete: true);
    }

    test('draft creation is idempotent; approval freezes figures',
        () async {
      await addEmployee(ratePaise: 3100000);
      await reviewRules();
      final a = await payroll.getOrCreateDraft('2026-10', 'Owner');
      final b = await payroll.getOrCreateDraft('2026-10', 'Owner');
      expect(a.id, b.id);
      expect((await payroll.listRuns(periodKey: '2026-10')).length, 1);
      final line = (await payroll.linesFor(a.id)).single;
      expect(line.counts.weeklyOff, 4);
      expect(line.counts.unmarked, 27);
      expect(line.earningsPaise, 400000);
      final approved = await payroll.approve(a.id, 'Owner',
          acknowledgeIncomplete: true);
      expect(approved.status, PayrollRunStatus.approved);
      expect(approved.rulesSnapshot, isNotNull);
      // Second approval is rejected — no double approval.
      await expectLater(
        payroll.approve(a.id, 'Owner', acknowledgeIncomplete: true),
        throwsStateError,
      );
    });

    test('approval blocked until rules are reviewed', () async {
      await addEmployee(ratePaise: 3100000);
      final draft = await payroll.getOrCreateDraft('2026-10', 'Owner');
      await expectLater(
        payroll.approve(draft.id, 'Owner', acknowledgeIncomplete: true),
        throwsStateError,
      );
      await reviewRules();
      final approved = await payroll.approve(draft.id, 'Owner',
          acknowledgeIncomplete: true);
      expect(approved.status, PayrollRunStatus.approved);
    });

    test('approval blocked by incomplete attendance without ack',
        () async {
      await addEmployee(ratePaise: 3100000);
      await reviewRules();
      final draft = await payroll.getOrCreateDraft('2026-10', 'Owner');
      await expectLater(
        payroll.approve(draft.id, 'Owner'),
        throwsStateError,
      );
    });

    test('advances deducted exactly once across runs', () async {
      await addEmployee(ratePaise: 3100000);
      await addAdvance('adv_1', 'emp_1', 50000, '2026-10-05');
      await addAdvance('adv_2', 'emp_1', 100000, '2026-10-12');
      await addAdvance('adv_3', 'emp_1', 30000, '2026-10-18');
      final run = await approvedRun();
      final line = (await payroll.linesFor(run.id)).single;
      expect(line.advancesPaise, 180000);
      expect(line.netPaise, 400000 - 180000);
      // The ledger itself is untouched (still ₹1,800 for the month)…
      expect(
        await advances.totalForPeriod('emp_1',
            fromKey: '2026-10-01', toKey: '2026-10-31'),
        180000,
      );
      // …but a fresh preview no longer offers them for deduction.
      final preview = (await payroll.preview('2026-10')).single;
      expect(preview.advancesPaise, 0);
      // And no second run can be approved for the period.
      final runs = await payroll.listRuns(periodKey: '2026-10');
      expect(
        runs.where((r) => r.status == PayrollRunStatus.approved).length,
        1,
      );
    });

    test('a reversed advance nets to zero before payroll', () async {
      // Reversals are dated the day they are recorded (Task 4), so
      // use the current studio month for a deterministic fixture:
      // advance and reversal land in the same period and net out.
      await addEmployee(ratePaise: 3100000);
      final month = StudioTime.monthKeyOf(DateTime.now());
      await addAdvance('adv_1', 'emp_1', 100000, '$month-05');
      await advances.reverse('adv_1', actor: 'Owner');
      final preview = (await payroll.preview(month)).single;
      expect(preview.advancesPaise, 0);
    });

    test('partial payments settle to Paid; overpay is rejected',
        () async {
      await addEmployee(ratePaise: 3100000);
      await addAdvance('adv_1', 'emp_1', 180000, '2026-10-05');
      final run = await approvedRun();
      final line = (await payroll.linesFor(run.id)).single;
      expect(line.netPaise, 220000);
      PayrollPayment payment(String id, int paise) => PayrollPayment(
            id: id,
            runId: run.id,
            lineId: line.id,
            employeeId: 'emp_1',
            amountPaise: paise,
            paidAt: DateTime(2026, 11, 1),
            method: 'cash',
            recordedBy: 'Owner',
          );
      await payroll.recordPayment(payment('pay_1', 100000));
      // Idempotent: the same payment id recorded again changes nothing.
      await payroll.recordPayment(payment('pay_1', 100000));
      var current = await payroll.getRun(run.id);
      expect(current!.status, PayrollRunStatus.partiallyPaid);
      expect((await payroll.linesFor(run.id)).single.paidPaise, 100000);
      await expectLater(
        payroll.recordPayment(payment('pay_2', 120001)),
        throwsArgumentError,
      );
      await payroll.recordPayment(payment('pay_2', 120000));
      current = await payroll.getRun(run.id);
      expect(current!.status, PayrollRunStatus.paid);
    });

    test('negative net becomes an explicit carry-forward, never < 0',
        () async {
      await addEmployee(ratePaise: 3100000);
      await addAdvance('adv_big', 'emp_1', 500000, '2026-10-05');
      final run = await approvedRun();
      final line = (await payroll.linesFor(run.id)).single;
      expect(line.grossPaise, 400000);
      expect(line.netPaise, 0);
      expect(line.carryForwardPaise, 100000);
    });

    test('approved payroll is immutable: later edits do not rewrite it',
        () async {
      await addEmployee(ratePaise: 3100000);
      final run = await approvedRun();
      // Change salary, attendance and rules after approval.
      await employees.upsert(
        const Employee(
          id: 'emp_1',
          name: 'Rahul',
          role: 'Stylist',
          salaryType: SalaryType.monthly,
          monthlySalaryPaise: 9999900,
        ),
      );
      await attendance.mark(
        employeeId: 'emp_1',
        dateKey: '2026-10-01',
        status: AttendanceStatus.present,
        actor: 'Owner',
      );
      await payroll.saveSettings(
        PayrollRules().copyWith(basis: SalaryBasis.fixed30),
        markReviewed: false,
      );
      final line = (await payroll.linesFor(run.id)).single;
      expect(line.ratePaise, 3100000);
      expect(line.earningsPaise, 400000);
      expect(line.counts.unmarked, 27);
      final frozen = await payroll.getRun(run.id);
      expect(frozen!.rulesSnapshot!.basis, SalaryBasis.calendarDays);
    });

    test('revision voids the old run and releases its advances',
        () async {
      await addEmployee(ratePaise: 3100000);
      await addAdvance('adv_1', 'emp_1', 180000, '2026-10-05');
      final run = await approvedRun();
      final newDraft = await payroll.revise(run.id, 'Owner');
      expect(newDraft.status, PayrollRunStatus.draft);
      expect(newDraft.version, 2);
      final old = await payroll.getRun(run.id);
      expect(old!.status, PayrollRunStatus.voided);
      // Advances are deductible again in the revised run.
      final line = (await payroll.linesFor(newDraft.id)).single;
      expect(line.advancesPaise, 180000);
      final reapproved = await payroll.approve(newDraft.id, 'Owner',
          acknowledgeIncomplete: true);
      expect(reapproved.status, PayrollRunStatus.approved);
      expect(
        (await payroll.linesFor(newDraft.id)).single.netPaise,
        220000,
      );
    });

    test('a paid payroll cannot be voided or revised', () async {
      await addEmployee(ratePaise: 3100000);
      final run = await approvedRun();
      final line = (await payroll.linesFor(run.id)).single;
      await payroll.recordPayment(
        PayrollPayment(
          id: 'pay_full',
          runId: run.id,
          lineId: line.id,
          employeeId: 'emp_1',
          amountPaise: line.netPaise,
          paidAt: DateTime(2026, 11, 1),
          method: 'upi',
          recordedBy: 'Owner',
        ),
      );
      await expectLater(
        payroll.voidRun(run.id, 'Owner', 'mistake'),
        throwsStateError,
      );
      await expectLater(payroll.revise(run.id, 'Owner'), throwsStateError);
    });
  });

  group('overtime and adjustments', () {
    test('overtime and bonus/deduction flow into gross and net',
        () async {
      await addEmployee();
      await markFebruary('emp_1');
      await reviewRules();
      final draft = await payroll.getOrCreateDraft('2024-02', 'Owner');
      await payroll.setOvertime(draft.id, 'emp_1', 20000); // 2 days
      var line = (await payroll.linesFor(draft.id)).single;
      expect(line.overtimePaise, 310345);
      expect(line.grossPaise, 2586207 + 310345);
      await payroll.addAdjustment(
        PayrollAdjustment(
          id: 'adj_bonus',
          runId: draft.id,
          lineId: line.id,
          isBonus: true,
          amountPaise: 100000,
          label: 'Festival bonus',
          createdBy: 'Owner',
          createdAt: DateTime(2024, 3, 1),
        ),
      );
      await payroll.addAdjustment(
        PayrollAdjustment(
          id: 'adj_ded',
          runId: draft.id,
          lineId: line.id,
          isBonus: false,
          amountPaise: 50000,
          label: 'Uniform',
          createdBy: 'Owner',
          createdAt: DateTime(2024, 3, 1),
        ),
      );
      line = (await payroll.linesFor(draft.id)).single;
      expect(line.bonusPaise, 100000);
      expect(line.deductionsPaise, 50000);
      expect(line.netPaise, 2586207 + 310345 + 100000 - 50000);
      // Adjustments lock once approved.
      await payroll.approve(draft.id, 'Owner');
      await expectLater(
        payroll.addAdjustment(
          PayrollAdjustment(
            id: 'adj_late',
            runId: draft.id,
            lineId: line.id,
            isBonus: true,
            amountPaise: 100,
            label: 'Late',
            createdBy: 'Owner',
            createdAt: DateTime(2024, 3, 2),
          ),
        ),
        throwsStateError,
      );
    });
  });

  group('settings', () {
    test('defaults are unreviewed; review persists with the rules',
        () async {
      final initial = await payroll.getSettings();
      expect(initial.isReviewed, isFalse);
      await payroll.saveSettings(
        PayrollRules().copyWith(basis: SalaryBasis.fixed30),
        markReviewed: true,
      );
      final saved = await payroll.getSettings();
      expect(saved.isReviewed, isTrue);
      expect(saved.rules.basis, SalaryBasis.fixed30);
    });
  });

  group('visibility', () {
    test('staff role cannot see the payroll route', () {
      expect(roleCanSee(AppRole.staff, '/payroll'), isFalse);
      expect(roleCanSee(AppRole.owner, '/payroll'), isTrue);
    });
  });

  group('durability', () {
    test('approved payroll + payment survive a file-backed restart',
        () async {
      final file = File(
        '${Directory.systemTemp.path}/sf_payroll_test_'
        '${DateTime.now().microsecondsSinceEpoch}.db',
      );
      var fileDb = AppDatabase(NativeDatabase(file));
      var filePayroll = DriftPayrollRepository(fileDb);
      await DriftEmployeeRepository(fileDb).upsert(
        const Employee(
          id: 'emp_1',
          name: 'Rahul',
          role: 'Stylist',
          monthlySalaryPaise: 3100000,
        ),
      );
      await filePayroll.saveSettings(PayrollRules(), markReviewed: true);
      final draft =
          await filePayroll.getOrCreateDraft('2026-10', 'Owner');
      final approved = await filePayroll.approve(draft.id, 'Owner',
          acknowledgeIncomplete: true);
      final line = (await filePayroll.linesFor(approved.id)).single;
      await filePayroll.recordPayment(
        PayrollPayment(
          id: 'pay_1',
          runId: approved.id,
          lineId: line.id,
          employeeId: 'emp_1',
          amountPaise: 100000,
          paidAt: DateTime(2026, 11, 1),
          method: 'cash',
          recordedBy: 'Owner',
        ),
      );
      await fileDb.close();

      fileDb = AppDatabase(NativeDatabase(file));
      filePayroll = DriftPayrollRepository(fileDb);
      final version =
          await fileDb.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 6);
      final run = await filePayroll.getRun(approved.id);
      expect(run!.status, PayrollRunStatus.partiallyPaid);
      expect(
        (await filePayroll.linesFor(approved.id)).single.paidPaise,
        100000,
      );
      await fileDb.close();
      await file.delete();
    });

    test('a v4 database upgrades to v5 with data intact', () async {
      final dir = await Directory.systemTemp.createTemp('sf_mig5_');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/v4.db';
      // Genuine v4 fixture written with raw sqlite (the pattern used
      // by the earlier migration tests): v4-shaped employees plus
      // the v4 attendance/advances tables.
      final raw = sqlite3.sqlite3.open(path);
      raw.execute('''
        CREATE TABLE "employees" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "role" TEXT NOT NULL DEFAULT '', "phone" TEXT NOT NULL DEFAULT '', "salary_type" TEXT NOT NULL DEFAULT 'monthly', "monthly_salary_paise" INTEGER NOT NULL DEFAULT 0, "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), "joining_date" INTEGER NULL, "photo_path" TEXT NULL, "created_at" INTEGER NULL, "updated_at" INTEGER NULL, PRIMARY KEY ("id"));
        CREATE TABLE "attendance_records" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "employee_id" TEXT NOT NULL, "date_key" TEXT NOT NULL, "status" TEXT NOT NULL, "marked_by" TEXT NOT NULL, "marked_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, UNIQUE ("employee_id", "date_key"));
        CREATE TABLE "attendance_audit_events" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "employee_id" TEXT NOT NULL, "date_key" TEXT NOT NULL, "old_status" TEXT NULL, "new_status" TEXT NOT NULL, "actor" TEXT NOT NULL, "created_at" INTEGER NOT NULL);
        CREATE TABLE "salary_advances" ("id" TEXT NOT NULL, "employee_id" TEXT NOT NULL, "amount_paise" INTEGER NOT NULL, "business_date_key" TEXT NOT NULL, "recorded_at" INTEGER NOT NULL, "method" TEXT NOT NULL DEFAULT 'cash', "notes" TEXT NULL, "recorded_by" TEXT NOT NULL, "reversal_of_id" TEXT NULL, PRIMARY KEY ("id"));
        INSERT INTO "employees" ("id", "name", "role", "salary_type", "monthly_salary_paise", "is_active")
        VALUES ('emp_1', 'Rahul', 'Stylist', 'monthly', 3100000, 1);
        PRAGMA user_version = 4;
      ''');
      raw.close();

      final upgraded = AppDatabase.forTesting(NativeDatabase(File(path)));
      final version =
          await upgraded.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 6);
      final repo = DriftPayrollRepository(upgraded);
      final preview = await repo.preview('2026-10');
      expect(preview.single.employee.name, 'Rahul');
      expect(preview.single.computation.earningsPaise, 400000);
      await upgraded.close();
    });
  });
}
