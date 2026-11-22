import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/state.dart';
import '../../core/format.dart';
import '../../core/motion.dart';
import '../../core/price_parse.dart';
import 'cart.dart';
import '../../data/providers.dart';

/// The current-bill panel: lines with steppers, running total, clear and a
/// large checkout action. Shared by the tablet right pane and (in a sheet)
/// the mobile layout, so behaviour is identical everywhere.
class BillPanel extends ConsumerWidget {
  const BillPanel({super.key, this.showHeader = true});

  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Current bill', style: theme.textTheme.titleLarge),
                ),
                if (!cart.isEmpty)
                  TextButton.icon(
                    onPressed: () => _confirmClear(context, ref),
                    icon: const Icon(Icons.delete_outline, size: 19),
                    label: const Text('Clear'),
                  ),
              ],
            ),
          ),
        Expanded(
          child: cart.isEmpty
              ? _EmptyBill(theme: theme)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  itemCount: cart.lines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final line = cart.lines[index];
                    return _BillLineRow(
                      key: ValueKey('line_${line.serviceId}_${line.pricePaise}'),
                      line: line,
                      onIncrement: () => ref
                          .read(cartProvider.notifier)
                          .incrementLine(line.serviceId, line.pricePaise),
                      onDecrement: () => ref
                          .read(cartProvider.notifier)
                          .decrementLine(line.serviceId, line.pricePaise),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outline)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!cart.isEmpty &&
                  (cart.discountPaise > 0 || cart.taxPaise > 0)) ...[
                _TotalRow(label: 'Subtotal', value: inr(cart.subtotalPaise)),
                if (cart.discountPaise > 0)
                  _TotalRow(
                    label: cart.discountPercent > 0
                        ? 'Discount (${cart.discountPercent}%)'
                        : 'Discount',
                    value: '-${inr(cart.discountPaise)}',
                  ),
                if (cart.taxPaise > 0)
                  _TotalRow(
                    label:
                        'Tax (${(cart.taxBasisPoints / 100).toStringAsFixed(cart.taxBasisPoints % 100 == 0 ? 0 : 2)}%)',
                    value: inr(cart.taxPaise),
                  ),
                const SizedBox(height: 6),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cart.isEmpty
                          ? 'No items yet'
                          : '${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    inr(cart.totalPaise),
                    key: const ValueKey('bill_total'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (!cart.isEmpty) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    key: const ValueKey('discount_tax_button'),
                    onPressed: () => _openDiscountTax(context, ref, cart),
                    icon: const Icon(Icons.percent_outlined, size: 18),
                    label: Text(
                      cart.discountPaise > 0 || cart.taxPaise > 0
                          ? 'Discount / tax applied'
                          : 'Add discount / tax',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton(
                key: const ValueKey('checkout_button'),
                onPressed: cart.isEmpty
                    ? null
                    : () => context.push('/checkout'),
                child: const Text('Checkout'),
              ),
              const SizedBox(height: 6),
              Text(
                'Checkout finalizes an invoice on this device.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const _DraftSaveStatusLine(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear this bill?'),
        content: const Text(
          'All selected services will be removed from the current bill.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep bill'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear bill'),
          ),
        ],
      ),
    );
    if (confirmed == true) ref.read(cartProvider.notifier).clear();
  }
}

