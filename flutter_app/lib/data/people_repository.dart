import 'package:drift/drift.dart';

import '../core/studio_time.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import 'database.dart';

String _statusName(AttendanceStatus status) => switch (status) {
      AttendanceStatus.present => 'present',
      AttendanceStatus.absent => 'absent',
      AttendanceStatus.halfDay => 'half_day',
      AttendanceStatus.leave => 'leave',
    };

AttendanceStatus _statusFrom(String raw) => switch (raw) {
      'absent' => AttendanceStatus.absent,
      'half_day' => AttendanceStatus.halfDay,
      'leave' => AttendanceStatus.leave,
      _ => AttendanceStatus.present,
    };

/// Drift-backed attendance (Task 4). One record per employee per
/// studio-local date; corrections update the record and append an
/// audit entry in the same transaction.
class DriftAttendanceRepository implements AttendanceRepository {
  DriftAttendanceRepository(this._db);

  final AppDatabase _db;

  AttendanceRecord _toRecord(AttendanceRow row) => AttendanceRecord(
        employeeId: row.employeeId,
        dateKey: row.dateKey,
        status: _statusFrom(row.status),
        markedBy: row.markedBy,
        markedAt: row.markedAt,
        updatedAt: row.updatedAt,
      );

  @override
  Future<Map<String, AttendanceRecord>> recordsForDate(
    String dateKey,
  ) async {
    final rows = await (_db.select(_db.attendanceRecords)
          ..where((t) => t.dateKey.equals(dateKey)))
        .get();
    return {for (final row in rows) row.employeeId: _toRecord(row)};
  }

  @override
  Future<List<AttendanceRecord>> recordsForMonth(
    int year,
    int month, {
    String? employeeId,
  }) async {
    final prefix =
        '$year-${month.toString().padLeft(2, '0')}';
    final rows = await (_db.select(_db.attendanceRecords)
          ..where((t) => t.dateKey.like('$prefix%'))
          ..orderBy([(t) => OrderingTerm.asc(t.dateKey)]))
        .get();
    return [
      for (final row in rows)
        if (employeeId == null || row.employeeId == employeeId)
          _toRecord(row),
    ];
  }

