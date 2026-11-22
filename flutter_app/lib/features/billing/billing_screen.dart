import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/state.dart';
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

    if (layout == LayoutClass.expanded) {
      return Row(
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
    }

    // Medium + compact: catalog with a sticky bill summary.
    return Column(
      children: [
        if (layout == LayoutClass.compact) const _MobileHeader(),
        Expanded(child: catalog),
        const BillSummaryBar(),
      ],
    );
  }
}

class _MobileHeader extends ConsumerWidget {
  const _MobileHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branding.businessName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: 'serif',
                    letterSpacing: 0.8,
                  ),
                ),
                if (branding.tagline != null)
                  Text(branding.tagline!, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'SAMPLE DATA',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text('New bill', style: theme.textTheme.headlineSmall),
              ),
              const _DraftsButton(),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SAMPLE DATA',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
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