class _EmptyBill extends StatelessWidget {
  const _EmptyBill({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 44,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap a service to start the bill',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Selected services appear here with quantities and the running total.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _BillLineRow extends ConsumerWidget {
  const _BillLineRow({
    super.key,
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartLine line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final staff = ref.watch(staffListProvider).valueOrNull ?? const [];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.serviceName, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${inr(line.pricePaise)} each',
                  style: theme.textTheme.bodySmall,
                ),
                PopupMenuButton<String?>(
                  key: ValueKey(
                    'assign_${line.serviceId}_${line.pricePaise}',
                  ),
                  tooltip: 'Assign employee',
                  onSelected: (employeeId) {
                    if (employeeId == null) {
                      ref.read(cartProvider.notifier).setLineEmployee(
                            line.serviceId,
                            line.pricePaise,
                          );
                    } else {
                      final employee =
                          staff.firstWhere((e) => e.id == employeeId);
                      ref.read(cartProvider.notifier).setLineEmployee(
                            line.serviceId,
                            line.pricePaise,
                            employeeId: employee.id,
                            employeeName: employee.name,
                          );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String?>(
                      value: null,
                      child: Text('No employee'),
                    ),
                    for (final employee in staff)
                      PopupMenuItem<String?>(
                        value: employee.id,
                        child: Text(employee.name),
                      ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 15,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            line.employeeName ?? 'Assign staff',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Icons.remove,
            tooltip: 'One less',
            onPressed: onDecrement,
          ),
          SizedBox(
            width: 34,
            child: Text(
              '${line.quantity}',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            tooltip: 'One more',
            onPressed: onIncrement,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: Text(
              inr(line.totalPaise),
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 20,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      style: IconButton.styleFrom(
        backgroundColor: scheme.surfaceContainerLow,
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon),
    );
  }
}

/// Compact summary bar for phone/portrait layouts: total + item count,
/// tapping expands the full panel; Checkout stays one tap away.
class BillSummaryBar extends ConsumerWidget {
  const BillSummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: scheme.outline)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: cart.isEmpty ? null : () => _showPanel(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cart.isEmpty
                              ? 'No items yet'
                              : '${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'} — view bill',
                          style: theme.textTheme.bodySmall,
                        ),
                        AnimatedSwitcher(
                          duration:
                              Motion.durationOf(context, Motion.fast),
                          child: Text(
                            inr(cart.totalPaise),
                            key: ValueKey(cart.totalPaise),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                key: const ValueKey('checkout_button'),
                onPressed:
                    cart.isEmpty ? null : () => context.push('/checkout'),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPanel(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.72,
        child: BillPanel(showHeader: true),
      ),
    );
  }
}

/// Honest persistence state for the current draft. "Saved" is shown ONLY
/// after the database write completes; a failure is tappable to retry.
class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

Future<void> _openDiscountTax(
  BuildContext context,
  WidgetRef ref,
  CartState cart,
) async {
  final isOwner = ref.read(roleProvider) == AppRole.owner;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final current = ref.watch(cartProvider);
          final flatController = TextEditingController(
            text: current.flatDiscountPaise == 0
                ? ''
                : formatPaiseForInput(current.flatDiscountPaise),
          );
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Discount & tax',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!isOwner)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Discounts need the owner (role preview — not secure '
                      'authentication).',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 12),
                Text('Discount %',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final pct in [0, 5, 10, 15, 20, 25])
                      ChoiceChip(
                        label: Text('$pct%'),
                        selected: current.discountPercent == pct,
                        onSelected: isOwner
                            ? (_) {
                                ref
                                    .read(cartProvider.notifier)
                                    .setDiscountPercent(pct);
                                setSheetState(() {});
                              }
                            : null,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: flatController,
                  enabled: isOwner,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Flat discount (₹)',
                    hintText: 'Optional',
                  ),
                  onSubmitted: (value) {
                    final paise = parseInrToPaise(value) ?? 0;
                    ref
                        .read(cartProvider.notifier)
                        .setFlatDiscountPaise(paise);
                    setSheetState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Text('Tax (GST) %',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final pct in [0, 5, 12, 18, 28])
                      ChoiceChip(
                        label: Text('$pct%'),
                        selected: current.taxBasisPoints == pct * 100,
                        onSelected: isOwner
                            ? (_) {
                                ref
                                    .read(cartProvider.notifier)
                                    .setTaxBasisPoints(pct * 100);
                                setSheetState(() {});
                              }
                            : null,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final paise =
                        parseInrToPaise(flatController.text) ?? 0;
                    if (isOwner) {
                      ref
                          .read(cartProvider.notifier)
                          .setFlatDiscountPaise(paise);
                    }
                    Navigator.of(sheetContext).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _DraftSaveStatusLine extends ConsumerWidget {
  const _DraftSaveStatusLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) return const SizedBox.shrink();
    final status = ref.watch(draftSaveStatusProvider);
    final theme = Theme.of(context);
    final (icon, text, color) = switch (status.kind) {
      DraftSaveKind.saving => (
          Icons.sync,
          'Saving draft…',
          theme.colorScheme.onSurfaceVariant,
        ),
      DraftSaveKind.saved => (
          Icons.check_circle_outline,
          'Draft saved on this device',
          theme.colorScheme.primary,
        ),
      DraftSaveKind.error => (
          Icons.error_outline,
          'Draft not saved — tap to retry',
          theme.colorScheme.error,
        ),
      DraftSaveKind.idle => (
          Icons.schedule,
          'Draft not saved yet',
          theme.colorScheme.onSurfaceVariant,
        ),
    };
    return InkWell(
      onTap: status.kind == DraftSaveKind.error
          ? () => ref.read(draftAutosaverProvider).retry()
          : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
