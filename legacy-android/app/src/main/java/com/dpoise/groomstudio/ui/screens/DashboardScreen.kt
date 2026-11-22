package com.dpoise.groomstudio.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AccountBalanceWallet
import androidx.compose.material.icons.outlined.Groups
import androidx.compose.material.icons.outlined.HowToReg
import androidx.compose.material.icons.outlined.Payments
import androidx.compose.material.icons.outlined.ReceiptLong
import androidx.compose.material.icons.outlined.ShoppingBag
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.dpoise.groomstudio.domain.model.AttendanceStatus
import com.dpoise.groomstudio.navigation.Destination
import com.dpoise.groomstudio.ui.components.QuickActionCard
import com.dpoise.groomstudio.ui.components.SampleBadge
import com.dpoise.groomstudio.ui.components.SectionHeader
import com.dpoise.groomstudio.ui.components.StatCard
import com.dpoise.groomstudio.ui.theme.Spacing
import com.dpoise.groomstudio.util.CurrencyFormatter
import com.dpoise.groomstudio.util.DateTimeUtil
import com.dpoise.groomstudio.util.SampleData
import com.dpoise.groomstudio.viewmodel.DashboardViewModel
import java.time.LocalDate

@Composable
fun DashboardScreen(
    viewModel: DashboardViewModel,
    studioName: String,
    onNavigate: (Destination) -> Unit,
    modifier: Modifier = Modifier
) {
    val state by viewModel.uiState.collectAsState()

    if (state.isLoading) {
        Column(
            modifier = modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            CircularProgressIndicator(color = MaterialTheme.colorScheme.primary)
            Spacer(Modifier.height(16.dp))
            Text("Loading studio overview…", style = MaterialTheme.typography.bodyMedium)
        }
        return
    }

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(horizontal = 28.dp, vertical = 24.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        item { DashboardHeader(showingSample = state.showingSampleData, studioName = studioName) }

        if (state.errorMessage != null) {
            item {
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.errorContainer
                    ),
                    shape = MaterialTheme.shapes.medium
                ) {
                    Text(
                        state.errorMessage,
                        modifier = Modifier.padding(16.dp),
                        color = MaterialTheme.colorScheme.onErrorContainer,
                        style = MaterialTheme.typography.bodyMedium
                    )
                }
            }
        }

        item { StatsRow(state = state) }
        item { QuickActions(onNavigate = onNavigate) }

        item {
            BoxWithConstraints(Modifier.fillMaxWidth()) {
                if (maxWidth >= 900.dp) {
                    Row(
                        Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(24.dp)
                    ) {
                        RecentTransactions(
                            transactions = state.recentTransactions,
                            modifier = Modifier.weight(1.4f),
                            onViewAll = { onNavigate(Destination.BillingHistory) }
                        )
                        AttendanceSummary(
                            rows = state.attendanceSummary,
                            present = state.stats.presentToday,
                            total = state.stats.totalEmployees,
                            modifier = Modifier.weight(1f),
                            onViewAll = { onNavigate(Destination.Attendance) }
                        )
                    }
                } else {
                    Column(verticalArrangement = Arrangement.spacedBy(24.dp)) {
                        RecentTransactions(
                            transactions = state.recentTransactions,
                            modifier = Modifier.fillMaxWidth(),
                            onViewAll = { onNavigate(Destination.BillingHistory) }
                        )
                        AttendanceSummary(
                            rows = state.attendanceSummary,
                            present = state.stats.presentToday,
                            total = state.stats.totalEmployees,
                            modifier = Modifier.fillMaxWidth(),
                            onViewAll = { onNavigate(Destination.Attendance) }
                        )
                    }
                }
            }
        }

        item {
            Text(
                "All figures on this dashboard are sample data for design review. " +
                    "Live numbers appear once billing and attendance are implemented.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun DashboardHeader(showingSample: Boolean, studioName: String) {
    Row(
        Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(Modifier.weight(1f)) {
            Text(
                "${DateTimeUtil.greeting()}, $studioName",
                style = MaterialTheme.typography.headlineMedium
            )
            Spacer(Modifier.height(4.dp))
            Text(
                DateTimeUtil.formatDay(LocalDate.now()) + "  ·  Studio overview",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        if (showingSample) SampleBadge(text = "SAMPLE DATA — NOT REAL")
    }
}

@Composable
private fun StatsRow(state: com.dpoise.groomstudio.viewmodel.DashboardUiState) {
    val stats = state.stats
    BoxWithConstraints(Modifier.fillMaxWidth()) {
        val columns = when {
            maxWidth >= 1100.dp -> 5
            maxWidth >= 700.dp -> 3
            else -> 2
        }
        val cards: List<@Composable (Modifier) -> Unit> = listOf(
            { m ->
                StatCard(
                    label = "TODAY'S REVENUE", icon = Icons.Outlined.Payments,
                    value = CurrencyFormatter.formatPaiseCompact(stats.todayRevenueInPaise),
                    supporting = "Sample figure", modifier = m
                )
            },
            { m ->
                StatCard(
                    label = "BILLS TODAY", icon = Icons.Outlined.ReceiptLong,
                    value = stats.billsToday.toString(),
                    supporting = "Sample count", modifier = m
                )
            },
            { m ->
                StatCard(
                    label = "TOTAL EMPLOYEES", icon = Icons.Outlined.Groups,
                    value = stats.totalEmployees.toString(),
                    supporting = "On studio roster", modifier = m
                )
            },
            { m ->
                StatCard(
                    label = "PRESENT TODAY", icon = Icons.Outlined.HowToReg,
                    value = "${stats.presentToday} / ${stats.totalEmployees}",
                    supporting = "Sample attendance", modifier = m
                )
            },
            { m ->
                StatCard(
                    label = "PENDING SALARY", icon = Icons.Outlined.AccountBalanceWallet,
                    value = CurrencyFormatter.formatPaiseCompact(stats.pendingSalaryInPaise),
                    supporting = "Sample amount due", modifier = m
                )
            }
        )
        Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
            cards.chunked(columns).forEach { rowCards ->
                Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                    rowCards.forEach { card -> card(Modifier.weight(1f)) }
                    repeat(columns - rowCards.size) { Spacer(Modifier.weight(1f)) }
                }
            }
        }
    }
}

@Composable
private fun QuickActions(onNavigate: (Destination) -> Unit) {
    Column {
        SectionHeader(title = "Quick actions")
        Spacer(Modifier.height(14.dp))
        BoxWithConstraints(Modifier.fillMaxWidth()) {
            val actions: List<@Composable (Modifier) -> Unit> = listOf(
                { m ->
                    QuickActionCard(
                        label = "New Bill", description = "Start a customer bill",
                        icon = Icons.Outlined.ReceiptLong,
                        onClick = { onNavigate(Destination.NewBill) }, modifier = m
                    )
                },
                { m ->
                    QuickActionCard(
                        label = "Mark Attendance", description = "Today's staff check-in",
                        icon = Icons.Outlined.HowToReg,
                        onClick = { onNavigate(Destination.Attendance) }, modifier = m
                    )
                },
                { m ->
                    QuickActionCard(
                        label = "Billing History", description = "Past bills & payments",
                        icon = Icons.Outlined.ShoppingBag,
                        onClick = { onNavigate(Destination.BillingHistory) }, modifier = m
                    )
                },
                { m ->
                    QuickActionCard(
                        label = "Salary Management", description = "Payroll & pending pay",
                        icon = Icons.Outlined.AccountBalanceWallet,
                        onClick = { onNavigate(Destination.Salary) }, modifier = m
                    )
                }
            )
            val columns = if (maxWidth >= 900.dp) 4 else if (maxWidth >= 560.dp) 2 else 1
            Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
                actions.chunked(columns).forEach { rowActions ->
                    Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                        rowActions.forEach { action -> action(Modifier.weight(1f)) }
                        repeat(columns - rowActions.size) { Spacer(Modifier.weight(1f)) }
                    }
                }
            }
        }
    }
}

