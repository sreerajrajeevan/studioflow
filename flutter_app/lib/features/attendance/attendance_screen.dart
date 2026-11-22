import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/state.dart';
import '../../core/studio_time.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../shared/sample_badge.dart';

/// Attendance (Task 4): tap-to-mark daily attendance plus a monthly
/// calendar with corrections.
///
/// Rules kept by the data layer (not just this screen): one record per
/// employee per studio-local (Asia/Kolkata) date; corrections are
/// audited; nobody is ever auto-marked absent — "Not marked" is simply
/// the absence of a record.
class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

enum _Mode { today, month }

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  _Mode _mode = _Mode.today;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(attendanceProvider.notifier).load();
      ref.read(employeesAdminProvider.notifier).refresh();
    });
  }

  String get _actor =>
      ref.read(roleProvider) == AppRole.owner ? 'Owner' : 'Staff';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ScreenHeader(
          title: 'Attendance',
          subtitle:
              'Studio-local dates (Asia/Kolkata). Tap a status to mark — '
              'it saves immediately. Unmarked staff are never auto-marked '
              'absent.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: SegmentedButton<_Mode>(
            segments: const [
              ButtonSegment(value: _Mode.today, label: Text('Daily marking')),
              ButtonSegment(value: _Mode.month, label: Text('Month calendar')),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
        ),
        Expanded(
          child: _mode == _Mode.today
              ? _DailyMarking(actor: _actor)
              : _MonthCalendar(actor: _actor),
        ),
      ],
    );
  }
}

String _prettyKey(String dateKey) {
  final (y, m, d) = StudioTime.parseKey(dateKey);
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '$d ${months[m - 1]} $y';
}

class _DailyMarking extends ConsumerWidget {
  const _DailyMarking({required this.actor});

