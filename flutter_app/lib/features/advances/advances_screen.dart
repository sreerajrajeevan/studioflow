import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/price_parse.dart';
import '../../core/studio_time.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../shared/sample_badge.dart';

/// Salary advances (Task 4): money given to an employee before payday.
///
/// The ledger is immutable and completely separate from customer
/// billing payments. Mistakes are fixed with an audited reversal entry
/// — entries are never edited or deleted. Saving is single-flight and
/// idempotent on the entry id, so a double tap cannot record an
/// advance twice. Owner-only screen (salary-sensitive).
class AdvancesScreen extends ConsumerStatefulWidget {
  const AdvancesScreen({super.key});

  @override
  ConsumerState<AdvancesScreen> createState() => _AdvancesScreenState();
}

class _AdvancesScreenState extends ConsumerState<AdvancesScreen> {
  String? _employeeId;
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  AdvanceMethod _method = AdvanceMethod.cash;
  String _dateKey = StudioTime.todayKey();
  String _entryId = _newEntryId();
  bool _saving = false;
  String? _error;
  int _reloadTick = 0;

  static String _newEntryId() =>
      'adv_${newDraftId().substring('draft-'.length)}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeesAdminProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  String get _actor => 'Owner';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final employees =
        ref.watch(employeesAdminProvider).where((e) => e.isActive).toList();
    final employeeId = _employeeId ??
        (employees.isNotEmpty ? employees.first.id : null);
    final (py, pm, _) = StudioTime.parseKey(_dateKey);
    final monthFrom = '$py-${pm.toString().padLeft(2, '0')}-01';
    final monthTo = StudioTime.dateKeysOfMonth(py, pm).last;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const ScreenHeader(
          title: 'Salary advances',
          subtitle: 'Money given before payday. Entries are never '
              'deleted — mistakes are reversed, with the reversal kept '
              'in the ledger.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                key: const ValueKey('advance_employee'),
                initialValue: employeeId,
                decoration: const InputDecoration(labelText: 'Employee'),
                items: [
                  for (final e in employees)
                    DropdownMenuItem(value: e.id, child: Text(e.name)),
                ],
                onChanged: (value) => setState(() => _employeeId = value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const ValueKey('advance_amount'),
                      controller: _amount,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Amount (₹)',
                        errorText: _error,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final (y, m, d) = StudioTime.parseKey(_dateKey);
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(y, m, d),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _dateKey = StudioTime.dateKeyOf(
                              DateTime.utc(
                                  picked.year, picked.month, picked.day, 12),
                            );
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(_dateKey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<AdvanceMethod>(
                segments: const [
                  ButtonSegment(
                      value: AdvanceMethod.cash, label: Text('Cash')),
                  ButtonSegment(value: AdvanceMethod.upi, label: Text('UPI')),
                  ButtonSegment(
                      value: AdvanceMethod.other, label: Text('Other')),
                ],
                selected: {_method},
                onSelectionChanged: (s) => setState(() => _method = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                key: const ValueKey('save_advance_button'),
                onPressed:
                    _saving || employeeId == null ? null : () => _save(employeeId),
                child: Text(_saving ? 'Saving…' : 'Save advance'),
              ),
            ],
          ),
        ),
        const Divider(height: 32),
        if (employeeId != null)
          FutureBuilder(
            key: ValueKey('$employeeId-$_dateKey-$_reloadTick'),
            future: Future.wait([
              ref.read(advanceRepositoryProvider).listForEmployee(employeeId),
              ref.read(advanceRepositoryProvider).totalForPeriod(
                    employeeId,
                    fromKey: monthFrom,
                    toKey: monthTo,
                  ),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final entries = snapshot.data![0] as List<SalaryAdvance>;
              final monthTotal = snapshot.data![1] as int;
              final reversedIds = {
                for (final e in entries)
                  if (e.reversalOfId != null) e.reversalOfId!,
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Total advances in ${_dateKey.substring(0, 7)}: '
                      '${inr(monthTotal)}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (entries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No advances recorded yet.'),
                    ),
                  for (final entry in entries)
                    ListTile(
                      title: Text(
                        '${entry.isReversal ? 'Reversal · ' : ''}'
                        '${inr(entry.amountPaise)} · '
                        '${entry.method.name.toUpperCase()}',
                      ),
                      subtitle: Text(
                        '${entry.businessDateKey} · by ${entry.recordedBy}'
                        '${entry.notes != null && entry.notes!.isNotEmpty ? ' · ${entry.notes}' : ''}'
                        '${reversedIds.contains(entry.id) ? ' · REVERSED' : ''}',
                      ),
                      trailing: !entry.isReversal &&
                              !reversedIds.contains(entry.id)
                          ? TextButton(
                              onPressed: () => _reverse(entry),
                              child: const Text('Reverse'),
                            )
                          : null,
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Future<void> _save(String employeeId) async {
    final paise = parseInrToPaise(_amount.text);
    if (paise == null || paise <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(advanceRepositoryProvider).record(
            SalaryAdvance(
              id: _entryId,
              employeeId: employeeId,
              amountPaise: paise,
              businessDateKey: _dateKey,
              recordedAt: DateTime.now(),
              method: _method,
              notes: _notes.text.trim().isEmpty
                  ? null
                  : _notes.text.trim(),
              recordedBy: _actor,
            ),
          );
      if (!mounted) return;
      setState(() {
        _entryId = _newEntryId(); // next entry gets a fresh id
        _amount.clear();
        _notes.clear();
        _reloadTick++;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not save. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _reverse(SalaryAdvance entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reverse this advance?'),
        content: Text(
          'A reversal entry of ${inr(entry.amountPaise)} will be added. '
          'The original stays in the ledger — nothing is deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reverse advance'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(advanceRepositoryProvider)
        .reverse(entry.id, actor: _actor);
    setState(() => _reloadTick++);
  }
}