@Composable
private fun RecentTransactions(
    transactions: List<SampleData.SampleTransaction>,
    modifier: Modifier = Modifier,
    onViewAll: () -> Unit
) {
    Card(
        modifier = modifier,
        shape = MaterialTheme.shapes.large,
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(Modifier.padding(20.dp)) {
            SectionHeader(
                title = "Recent transactions",
                showSampleBadge = true,
                actionLabel = "View all",
                onAction = onViewAll
            )
            Spacer(Modifier.height(8.dp))
            transactions.forEachIndexed { index, tx ->
                Row(
                    Modifier
                        .fillMaxWidth()
                        .padding(vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            tx.customerName,
                            style = MaterialTheme.typography.titleSmall,
                            fontWeight = FontWeight.SemiBold
                        )
                        Text(
                            "${tx.serviceSummary}  ·  ${tx.billNumber}",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    Column(horizontalAlignment = Alignment.End) {
                        Text(
                            CurrencyFormatter.formatPaiseCompact(tx.amountInPaise),
                            style = MaterialTheme.typography.titleSmall,
                            fontWeight = FontWeight.SemiBold
                        )
                        Text(
                            "${tx.paymentMethod.name}  ·  ${tx.timeLabel}",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
                if (index < transactions.lastIndex) {
                    HorizontalDivider(color = MaterialTheme.colorScheme.outline)
                }
            }
        }
    }
}

@Composable
private fun AttendanceSummary(
    rows: List<SampleData.SampleAttendanceRow>,
    present: Int,
    total: Int,
    modifier: Modifier = Modifier,
    onViewAll: () -> Unit
) {
    Card(
        modifier = modifier,
        shape = MaterialTheme.shapes.large,
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(Modifier.padding(20.dp)) {
            SectionHeader(
                title = "Attendance today",
                subtitle = "$present of $total present (sample)",
                showSampleBadge = true,
                actionLabel = "Open",
                onAction = onViewAll
            )
            Spacer(Modifier.height(8.dp))
            rows.forEachIndexed { index, row ->
                Row(
                    Modifier
                        .fillMaxWidth()
                        .padding(vertical = 10.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(Modifier.weight(1f)) {
                        Text(row.employeeName, style = MaterialTheme.typography.titleSmall)
                        Text(
                            row.role,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    AttendanceChip(row.status, row.checkInLabel)
                }
                if (index < rows.lastIndex) {
                    HorizontalDivider(color = MaterialTheme.colorScheme.outline)
                }
            }
        }
    }
}

@Composable
private fun AttendanceChip(status: AttendanceStatus, checkInLabel: String?) {
    val (label, container, content) = when (status) {
        AttendanceStatus.PRESENT -> Triple(
            "Present" + (checkInLabel?.let { " · $it" } ?: ""),
            MaterialTheme.colorScheme.primaryContainer,
            MaterialTheme.colorScheme.onPrimaryContainer
        )
        AttendanceStatus.HALF_DAY -> Triple(
            "Half day",
            MaterialTheme.colorScheme.secondaryContainer,
            MaterialTheme.colorScheme.onSecondaryContainer
        )
        AttendanceStatus.LEAVE -> Triple(
            "On leave",
            MaterialTheme.colorScheme.surfaceVariant,
            MaterialTheme.colorScheme.onSurfaceVariant
        )
        AttendanceStatus.ABSENT -> Triple(
            "Absent",
            MaterialTheme.colorScheme.errorContainer,
            MaterialTheme.colorScheme.onErrorContainer
        )
    }
    androidx.compose.material3.Surface(
        color = container, contentColor = content,
        shape = MaterialTheme.shapes.extraSmall
    ) {
        Text(
            label,
            style = MaterialTheme.typography.labelSmall,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 5.dp)
        )
    }
}