  final String actor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attendance = ref.watch(attendanceProvider);
    final employees =
        ref.watch(employeesAdminProvider).where((e) => e.isActive).toList();
    final (y, m, d) = StudioTime.parseKey(attendance.dateKey);
    final isToday = attendance.dateKey == StudioTime.todayKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous day',
                onPressed: () {
                  final prev = DateTime.utc(y, m, d)
                      .subtract(const Duration(days: 1));
                  ref.read(attendanceProvider.notifier).setDate(
                        StudioTime.dateKeyOf(prev),
                      );
                },
              ),
              Expanded(
                child: Text(
                  '${_prettyKey(attendance.dateKey)}'
                  '${isToday ? ' · Today' : ''}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next day',
                onPressed: () {
                  final next =
                      DateTime.utc(y, m, d).add(const Duration(days: 1));
                  ref.read(attendanceProvider.notifier).setDate(
                        StudioTime.dateKeyOf(next),
                      );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: !attendance.loaded
              ? const Center(child: CircularProgressIndicator())
              : employees.isEmpty
                  ? const Center(child: Text('No active employees.'))
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        final record = attendance.records[employee.id];
                        return _AttendanceRow(
                          employee: employee,
                          record: record,
                          onMark: (status) => ref
                              .read(attendanceProvider.notifier)
                              .mark(employee.id, status, actor: actor),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({
    required this.employee,
    required this.record,
    required this.onMark,
  });

  final Employee employee;
  final AttendanceRecord? record;
  final void Function(AttendanceStatus status) onMark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = record?.status;
    return Card(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    employee.name.isEmpty
                        ? '?'
                        : employee.name[0].toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    employee.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  status == null
                      ? 'Not marked'
                      : 'Saved · by ${record!.markedBy}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: status == null
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final (value, label) in [
                  (AttendanceStatus.present, 'Present'),
                  (AttendanceStatus.absent, 'Absent'),
                  (AttendanceStatus.halfDay, 'Half Day'),
                  (AttendanceStatus.leave, 'Leave'),
                ])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        height: 48,
                        child: status == value
                            ? FilledButton(
                                onPressed: () => onMark(value),
                                child: Text(label),
                              )
                            : OutlinedButton(
                                onPressed: () => onMark(value),
                                child: Text(label),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthCalendar extends ConsumerStatefulWidget {
  const _MonthCalendar({required this.actor});

  final String actor;

  @override
  ConsumerState<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends ConsumerState<_MonthCalendar> {
  late int _year;
  late int _month;
  String? _employeeId;
  int _reloadTick = 0;

  @override
  void initState() {
    super.initState();
    final (y, m, _) = StudioTime.parseKey(StudioTime.todayKey());
    _year = y;
    _month = m;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(attendanceRepositoryProvider);
    final employees =
        ref.watch(employeesAdminProvider).where((e) => e.isActive).toList();
    final employeeId = _employeeId ??
        (employees.isNotEmpty ? employees.first.id : null);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(() {
                _month--;
                if (_month < 1) {
                  _month = 12;
                  _year--;
                }
              }),
            ),
            Expanded(
              child: Text(
                '${_prettyKey('$_year-${_month.toString().padLeft(2, '0')}-01').substring(2)}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(() {
                _month++;
                if (_month > 12) {
                  _month = 1;
                  _year++;
                }
              }),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final employee in employees)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(employee.name),
                    selected: employeeId == employee.id,
                    onSelected: (_) =>
                        setState(() => _employeeId = employee.id),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (employeeId == null)
          const Text('No active employees.')
        else
          FutureBuilder(
            key: ValueKey('$_year-$_month-$employeeId-$_reloadTick'),
            future: Future.wait([
              repo.recordsForMonth(_year, _month, employeeId: employeeId),
              repo.monthlySummary(employeeId, _year, _month),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final records = snapshot.data![0] as List<AttendanceRecord>;
              final summary = snapshot.data![1] as MonthlyAttendanceSummary;
              final byDay = {
                for (final r in records)
                  StudioTime.parseKey(r.dateKey).$3: r.status,
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(
                          label: 'Present', value: summary.present),
                      _SummaryChip(label: 'Absent', value: summary.absent),
                      _SummaryChip(
                          label: 'Half days', value: summary.halfDays),
                      _SummaryChip(label: 'Leave', value: summary.leave),
                      _SummaryChip(
                          label: 'Unmarked', value: summary.unmarked),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: StudioTime.daysInMonth(_year, _month),
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final status = byDay[day];
                      return _DayCell(
                        day: day,
                        status: status,
                        onTap: () => _correct(employeeId, day, status),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap a day to mark or correct it — corrections are '
                    'kept in the attendance audit trail.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Future<void> _correct(
    String employeeId,
    int day,
    AttendanceStatus? current,
  ) async {
    final dateKey =
        '$_year-${_month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    final status = await showModalBottomSheet<AttendanceStatus>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('Mark ${_prettyKey(dateKey)}')),
            for (final (value, label) in [
              (AttendanceStatus.present, 'Present'),
              (AttendanceStatus.absent, 'Absent'),
              (AttendanceStatus.halfDay, 'Half Day'),
              (AttendanceStatus.leave, 'Leave'),
            ])
              ListTile(
                leading: Icon(
                  current == value
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(label),
                onTap: () => Navigator.of(sheetContext).pop(value),
              ),
          ],
        ),
      ),
    );
    if (status == null) return;
    await ref.read(attendanceRepositoryProvider).mark(
          employeeId: employeeId,
          dateKey: dateKey,
          status: status,
          actor: widget.actor,
        );
    // If the corrected day is the daily view's date, keep it in sync.
    ref.read(attendanceProvider.notifier).load();
    setState(() => _reloadTick++);
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.status, required this.onTap});

  final int day;
  final AttendanceStatus? status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, String letter) = switch (status) {
      AttendanceStatus.present => (scheme.primaryContainer, 'P'),
      AttendanceStatus.absent => (scheme.errorContainer, 'A'),
      AttendanceStatus.halfDay => (scheme.tertiaryContainer, 'H'),
      AttendanceStatus.leave => (scheme.secondaryContainer, 'L'),
      null => (scheme.surfaceContainerHighest, '·'),
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(letter, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