  @override
  Future<AttendanceRecord> mark({
    required String employeeId,
    required String dateKey,
    required AttendanceStatus status,
    required String actor,
  }) async {
    // Date keys are studio-local calendar dates.
    final (y, m, d) = StudioTime.parseKey(dateKey);
    if (m < 1 || m > 12 || d < 1 || d > StudioTime.daysInMonth(y, m)) {
      throw ArgumentError('Invalid attendance date: $dateKey');
    }
    return _db.transaction(() async {
      final now = DateTime.now();
      final existing = await (_db.select(_db.attendanceRecords)
            ..where(
              (t) => t.employeeId.equals(employeeId) & t.dateKey.equals(dateKey),
            ))
          .getSingleOrNull();
      if (existing == null) {
        await _db.into(_db.attendanceRecords).insert(
              AttendanceRecordsCompanion(
                employeeId: Value(employeeId),
                dateKey: Value(dateKey),
                status: Value(_statusName(status)),
                markedBy: Value(actor),
                markedAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      } else {
        await (_db.update(_db.attendanceRecords)
              ..where((t) => t.id.equals(existing.id)))
            .write(
          AttendanceRecordsCompanion(
            status: Value(_statusName(status)),
            markedBy: Value(actor),
            updatedAt: Value(now),
          ),
        );
      }
      await _db.into(_db.attendanceAuditEvents).insert(
            AttendanceAuditEventsCompanion(
              employeeId: Value(employeeId),
              dateKey: Value(dateKey),
              oldStatus: Value(existing?.status),
              newStatus: Value(_statusName(status)),
              actor: Value(actor),
              createdAt: Value(now),
            ),
          );
      final row = await (_db.select(_db.attendanceRecords)
            ..where(
              (t) => t.employeeId.equals(employeeId) & t.dateKey.equals(dateKey),
            ))
          .getSingle();
      return _toRecord(row);
    });
  }

  @override
  Future<MonthlyAttendanceSummary> monthlySummary(
    String employeeId,
    int year,
    int month,
  ) async {
    final records = await recordsForMonth(year, month, employeeId: employeeId);
    var present = 0, absent = 0, half = 0, leave = 0;
    final markedDays = <int>{};
    for (final record in records) {
      markedDays.add(StudioTime.parseKey(record.dateKey).$3);
      switch (record.status) {
        case AttendanceStatus.present:
          present++;
        case AttendanceStatus.absent:
          absent++;
        case AttendanceStatus.halfDay:
          half++;
        case AttendanceStatus.leave:
          leave++;
      }
    }
    // Unmarked = elapsed days with no record. Elapsed means: whole
    // month for past months, up to today (studio-local) for the
    // current month, none for future months.
    final today = StudioTime.todayKey();
    final (ty, tm, td) = StudioTime.parseKey(today);
    var elapsed = 0;
    if (year < ty || (year == ty && month < tm)) {
      elapsed = StudioTime.daysInMonth(year, month);
    } else if (year == ty && month == tm) {
      elapsed = td;
    }
    final unmarked = elapsed - markedDays.where((d) => d <= elapsed).length;
    return MonthlyAttendanceSummary(
      employeeId: employeeId,
      year: year,
      month: month,
      present: present,
      absent: absent,
      halfDays: half,
      leave: leave,
      unmarked: unmarked < 0 ? 0 : unmarked,
    );
  }

  @override
  Future<List<AttendanceAuditEntry>> auditFor(
    String employeeId,
    String dateKey,
  ) async {
    final rows = await (_db.select(_db.attendanceAuditEvents)
          ..where(
            (t) => t.employeeId.equals(employeeId) & t.dateKey.equals(dateKey),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return [
      for (final row in rows)
        AttendanceAuditEntry(
          employeeId: row.employeeId,
          dateKey: row.dateKey,
          oldStatus: row.oldStatus == null ? null : _statusFrom(row.oldStatus!),
          newStatus: _statusFrom(row.newStatus),
          actor: row.actor,
          createdAt: row.createdAt,
        ),
    ];
  }
}

String _advanceMethodName(AdvanceMethod method) => method.name;

AdvanceMethod _advanceMethodFrom(String raw) => switch (raw) {
      'upi' => AdvanceMethod.upi,
      'other' => AdvanceMethod.other,
      _ => AdvanceMethod.cash,
    };

/// Drift-backed salary advance ledger (Task 4). Immutable entries;
/// corrections are reversal entries. See the interface docs.
class DriftAdvanceRepository implements AdvanceRepository {
  DriftAdvanceRepository(this._db);

  final AppDatabase _db;

  SalaryAdvance _toAdvance(AdvanceRow row) => SalaryAdvance(
        id: row.id,
        employeeId: row.employeeId,
        amountPaise: row.amountPaise,
        businessDateKey: row.businessDateKey,
        recordedAt: row.recordedAt,
        method: _advanceMethodFrom(row.method),
        notes: row.notes,
        recordedBy: row.recordedBy,
        reversalOfId: row.reversalOfId,
      );

  @override
  Future<SalaryAdvance> record(SalaryAdvance advance) async {
    if (advance.amountPaise <= 0) {
      throw ArgumentError('Advance amount must be positive.');
    }
    if (advance.isReversal) {
      throw ArgumentError('Use reverse() to create a reversal.');
    }
    final existing = await (_db.select(_db.salaryAdvances)
          ..where((t) => t.id.equals(advance.id)))
        .getSingleOrNull();
    if (existing != null) return _toAdvance(existing);
    await _db.into(_db.salaryAdvances).insert(
          SalaryAdvancesCompanion(
            id: Value(advance.id),
            employeeId: Value(advance.employeeId),
            amountPaise: Value(advance.amountPaise),
            businessDateKey: Value(advance.businessDateKey),
            recordedAt: Value(advance.recordedAt),
            method: Value(_advanceMethodName(advance.method)),
            notes: Value(advance.notes),
            recordedBy: Value(advance.recordedBy),
          ),
        );
    final row = await (_db.select(_db.salaryAdvances)
          ..where((t) => t.id.equals(advance.id)))
        .getSingle();
    return _toAdvance(row);
  }

  @override
  Future<SalaryAdvance> reverse(
    String advanceId, {
    required String actor,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final original = await (_db.select(_db.salaryAdvances)
            ..where((t) => t.id.equals(advanceId)))
          .getSingleOrNull();
      if (original == null) throw StateError('Advance not found.');
      if (original.reversalOfId != null) {
        throw StateError('A reversal cannot be reversed.');
      }
      final existingReversal = await (_db.select(_db.salaryAdvances)
            ..where((t) => t.reversalOfId.equals(advanceId)))
          .getSingleOrNull();
      if (existingReversal != null) {
        throw StateError('This advance is already reversed.');
      }
      final now = DateTime.now();
      final reversalId = 'adv_rev_$advanceId';
      await _db.into(_db.salaryAdvances).insert(
            SalaryAdvancesCompanion(
              id: Value(reversalId),
              employeeId: Value(original.employeeId),
              amountPaise: Value(original.amountPaise),
              businessDateKey: Value(StudioTime.todayKey(now)),
              recordedAt: Value(now),
              method: Value(original.method),
              notes: Value(notes ?? 'Reversal of advance $advanceId'),
              recordedBy: Value(actor),
              reversalOfId: Value(advanceId),
            ),
          );
      final row = await (_db.select(_db.salaryAdvances)
            ..where((t) => t.id.equals(reversalId)))
          .getSingle();
      return _toAdvance(row);
    });
  }

  @override
  Future<List<SalaryAdvance>> listForEmployee(
    String employeeId, {
    String? fromKey,
    String? toKey,
  }) async {
    final query = _db.select(_db.salaryAdvances)
      ..where((t) => t.employeeId.equals(employeeId))
      ..orderBy([
        (t) => OrderingTerm.desc(t.businessDateKey),
        (t) => OrderingTerm.desc(t.recordedAt),
      ]);
    if (fromKey != null) {
      query.where((t) => t.businessDateKey.isBiggerOrEqualValue(fromKey));
    }
    if (toKey != null) {
      query.where((t) => t.businessDateKey.isSmallerOrEqualValue(toKey));
    }
    final rows = await query.get();
    return [for (final row in rows) _toAdvance(row)];
  }

  @override
  Future<int> totalForPeriod(
    String employeeId, {
    required String fromKey,
    required String toKey,
  }) async {
    final entries = await listForEmployee(
      employeeId,
      fromKey: fromKey,
      toKey: toKey,
    );
    var total = 0;
    for (final entry in entries) {
      total += entry.signedPaise;
    }
    return total;
  }
}
