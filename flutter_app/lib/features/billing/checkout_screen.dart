import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/app_shell.dart';
import '../../app/state.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/price_parse.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../../domain/repositories.dart';
import 'cart.dart';
import 'checkout_controller.dart';
import 'invoice_detail_screen.dart';
import 'invoice_document.dart';

/// Checkout (Task 3): review the bill, record how it was paid, confirm
/// payments MANUALLY, and finalize an immutable invoice.
///
/// Payment safety rules enforced here:
/// - A QR code is shown only from the studio's OWN merchant UPI
///   configuration (Settings). Displaying or scanning it is never
///   treated as evidence of payment.
/// - Nothing is ever auto-marked paid. A person confirms each payment,
///   and who/when is stored on the invoice.
/// - Finalizing is single-flight and idempotent on the draft id: a
///   double tap or a retry can never create two invoices.
/// - Finalizing with unconfirmed payments is allowed, but the invoice
///   then honestly shows PAYMENT PENDING and can be confirmed later
///   from History — pending payments are never silently discarded.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _PaymentEntry {
  _PaymentEntry({required this.method, required this.amountPaise});

  final String id = 'pay_${newDraftId().substring('draft-'.length)}';
  PaymentMethod method;
  int amountPaise;
  bool confirmed = false;
  String? confirmedBy;
  DateTime? confirmedAt;
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final List<_PaymentEntry> _payments = [];
  final TextEditingController _customer = TextEditingController();
  bool _initialized = false;
  String? _error;

  @override
  void dispose() {
    _customer.dispose();
    super.dispose();
  }

  String get _actor =>
      ref.read(roleProvider) == AppRole.owner ? 'Owner' : 'Staff';

  @override
  Widget build(BuildContext context) {
    final branding = ref.watch(brandingProvider);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final checkoutStatus = ref.watch(checkoutControllerProvider);

    if (!_initialized && !cart.isEmpty) {
      _initialized = true;
      _payments.add(
        _PaymentEntry(
            method: PaymentMethod.cash, amountPaise: cart.totalPaise),
      );
    }

    final confirmedTotal = _payments
        .where((p) => p.confirmed)
        .fold(0, (sum, p) => sum + p.amountPaise);
    final recordedTotal =
        _payments.fold(0, (sum, p) => sum + p.amountPaise);
    final fullyConfirmed = !cart.isEmpty && confirmedTotal >= cart.totalPaise;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Checkout'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Row(
                children: [
                  BrandMark(branding: branding, size: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branding.businessName,
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          'Invoice will be saved on this device with a '
                          'local provisional reference.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SummaryCard(cart: cart),
              const SizedBox(height: 14),
              TextField(
                controller: _customer,
                decoration: const InputDecoration(
                  labelText: 'Customer name (optional)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
              Text('Payment', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Record how the customer paid. Confirm each payment only '
                'when the money is actually received — confirmations are '
                'manual and recorded with your name and the time.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < _payments.length; i++) ...[
                _PaymentEntryCard(
                  entry: _payments[i],
                  canRemove: _payments.length > 1,
                  upiPayload: _payments[i].method == PaymentMethod.upi
                      ? buildUpiPayload(
                          upiId: branding.upiId,
                          payeeName: branding.upiPayeeName,
                          amountPaise: _payments[i].amountPaise,
                          note: 'Bill ${cart.draftId ?? ''}',
                        )
                      : null,
                  onChanged: () => setState(() {}),
                  onRemove: () => setState(() => _payments.removeAt(i)),
                  onConfirm: () => setState(() {
                    _payments[i].confirmed = true;
                    _payments[i].confirmedBy = _actor;
                    _payments[i].confirmedAt = DateTime.now();
                  }),
                ),
                const SizedBox(height: 10),
              ],
              if (recordedTotal < cart.totalPaise)
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _payments.add(_PaymentEntry(
                      method: PaymentMethod.cash,
                      amountPaise: cart.totalPaise - recordedTotal,
                    ));
                  }),
                  icon: const Icon(Icons.call_split),
                  label: const Text('Add split payment'),
                ),
              const SizedBox(height: 8),
              Text(
                cart.isEmpty
                    ? ''
                    : 'Confirmed ${inr(confirmedTotal)} of '
                        '${inr(cart.totalPaise)}'
                        '${fullyConfirmed ? '' : ' — the invoice will show PAYMENT PENDING until the rest is confirmed (here or later, from History).'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: fullyConfirmed
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                key: const ValueKey('complete_payment_button'),
                onPressed: cart.isEmpty ||
                        checkoutStatus == CheckoutStatus.processing
                    ? null
                    : () => _finalize(cart),
                child: Text(
                  checkoutStatus == CheckoutStatus.processing
                      ? 'Finalizing…'
                      : 'Finalize invoice',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Finalizing saves the invoice, its payments and an audit '
                'record in one step. It cannot be edited afterwards — '
                'only voided, with a reason.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _finalize(CartState cart) async {
    setState(() => _error = null);
    final branding = ref.read(brandingProvider);
    FinalizedBill? bill;
    try {
      await ref.read(checkoutControllerProvider.notifier).complete(() async {
        bill = await ref.read(billingRepositoryProvider).finalizeDraft(
              cart: cart,
              studio: StudioSnapshot(
                businessName: branding.businessName,
                tagline: branding.tagline,
                address: branding.address,
                phone: branding.phone,
                email: branding.email,
                gstin: branding.gstin,
                upiId: branding.upiId,
                invoicePrefix: branding.invoicePrefix,
                invoiceFooter: branding.invoiceFooter,
              ),
              studioPrimaryColor: branding.primaryColor.toARGB32(),
              payments: [
                for (final p in _payments)
                  PaymentDraft(
                    id: p.id,
                    method: p.method,
                    amountPaise: p.amountPaise,
                    status: p.confirmed
                        ? PaymentStatus.confirmedManual
                        : PaymentStatus.pending,
                    confirmedBy: p.confirmedBy,
                    confirmedAt: p.confirmedAt,
                  ),
              ],
              actor: _actor,
              customerName: _customer.text,
            );
      });
    } on ArgumentError catch (e) {
      setState(() => _error = e.message);
      return;
    } catch (_) {
      setState(
        () => _error = 'Could not save the invoice. Nothing was '
            'finalized — check the bill and try again.',
      );
      return;
    }
    if (!mounted || bill == null) return;
    // Success: the draft is consumed. Clear the cart and show the
    // invoice. History refreshes so the new bill is listed.
    ref.read(cartProvider.notifier).clear();
    ref.read(checkoutControllerProvider.notifier).resetForNewDraft();
    ref.read(billingHistoryProvider.notifier).refresh();
    ref.read(savedDraftsProvider.notifier).refresh();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => InvoiceDetailScreen(billId: bill!.id),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bill summary', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final line in cart.lines)
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
                    Text(inr(line.totalPaise)),
                  ],
                ),
              ),
            const Divider(),
            _row(context, 'Subtotal', inr(cart.subtotalPaise)),
            if (cart.discountPaise > 0)
              _row(
                context,
                cart.discountPercent > 0
                    ? 'Discount (${cart.discountPercent}%)'
                    : 'Discount',
                '-${inr(cart.discountPaise)}',
              ),
            if (cart.taxPaise > 0) _row(context, 'Tax', inr(cart.taxPaise)),
            _row(context, 'Total', inr(cart.totalPaise), bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value,
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

class _PaymentEntryCard extends StatelessWidget {
  const _PaymentEntryCard({
    required this.entry,
    required this.canRemove,
    required this.upiPayload,
    required this.onChanged,
    required this.onRemove,
    required this.onConfirm,
  });

  final _PaymentEntry entry;
  final bool canRemove;
  final String? upiPayload;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SegmentedButton<PaymentMethod>(
                  segments: const [
                    ButtonSegment(
                      value: PaymentMethod.cash,
                      label: Text('Cash'),
                    ),
                    ButtonSegment(
                      value: PaymentMethod.upi,
                      label: Text('UPI'),
                    ),
                    ButtonSegment(
                      value: PaymentMethod.card,
                      label: Text('Card'),
                    ),
                  ],
                  selected: {entry.method},
                  onSelectionChanged: entry.confirmed
                      ? null
                      : (selection) {
                          entry.method = selection.first;
                          onChanged();
                        },
                ),
                const Spacer(),
                if (canRemove && !entry.confirmed)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Remove payment',
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: formatPaiseForInput(entry.amountPaise),
              enabled: !entry.confirmed,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount (₹)'),
              onChanged: (value) {
                final paise = parseInrToPaise(value);
                if (paise != null) entry.amountPaise = paise;
              },
            ),
            if (entry.method == PaymentMethod.upi) ...[
              const SizedBox(height: 12),
              if (upiPayload != null) ...[
                Center(
                  child: QrImageView(
                    data: upiPayload!,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This QR comes from the studio\'s own UPI settings. It '
                  'may not trigger the soundbox — the soundbox\'s own QR '
                  'works too. A QR is never proof of payment: confirm '
                  'below only after the money arrives.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ] else
                Text(
                  'No merchant UPI is configured in Settings, so no QR '
                  'can be generated. Use the studio\'s own QR/soundbox '
                  'and confirm the payment manually below.',
                  style: theme.textTheme.bodySmall,
                ),
            ],
            const SizedBox(height: 10),
            if (entry.confirmed)
              Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Manually confirmed by ${entry.confirmedBy} — '
                      'not provider-verified.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.check),
                label: Text(
                  switch (entry.method) {
                    PaymentMethod.cash => 'Confirm cash received',
                    PaymentMethod.upi => 'Confirm UPI payment received',
                    PaymentMethod.card => 'Confirm card payment',
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
