import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/state.dart';
import '../../core/format.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import 'invoice_document.dart';

/// The finalized invoice: receipt view, payment confirmations, share /
/// reprint (PDF + text), void with reason, and the audit trail.
/// A finalized invoice is never edited — only voided, with the record
/// preserved.
class InvoiceDetailScreen extends ConsumerStatefulWidget {
  const InvoiceDetailScreen({super.key, required this.billId});

  final String billId;

  @override
  ConsumerState<InvoiceDetailScreen> createState() =>
      _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  FinalizedBill? _bill;
  List<BillingAuditEvent> _audit = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(billingRepositoryProvider);
      final bill = await repo.getBill(widget.billId);
      final audit =
          bill == null ? <BillingAuditEvent>[] : await repo.auditFor(bill.id);
      if (!mounted) return;
      setState(() {
        _bill = bill;
        _audit = audit;
        _loading = false;
        _error = bill == null ? 'Invoice not found.' : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load this invoice.';
      });
    }
  }

  String get _actor =>
      ref.read(roleProvider) == AppRole.owner ? 'Owner' : 'Staff';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bill = _bill;
    return Scaffold(
      appBar: AppBar(
        title: Text(bill?.provisionalRef ?? 'Invoice'),
        actions: [
          if (bill != null) ...[
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share as text',
              onPressed: () => _shareText(bill),
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              tooltip: 'Share PDF (reprint)',
              onPressed: () => _sharePdf(bill),
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      children: [
                        _ReceiptCard(bill: bill!),
                        const SizedBox(height: 16),
                        _PaymentsCard(
                          bill: bill,
                          onConfirm: (payment) async {
                            await ref
                                .read(billingRepositoryProvider)
                                .confirmPayment(bill.id, payment.id,
                                    actor: _actor);
                            ref
                                .read(billingHistoryProvider.notifier)
                                .refresh();
                            await _load();
                          },
                        ),
                        if (bill.status == FinalizedBillStatus.finalized &&
                            ref.watch(roleProvider) == AppRole.owner) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            key: const ValueKey('void_button'),
                            onPressed: () => _void(bill),
                            icon: Icon(Icons.block,
                                color: theme.colorScheme.error),
                            label: Text(
                              'Void this invoice',
                              style:
                                  TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                        ],
                        if (bill.status == FinalizedBillStatus.voided) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Voided by ${bill.voidedBy} — ${bill.voidReason}',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text('Audit trail',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        for (final event in _audit)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.fact_check_outlined,
                                size: 20),
                            title: Text('${event.type} · ${event.actor}'),
                            subtitle: Text(
                              '${formatInvoiceDateTime(event.createdAt)}'
                              '${event.detail.isEmpty ? '' : ' · ${event.detail}'}',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> _shareText(FinalizedBill bill) async {
    final doc = InvoiceDocument.fromBill(bill);
    await SharePlus.instance.share(
      ShareParams(text: formatTextReceipt(doc)),
    );
  }

  Future<void> _sharePdf(FinalizedBill bill) async {
    final doc = InvoiceDocument.fromBill(bill);
    final bytes = await buildInvoicePdf(doc);
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/invoice_${bill.provisionalRef.replaceAll('/', '-')}.pdf',
    );
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Invoice ${bill.provisionalRef}',
      ),
    );
  }

  Future<void> _void(FinalizedBill bill) async {
    final reasonController = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Void invoice?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'The invoice stays in history, marked VOIDED, with this '
              'reason and your name in the audit trail. It is never '
              'deleted.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Reason (required)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = reasonController.text.trim();
              if (value.isNotEmpty) Navigator.of(dialogContext).pop(value);
            },
            child: const Text('Void invoice'),
          ),
        ],
      ),
    );
    if (reason == null || !mounted) return;
    await ref
        .read(billingRepositoryProvider)
        .voidBill(bill.id, reason: reason, actor: _actor);
    ref.read(billingHistoryProvider.notifier).refresh();
    await _load();
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.bill});

  final FinalizedBill bill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doc = InvoiceDocument.fromBill(bill);
    final accent = Color(bill.studioPrimaryColor);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              doc.studioName,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (doc.tagline != null && doc.tagline!.isNotEmpty)
              Text(doc.tagline!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall),
            if (doc.address.isNotEmpty)
              Text(doc.address,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall),
            if (doc.phone.isNotEmpty || (doc.email?.isNotEmpty ?? false))
              Text(
                [doc.phone, if (doc.email != null) doc.email!]
                    .where((e) => e.isNotEmpty)
                    .join(' · '),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            if (doc.gstin != null && doc.gstin!.isNotEmpty)
              Text('GSTIN: ${doc.gstin}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall),
            const Divider(height: 24),
            _kv(context, 'Invoice (local ref)', doc.provisionalRef),
            _kv(context, 'Date', formatInvoiceDateTime(doc.issuedAt)),
            if (doc.customerName.isNotEmpty)
              _kv(context, 'Customer', doc.customerName),
            if (doc.isVoided)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '*** VOIDED ***',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            const Divider(height: 24),
            for (final line in doc.lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${line.serviceName} × ${line.quantity}'
                        '${line.employeeName != null ? ' · ${line.employeeName}' : ''}',
                      ),
                    ),
                    Text(inr(line.lineTotalPaise)),
                  ],
                ),
              ),
            const Divider(height: 24),
            _kv(context, 'Subtotal', inr(doc.subtotalPaise)),
            if (doc.discountPaise > 0)
              _kv(
                context,
                doc.discountPercent > 0
                    ? 'Discount (${doc.discountPercent}%)'
                    : 'Discount',
                '-${inr(doc.discountPaise)}',
              ),
            if (doc.taxPaise > 0) _kv(context, 'Tax', inr(doc.taxPaise)),
            _kv(context, 'TOTAL', inr(doc.totalPaise), bold: true),
            const SizedBox(height: 8),
            Text(
              doc.paymentStatusLabel,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: doc.paymentStatus == PaymentStatus.pending
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (doc.footer != null && doc.footer!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(doc.footer!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 6),
            Text(
              'Local provisional reference — not an official invoice '
              'number.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(BuildContext context, String label, String value,
      {bool bold = false}) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: bold ? FontWeight.w700 : null,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _PaymentsCard extends StatelessWidget {
  const _PaymentsCard({required this.bill, required this.onConfirm});

  final FinalizedBill bill;
  final void Function(BillPayment payment) onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Payments', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (bill.payments.isEmpty)
              Text('No payments recorded.',
                  style: theme.textTheme.bodyMedium),
            for (final payment in bill.payments)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${InvoiceDocument.methodLabel(payment.method)} · '
                  '${inr(payment.amountPaise)}',
                ),
                subtitle: Text(
                  switch (payment.status) {
                    PaymentStatus.pending => 'Pending confirmation',
                    PaymentStatus.confirmedManual =>
                      'Manually confirmed by ${payment.confirmedBy} · '
                          '${payment.confirmedAt != null ? formatInvoiceDateTime(payment.confirmedAt!) : ''}',
                    PaymentStatus.verifiedProvider => 'Provider verified',
                  },
                ),
                trailing: payment.status == PaymentStatus.pending &&
                        bill.status == FinalizedBillStatus.finalized
                    ? FilledButton.tonal(
                        onPressed: () => onConfirm(payment),
                        child: const Text('Confirm'),
                      )
                    : Icon(
                        payment.status == PaymentStatus.pending
                            ? Icons.hourglass_empty
                            : Icons.check_circle,
                        color: payment.status == PaymentStatus.pending
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
