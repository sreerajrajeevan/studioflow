import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/state.dart';
import '../../branding/brand_logo.dart';
import '../../core/breakpoints.dart';
import '../../core/format.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import 'cart.dart';
import 'drafts_sheet.dart';

/// Screen 1 of the billing flow (Task 5.1): "Who's billing?"
///
/// Lists ACTIVE employees from the repository as large selection cards.
/// Selecting one stores the employee ID in the billing session (the
/// cart) and advances immediately to Customer Details. Inactive
/// employees are never listed, so one can never be silently selected.
///
/// When an unfinished bill exists (crash recovery or a paused draft), a
/// resume card offers a straight path back into it with its employee
/// and customer intact.
class EmployeeSelectScreen extends ConsumerWidget {
  const EmployeeSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final employees = ref.watch(staffListProvider);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final layout = context.layoutClass;
    final hasResumable = !cart.isEmpty || cart.hasSession;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(
          children: [
            BrandLogo(branding: branding, size: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branding.businessName,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (branding.tagline != null)
                    Text(
                      branding.tagline!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              key: const ValueKey('drafts_button'),
              tooltip: 'Saved drafts',
              onPressed: () => showDraftsSheet(context),
              icon: const Icon(Icons.drafts_outlined),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text("Who's billing?", style: theme.textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Select the employee handling this bill.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (hasResumable) ...[
          const SizedBox(height: 20),
          _ResumeCard(cart: cart),
        ],
        const SizedBox(height: 22),
        employees.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text(
            'Could not load employees. $e',
            style: theme.textTheme.bodyMedium,
          ),
          data: (list) {
            if (list.isEmpty) return const _NoEmployees();
            final columns = switch (layout) {
              LayoutClass.expanded => 3,
              LayoutClass.medium => 2,
              LayoutClass.compact => 2,
            };
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: layout == LayoutClass.compact ? 0.84 : 1.35,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) => _EmployeeCard(
                employee: list[i],
                selected: cart.billingEmployeeId == list[i].id,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ResumeCard extends ConsumerWidget {
  const _ResumeCard({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final who = cart.customerName.isNotEmpty
        ? cart.customerName
        : (cart.billingEmployeeName ?? 'Bill in progress');
    return Card(
      key: const ValueKey('resume_card'),
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.receipt_long_outlined, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill in progress — $who',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    cart.isEmpty
                        ? 'No services added yet'
                        : '${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'} · ${inr(cart.totalPaise)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              key: const ValueKey('resume_button'),
              onPressed: () => context.go('/billing/services'),
              child: const Text('Resume'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeCard extends ConsumerWidget {
  const _EmployeeCard({required this.employee, required this.selected});

  final Employee employee;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        key: ValueKey('employee_card_${employee.id}'),
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          ref
              .read(cartProvider.notifier)
              .setBillingEmployee(employee.id, employee.name);
          context.go('/billing/customer');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outline,
              width: selected ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Avatar(employee: employee, size: 58),
              const SizedBox(height: 10),
              Text(
                employee.name,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (employee.role.isNotEmpty)
                Text(
                  employee.role,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (selected) ...[
                const SizedBox(height: 6),
                Icon(Icons.check_circle, color: scheme.primary, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Employee avatar: the stored photo when one exists on disk, otherwise
/// initials on the accent-tinted disc. Never a stock image.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.employee, required this.size});

  final Employee employee;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = employee.photoPath;
    if (path != null && path.isNotEmpty && File(path).existsSync()) {
      return ClipOval(
        child: Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _initials(context),
        ),
      );
    }
    return _initials(context);
  }

  Widget _initials(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final parts = employee.name.trim().split(RegExp(r'\s+'));
    final initials = parts
        .take(2)
        .map((p) => p.isEmpty ? '' : p[0].toUpperCase())
        .join();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _NoEmployees extends StatelessWidget {
  const _NoEmployees();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(
              Icons.groups_outlined,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'No active employees yet',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Add an employee first — every bill needs someone billing it.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const ValueKey('add_employees_button'),
              onPressed: () => context.go('/employees'),
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Go to Employees'),
            ),
          ],
        ),
      ),
    );
  }
}
