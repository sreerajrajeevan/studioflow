import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../branding/brand_logo.dart';
import '../branding/studio_branding.dart';
import '../core/breakpoints.dart';
import 'state.dart';

class NavDestinationDef {
  const NavDestinationDef({
    required this.location,
    required this.label,
    required this.icon,
    this.inMoreMenu = false,
  });

  final String location;
  final String label;
  final IconData icon;

  /// On the rail, secondary destinations live under "More" to keep the
  /// counter workflow one tap away and the rail uncluttered.
  final bool inMoreMenu;
}

const allDestinations = <NavDestinationDef>[
  NavDestinationDef(
    location: '/billing',
    label: 'New Bill',
    icon: Icons.receipt_long_outlined,
  ),
  NavDestinationDef(
    location: '/attendance',
    label: 'Attendance',
    icon: Icons.how_to_reg_outlined,
  ),
  NavDestinationDef(
    location: '/history',
    label: 'History',
    icon: Icons.history_outlined,
  ),
  NavDestinationDef(
    location: '/dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
  ),
  NavDestinationDef(
    location: '/services',
    label: 'Services',
    icon: Icons.content_cut_outlined,
    inMoreMenu: true,
  ),
  NavDestinationDef(
    location: '/employees',
    label: 'Employees',
    icon: Icons.groups_outlined,
    inMoreMenu: true,
  ),
  NavDestinationDef(
    location: '/salary',
    label: 'Salary',
    icon: Icons.account_balance_wallet_outlined,
    inMoreMenu: true,
  ),
  NavDestinationDef(
    location: '/reports',
    label: 'Reports',
    icon: Icons.assessment_outlined,
    inMoreMenu: true,
  ),
  NavDestinationDef(
    location: '/settings',
    label: 'Settings',
    icon: Icons.settings_outlined,
    inMoreMenu: true,
  ),
];

List<NavDestinationDef> visibleDestinations(AppRole role) =>
    allDestinations.where((d) => roleCanSee(role, d.location)).toList();

/// Typographic brand mark — used until a studio uploads a real logo.
/// Never an invented pictorial logo.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.branding, this.size = 44});

  final StudioBranding branding;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.secondary,
        borderRadius: BorderRadius.circular(size * 0.27),
      ),
      alignment: Alignment.center,
      child: Text(
        branding.businessName.trim().isEmpty
            ? 'S'
            : branding.businessName.trim()[0].toUpperCase(),
        style: TextStyle(
          fontFamily: 'serif',
          fontSize: size * 0.5,
          fontWeight: FontWeight.w700,
          color: scheme.onSecondary,
        ),
      ),
    );
  }
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final role = ref.watch(roleProvider);
    final visible = visibleDestinations(role);
    final layout = context.layoutClass;

    if (layout == LayoutClass.compact) {
      return Scaffold(
        body: child,
        bottomNavigationBar: _BottomBar(
          visible: visible,
          location: location,
          onMore: () => _showMoreSheet(context, ref, visible),
        ),
      );
    }

    final railDests = visible.where((d) => !d.inMoreMenu).toList();
    final moreDests = visible.where((d) => d.inMoreMenu).toList();
    // Flow sub-routes (/billing/customer, /billing/services) keep the
    // New Bill rail destination selected.
    bool matches(NavDestinationDef d) =>
        d.location == location ||
        (d.location == '/billing' && location.startsWith('/billing/'));
    final selectedIndex = railDests.indexWhere(matches);
    final moreSelected = moreDests.any(matches);

    return Scaffold(
      body: Row(
        children: [
          Container(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: NavigationRail(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF0B0B0B)
                  : const Color(0xFF232323),
              selectedIndex: selectedIndex < 0 ? null : selectedIndex,
              onDestinationSelected: (i) => context.go(railDests[i].location),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BrandLogo(branding: branding, size: 46),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 72,
                      child: Text(
                        branding.businessName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFFFBF9F4),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'More',
                            onPressed: () =>
                                _showMoreSheet(context, ref, visible),
                            icon: Icon(
                              Icons.more_horiz,
                              color: moreSelected
                                  ? const Color(0xFFFBF9F4)
                                  : const Color(0xFFFBF9F4)
                                      .withValues(alpha: 0.65),
                            ),
                          ),
                          Text(
                            'More',
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFFFBF9F4)
                                  .withValues(alpha: moreSelected ? 1 : 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
              destinations: [
                for (final d in railDests)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _showMoreSheet(BuildContext context, WidgetRef ref, List<NavDestinationDef> visible) {
    final moreDests = visible.where((d) => d.inMoreMenu).toList();
    final role = ref.read(roleProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (moreDests.isNotEmpty) ...[
                  for (final d in moreDests)
                    ListTile(
                      leading: Icon(d.icon),
                      title: Text(d.label),
                      selected: d.location == location ||
                          (d.location == '/billing' &&
                              location.startsWith('/billing/')),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        context.go(d.location);
                      },
                    ),
                  const Divider(),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Role preview (UI only — not authentication)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<AppRole>(
                    segments: const [
                      ButtonSegment(value: AppRole.owner, label: Text('Owner')),
                      ButtonSegment(value: AppRole.staff, label: Text('Staff')),
                    ],
                    selected: {role},
                    onSelectionChanged: (selection) {
                      ref.read(roleProvider.notifier).state = selection.first;
                      Navigator.of(sheetContext).pop();
                      // If the current screen is now hidden, go to billing.
                      if (!roleCanSee(selection.first, location)) {
                        context.go('/billing');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.visible,
    required this.location,
    required this.onMore,
  });

  final List<NavDestinationDef> visible;
  final String location;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final primary = visible.where((d) => !d.inMoreMenu).toList();
    final index = primary.indexWhere(
      (d) =>
          d.location == location ||
          (d.location == '/billing' && location.startsWith('/billing/')),
    );
    return NavigationBar(
      selectedIndex: index < 0 ? 0 : index,
      onDestinationSelected: (i) {
        if (i < primary.length) {
          context.go(primary[i].location);
        } else {
          onMore();
        }
      },
      destinations: [
        for (final d in primary)
          NavigationDestination(icon: Icon(d.icon), label: d.label),
        const NavigationDestination(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }
}
