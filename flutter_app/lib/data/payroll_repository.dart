import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/payroll_engine.dart';
import '../core/studio_time.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import 'database.dart';

/// Drift-backed payroll (Task 5).
///
/// Invariants enforced here and in the schema:
/// - Approval requires owner-reviewed rules, is idempotent (a second
///   approval attempt fails on state), and freezes rules + figures.
/// - Each salary advance is consumed by at most one run: the link
///   table's primary key makes double-consumption impossible, and
///   approval links advances inside the approval transaction, so a
///   conflict rolls the whole approval back.
/// - A run is Paid only when its lines' payments settle the net.
/// - Net pay is never negative: excess deductions become an explicit
///   carry-forward on the line.
class DriftPayrollRepository implements PayrollRepository {
  DriftPayrollRepository(this._db);

  final AppDatabase _db;

  // -------------------------------------------------------------- settings

  @override
  Future<PayrollSettingsState> getSettings() async {
    final row = await (_db.select(_db.payrollSettings)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (row != null) {
      return PayrollSettingsState(
        rules: PayrollRules.fromJson(
          (jsonDecode(row.rulesJson) as Map).cast<String, Object?>(),
        ),
        reviewedAt: row.reviewedAt,
        updatedAt: row.updatedAt,
      );
    }
    // First read: persist the example defaults so the settings row
    // exists for later updates. reviewedAt stays null — the owner
    // must review before the first real payroll.
    final defaults = PayrollRules();
    final now = DateTime.now();
    await _db.into(_db.payrollSettings).insert(
          PayrollSettingsCompanion.insert(
            id: const Value(1),
            rulesJson: jsonEncode(defaults.toJson()),
            updatedAt: now,
          ),
        );
    return PayrollSettingsState(rules: defaults, updatedAt: now);
  }

  @override
  Future<void> saveSettings(
    PayrollRules rules, {
    required bool markReviewed,
  }) async {
    final current = await getSettings();
    final now = DateTime.now();
    await (_db.update(_db.payrollSettings)..where((t) => t.id.equals(1)))
        .write(
      PayrollSettingsCompanion(
        rulesJson: Value(jsonEncode(rules.toJson())),
        reviewedAt: markReviewed
            ? Value(current.reviewedAt ?? now)
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  // -------------------------------------------------------------- helpers

  /// Employees who belong in this period's payroll: everyone active,
  /// plus anyone (now inactive) who has attendance or advances in
  /// the period — they still need paying.
  Future<List<Employee>> _eligibleEmployees(String periodKey) async {
    final all = await (_db.select(_db.employees)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    final withAttendance = await (_db.select(_db.attendanceRecords)
          ..where((t) => t.dateKey.like('$periodKey-%')))
        .get();
    final withAdvances = await (_db.select(_db.salaryAdvances)
          ..where((t) => t.businessDateKey.like('$periodKey-%')))
        .get();
    final extraIds = {
      for (final r in withAttendance) r.employeeId,
      for (final a in withAdvances) a.employeeId,
    };
    return [
      for (final row in all)
        if (row.isActive || extraIds.contains(row.id)) _employeeFromRow(row),
    ];
  }

  Employee _employeeFromRow(EmployeeRow row) => Employee(
        id: row.id,
        name: row.name,
        role: row.role,
        phone: row.phone,
        salaryType: SalaryType.values.firstWhere(
          (t) => t.name == row.salaryType,
          orElse: () => SalaryType.monthly,
        ),
        monthlySalaryPaise: row.monthlySalaryPaise,
        isActive: row.isActive,
        joiningDate: row.joiningDate,
        photoPath: row.photoPath,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  /// All date keys of a 'yyyy-MM' period.
  List<String> _keysOfPeriod(String periodKey) {
    final parts = periodKey.split('-');
    return StudioTime.dateKeysOfMonth(
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Attendance tallies over ELAPSED days of the period. Unmarked
  /// elapsed days fall into the weekly-off bucket when they land on
  /// the configured weekly off, the holiday bucket when listed as
  /// studio holidays, and unmarked otherwise.
  Future<PayrollCounts> _countsFor(
    String employeeId,
    String periodKey,
    PayrollRules rules,
  ) async {
    final records = await (_db.select(_db.attendanceRecords)
          ..where((t) =>
              t.employeeId.equals(employeeId) &
              t.dateKey.like('$periodKey-%')))
        .get();
    final byKey = {for (final r in records) r.dateKey: r.status};
    final today = StudioTime.todayKey();
    var present = 0, half = 0, leave = 0, absent = 0;
    var unmarked = 0, weeklyOff = 0, holidays = 0;
    for (final key in _keysOfPeriod(periodKey)) {
      if (key.compareTo(today) > 0) break; // future days don't exist yet
      final status = byKey[key];
      if (status != null) {
        switch (status) {
          case 'present':
            present++;
          case 'half_day':
            half++;
          case 'leave':
            leave++;
          case 'absent':
            absent++;
        }
        continue;
      }
      final (y, m, d) = StudioTime.parseKey(key);
      final weekday = DateTime.utc(y, m, d).weekday;
      if (rules.weeklyOffWeekday != 0 && weekday == rules.weeklyOffWeekday) {
        weeklyOff++;
      } else if (rules.holidayDateKeys.contains(key)) {
        holidays++;
      } else {
        unmarked++;
      }
    }
    return PayrollCounts(
      present: present,
      halfDays: half,
      leave: leave,
      absent: absent,
      unmarked: unmarked,
      weeklyOff: weeklyOff,
      holidays: holidays,
    );
  }

  int _basisDaysFor(String periodKey, PayrollRules rules) {
    final allKeys = _keysOfPeriod(periodKey);
    var weeklyOffs = 0;
    for (final key in allKeys) {
      final (y, m, d) = StudioTime.parseKey(key);
      if (rules.weeklyOffWeekday != 0 &&
          DateTime.utc(y, m, d).weekday == rules.weeklyOffWeekday) {
        weeklyOffs++;
      }
    }
    final holidaysInMonth = rules.holidayDateKeys
        .where((k) => k.startsWith('$periodKey-'))
        .length;
    return PayrollEngine.basisDays(
      rules,
      daysInMonth: allKeys.length,
      weeklyOffDaysInMonth: weeklyOffs,
      holidaysInMonth: holidaysInMonth,
    );
  }

  /// This period's advances for an employee that no run has consumed
  /// yet. Signed: reversals subtract.
  Future<List<SalaryAdvance>> _candidateAdvances(
    String employeeId,
    String periodKey,
  ) async {
    final rows = await (_db.select(_db.salaryAdvances)
          ..where((t) =>
              t.employeeId.equals(employeeId) &
              t.businessDateKey.like('$periodKey-%'))
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .get();
    if (rows.isEmpty) return const [];
    final linked = await (_db.select(_db.payrollAdvanceLinks)).get();
    final linkedIds = {for (final l in linked) l.advanceId};
    return [
      for (final row in rows)
        if (!linkedIds.contains(row.id))
          SalaryAdvance(
            id: row.id,
            employeeId: row.employeeId,
            amountPaise: row.amountPaise,
            businessDateKey: row.businessDateKey,
            recordedAt: row.recordedAt,
            method: AdvanceMethod.values.firstWhere(
              (m) => m.name == row.method,
              orElse: () => AdvanceMethod.cash,
            ),
            recordedBy: row.recordedBy,
            notes: row.notes,
            reversalOfId: row.reversalOfId,
          ),
    ];
  }

  static int _signedTotal(List<SalaryAdvance> advances) =>
      advances.fold(0, (sum, a) => sum + a.signedPaise);

  PayrollComputation _computeFor({
    required Employee employee,
    required PayrollCounts counts,
    required int basisDays,
    required PayrollRules rules,
    required int advancesPaise,
    int overtimeUnitsBp = 0,
    int bonusPaise = 0,
    int deductionsPaise = 0,
  }) =>
      PayrollEngine.compute(
        isDaily: employee.salaryType == SalaryType.daily,
        ratePaise: employee.monthlySalaryPaise,
        rules: rules,
        counts: counts,
        basisDays: basisDays,
        overtimeUnitsBp: overtimeUnitsBp,
        bonusPaise: bonusPaise,
        otherDeductionsPaise: deductionsPaise,
        advancesPaise: advancesPaise,
      );

  // -------------------------------------------------------------- preview

  @override
  Future<List<PayrollPreviewLine>> preview(String periodKey) async {
    final settings = await getSettings();
    final rules = settings.rules;
    final basisDays = _basisDaysFor(periodKey, rules);
    final employees = await _eligibleEmployees(periodKey);
    final lines = <PayrollPreviewLine>[];
    for (final employee in employees) {
      final counts = await _countsFor(employee.id, periodKey, rules);
      final advances = await _candidateAdvances(employee.id, periodKey);
      final advancesPaise = _signedTotal(advances);
      lines.add(
        PayrollPreviewLine(
          employee: employee,
          counts: counts,
          basisDays: basisDays,
          advancesPaise: advancesPaise,
          computation: _computeFor(
            employee: employee,
            counts: counts,
            basisDays: basisDays,
            rules: rules,
            advancesPaise: advancesPaise,
          ),
        ),
      );
    }
    return lines;
  }

  // -------------------------------------------------------------- runs

  PayrollRun _runFromRow(PayrollRunRow row) => PayrollRun(
        id: row.id,
        periodKey: row.periodKey,
        version: row.version,
        status: PayrollRunStatus.values.firstWhere(
          (s) => s.name == row.status || _statusName(s) == row.status,
          orElse: () => PayrollRunStatus.draft,
        ),
        rulesSnapshot: row.rulesJson == null
            ? null
            : PayrollRules.fromJson(
                (jsonDecode(row.rulesJson!) as Map).cast<String, Object?>(),
              ),
        createdBy: row.createdBy,
        createdAt: row.createdAt,
        approvedBy: row.approvedBy,
        approvedAt: row.approvedAt,
        voidReason: row.voidReason,
      );

  static String _statusName(PayrollRunStatus status) => switch (status) {
        PayrollRunStatus.partiallyPaid => 'partially_paid',
        _ => status.name,
      };

  PayrollLine _lineFromRow(PayrollLineRow row) => PayrollLine(
        id: row.id,
        runId: row.runId,
        employeeId: row.employeeId,
        employeeName: row.employeeName,
        salaryType: SalaryType.values.firstWhere(
          (t) => t.name == row.salaryType,
          orElse: () => SalaryType.monthly,
        ),
        ratePaise: row.ratePaise,
        counts: PayrollCounts(
          present: row.presentDays,
          halfDays: row.halfDays,
          leave: row.leaveDays,
          absent: row.absentDays,
          unmarked: row.unmarkedDays,
          weeklyOff: row.weeklyOffDays,
          holidays: row.holidayDays,
        ),
        payableUnitsBp: row.payableUnitsBp,
        basisDays: row.basisDays,
        earningsPaise: row.earningsPaise,
        overtimeUnitsBp: row.overtimeUnitsBp,
        overtimePaise: row.overtimePaise,
        bonusPaise: row.bonusPaise,
        deductionsPaise: row.deductionsPaise,
        advancesPaise: row.advancesPaise,
        grossPaise: row.grossPaise,
        netPaise: row.netPaise,
        carryForwardPaise: row.carryForwardPaise,
        paidPaise: row.paidPaise,
      );

  @override
  Future<PayrollRun?> getRun(String runId) async {
    final row = await (_db.select(_db.payrollRuns)
          ..where((t) => t.id.equals(runId)))
        .getSingleOrNull();
    return row == null ? null : _runFromRow(row);
  }

  @override
  Future<List<PayrollRun>> listRuns({String? periodKey}) async {
    final rows = await (_db.select(_db.payrollRuns)
          ..where((t) =>
              periodKey == null ? const Constant(true) : t.periodKey.equals(periodKey))
          ..orderBy([
            (t) => OrderingTerm.desc(t.periodKey),
            (t) => OrderingTerm.asc(t.version),
          ]))
        .get();
    return [for (final row in rows) _runFromRow(row)];
  }

  @override
  Future<List<PayrollLine>> linesFor(String runId) async {
    final rows = await (_db.select(_db.payrollLines)
          ..where((t) => t.runId.equals(runId))
          ..orderBy([(t) => OrderingTerm.asc(t.employeeName)]))
        .get();
    return [for (final row in rows) _lineFromRow(row)];
  }

  @override
  Future<List<PayrollAdjustment>> adjustmentsFor(String runId) async {
    final rows = await (_db.select(_db.payrollAdjustments)
          ..where((t) => t.runId.equals(runId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return [
      for (final row in rows)
        PayrollAdjustment(
          id: row.id,
          runId: row.runId,
          lineId: row.lineId,
          isBonus: row.kind == 'bonus',
          amountPaise: row.amountPaise,
          label: row.label,
          createdBy: row.createdBy,
          createdAt: row.createdAt,
        ),
    ];
  }

  @override
  Future<List<PayrollPayment>> paymentsFor(String runId) async {
    final rows = await (_db.select(_db.payrollPayments)
          ..where((t) => t.runId.equals(runId))
          ..orderBy([(t) => OrderingTerm.asc(t.paidAt)]))
        .get();
    return [
      for (final row in rows)
        PayrollPayment(
          id: row.id,
          runId: row.runId,
          lineId: row.lineId,
          employeeId: row.employeeId,
          amountPaise: row.amountPaise,
          paidAt: row.paidAt,
          method: row.method,
          recordedBy: row.recordedBy,
          notes: row.notes,
        ),
    ];
  }

  Future<void> _audit(String runId, String type, String actor,
      [String? detail]) async {
    await _db.into(_db.payrollAuditEvents).insert(
          PayrollAuditEventsCompanion.insert(
            runId: runId,
            type: type,
            actor: actor,
            detail: Value(detail),
            createdAt: DateTime.now(),
          ),
        );
  }

  /// Builds fresh draft lines for [runId] from the live preview,
  /// preserving overtime + adjustments per employee from [preserve]
  /// (existing lines of the same run, keyed by employee id).
  Future<void> _rebuildLines(
    String runId,
    String periodKey, {
    Map<String, PayrollLine> preserve = const {},
  }) async {
    final settings = await getSettings();
    final rules = settings.rules;
    final previewLines = await preview(periodKey);
    final adjustments = await adjustmentsFor(runId);
    await (_db.delete(_db.payrollLines)..where((t) => t.runId.equals(runId)))
        .go();
    for (final previewLine in previewLines) {
      final employee = previewLine.employee;
      final old = preserve[employee.id];
      final lineId = '$runId:${employee.id}';
      final lineAdjustments =
          adjustments.where((a) => a.lineId == old?.id).toList();
      final bonus = lineAdjustments
          .where((a) => a.isBonus)
          .fold(0, (s, a) => s + a.amountPaise);
      final deductions = lineAdjustments
          .where((a) => !a.isBonus)
          .fold(0, (s, a) => s + a.amountPaise);
      final computation = _computeFor(
        employee: employee,
        counts: previewLine.counts,
        basisDays: previewLine.basisDays,
        rules: rules,
        advancesPaise: previewLine.advancesPaise,
        overtimeUnitsBp: old?.overtimeUnitsBp ?? 0,
        bonusPaise: bonus,
        deductionsPaise: deductions,
      );
      await _db.into(_db.payrollLines).insert(
            PayrollLinesCompanion.insert(
              id: lineId,
              runId: runId,
              employeeId: employee.id,
              employeeName: employee.name,
              salaryType: employee.salaryType.name,
              ratePaise: employee.monthlySalaryPaise,
              presentDays: Value(previewLine.counts.present),
              halfDays: Value(previewLine.counts.halfDays),
              leaveDays: Value(previewLine.counts.leave),
              absentDays: Value(previewLine.counts.absent),
              unmarkedDays: Value(previewLine.counts.unmarked),
              weeklyOffDays: Value(previewLine.counts.weeklyOff),
              holidayDays: Value(previewLine.counts.holidays),
              payableUnitsBp: Value(computation.payableUnitsBp),
              basisDays: Value(computation.basisDays),
              earningsPaise: Value(computation.earningsPaise),
              overtimeUnitsBp: Value(old?.overtimeUnitsBp ?? 0),
              overtimePaise: Value(computation.overtimePaise),
              bonusPaise: Value(bonus),
              deductionsPaise: Value(deductions),
              advancesPaise: Value(previewLine.advancesPaise),
              grossPaise: Value(computation.grossPaise),
              netPaise: Value(computation.netPaise),
              carryForwardPaise: Value(computation.carryForwardPaise),
            ),
          );
      // Re-point preserved adjustments at the rebuilt line id (the id
      // is stable — runId:employeeId — so this is a no-op safeguard).
      for (final adjustment in lineAdjustments) {
        await (_db.update(_db.payrollAdjustments)
              ..where((t) => t.id.equals(adjustment.id)))
            .write(PayrollAdjustmentsCompanion(lineId: Value(lineId)));
      }
    }
  }

  @override
  Future<PayrollRun> getOrCreateDraft(String periodKey, String actor) async {
    final runs = await listRuns(periodKey: periodKey);
    final draft =
        runs.where((r) => r.status == PayrollRunStatus.draft).firstOrNull;
    if (draft != null) return draft;
    // An approved/settled run already exists for this period: never
    // spawn a competing draft — return it (revisions void it first).
    final live = runs
        .where((r) => r.status != PayrollRunStatus.voided)
        .toList()
      ..sort((a, b) => b.version.compareTo(a.version));
    if (live.isNotEmpty) return live.first;
    return _db.transaction(() async {
      final version = runs.isEmpty
          ? 1
          : runs.map((r) => r.version).reduce((a, b) => a > b ? a : b) + 1;
      final runId = 'pay_${periodKey}_v$version';
      final now = DateTime.now();
      await _db.into(_db.payrollRuns).insert(
            PayrollRunsCompanion.insert(
              id: runId,
              periodKey: periodKey,
              version: Value(version),
              status: 'draft',
              createdBy: actor,
              createdAt: now,
            ),
          );
      await _rebuildLines(runId, periodKey);
      await _audit(runId, 'created', actor, 'Draft created for $periodKey');
      return (await getRun(runId))!;
    });
  }

  @override
  Future<void> refreshDraft(String runId) async {
    final run = await getRun(runId);
    if (run == null) throw StateError('Payroll run not found.');
    if (run.status != PayrollRunStatus.draft) {
      throw StateError('Only a draft payroll can be refreshed.');
    }
    await _db.transaction(() async {
      final existing = await linesFor(runId);
      await _rebuildLines(
        runId,
        run.periodKey,
        preserve: {for (final l in existing) l.employeeId: l},
      );
    });
  }

  /// Recomputes one draft line's money from its stored counts with
  /// current rules, adjustments and unconsumed advances.
  Future<void> _recomputeDraftLine(PayrollLine line) async {
    final run = await getRun(line.runId);
    final settings = await getSettings();
    final employee = await (_db.select(_db.employees)
          ..where((t) => t.id.equals(line.employeeId)))
        .getSingleOrNull();
    if (run == null || employee == null) return;
    final adjustments = (await adjustmentsFor(line.runId))
        .where((a) => a.lineId == line.id)
        .toList();
    final bonus = adjustments
        .where((a) => a.isBonus)
        .fold(0, (s, a) => s + a.amountPaise);
    final deductions = adjustments
        .where((a) => !a.isBonus)
        .fold(0, (s, a) => s + a.amountPaise);
    final advances =
        await _candidateAdvances(line.employeeId, run.periodKey);
    final computation = _computeFor(
      employee: _employeeFromRow(employee),
      counts: line.counts,
      basisDays: line.basisDays,
      rules: settings.rules,
      advancesPaise: _signedTotal(advances),
      overtimeUnitsBp: line.overtimeUnitsBp,
      bonusPaise: bonus,
      deductionsPaise: deductions,
    );
    await (_db.update(_db.payrollLines)..where((t) => t.id.equals(line.id)))
        .write(
      PayrollLinesCompanion(
        payableUnitsBp: Value(computation.payableUnitsBp),
        earningsPaise: Value(computation.earningsPaise),
        overtimePaise: Value(computation.overtimePaise),
        bonusPaise: Value(bonus),
        deductionsPaise: Value(deductions),
        advancesPaise: Value(_signedTotal(advances)),
        grossPaise: Value(computation.grossPaise),
        netPaise: Value(computation.netPaise),
        carryForwardPaise: Value(computation.carryForwardPaise),
      ),
    );
  }

  Future<PayrollLine> _lineFor(String runId, String employeeId) async {
    final row = await (_db.select(_db.payrollLines)
          ..where((t) => t.runId.equals(runId) & t.employeeId.equals(employeeId)))
        .getSingleOrNull();
    if (row == null) throw StateError('Payroll line not found.');
    return _lineFromRow(row);
  }

  Future<void> _requireDraft(String runId) async {
    final run = await getRun(runId);
    if (run == null) throw StateError('Payroll run not found.');
    if (run.status != PayrollRunStatus.draft) {
      throw StateError('Payroll is no longer a draft.');
    }
  }

  @override
  Future<void> setOvertime(String runId, String employeeId, int unitsBp) async {
    if (unitsBp < 0) throw ArgumentError('Overtime must not be negative.');
    await _requireDraft(runId);
    final line = await _lineFor(runId, employeeId);
    await (_db.update(_db.payrollLines)..where((t) => t.id.equals(line.id)))
        .write(PayrollLinesCompanion(overtimeUnitsBp: Value(unitsBp)));
    await _recomputeDraftLine(
      PayrollLine(
        id: line.id,
        runId: line.runId,
        employeeId: line.employeeId,
        employeeName: line.employeeName,
        salaryType: line.salaryType,
        ratePaise: line.ratePaise,
        counts: line.counts,
        payableUnitsBp: line.payableUnitsBp,
        basisDays: line.basisDays,
        earningsPaise: line.earningsPaise,
        overtimeUnitsBp: unitsBp,
        overtimePaise: line.overtimePaise,
        bonusPaise: line.bonusPaise,
        deductionsPaise: line.deductionsPaise,
        advancesPaise: line.advancesPaise,
        grossPaise: line.grossPaise,
        netPaise: line.netPaise,
        carryForwardPaise: line.carryForwardPaise,
        paidPaise: line.paidPaise,
      ),
    );
  }

  @override
  Future<PayrollAdjustment> addAdjustment(PayrollAdjustment adjustment) async {
    if (adjustment.amountPaise <= 0) {
      throw ArgumentError('Adjustment amount must be positive.');
    }
    await _requireDraft(adjustment.runId);
    final existing = await (_db.select(_db.payrollAdjustments)
          ..where((t) => t.id.equals(adjustment.id)))
        .getSingleOrNull();
    if (existing != null) {
      return PayrollAdjustment(
        id: existing.id,
        runId: existing.runId,
        lineId: existing.lineId,
        isBonus: existing.kind == 'bonus',
        amountPaise: existing.amountPaise,
        label: existing.label,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt,
      );
    }
    await _db.into(_db.payrollAdjustments).insert(
          PayrollAdjustmentsCompanion.insert(
            id: adjustment.id,
            runId: adjustment.runId,
            lineId: adjustment.lineId,
            kind: adjustment.isBonus ? 'bonus' : 'deduction',
            amountPaise: adjustment.amountPaise,
            label: adjustment.label,
            createdBy: adjustment.createdBy,
            createdAt: adjustment.createdAt,
          ),
        );
    final lineRow = await (_db.select(_db.payrollLines)
          ..where((t) => t.id.equals(adjustment.lineId)))
        .getSingle();
    await _recomputeDraftLine(_lineFromRow(lineRow));
    return adjustment;
  }

  @override
  Future<void> removeAdjustment(String adjustmentId) async {
    final row = await (_db.select(_db.payrollAdjustments)
          ..where((t) => t.id.equals(adjustmentId)))
        .getSingleOrNull();
    if (row == null) return;
    await _requireDraft(row.runId);
    await (_db.delete(_db.payrollAdjustments)
          ..where((t) => t.id.equals(adjustmentId)))
        .go();
    final lines = await linesFor(row.runId);
    final line = lines.where((l) => l.id == row.lineId).firstOrNull;
    if (line != null) await _recomputeDraftLine(line);
  }

  // -------------------------------------------------------------- approval

  @override
  Future<PayrollRun> approve(
    String runId,
    String actor, {
    bool acknowledgeIncomplete = false,
  }) async {
    return _db.transaction(() async {
      final run = await getRun(runId);
      if (run == null) throw StateError('Payroll run not found.');
      if (run.status != PayrollRunStatus.draft) {
        throw StateError('Payroll has already been approved or voided.');
      }
      final settings = await getSettings();
      if (!settings.isReviewed) {
        throw StateError(
          'Payroll rules must be reviewed by the owner before the '
          'first payroll can be approved.',
        );
      }
      final siblings = await listRuns(periodKey: run.periodKey);
      final activeSibling = siblings.where(
        (r) =>
            r.id != runId &&
            r.status != PayrollRunStatus.draft &&
            r.status != PayrollRunStatus.voided,
      );
      if (activeSibling.isNotEmpty) {
        throw StateError(
          'Another payroll for ${run.periodKey} is already approved. '
          'Revise it instead of approving a second one.',
        );
      }
      // Freeze fresh figures: attendance may have changed since the
      // draft was created.
      final existing = await linesFor(runId);
      await _rebuildLines(
        runId,
        run.periodKey,
        preserve: {for (final l in existing) l.employeeId: l},
      );
      final lines = await linesFor(runId);
      final incomplete =
          lines.where((l) => l.counts.unmarked > 0).toList();
      if (incomplete.isNotEmpty && !acknowledgeIncomplete) {
        throw StateError(
          'Attendance is incomplete for '
          '${incomplete.map((l) => l.employeeName).join(', ')} '
          '(unmarked days). Mark attendance or explicitly acknowledge '
          'before approving.',
        );
      }
      // Consume advances: link each candidate to its line. The link
      // table's primary key makes a second consumption impossible —
      // a conflict aborts this transaction.
      final now = DateTime.now();
      for (final line in lines) {
        final advances =
            await _candidateAdvances(line.employeeId, run.periodKey);
        for (final advance in advances) {
          await _db.into(_db.payrollAdvanceLinks).insert(
                PayrollAdvanceLinksCompanion.insert(
                  advanceId: advance.id,
                  runId: runId,
                  lineId: line.id,
                  linkedAt: now,
                ),
              );
        }
      }
      final totalNet = lines.fold(0, (s, l) => s + l.netPaise);
      await (_db.update(_db.payrollRuns)..where((t) => t.id.equals(runId)))
          .write(
        PayrollRunsCompanion(
          status: Value(totalNet == 0 ? 'paid' : 'approved'),
          rulesJson: Value(jsonEncode(settings.rules.toJson())),
          approvedBy: Value(actor),
          approvedAt: Value(now),
        ),
      );
      await _audit(
        runId,
        'approved',
        actor,
        'Net ${totalNet}p across ${lines.length} employees'
        '${incomplete.isNotEmpty ? '; incomplete attendance acknowledged' : ''}',
      );
      return (await getRun(runId))!;
    });
  }

  // -------------------------------------------------------------- payments

  Future<void> _refreshRunStatus(String runId) async {
    final run = await getRun(runId);
    if (run == null ||
        run.status == PayrollRunStatus.draft ||
        run.status == PayrollRunStatus.voided) {
      return;
    }
    final lines = await linesFor(runId);
    final totalNet = lines.fold(0, (s, l) => s + l.netPaise);
    final totalPaid = lines.fold(0, (s, l) => s + l.paidPaise);
    final status = totalNet == 0 || totalPaid >= totalNet
        ? 'paid'
        : totalPaid > 0
            ? 'partially_paid'
            : 'approved';
    await (_db.update(_db.payrollRuns)..where((t) => t.id.equals(runId)))
        .write(PayrollRunsCompanion(status: Value(status)));
  }

  @override
  Future<PayrollPayment> recordPayment(PayrollPayment payment) async {
    if (payment.amountPaise <= 0) {
      throw ArgumentError('Payment amount must be positive.');
    }
    return _db.transaction(() async {
      final existing = await (_db.select(_db.payrollPayments)
            ..where((t) => t.id.equals(payment.id)))
          .getSingleOrNull();
      if (existing != null) {
        return PayrollPayment(
          id: existing.id,
          runId: existing.runId,
          lineId: existing.lineId,
          employeeId: existing.employeeId,
          amountPaise: existing.amountPaise,
          paidAt: existing.paidAt,
          method: existing.method,
          recordedBy: existing.recordedBy,
          notes: existing.notes,
        );
      }
      final run = await getRun(payment.runId);
      if (run == null ||
          run.status == PayrollRunStatus.draft ||
          run.status == PayrollRunStatus.voided) {
        throw StateError('Payments require an approved payroll.');
      }
      final line = await _lineFor(payment.runId, payment.employeeId);
      if (payment.amountPaise > line.remainingPaise) {
        throw ArgumentError(
          'Payment exceeds the remaining payable amount for '
          '${line.employeeName}.',
        );
      }
      await _db.into(_db.payrollPayments).insert(
            PayrollPaymentsCompanion.insert(
              id: payment.id,
              runId: payment.runId,
              lineId: line.id,
              employeeId: payment.employeeId,
              amountPaise: payment.amountPaise,
              paidAt: payment.paidAt,
              method: payment.method,
              notes: Value(payment.notes),
              recordedBy: payment.recordedBy,
            ),
          );
      await (_db.update(_db.payrollLines)..where((t) => t.id.equals(line.id)))
          .write(
        PayrollLinesCompanion(
          paidPaise: Value(line.paidPaise + payment.amountPaise),
        ),
      );
      await _refreshRunStatus(payment.runId);
      await _audit(
        payment.runId,
        'payment',
        payment.recordedBy,
        '${payment.amountPaise}p to ${line.employeeName} '
            'via ${payment.method}',
      );
      return payment;
    });
  }

  // -------------------------------------------------------------- void/revise

  @override
  Future<void> voidRun(String runId, String actor, String reason) async {
    if (reason.trim().isEmpty) {
      throw ArgumentError('A reason is required to void payroll.');
    }
    await _db.transaction(() async {
      final run = await getRun(runId);
      if (run == null) throw StateError('Payroll run not found.');
      if (run.status == PayrollRunStatus.partiallyPaid ||
          run.status == PayrollRunStatus.paid) {
        throw StateError(
          'A payroll with recorded payments cannot be voided.',
        );
      }
      if (run.status == PayrollRunStatus.voided) {
        throw StateError('Payroll is already voided.');
      }
      // Release consumed advances back to the unconsumed pool.
      await (_db.delete(_db.payrollAdvanceLinks)
            ..where((t) => t.runId.equals(runId)))
          .go();
      await (_db.update(_db.payrollRuns)..where((t) => t.id.equals(runId)))
          .write(
        PayrollRunsCompanion(
          status: const Value('voided'),
          voidReason: Value(reason.trim()),
        ),
      );
      await _audit(runId, 'voided', actor, reason.trim());
    });
  }

  @override
  Future<PayrollRun> revise(String runId, String actor) async {
    final run = await getRun(runId);
    if (run == null) throw StateError('Payroll run not found.');
    if (run.status != PayrollRunStatus.approved) {
      throw StateError(
        'Only an approved payroll with no payments can be revised.',
      );
    }
    await voidRun(runId, actor, 'Revised — superseded by a new draft');
    return getOrCreateDraft(run.periodKey, actor);
  }
}
