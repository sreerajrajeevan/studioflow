package com.dpoise.groomstudio.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.dpoise.groomstudio.StudioFlowApp
import com.dpoise.groomstudio.domain.model.StudioProfile
import com.dpoise.groomstudio.ui.components.AppShell
import com.dpoise.groomstudio.ui.screens.AttendanceScreen
import com.dpoise.groomstudio.ui.screens.BillingHistoryScreen
import com.dpoise.groomstudio.ui.screens.DashboardScreen
import com.dpoise.groomstudio.ui.screens.EmployeesScreen
import com.dpoise.groomstudio.ui.screens.NewBillScreen
import com.dpoise.groomstudio.ui.screens.ReportsScreen
import com.dpoise.groomstudio.ui.screens.SalaryScreen
import com.dpoise.groomstudio.ui.screens.ServicesScreen
import com.dpoise.groomstudio.ui.screens.SettingsScreen
import com.dpoise.groomstudio.viewmodel.DashboardViewModel
import com.dpoise.groomstudio.viewmodel.SettingsViewModel

@Composable
fun StudioFlowNavHost(profile: StudioProfile) {
    val navController: NavHostController = rememberNavController()
    val backStack by navController.currentBackStackEntryAsState()
    val current = Destination.fromRoute(backStack?.destination?.route)
    val context = LocalContext.current
    val app = context.applicationContext as StudioFlowApp

    val navigate: (Destination) -> Unit = { dest ->
        if (dest != current) {
            navController.navigate(dest.route) {
                popUpTo(Destination.start.route) { saveState = true }
                launchSingleTop = true
                restoreState = true
            }
        }
    }

    AppShell(
        current = current,
        onNavigate = navigate,
        studioName = profile.businessName,
        studioTagline = profile.tagline,
        studioLogoPath = profile.logoPath
    ) {
        NavHost(
            navController = navController,
            startDestination = Destination.start.route
        ) {
            composable(Destination.Dashboard.route) {
                val dashboardViewModel: DashboardViewModel = viewModel(
                    factory = DashboardViewModel.Factory(app.container.getDashboardStats)
                )
                DashboardScreen(
                    viewModel = dashboardViewModel,
                    studioName = profile.businessName,
                    onNavigate = navigate
                )
            }
            composable(Destination.NewBill.route) { NewBillScreen(onNavigate = navigate) }
            composable(Destination.Services.route) { ServicesScreen(onNavigate = navigate) }
            composable(Destination.BillingHistory.route) { BillingHistoryScreen(onNavigate = navigate) }
            composable(Destination.Employees.route) { EmployeesScreen(onNavigate = navigate) }
            composable(Destination.Attendance.route) { AttendanceScreen(onNavigate = navigate) }
            composable(Destination.Salary.route) { SalaryScreen(onNavigate = navigate) }
            composable(Destination.Reports.route) { ReportsScreen(onNavigate = navigate) }
            composable(Destination.Settings.route) {
                val settingsViewModel: SettingsViewModel = viewModel(
                    factory = SettingsViewModel.Factory(
                        app.container.studioProfileRepository,
                        app.container.logoStorage
                    )
                )
                SettingsScreen(viewModel = settingsViewModel)
            }
        }
    }
}
