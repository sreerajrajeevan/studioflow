import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/state.dart';
import '../../core/format.dart';
import '../../core/money.dart' show newDraftId;
import '../../core/payroll_engine.dart';
import '../../core/price_parse.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../shared/sample_badge.dart';
import 'payroll_rules_sheet.dart';
import 'payroll_statement.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String _periodLabel(String periodKey) {
  final parts = periodKey.split('-');
  final month = int.parse(parts[1]);
  return '${_monthNames[month - 1]} ${parts[0]}';
}

String _shiftPeriod(String periodKey, int deltaMonths) {
  final parts = periodKey.split('-');
  var year = int.parse(parts[0]);
  var month = int.parse(parts[1]) + deltaMonths;
  while (month < 1) {
    month += 12;
    year--;
  }
  while (month > 12) {
    month -= 12;
    year++;
  }
  return '$year-${month.toString().padLeft(2, '0')}';
}

String _statusLabel(PayrollRunStatus status) => switch (status) {
      PayrollRunStatus.draft => 'Draft — not approved',
      PayrollRunStatus.approved => 'Approved',
      PayrollRunStatus.partiallyPaid => 'Partially paid',
      PayrollRunStatus.paid => 'Paid',
      PayrollRunStatus.voided => 'Voided',
    };

/// Monthly payroll (Task 5): preview from attendance + advances,
/// owner review and approval with frozen snapshots, then salary
/// payments tracked until the balance settles. Owner-only data —
/// staff never see salaries.
class SalaryScreen extends ConsumerWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final state = ref.watch(payrollProvider);
    final notifier = ref.read(payrollProvider.notifier);
    final branding = ref.watch(brandingProvider);

    if (role != AppRole.owner) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeader(
              title: 'Salary',
              subtitle: 'Payroll is private to the studio owner.',
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Salary details are visible only to the owner. '
                  'Switch to the Owner role (preview) to view payroll.',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ScreenHeader(
          title: 'Salary',
          subtitle: 'Monthly payroll from attendance, advances and '
              'your studio rules.',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () =>
                  notifier.setPeriod(_shiftPeriod(state.periodKey, -1)),
            ),
            Text(
              _periodLabel(state.periodKey),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  notifier.setPeriod(_shiftPeriod(state.periodKey, 1)),
            ),
          ],
        ),
        if (state.error != null)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(state.error!),
            ),
          ),
        if (state.settings != null && !state.settings!.isReviewed)
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.fact_check_outlined),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'The payroll rules are still the example defaults. '
                      'Review them for your studio — approval is disabled '
                      'until you do.',
                    ),
                  ),
                  FilledButton(
                    onPressed: () => _openRules(context, ref, state),
                    child: const Text('Review rules'),
                  ),
                ],
              ),
            ),
          )
        else if (state.settings != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _openRules(context, ref, state),
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Payroll rules'),
            ),
          ),
        if (state.loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.run == null)
          _PreviewSection(state: state)
        else
          _RunSection(state: state, studioName: branding.businessName),
      ],
    );
  }

  Future<void> _openRules(
    BuildContext context,
    WidgetRef ref,
    PayrollState state,
  ) async {
    final settings = state.settings;
    if (settings == null) return;
    final result = await showModalBottomSheet<(PayrollRules, bool)>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PayrollRulesSheet(
        initial: settings.rules,
        isReviewed: settings.isReviewed,
      ),
    );
    if (result != null) {
      await ref
          .read(payrollProvider.notifier)
          .saveSettings(result.$1, result.$2);
    }
  }
}

class _PreviewSection extends ConsumerWidget {
  const _PreviewSection({required this.state});

