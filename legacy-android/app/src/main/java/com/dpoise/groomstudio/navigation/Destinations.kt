package com.dpoise.groomstudio.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AccountBalanceWallet
import androidx.compose.material.icons.outlined.Assessment
import androidx.compose.material.icons.outlined.ContentCut
import androidx.compose.material.icons.outlined.Dashboard
import androidx.compose.material.icons.outlined.Groups
import androidx.compose.material.icons.outlined.HowToReg
import androidx.compose.material.icons.outlined.ReceiptLong
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material.icons.outlined.ShoppingBag
import androidx.compose.ui.graphics.vector.ImageVector

enum class Destination(
    val route: String,
    val label: String,
    val icon: ImageVector
) {
    Dashboard("dashboard", "Dashboard", Icons.Outlined.Dashboard),
    NewBill("new_bill", "New Bill", Icons.Outlined.ReceiptLong),
    Services("services", "Services", Icons.Outlined.ContentCut),
    BillingHistory("billing_history", "Billing History", Icons.Outlined.ShoppingBag),
    Employees("employees", "Employees", Icons.Outlined.Groups),
    Attendance("attendance", "Attendance", Icons.Outlined.HowToReg),
    Salary("salary", "Salary", Icons.Outlined.AccountBalanceWallet),
    Reports("reports", "Reports", Icons.Outlined.Assessment),
    Settings("settings", "Settings", Icons.Outlined.Settings);

    companion object {
        val start: Destination = Dashboard
        fun fromRoute(route: String?): Destination =
            entries.firstOrNull { it.route == route } ?: Dashboard
    }
}
