import 'package:flutter/widgets.dart';

/// Width-driven layout classes. Layouts key off available width only —
/// never off device models — so the same widgets serve tablets, phones,
/// and later desktop/web windows.
enum LayoutClass { compact, medium, expanded }

LayoutClass layoutClassForWidth(double width) {
  if (width >= 1100) return LayoutClass.expanded; // landscape tablet: 3-pane POS
  if (width >= 600) return LayoutClass.medium; // portrait tablet / large phone
  return LayoutClass.compact; // phone
}

LayoutClass layoutClassOf(BuildContext context) =>
    layoutClassForWidth(MediaQuery.sizeOf(context).width);

extension LayoutContext on BuildContext {
  LayoutClass get layoutClass => layoutClassOf(this);
  bool get isExpanded => layoutClass == LayoutClass.expanded;
  bool get isCompact => layoutClass == LayoutClass.compact;
}