  final PayrollState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = state.preview ?? const [];
    final gross = preview.fold(0, (s, l) => s + l.computation.grossPaise);
    final net = preview.fold(0, (s, l) => s + l.computation.netPaise);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview — not a payroll yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Calculated live from attendance and advances. '
                  'Nothing is final until you create a draft and the '
                  'owner approves it.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Gross: ${inr(gross)}')),
                    Expanded(child: Text('Net payable: ${inr(net)}')),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: state.busy
                      ? null
                      : () =>
                          ref.read(payrollProvider.notifier).createDraft(),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Create draft payroll'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final line in preview)
          Card(
            child: ListTile(
              title: Text(line.employee.name),
              subtitle: Text(
                '${line.employee.salaryType == SalaryType.daily ? 'Daily' : 'Monthly'} '
                '· ${inr(line.employee.monthlySalaryPaise)}'
                ' · P ${line.counts.present} · H ${line.counts.halfDays}'
                ' · L ${line.counts.leave} · A ${line.counts.absent}'
                ' · Unmarked ${line.counts.unmarked}'
                '${line.advancesPaise != 0 ? ' · Advances ${inr(line.advancesPaise)}' : ''}'
                '${line.incompleteAttendance ? '\n⚠ Attendance incomplete' : ''}'
                '${line.missingRate ? '\n⚠ No salary set for this employee' : ''}',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    inr(line.computation.netPaise),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'net',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RunSection extends ConsumerWidget {
  const _RunSection({required this.state, required this.studioName});

  final PayrollState state;
  final String studioName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = state.run!;
    final notifier = ref.read(payrollProvider.notifier);
    final isDraft = run.status == PayrollRunStatus.draft;
    final isApproved = run.status == PayrollRunStatus.approved;
    final canShare = !isDraft && run.status != PayrollRunStatus.voided;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(label: Text(_statusLabel(run.status))),
                    const SizedBox(width: 8),
                    Text('Version ${run.version}'),
                    if (run.approvedBy != null) ...[
                      const SizedBox(width: 8),
                      Text('Approved by ${run.approvedBy}'),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                _summaryRow(context, 'Total gross', inr(state.totalGross)),
                _summaryRow(
                    context, 'Advances deducted', inr(state.totalAdvances)),
                _summaryRow(
                    context, 'Other deductions', inr(state.totalDeductions)),
                _summaryRow(context, 'Net payable', inr(state.totalNet)),
                _summaryRow(context, 'Paid so far', inr(state.totalPaid)),
                _summaryRow(context, 'Outstanding', inr(state.outstanding)),
                if (state.totalCarryForward > 0)
                  _summaryRow(
                    context,
                    'Carried forward (over-deducted)',
                    inr(state.totalCarryForward),
                  ),
                if (state.hasIncomplete && isDraft)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '⚠ Some attendance is unmarked. Approval will ask '
                      'you to acknowledge this.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (isDraft) ...[
                      OutlinedButton.icon(
                        onPressed: state.busy ? null : notifier.refresh,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Refresh figures'),
                      ),
                      FilledButton.icon(
                        onPressed: state.busy ||
                                !(state.settings?.isReviewed ?? false)
                            ? null
                            : () => _approve(context, ref),
                        icon: const Icon(Icons.check_circle_outline,
                            size: 18),
                        label: const Text('Approve payroll'),
                      ),
                    ],
                    if (isApproved)
                      OutlinedButton.icon(
                        onPressed: state.busy ? null : notifier.revise,
                        icon: const Icon(Icons.edit_note, size: 18),
                        label: const Text('Revise'),
                      ),
                    if (isDraft || isApproved)
                      TextButton.icon(
                        onPressed: state.busy
                            ? null
                            : () => _void(context, ref),
                        icon: const Icon(Icons.block, size: 18),
                        label: const Text('Void'),
                      ),
                    if (canShare) ...[
                      OutlinedButton.icon(
                        onPressed: () => _shareText(context),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share statement'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _sharePdf(context),
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text('PDF'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final line in state.lines)
          Card(
            child: ListTile(
              title: Text(line.employeeName),
              subtitle: Text(
                '${line.salaryType == SalaryType.daily ? 'Daily' : 'Monthly'} '
                '· ${inr(line.ratePaise)}'
                ' · P ${line.counts.present} · H ${line.counts.halfDays}'
                ' · L ${line.counts.leave} · A ${line.counts.absent}'
                ' · Unmarked ${line.counts.unmarked}'
                '${line.counts.unmarked > 0 ? ' ⚠' : ''}',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    inr(line.netPaise),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    line.remainingPaise > 0
                        ? 'due ${inr(line.remainingPaise)}'
                        : 'settled',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              onTap: () => _openLine(context, line),
            ),
          ),
      ],
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    var acknowledged = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Approve payroll?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Net payable ${inr(state.totalNet)} for '
                '${_periodLabel(state.periodKey)}. Approval freezes '
                'these figures and deducts the period advances exactly '
                'once.',
              ),
              if (state.hasIncomplete)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Attendance is incomplete (unmarked days). I have '
                    'reviewed and approve anyway.',
                  ),
                  value: acknowledged,
                  onChanged: (v) =>
                      setState(() => acknowledged = v ?? false),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: (state.hasIncomplete && !acknowledged)
                  ? null
                  : () => Navigator.of(dialogContext).pop(true),
              child: const Text('Approve'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      await ref.read(payrollProvider.notifier).approve(acknowledged);
    }
  }

  Future<void> _void(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Void this payroll?'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Reason (required)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Void payroll'),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(payrollProvider.notifier)
          .voidRun(controller.text.trim());
    }
    controller.dispose();
  }

  PayrollStatement _statement() => PayrollStatement(
        studioName: studioName,
        run: state.run!,
        lines: state.lines,
      );

  Future<void> _shareText(BuildContext context) async {
    await SharePlus.instance.share(
      ShareParams(text: _statement().formatText()),
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    final bytes = await _statement().buildPdf();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/salary_${state.periodKey}.pdf');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Salary statement ${state.periodKey}',
      ),
    );
  }

  void _openLine(BuildContext context, PayrollLine line) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _LineDetailSheet(lineId: line.id),
    );
  }
}

