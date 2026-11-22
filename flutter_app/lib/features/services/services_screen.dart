import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/state.dart';
import '../../core/breakpoints.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/price_parse.dart';
import '../../data/providers.dart';
import '../../data/repositories_impl.dart' show categoryIdFor;
import '../../domain/models.dart';
import '../../domain/repositories.dart';

/// Service catalog management (Task 2).
///
/// Owners add, edit, price, deactivate, and reorder services and
/// categories; every change persists to Drift and refreshes the billing
/// catalog immediately. Staff (role preview) get a read-only view.
///
/// Editing the catalog NEVER touches an open bill: cart lines carry
/// snapshot prices, and a re-tap at a changed price opens a separate
/// line (see the snapshot policy in cart.dart).
class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String? _categoryId; // null = all categories
  String _query = '';
  bool _reorder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(catalogAdminProvider).loaded) {
        ref.read(catalogAdminProvider.notifier).load();
      }
    });
  }

  List<ServiceItem> _visible(CatalogAdminState admin) {
    final q = _query.trim().toLowerCase();
    return admin.services.where((s) {
      if (_categoryId != null && s.categoryId != _categoryId) return false;
      if (q.isNotEmpty && !s.name.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(catalogAdminProvider);
    final isOwner = ref.watch(roleProvider) == AppRole.owner;
    final layout = context.layoutClass;
    final services = _visible(admin);

    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          count: services.length,
          isOwner: isOwner,
          canReorder: isOwner && _categoryId != null,
          reorder: _reorder,
          onToggleReorder: () => setState(() => _reorder = !_reorder),
          onSearch: (q) => setState(() => _query = q),
          onAdd: isOwner ? () => _openEditor(context, admin) : null,
        ),
        if (!isOwner) const _StaffNote(),
        Expanded(
          child: _reorder && _categoryId != null
              ? _ReorderableServices(
                  services: services,
                  onReorder: (ids) => ref
                      .read(catalogAdminProvider.notifier)
                      .reorderServices(ids),
                )
              : _ServiceList(
                  services: services,
                  isOwner: isOwner,
                  onEdit: (s) => _openEditor(context, admin, existing: s),
                ),
        ),
      ],
    );

    if (layout == LayoutClass.expanded) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 264,
            child: _CategoryPanel(
              admin: admin,
              selectedId: _categoryId,
              isOwner: isOwner,
              onSelect: (id) => setState(() {
                _categoryId = id;
                _reorder = false;
              }),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: main),
        ],
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            _CategoryChips(
              admin: admin,
              selectedId: _categoryId,
              isOwner: isOwner,
              onSelect: (id) => setState(() {
                _categoryId = id;
                _reorder = false;
              }),
            ),
            Expanded(child: main),
          ],
        ),
        if (isOwner)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _openEditor(context, admin),
              icon: const Icon(Icons.add),
              label: const Text('Add service'),
            ),
          ),
      ],
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    CatalogAdminState admin, {
    ServiceItem? existing,
  }) async {
    if (admin.categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create a category first, then add services to it.'),
        ),
      );
      return;
    }
    final saved = await showDialog<ServiceItem>(
      context: context,
      builder: (_) => _ServiceEditorDialog(
        categories: admin.categories,
        existing: existing,
        initialCategoryId: existing?.categoryId ?? _categoryId,
      ),
    );
    if (saved == null || !context.mounted) return;
    try {
      await ref.read(catalogAdminProvider.notifier).saveService(saved);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved ${saved.name} — billing is updated.')),
        );
      }
    } on CatalogValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}

