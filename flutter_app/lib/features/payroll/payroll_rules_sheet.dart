import 'package:flutter/material.dart';

import '../../core/payroll_engine.dart';

/// Editor for the studio's payroll rules. Returns a record of
/// (rules, markReviewed) when saved, or null when dismissed.
///
/// The shipped defaults are EXAMPLES — until the owner reviews and
/// confirms them here, payroll approval stays blocked.
class PayrollRulesSheet extends StatefulWidget {
  const PayrollRulesSheet({
    super.key,
    required this.initial,
    required this.isReviewed,
  });

  final PayrollRules initial;
  final bool isReviewed;

  @override
  State<PayrollRulesSheet> createState() => _PayrollRulesSheetState();
}

class _PayrollRulesSheetState extends State<PayrollRulesSheet> {
  late PayrollRules _rules;
  late final TextEditingController _holidays;
  bool _reviewed = false;

  static const _weekdays = [
    (0, 'No weekly off'),
    (1, 'Monday'),
    (2, 'Tuesday'),
    (3, 'Wednesday'),
    (4, 'Thursday'),
    (5, 'Friday'),
    (6, 'Saturday'),
    (7, 'Sunday'),
  ];

  @override
  void initState() {
    super.initState();
    _rules = widget.initial;
    _holidays = TextEditingController(
      text: (_rules.holidayDateKeys.toList()..sort()).join(', '),
    );
  }

  @override
  void dispose() {
    _holidays.dispose();
    super.dispose();
  }

  PayrollRules _collect() {
    final holidays = _holidays.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s))
        .toSet();
    return _rules.copyWith(holidayDateKeys: holidays);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Payroll rules', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                widget.isReviewed
                    ? 'These rules apply to new drafts. Approved payrolls '
                        'keep the rules they were approved with.'
                    : 'These start as example defaults. Review each rule '
                        'for your studio — payroll approval unlocks once '
                        'you confirm them below.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text('Monthly salary basis', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<SalaryBasis>(
                segments: const [
                  ButtonSegment(
                    value: SalaryBasis.calendarDays,
                    label: Text('Calendar days'),
                  ),
                  ButtonSegment(
                    value: SalaryBasis.fixed30,
                    label: Text('Fixed 30'),
                  ),
                  ButtonSegment(
                    value: SalaryBasis.workingDays,
                    label: Text('Working days'),
                  ),
                ],
                selected: {_rules.basis},
                onSelectionChanged: (s) =>
                    setState(() => _rules = _rules.copyWith(basis: s.first)),
              ),
              const SizedBox(height: 16),
              Text('Half-day pay', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('0%')),
                  ButtonSegment(value: 2500, label: Text('25%')),
                  ButtonSegment(value: 5000, label: Text('50%')),
                  ButtonSegment(value: 7500, label: Text('75%')),
                  ButtonSegment(value: 10000, label: Text('100%')),
                ],
                selected: {_rules.halfDayMultiplierBp},
                onSelectionChanged: (s) => setState(() =>
                    _rules = _rules.copyWith(halfDayMultiplierBp: s.first)),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Leave days are paid'),
                value: _rules.leaveIsPaid,
                onChanged: (v) =>
                    setState(() => _rules = _rules.copyWith(leaveIsPaid: v)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Absent days are paid'),
                value: _rules.absentIsPaid,
                onChanged: (v) =>
                    setState(() => _rules = _rules.copyWith(absentIsPaid: v)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Unmarked days are paid'),
                subtitle: const Text(
                  'Unmarked means attendance was never recorded — '
                  'most studios leave this off.',
                ),
                value: _rules.unmarkedIsPaid,
                onChanged: (v) => setState(
                    () => _rules = _rules.copyWith(unmarkedIsPaid: v)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text('Weekly off',
                        style: theme.textTheme.labelLarge),
                  ),
                  DropdownButton<int>(
                    value: _rules.weeklyOffWeekday,
                    items: [
                      for (final (value, label) in _weekdays)
                        DropdownMenuItem(value: value, child: Text(label)),
                    ],
                    onChanged: (v) => setState(
                        () => _rules = _rules.copyWith(weeklyOffWeekday: v)),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Weekly off is paid'),
                value: _rules.weeklyOffIsPaid,
                onChanged: (v) => setState(
                    () => _rules = _rules.copyWith(weeklyOffIsPaid: v)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Studio holidays are paid'),
                value: _rules.holidayIsPaid,
                onChanged: (v) => setState(
                    () => _rules = _rules.copyWith(holidayIsPaid: v)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _holidays,
                decoration: const InputDecoration(
                  labelText: 'Studio holidays (yyyy-MM-dd, comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Overtime pay', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 10000, label: Text('1.0×')),
                  ButtonSegment(value: 15000, label: Text('1.5×')),
                  ButtonSegment(value: 20000, label: Text('2.0×')),
                ],
                selected: {_rules.overtimeMultiplierBp},
                onSelectionChanged: (s) => setState(() =>
                    _rules = _rules.copyWith(overtimeMultiplierBp: s.first)),
              ),
              if (!widget.isReviewed) ...[
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'I have reviewed these rules for my studio',
                  ),
                  value: _reviewed,
                  onChanged: (v) => setState(() => _reviewed = v ?? false),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (!widget.isReviewed && !_reviewed)
                      ? null
                      : () => Navigator.of(context).pop(
                            (_collect(), !widget.isReviewed && _reviewed),
                          ),
                  child: const Text('Save rules'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
