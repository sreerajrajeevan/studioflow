import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../branding/studio_branding.dart';

/// Active studio branding. Settings edits and preset picks update this and
/// the whole app re-themes immediately (MaterialApp watches it).
final brandingProvider = StateProvider<StudioBranding>(
  (ref) => genericStudioBranding,
);

/// Two future roles. STAFF hides administrative destinations in the UI.
enum AppRole { owner, staff }

/// LOCAL UI PREVIEW ONLY — this switch exists so the owner can preview what
/// staff will see. It is NOT authentication and enforces nothing; real
/// authorization will be enforced by the backend.
final roleProvider = StateProvider<AppRole>((ref) => AppRole.owner);

/// Destinations a role may see in navigation. Staff keep the counter
/// workflows (billing, attendance, allowed history, dashboard).
bool roleCanSee(AppRole role, String location) {
  if (role == AppRole.owner) return true;
  const staffAllowed = {'/billing', '/attendance', '/history', '/dashboard'};
  // The billing FLOW has sub-routes (customer details, services) — all
  // of /billing is one counter workflow for staff.
  if (location.startsWith('/billing')) return true;
  return staffAllowed.contains(location);
}
