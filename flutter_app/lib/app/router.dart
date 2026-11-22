import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/advances/advances_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/billing/billing_screen.dart';
import '../features/billing/checkout_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/employees/employees_screen.dart';
import '../features/history/history_screen.dart';
import '../features/payroll/salary_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/services/services_screen.dart';
import '../features/settings/settings_screen.dart';
import 'app_shell.dart';
import 'state.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/billing',
    redirect: (context, state) {
      // Role-preview guard: staff preview cannot open admin destinations.
      // (UI-level only — the backend will enforce real authorization.)
      final role = ref.read(roleProvider);
      final location = state.matchedLocation;
      if (!roleCanSee(role, location) && location != '/checkout') {
        return '/billing';
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/billing',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BillingScreen()),
          ),
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/attendance',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AttendanceScreen()),
          ),
          GoRoute(
            path: '/advances',
            builder: (context, state) => const AdvancesScreen(),
          ),
          GoRoute(
            path: '/employees',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: EmployeesScreen()),
          ),
          GoRoute(
            path: '/salary',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SalaryScreen()),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HistoryScreen()),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ReportsScreen()),
          ),
          GoRoute(
            path: '/services',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ServicesScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
});
