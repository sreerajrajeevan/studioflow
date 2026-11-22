package com.dpoise.groomstudio.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AccountBalanceWallet
import androidx.compose.material.icons.outlined.Assessment
import androidx.compose.material.icons.outlined.ContentCut
import androidx.compose.material.icons.outlined.Groups
import androidx.compose.material.icons.outlined.HowToReg
import androidx.compose.material.icons.outlined.ReceiptLong
import androidx.compose.material.icons.outlined.ShoppingBag
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import com.dpoise.groomstudio.navigation.Destination
import com.dpoise.groomstudio.ui.components.EmptyState
import com.dpoise.groomstudio.ui.components.ScreenHeader

/**
 * Module placeholders. Each screen states exactly what the module will do,
 * what is NOT implemented yet, and where its data will come from — so staff
 * reviewing the build never mistake a shell for a finished feature.
 */
@Composable
private fun PlaceholderScaffold(
    title: String,
    subtitle: String,
    icon: ImageVector,
    emptyTitle: String,
    emptyMessage: String,
    plannedFeatures: List<String>,
    primaryActionLabel: String? = null,
    onPrimaryAction: (() -> Unit)? = null
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 28.dp, vertical = 24.dp)
    ) {
        ScreenHeader(title = title, subtitle = subtitle)
        Spacer(Modifier.height(24.dp))
        EmptyState(title = emptyTitle, message = emptyMessage, icon = icon)
        Spacer(Modifier.height(8.dp))
        Text("Planned in the next tasks", style = MaterialTheme.typography.titleMedium)
        Spacer(Modifier.height(10.dp))
        Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
            plannedFeatures.forEach { feature ->
                Text(
                    "•  $feature",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        if (primaryActionLabel != null && onPrimaryAction != null) {
            Spacer(Modifier.height(24.dp))
            Button(
                onClick = onPrimaryAction,
                modifier = Modifier.height(52.dp),
                shape = MaterialTheme.shapes.medium
            ) {
                Text(primaryActionLabel, style = MaterialTheme.typography.labelLarge)
            }
        }
        Spacer(Modifier.height(16.dp))
        Text(
            "Placeholder — no real data is created, charged or saved from this screen yet.",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
fun NewBillScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "New Bill",
        subtitle = "Create a customer bill — billing flow arrives in the next task.",
        icon = Icons.Outlined.ReceiptLong,
        emptyTitle = "Billing is not live yet",
        emptyMessage = "The bill builder, service picker and UPI QR payment step are planned next. Nothing can be charged from this screen today.",
        plannedFeatures = listOf(
            "Pick services from the catalog, assign a stylist per service",
            "Customer name / phone, discount, and automatic total",
            "Cash, card and UPI QR payment with a printable/shareable receipt",
            "Saved instantly to the on-device database — works fully offline"
        ),
        primaryActionLabel = "Browse services instead",
        onPrimaryAction = { onNavigate(Destination.Services) }
    )
}

@Composable
fun ServicesScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "Services",
        subtitle = "The studio service catalog and price list.",
        icon = Icons.Outlined.ContentCut,
        emptyTitle = "No services added yet",
        emptyMessage = "Services are stored in the local database (Room). The catalog editor lands with the billing task — no sample services are pre-loaded as if they were real.",
        plannedFeatures = listOf(
            "Add / edit / deactivate services with price and duration",
            "Categories such as Hair, Beard, Skin and Packages",
            "Prices stored exactly (in paise) — no rounding surprises on bills"
        ),
        primaryActionLabel = "Back to dashboard",
        onPrimaryAction = { onNavigate(Destination.Dashboard) }
    )
}

@Composable
fun BillingHistoryScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "Billing History",
        subtitle = "Every bill created at the studio, newest first.",
        icon = Icons.Outlined.ShoppingBag,
        emptyTitle = "No bills yet",
        emptyMessage = "Once billing is live, bills will appear here with search, date filters, reprint and refund actions. The dashboard's recent list is sample data only.",
        plannedFeatures = listOf(
            "Search by bill number, customer name or phone",
            "Filter by date, payment method and status",
            "Open a bill to reprint, share or process a refund"
        ),
        primaryActionLabel = "Back to dashboard",
        onPrimaryAction = { onNavigate(Destination.Dashboard) }
    )
}

@Composable
fun EmployeesScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "Employees",
        subtitle = "Studio team, roles and salary details.",
        icon = Icons.Outlined.Groups,
        emptyTitle = "No employees added yet",
        emptyMessage = "Employee records live in the local database and drive attendance and salary. Add/edit flows arrive with the attendance task.",
        plannedFeatures = listOf(
            "Add staff with role, phone, joining date and monthly salary",
            "Activate / deactivate staff without losing history",
            "Per-employee attendance and salary history at a tap"
        ),
        primaryActionLabel = "Back to dashboard",
        onPrimaryAction = { onNavigate(Destination.Dashboard) }
    )
}

@Composable
fun AttendanceScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "Attendance",
        subtitle = "Daily staff attendance — present, absent, half day, leave.",
        icon = Icons.Outlined.HowToReg,
        emptyTitle = "Attendance opens with the next module",
        emptyMessage = "The daily marking sheet and monthly summary are planned next. The dashboard attendance list is sample data for layout review only.",
        plannedFeatures = listOf(
            "One-tap daily marking for the whole team, with check-in time",
            "Monthly calendar summary per employee",
            "Attendance feeds salary deductions automatically"
        ),
        primaryActionLabel = "Back to dashboard",
        onPrimaryAction = { onNavigate(Destination.Dashboard) }
    )
}

@Composable
fun SalaryScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "Salary",
        subtitle = "Monthly payroll, pending amounts and payment history.",
        icon = Icons.Outlined.AccountBalanceWallet,
        emptyTitle = "Payroll is not live yet",
        emptyMessage = "Salary calculation (base − deductions + bonus, attendance-aware) and payment recording arrive in the payroll task. No amounts here are real.",
        plannedFeatures = listOf(
            "Monthly salary sheet per employee with pending / paid status",
            "Record full or partial payments with date and method",
            "Pending total flows straight to the dashboard"
        ),
        primaryActionLabel = "Back to dashboard",
        onPrimaryAction = { onNavigate(Destination.Dashboard) }
    )
}

@Composable
fun ReportsScreen(onNavigate: (Destination) -> Unit) {
    PlaceholderScaffold(
        title = "Reports",
        subtitle = "Revenue, services and staff performance at a glance.",
        icon = Icons.Outlined.Assessment,
        emptyTitle = "Reports need real bills first",
        emptyMessage = "Reports are computed from stored bills, attendance and salary — they unlock once those modules hold real data.",
        plannedFeatures = listOf(
            "Daily / weekly / monthly revenue with payment-method split",
            "Best-selling services and busiest hours",
            "Staff-wise revenue and attendance summaries, exportable as PDF/CSV"
        ),
        primaryActionLabel = "Back to dashboard",
        onPrimaryAction = { onNavigate(Destination.Dashboard) }
    )
}
