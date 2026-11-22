import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../billing/invoice_detail_screen.dart';
import '../billing/invoice_document.dart';

/// Billing history (Task 3): every finalized invoice on this device,
/// searchable by provisional reference or customer, filterable by date
/// range and payment status. Invoices are never deleted — voided ones
/// stay listed, marked VOIDED.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(billingHistoryProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = ref.watch(billingHistoryProvider);
    final notifier = ref.read(billingHistoryProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Billing history', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'Finalized invoices stored on this device. References '
                'are local and provisional.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('history_search'),
                decoration: const InputDecoration(
                  hintText: 'Search by reference or customer',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                ),
                onChanged: (q) => notifier.setFilters(query: q),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All time'),
                      selected: history.range == HistoryRange.all,
                      onSelected: (_) =>
                          notifier.setFilters(range: HistoryRange.all),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Today'),
                      selected: history.range == HistoryRange.today,
                      onSelected: (_) =>
                          notifier.setFilters(range: HistoryRange.today),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Last 7 days'),
                      selected: history.range == HistoryRange.week,
                      onSelected: (_) =>
                          notifier.setFilters(range: HistoryRange.week),
                    ),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: const Text('Payment pending'),
                      selected:
                          history.paymentStatus == PaymentStatus.pending,
                      onSelected: (selected) => selected
                          ? notifier.setFilters(
                              paymentStatus: PaymentStatus.pending)
                          : notifier.setFilters(clearPaymentStatus: true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Voided'),
                      selected:
                          history.status == FinalizedBillStatus.voided,
                      onSelected: (selected) => selected
                          ? notifier.setFilters(
                              status: FinalizedBillStatus.voided)
                          : notifier.setFilters(clearStatus: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: !history.loaded
              ? const Center(child: CircularProgressIndicator())
              : history.bills.isEmpty
                  ? const Center(
                      child: Text(
                        'No invoices match. Finalized bills will appear '
                        'here.',
                      ),
                    )
                  : ListView.separated(
                      key: const ValueKey('history_list'),
                      itemCount: history.bills.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final bill = history.bills[index];
                        return _BillRow(bill: bill);
                      },
                    ),
        ),
      ],
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({required this.bill});

  final FinalizedBill bill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final voided = bill.status == FinalizedBillStatus.voided;
    final statusLabel = voided
        ? 'VOIDED'
        : switch (bill.paymentStatus) {
            PaymentStatus.pending => 'Payment pending',
            PaymentStatus.confirmedManual => 'Paid (manual)',
            PaymentStatus.verifiedProvider => 'Paid (verified)',
          };
    return ListTile(
      key: ValueKey('history_bill_${bill.id}'),
      title: Text(
        '${bill.provisionalRef}'
        '${bill.customerName.isEmpty ? '' : ' · ${bill.customerName}'}',
        style: voided
            ? TextStyle(
                color: theme.colorScheme.error,
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      subtitle: Text(
        '${formatInvoiceDateTime(bill.finalizedAt)} · '
        '${bill.lines.length} item${bill.lines.length == 1 ? '' : 's'} · '
        '$statusLabel',
      ),
      trailing: Text(
        inr(bill.totalPaise),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InvoiceDetailScreen(billId: bill.id),
          ),
        );
      },
    );
  }
}