class _StaffNote extends StatelessWidget {
  const _StaffNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Staff view (role preview): only the owner can edit the '
              'catalog. This preview is not secure authentication.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.count,
    required this.isOwner,
    required this.canReorder,
    required this.reorder,
    required this.onToggleReorder,
    required this.onSearch,
    required this.onAdd,
  });

  final int count;
  final bool isOwner;
  final bool canReorder;
  final bool reorder;
  final VoidCallback onToggleReorder;
  final ValueChanged<String> onSearch;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Services', style: theme.textTheme.headlineSmall),
              ),
              if (canReorder)
                TextButton.icon(
                  onPressed: onToggleReorder,
                  icon: Icon(reorder ? Icons.check : Icons.swap_vert),
                  label: Text(reorder ? 'Done' : 'Reorder'),
                ),
              if (isOwner)
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add service'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$count service${count == 1 ? '' : 's'} · changes apply to '
            'billing immediately · open bills keep their snapshot prices',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          TextField(
            key: const ValueKey('services_search'),
            onChanged: onSearch,
            decoration: const InputDecoration(
              hintText: 'Search services',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceList extends ConsumerWidget {
  const _ServiceList({
    required this.services,
    required this.isOwner,
    required this.onEdit,
  });

  final List<ServiceItem> services;
  final bool isOwner;
  final void Function(ServiceItem) onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (services.isEmpty) {
      return const Center(child: Text('No services match.'));
    }
    return ListView.builder(
      key: const ValueKey('services_list'),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _ServiceRow(
          key: ValueKey('service_row_${service.id}'),
          service: service,
          isOwner: isOwner,
          onEdit: () => onEdit(service),
        );
      },
    );
  }
}

class _ReorderableServices extends StatelessWidget {
  const _ReorderableServices({required this.services, required this.onReorder});

  final List<ServiceItem> services;
  final void Function(List<String> orderedIds) onReorder;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: services.length,
      onReorderItem: (oldIndex, newIndex) {
        final ids = services.map((s) => s.id).toList();
        ids.insert(newIndex, ids.removeAt(oldIndex));
        onReorder(ids);
      },
      itemBuilder: (context, index) {
        final service = services[index];
        return ListTile(
          key: ValueKey('reorder_${service.id}'),
          leading: const Icon(Icons.drag_handle),
          title: Text(service.name),
          trailing: Text(inr(service.pricePaise)),
        );
      },
    );
  }
}

class _ServiceRow extends ConsumerWidget {
  const _ServiceRow({
    super.key,
    required this.service,
    required this.isOwner,
    required this.onEdit,
  });

