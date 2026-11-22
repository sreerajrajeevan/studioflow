import 'package:flutter/material.dart';
import '../../core/format.dart';
import '../shared/sample_badge.dart';

/// Reports prototype — sample aggregates with simple bar visualisations.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _popular = <(String, int)>[
    ('Haircut', 86),
    ('Beard Trim', 54),
    ('Facial', 31),
    ('Hair Spa', 22),
    ('Gold Facial', 14),
  ];
  static const _methods = <(String, int)>[
    ('UPI', 58),
    ('Cash', 27),
    ('Card', 15),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const ScreenHeader(
          title: 'Reports',
          subtitle: 'This month at a glance. Sample aggregates for design review.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 700 ? 3 : 1;
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.4,
                children: const [
                  StatCard(
                    label: 'Revenue — November',
                    value: '₹1,84,300',
                    icon: Icons.currency_rupee,
                  ),
                  StatCard(
                    label: 'Bills',
                    value: '412',
                    icon: Icons.receipt_long_outlined,
                  ),
                  StatCard(
                    label: 'Average bill',
                    value: '₹447',
                    icon: Icons.trending_up_outlined,
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Text('Popular services', style: theme.textTheme.titleLarge),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _BarCard(rows: _popular, suffix: ' bills'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Text('Payment methods', style: theme.textTheme.titleLarge),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _BarCard(rows: _methods, suffix: '%'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text(
            'Revenue total cross-check: ${inr(18430000)} across 412 sample bills.',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _BarCard extends StatelessWidget {
  const _BarCard({required this.rows, required this.suffix});

  final List<(String, int)> rows;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final max = rows.map((r) => r.$2).reduce((a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(rows[i].$1, style: theme.textTheme.bodyLarge),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: rows[i].$2 / max,
                        minHeight: 12,
                        backgroundColor: scheme.surfaceContainerLow,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 64,
                    child: Text(
                      '${rows[i].$2}$suffix',
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
