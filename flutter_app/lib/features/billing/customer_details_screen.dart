import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/phone_validation.dart';
import 'cart.dart';

/// Screen 2 of the billing flow (Task 5.1): Customer Details.
///
/// Exactly three fields — name (required), mobile (required, validated
/// and normalized), notes (optional). The values are stored on the
/// billing session (the draft) and frozen into the invoice snapshot at
/// finalization. Going Back never clears the employee selection.
class CustomerDetailsScreen extends ConsumerStatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  ConsumerState<CustomerDetailsScreen> createState() =>
      _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState
    extends ConsumerState<CustomerDetailsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _notes;
  String? _nameError;
  String? _phoneError;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _phone = TextEditingController();
    _notes = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _name.text.trim();
    final normalized = normalizeIndianMobile(_phone.text);
    setState(() {
      _nameError = name.isEmpty ? 'Enter the customer name.' : null;
      _phoneError = _phone.text.trim().isEmpty
          ? 'Enter the mobile number.'
          : (normalized == null
              ? 'Enter a valid 10-digit mobile number.'
              : null);
    });
    if (_nameError != null || _phoneError != null) return;
    ref.read(cartProvider.notifier).setCustomer(
          name: name,
          phone: normalized!,
          notes: _notes.text,
        );
    context.go('/billing/services');
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (!_initialized) {
      _initialized = true;
      _name.text = cart.customerName;
      _phone.text = cart.customerPhone;
      _notes.text = cart.customerNotes;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            Row(
              children: [
                IconButton(
                  key: const ValueKey('customer_back'),
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back),
                  // Back preserves the employee selection and anything
                  // already typed is kept in the session on Continue;
                  // the flow simply returns to Screen 1.
                  onPressed: () => context.go('/billing'),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Customer Details',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 52),
              child: Text(
                "Enter the customer's information.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            if (cart.billingEmployeeName != null) ...[
              const SizedBox(height: 18),
              Card(
                child: ListTile(
                  leading: Icon(Icons.badge_outlined, color: scheme.primary),
                  title: Text('Billing: ${cart.billingEmployeeName}'),
                  subtitle: const Text('Employee handling this bill'),
                  trailing: TextButton(
                    key: const ValueKey('change_employee'),
                    onPressed: () => context.go('/billing'),
                    child: const Text('Change'),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              key: const ValueKey('customer_name_field'),
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                prefixIcon: const Icon(Icons.person_outline),
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('customer_phone_field'),
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                errorText: _phoneError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('customer_notes_field'),
              controller: _notes,
              maxLength: 200,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Additional Notes (optional)',
                prefixIcon: Icon(Icons.notes_outlined),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const ValueKey('continue_to_billing'),
              onPressed: _continue,
              child: const Text('Continue to Billing  →'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.go('/billing'),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