/// Detail + actions for one payroll line: breakdown, overtime and
/// adjustments while draft, payments once approved.
class _LineDetailSheet extends ConsumerStatefulWidget {
  const _LineDetailSheet({required this.lineId});

  final String lineId;

  @override
  ConsumerState<_LineDetailSheet> createState() => _LineDetailSheetState();
}

class _LineDetailSheetState extends ConsumerState<_LineDetailSheet> {
  final _adjustmentLabel = TextEditingController();
  final _adjustmentAmount = TextEditingController();
  final _paymentAmount = TextEditingController();
  final _paymentNotes = TextEditingController();
  bool _adjustmentIsBonus = true;
  String _paymentMethod = 'cash';
  late final String _paymentId = 'pay_${newDraftId()}';
  bool _paymentPrefilled = false;

  @override
  void dispose() {
    _adjustmentLabel.dispose();
    _adjustmentAmount.dispose();
    _paymentAmount.dispose();
    _paymentNotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(payrollProvider);
    final line =
        state.lines.where((l) => l.id == widget.lineId).firstOrNull;
    if (line == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('This line is no longer available.'),
      );
    }
    final run = state.run!;
    final isDraft = run.status == PayrollRunStatus.draft;
    final canPay = run.status == PayrollRunStatus.approved ||
        run.status == PayrollRunStatus.partiallyPaid;
    final adjustments =
        state.adjustments.where((a) => a.lineId == line.id).toList();
    final payments =
        state.payments.where((p) => p.lineId == line.id).toList();
    if (canPay && !_paymentPrefilled) {
      _paymentPrefilled = true;
      _paymentAmount.text = formatPaiseForInput(line.remainingPaise);
    }
    final notifier = ref.read(payrollProvider.notifier);
    final counts = line.counts;

    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [Expanded(child: Text(label)), Text(value)],
          ),
        );

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
              Text(
                line.employeeName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${line.salaryType == SalaryType.daily ? 'Daily wage' : 'Monthly salary'} '
                '· ${inr(line.ratePaise)}',
              ),
              const SizedBox(height: 12),
              row('Present', '${counts.present}'),
              row('Half days', '${counts.halfDays}'),
              row('Leave', '${counts.leave}'),
              row('Absent', '${counts.absent}'),
              row('Unmarked', '${counts.unmarked}'),
              row('Weekly off', '${counts.weeklyOff}'),
              row('Holidays', '${counts.holidays}'),
              row(
                'Payable days',
                (line.payableUnitsBp / 10000).toStringAsFixed(
                  line.payableUnitsBp % 10000 == 0 ? 0 : 2,
                ),
              ),
              if (line.salaryType == SalaryType.monthly)
                row('Basis days', '${line.basisDays}'),
              const Divider(),
              row('Earnings', inr(line.earningsPaise)),
              if (line.overtimePaise > 0 || isDraft)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Overtime (${(line.overtimeUnitsBp / 10000).toStringAsFixed(2)} days)',
                      ),
                    ),
                    if (isDraft) ...[
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: line.overtimeUnitsBp <= 0 || state.busy
                            ? null
                            : () => notifier.setOvertime(
                                  line.employeeId,
                                  line.overtimeUnitsBp - 5000 < 0
                                      ? 0
                                      : line.overtimeUnitsBp - 5000,
                                ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: state.busy
                            ? null
                            : () => notifier.setOvertime(
                                  line.employeeId,
                                  line.overtimeUnitsBp + 5000,
                                ),
                      ),
                    ],
                    Text(inr(line.overtimePaise)),
                  ],
                ),
              row('Bonuses / incentives', inr(line.bonusPaise)),
              row('Advances deducted', inr(line.advancesPaise)),
              row('Other deductions', inr(line.deductionsPaise)),
              row('Gross', inr(line.grossPaise)),
              row('Net payable', inr(line.netPaise)),
              if (line.carryForwardPaise > 0)
                row('Carried forward', inr(line.carryForwardPaise)),
              row('Paid', inr(line.paidPaise)),
              row('Remaining', inr(line.remainingPaise)),
              if (isDraft) ...[
                const Divider(),
                Text(
                  'Adjustments',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                for (final adjustment in adjustments)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${adjustment.isBonus ? '+' : '−'} '
                      '${inr(adjustment.amountPaise)} · ${adjustment.label}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: state.busy
                          ? null
                          : () => notifier.removeAdjustment(adjustment.id),
                    ),
                  ),
                Row(
                  children: [
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('Bonus')),
                        ButtonSegment(
                            value: false, label: Text('Deduction')),
                      ],
                      selected: {_adjustmentIsBonus},
                      onSelectionChanged: (s) =>
                          setState(() => _adjustmentIsBonus = s.first),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _adjustmentLabel,
                        decoration: const InputDecoration(
                          labelText: 'Label',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: _adjustmentAmount,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: '₹',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: state.busy
                          ? null
                          : () {
                              final paise =
                                  parseInrToPaise(_adjustmentAmount.text);
                              if (paise == null ||
                                  paise <= 0 ||
                                  _adjustmentLabel.text.trim().isEmpty) {
                                return;
                              }
                              notifier.addAdjustment(
                                line: line,
                                isBonus: _adjustmentIsBonus,
                                amountPaise: paise,
                                label: _adjustmentLabel.text.trim(),
                              );
                              _adjustmentLabel.clear();
                              _adjustmentAmount.clear();
                            },
                    ),
                  ],
                ),
              ],
              if (canPay && line.remainingPaise > 0) ...[
                const Divider(),
                Text(
                  'Record salary payment',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'cash', label: Text('Cash')),
                    ButtonSegment(value: 'upi', label: Text('UPI')),
                    ButtonSegment(value: 'bank', label: Text('Bank')),
                    ButtonSegment(value: 'other', label: Text('Other')),
                  ],
                  selected: {_paymentMethod},
                  onSelectionChanged: (s) =>
                      setState(() => _paymentMethod = s.first),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: TextField(
                        controller: _paymentAmount,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Amount ₹',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _paymentNotes,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: state.busy
                      ? null
                      : () {
                          final paise =
                              parseInrToPaise(_paymentAmount.text);
                          if (paise == null || paise <= 0) return;
                          notifier.recordPayment(
                            line: line,
                            amountPaise: paise,
                            method: _paymentMethod,
                            notes: _paymentNotes.text.trim().isEmpty
                                ? null
                                : _paymentNotes.text.trim(),
                            paymentId: _paymentId,
                          );
                        },
                  child: const Text('Record payment'),
                ),
              ],
              if (payments.isNotEmpty) ...[
                const Divider(),
                Text(
                  'Payments',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                for (final payment in payments)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${inr(payment.amountPaise)} · ${payment.method}'
                      '${payment.notes != null ? ' · ${payment.notes}' : ''}',
                    ),
                    subtitle: Text('Recorded by ${payment.recordedBy}'),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
