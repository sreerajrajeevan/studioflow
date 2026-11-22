import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/providers.dart';
import 'cart.dart';

/// Saved unfinished bills on this device. A draft is NOT an invoice: it
/// has no number and no payment state, and resuming or deleting one never
/// touches billing history.
class DraftsSheet extends ConsumerWidget {
  const DraftsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts = ref.watch(savedDraftsProvider);
    final currentId = ref.watch(cartProvider.select((c) => c.draftId));
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Saved drafts', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Unfinished bills stored on this device. '
              'Drafts are not invoices.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (drafts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No saved drafts.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              for (final draft in drafts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    draft.draftId == currentId
                        ? Icons.edit_note
                        : Icons.receipt_long_outlined,
                  ),
                  title: Text(
                    '${draft.itemCount} item${draft.itemCount == 1 ? '' : 's'}'
                    ' · ${inr(draft.totalPaise)}',
                  ),
                  subtitle: Text(
                    draft.lines
                        .map((l) => '${l.serviceName} ×${l.quantity}')
                        .join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (draft.draftId == currentId)
                        Chip(
                          label: const Text('Current'),
                          visualDensity: VisualDensity.compact,
                        )
                      else
                        TextButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).restore(draft);
                            ref
                                .read(draftAutosaverProvider)
                                .noteClean(draft);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Resume'),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete draft',
                        onPressed: () async {
                          await ref
                              .read(draftStoreProvider)
                              .deleteDraft(draft.draftId!);
                          if (draft.draftId == currentId) {
                            ref.read(cartProvider.notifier).clear();
                          }
                          await ref
                              .read(savedDraftsProvider.notifier)
                              .refresh();
                        },
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

void showDraftsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const DraftsSheet(),
  );
}
