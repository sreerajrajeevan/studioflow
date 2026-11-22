import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/state.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/price_parse.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../shared/sample_badge.dart';

/// Employees (Task 4): real Drift-backed team records. The owner adds,
/// edits and deactivates employees; staff see a read-only list of
/// names/roles (salary details are owner-only). Employees are NEVER
/// deleted — deactivation preserves their attendance, advances and
/// invoice history.
class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeesAdminProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final employees = ref.watch(employeesAdminProvider);
    final isOwner = ref.watch(roleProvider) == AppRole.owner;
    final active = employees.where((e) => e.isActive).toList();
    final inactive = employees.where((e) => !e.isActive).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ScreenHeader(
          title: 'Employees',
          subtitle: isOwner
              ? 'Your studio team — stored on this device.'
              : 'Your studio team. Staff view: names and roles only '
                  '(role preview — not secure authentication).',
        ),
        if (isOwner)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                key: const ValueKey('add_employee_button'),
                onPressed: () => _openEditor(context),
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Add employee'),
              ),
            ),
          ),
        if (employees.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('No employees yet.'),
          ),
        for (final employee in active)
          _EmployeeTile(employee: employee, isOwner: isOwner, onEdit: _openEditor),
        if (inactive.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text('Inactive', style: theme.textTheme.titleSmall),
          ),
          for (final employee in inactive)
            _EmployeeTile(
              employee: employee,
              isOwner: isOwner,
              onEdit: _openEditor,
            ),
        ],
      ],
    );
  }

  Future<void> _openEditor(BuildContext context, [Employee? existing]) async {
    final saved = await showDialog<Employee>(
      context: context,
      builder: (_) => _EmployeeEditor(existing: existing),
    );
    if (saved == null) return;
    await ref.read(employeesAdminProvider.notifier).save(saved);
    // Billing's staff picker reads the same repository — refresh it.
    ref.invalidate(staffListProvider);
  }
}

class _EmployeeTile extends ConsumerWidget {
  const _EmployeeTile({
    required this.employee,
    required this.isOwner,
    required this.onEdit,
  });

  final Employee employee;
  final bool isOwner;
  final void Function(BuildContext, [Employee?]) onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            employee.name.isEmpty ? '?' : employee.name[0].toUpperCase(),
          ),
        ),
        title: Text(employee.name),
        subtitle: Text(
          [
            if (employee.role.isNotEmpty) employee.role,
            if (employee.phone.isNotEmpty) employee.phone,
            if (isOwner)
              employee.salaryType == SalaryType.monthly
                  ? '${inr(employee.monthlySalaryPaise)}/month'
                  : '${inr(employee.monthlySalaryPaise)}/day',
            if (!employee.isActive) 'Inactive',
          ].join(' · '),
        ),
        trailing: isOwner
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit',
                    onPressed: () => onEdit(context, employee),
                  ),
                  Switch(
                    value: employee.isActive,
                    onChanged: (value) async {
                      await ref
                          .read(employeesAdminProvider.notifier)
                          .setActive(employee.id, value);
                      ref.invalidate(staffListProvider);
                    },
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class _EmployeeEditor extends StatefulWidget {
  const _EmployeeEditor({this.existing});

  final Employee? existing;

  @override
  State<_EmployeeEditor> createState() => _EmployeeEditorState();
}

class _EmployeeEditorState extends State<_EmployeeEditor> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _role =
      TextEditingController(text: widget.existing?.role ?? '');
  late final TextEditingController _phone =
      TextEditingController(text: widget.existing?.phone ?? '');
  late final TextEditingController _salary = TextEditingController(
    text: widget.existing == null
        ? ''
        : formatPaiseForInput(widget.existing!.monthlySalaryPaise),
  );
  late SalaryType _salaryType =
      widget.existing?.salaryType ?? SalaryType.monthly;
  late DateTime? _joining = widget.existing?.joiningDate;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    _phone.dispose();
    _salary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add employee' : 'Edit employee'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  errorText: _error,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _role,
                decoration: const InputDecoration(
                  labelText: 'Job role (e.g. Barber, Receptionist)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone (optional)',
                ),
              ),
              const SizedBox(height: 14),
              SegmentedButton<SalaryType>(
                segments: const [
                  ButtonSegment(
                    value: SalaryType.monthly,
                    label: Text('Monthly salary'),
                  ),
                  ButtonSegment(
                    value: SalaryType.daily,
                    label: Text('Daily wage'),
                  ),
                ],
                selected: {_salaryType},
                onSelectionChanged: (s) =>
                    setState(() => _salaryType = s.first),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _salary,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _salaryType == SalaryType.monthly
                      ? 'Base salary per month (₹)'
                      : 'Wage per day (₹)',
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Joining date'),
                subtitle: Text(
                  _joining == null
                      ? 'Not set'
                      : '${_joining!.day}/${_joining!.month}/${_joining!.year}',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _joining ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _joining = picked);
                  },
                  child: const Text('Pick'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save employee'),
        ),
      ],
    );
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Name is required.');
      return;
    }
    final salary = parseInrToPaise(_salary.text);
    if (salary == null) {
      setState(() => _error = 'Enter a valid salary amount.');
      return;
    }
    Navigator.of(context).pop(
      Employee(
        id: widget.existing?.id ??
            'emp_${newDraftId().substring('draft-'.length)}',
        name: name,
        role: _role.text.trim(),
        phone: _phone.text.trim(),
        salaryType: _salaryType,
        monthlySalaryPaise: salary,
        isActive: widget.existing?.isActive ?? true,
        joiningDate: _joining,
        photoPath: widget.existing?.photoPath,
        createdAt: widget.existing?.createdAt,
      ),
    );
  }
}