  final ServiceItem service;
  final bool isOwner;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dimmed = !service.isActive;
    return ListTile(
      title: Text(
        service.name,
        style: dimmed
            ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
            : null,
      ),
      subtitle: Text(
        [
          service.category,
          if (service.durationMinutes > 0) '${service.durationMinutes} min',
          if (service.description != null && service.description!.isNotEmpty)
            service.description!,
          if (!service.isActive) 'Inactive',
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            inr(service.pricePaise),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isOwner) ...[
            Switch(
              value: service.isActive,
              onChanged: (active) async {
                try {
                  await ref
                      .read(catalogAdminProvider.notifier)
                      .setServiceActive(service.id, active);
                } on CatalogValidationException catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message)),
                    );
                  }
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit service',
              onPressed: onEdit,
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryPanel extends ConsumerWidget {
  const _CategoryPanel({
    required this.admin,
    required this.selectedId,
    required this.isOwner,
    required this.onSelect,
  });

  final CatalogAdminState admin;
  final String? selectedId;
  final bool isOwner;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    int countFor(String? id) => id == null
        ? admin.services.length
        : admin.services.where((s) => s.categoryId == id).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Categories',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add category',
                  onPressed: () => _editCategory(context, ref, null),
                ),
            ],
          ),
        ),
        ListTile(
          selected: selectedId == null,
          leading: const Icon(Icons.apps_outlined),
          title: const Text('All services'),
          trailing: Text('${countFor(null)}'),
          onTap: () => onSelect(null),
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: admin.categories.length,
            onReorderItem: isOwner
                ? (oldIndex, newIndex) {
                    final ids = admin.categories.map((c) => c.id).toList();
                    ids.insert(newIndex, ids.removeAt(oldIndex));
                    ref
                        .read(catalogAdminProvider.notifier)
                        .reorderCategories(ids);
                  }
                : (_, __) {},
            itemBuilder: (context, index) {
              final category = admin.categories[index];
              return ListTile(
                key: ValueKey('category_${category.id}'),
                selected: selectedId == category.id,
                title: Text(
                  category.name,
                  style: category.isActive
                      ? null
                      : TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                subtitle: category.isActive
                    ? Text('${countFor(category.id)} services')
                    : const Text('Inactive — hidden from billing'),
                trailing: isOwner
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Rename category',
                            onPressed: () =>
                                _editCategory(context, ref, category),
                          ),
                          Switch(
                            value: category.isActive,
                            onChanged: (active) => ref
                                .read(catalogAdminProvider.notifier)
                                .setCategoryActive(category.id, active),
                          ),
                        ],
                      )
                    : null,
                onTap: () => onSelect(category.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _editCategory(
    BuildContext context,
    WidgetRef ref,
    ServiceCategory? existing,
  ) async {
    final saved = await showDialog<ServiceCategory>(
      context: context,
      builder: (_) => _CategoryEditorDialog(existing: existing),
    );
    if (saved == null || !context.mounted) return;
    try {
      await ref.read(catalogAdminProvider.notifier).saveCategory(saved);
    } on CatalogValidationException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.admin,
    required this.selectedId,
    required this.isOwner,
    required this.onSelect,
  });

  final CatalogAdminState admin;
  final String? selectedId;
  final bool isOwner;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: selectedId == null,
              onSelected: (_) => onSelect(null),
            ),
            for (final category in admin.categories) ...[
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text(category.name),
                selected: selectedId == category.id,
                onSelected: (_) => onSelect(category.id),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryEditorDialog extends StatefulWidget {
  const _CategoryEditorDialog({this.existing});

  final ServiceCategory? existing;

  @override
  State<_CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends State<_CategoryEditorDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existing == null;
    return AlertDialog(
      title: Text(isNew ? 'Add category' : 'Rename category'),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Category name',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) {
              setState(() => _error = 'Name cannot be empty.');
              return;
            }
            Navigator.of(context).pop(
              ServiceCategory(
                id: widget.existing?.id ?? categoryIdFor(name),
                name: name,
                sortOrder: widget.existing?.sortOrder ?? 0,
                isActive: widget.existing?.isActive ?? true,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ServiceEditorDialog extends StatefulWidget {
  const _ServiceEditorDialog({
    required this.categories,
    this.existing,
    this.initialCategoryId,
  });

  final List<ServiceCategory> categories;
  final ServiceItem? existing;
  final String? initialCategoryId;

  @override
  State<_ServiceEditorDialog> createState() => _ServiceEditorDialogState();
}

class _ServiceEditorDialogState extends State<_ServiceEditorDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _price = TextEditingController(
    text: widget.existing == null
        ? ''
        : formatPaiseForInput(widget.existing!.pricePaise),
  );
  late final TextEditingController _duration = TextEditingController(
    text: widget.existing == null || widget.existing!.durationMinutes == 0
        ? ''
        : '${widget.existing!.durationMinutes}',
  );
  late final TextEditingController _description =
      TextEditingController(text: widget.existing?.description ?? '');
  late String? _categoryId =
      widget.initialCategoryId ?? widget.categories.first.id;
  late bool _active = widget.existing?.isActive ?? true;
  String? _nameError;
  String? _priceError;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _duration.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existing == null;
    return AlertDialog(
      title: Text(isNew ? 'Add service' : 'Edit service'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              autofocus: isNew,
              decoration: InputDecoration(
                labelText: 'Service name',
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final c in widget.categories)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _price,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Price (₹)',
                hintText: 'e.g. 300 or 300.50',
                errorText: _priceError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _duration,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes, optional)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active (visible in billing)'),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    final name = _name.text.trim();
    final paise = parseInrToPaise(_price.text);
    var valid = true;
    if (name.isEmpty) {
      _nameError = 'Name cannot be empty.';
      valid = false;
    } else {
      _nameError = null;
    }
    if (paise == null) {
      _priceError =
          'Enter a valid amount — up to two decimals, max ₹${MoneyLimits.maxPricePaise ~/ 100}.';
      valid = false;
    } else {
      _priceError = null;
    }
    if (!valid || _categoryId == null) {
      setState(() {});
      return;
    }
    final category =
        widget.categories.firstWhere((c) => c.id == _categoryId);
    final duration = int.tryParse(_duration.text.trim()) ?? 0;
    Navigator.of(context).pop(
      ServiceItem(
        id: widget.existing?.id ??
            'svc_${newDraftId().substring('draft-'.length)}',
        name: name,
        category: category.name,
        categoryId: category.id,
        pricePaise: paise!,
        durationMinutes: duration < 0 ? 0 : duration,
        isActive: _active,
        description:
            _description.text.trim().isEmpty ? null : _description.text.trim(),
        sortOrder: widget.existing?.sortOrder ?? 0,
      ),
    );
  }
}
