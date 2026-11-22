import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/state.dart';
import '../../branding/brand_logo.dart';
import '../../core/breakpoints.dart';
import '../../domain/models.dart';
import '../../data/providers.dart';
import 'bill_panel.dart';
import 'drafts_sheet.dart';
import 'cart.dart';

/// The POS billing screen — the product's home.
///
/// - Expanded (landscape tablet): category/search + service grid in the
///   centre, bill panel permanently visible on the right. One screen, no
///   navigation needed to complete a bill.
/// - Medium (portrait tablet): grid + sticky bill summary bar.
/// - Compact (phone): dedicated composition — compact header, chips,
///   two-column grid, sticky summary with expandable panel.
class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  String? _category; // null = All
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final layout = context.layoutClass;
    final catalogItems = ref.watch(catalogProvider);
    final q = _query.trim().toLowerCase();
    final services = catalogItems.where((s) {
      if (!s.isActive) return false;
      if (_category != null && s.category != _category) return false;
      if (q.isNotEmpty && !s.name.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
    final categories = <String>[];
    for (final s in catalogItems) {
      if (!categories.contains(s.category)) categories.add(s.category);
    }

    final catalog = _CatalogColumn(
      category: _category,
      query: _query,
      services: services,
      gridColumns: switch (layout) {
        LayoutClass.expanded => 3,
        LayoutClass.medium => 3,
        LayoutClass.compact => 2,
      },
      categories: categories,
      onCategory: (c) => setState(() => _category = c),
      onQuery: (q) => setState(() => _query = q),
    );

    final Widget body;
    if (layout == LayoutClass.expanded) {
      // Tablet landscape POS: multi-column services + a persistent
      // right-side bill summary (Task 5.1 §7).
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: catalog),
          Container(
            width: 360,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                left: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            child: const BillPanel(),
          ),
        ],
      );
    } else {
      // Medium + compact: catalog with a sticky bill summary bar.
      body = Column(
        children: [
          Expanded(child: catalog),
          const BillSummaryBar(),
        ],
      );
    }

    return Column(
      children: [
        const _SessionHeader(),
        Expanded(child: body),
      ],
    );
  }
}

/// Screen 3 header (Task 5.1): compact original logo, the billing
/// employee and the customer, with an Edit action back to Customer
/// Details. Falls back to the studio identity before a session starts.
class _SessionHeader extends ConsumerWidget {
  const _SessionHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasSession = cart.billingEmployeeName != null;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outline)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          BrandLogo(branding: branding, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSession ? cart.billingEmployeeName! : branding.businessName,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  hasSession
                      ? (cart.customerName.isNotEmpty
                          ? 'Billing · Customer: ${cart.customerName}'
                          : 'Billing')
                      : (branding.tagline ?? ''),
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (hasSession)
            IconButton(
              key: const ValueKey('edit_customer_button'),
              tooltip: 'Edit customer details',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.go('/billing/customer'),
            ),
          const _DraftsButton(),
        ],
      ),
    );
  }
}

class _CatalogColumn extends ConsumerWidget {
  const _CatalogColumn({
    required this.category,
    required this.query,
    required this.services,
    required this.categories,
    required this.gridColumns,
    required this.onCategory,
    required this.onQuery,
  });

  final String? category;
  final String query;
  final List<ServiceItem> services;
  final int gridColumns;
  final ValueChanged<String?> onCategory;
  final List<String> categories;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: TextField(
            key: const ValueKey('service_search'),
            onChanged: onQuery,
            decoration: const InputDecoration(
              hintText: 'Search services',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: category == null,
                  onTap: () => onCategory(null),
                ),
                for (final c in categories)
                  _CategoryChip(
                    label: c,
                    selected: category == c,
                    onTap: () => onCategory(c),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: services.isEmpty
              ? Center(
                  child: Text(
                    'No services match your search.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : GridView.builder(
                  key: const ValueKey('service_grid'),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.45,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) =>
                      ServiceTile(service: services[index]),
                ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// A large, fast service tile. Tap = add one (or +1 if already on the bill).
/// The in-cart quantity shows as a badge; selection feedback is immediate.
class ServiceTile extends ConsumerWidget {
  const ServiceTile({super.key, required this.service});

  final ServiceItem service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity =
        ref.watch(cartProvider.select((c) => c.quantityOf(service.id)));
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final inCart = quantity > 0;

    return Material(
      color: inCart ? scheme.primaryContainer : scheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: ValueKey('service_tile_${service.id}'),
        borderRadius: BorderRadius.circular(16),
        onTap: () => ref.read(cartProvider.notifier).addService(service),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: inCart ? scheme.primary : scheme.outline,
              width: inCart ? 1.6 : 1,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        color:
                            inCart ? scheme.onPrimaryContainer : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${service.durationMinutes} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: inCart
                          ? scheme.onPrimaryContainer
                              .withValues(alpha: 0.75)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _priceLabel(service.pricePaise),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: inCart ? scheme.onPrimaryContainer : scheme.primary,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: scheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
              if (inCart)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    key: ValueKey('qty_badge_${service.id}'),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '× $quantity',
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _priceLabel(int paise) {
    final rupees = paise ~/ 100;
    return '₹$rupees';
  }
}

/// Opens the saved-drafts sheet; badge shows how many unfinished bills
/// are stored on this device.
class _DraftsButton extends ConsumerWidget {
  const _DraftsButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(savedDraftsProvider.select((d) => d.length));
    return IconButton(
      key: const ValueKey('drafts_button'),
      tooltip: 'Saved drafts',
      onPressed: () => showDraftsSheet(context),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.drafts_outlined),
      ),
    );
  }
}
