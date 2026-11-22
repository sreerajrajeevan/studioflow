import 'package:flutter/material.dart';

/// Inset policy for shell screens (Task 5.2 — the status-bar overlap
/// fix).
///
/// Root cause of the overlap: the app targets SDK 36, so Android 15+
/// draws it edge-to-edge whether it asks or not — and the shell's
/// screens are bare widgets (no AppBar, no Scaffold of their own), so
/// nothing ever applied the system top inset. Content started at y=0,
/// underneath the clock and notification icons.
///
/// The fix is applied ONCE, here, for every shell screen:
///
/// - TOP: always applied — no branding, title or control may sit under
///   the status bar or a display cutout.
/// - LEFT/RIGHT: applied — landscape cutouts push content, never cover.
/// - BOTTOM: NOT applied here. Bottom insets belong to the element
///   that owns the bottom edge (the bottom navigation bar, the bill
///   summary bar, sheets) — each pads itself, so nothing is padded
///   twice.
///
/// Screens must NOT add their own top SafeArea on top of this; their
/// own padding is design spacing only.
class ShellInsets extends StatelessWidget {
  const ShellInsets({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: true,
      right: true,
      child: child,
    );
  }
}
