import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/state.dart';
import '../../core/format.dart';
import '../shared/sample_badge.dart';

/// Dashboard prototype — SAMPLE figures, clearly badged.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _recentBills = <(String, String, int, String)>[
    ('Aarav S.', 'Haircut, Beard Trim', 45000, 'UPI'),
    ('Imran K.', 'Gold Facial', 120000, 'Card'),
    ('Nikhil R.', 'Hair Spa', 90000, 'Cash'),
    ('Vishnu P.', 'Haircut', 30000, 'UPI'),
    ('Kiran D.', 'Facial, Hair Wash', 80000, 'UPI'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ScreenHeader(
          title: 'Good evening, ${branding.businessName}',
          subtitle: 'Studio overview for today — sample figures for design review.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 560
                      ? 2
                      : 1;
              const stats = <(String, String, IconData)>[
                ('Today\'s revenue', '₹12,450', Icons.currency_rupee),
                ('Bills today', '18', Icons.receipt_long_outlined),
                ('Employees present', '4 of 5', Icons.groups_outlined),
                ('Pending salary', '₹86,000', Icons.account_balance_wallet_outlined),
              ];
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.1,
                children: [
                  for (final (label, value, icon) in stats)
                    StatCard(label: label, value: value, icon: icon),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Text('Quick actions', style: theme.textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickAction(
                icon: Icons.receipt_long_outlined,
                label: 'New Bill',
                onTap: () => context.go('/billing'),
              ),
              _QuickAction(
                icon: Icons.how_to_reg_outlined,
                label: 'Mark Attendance',
                onTap: () => context.go('/attendance'),
              ),
              _QuickAction(
                icon: Icons.history_outlined,
                label: 'Billing History',
                onTap: () => context.go('/history'),
              ),
              _QuickAction(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Salary Management',
                onTap: () => context.go('/salary'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Text('Recent bills', style: theme.textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            child: Column(
              children: [
                for (var i = 0; i < _recentBills.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: Text(_recentBills[i].$1),
                    subtitle: Text(_recentBills[i].$2),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          inr(_recentBills[i].$3),
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(_recentBills[i].$4,
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 168,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: scheme.primary, size: 24),
                const SizedBox(height: 10),
                Text(label,
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
