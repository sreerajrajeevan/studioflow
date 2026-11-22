package com.dpoise.groomstudio.domain.usecase

import com.dpoise.groomstudio.data.repository.AttendanceRepository
import com.dpoise.groomstudio.data.repository.BillingRepository
import com.dpoise.groomstudio.data.repository.EmployeeRepository
import com.dpoise.groomstudio.data.repository.SalaryRepository
import com.dpoise.groomstudio.domain.model.DashboardStats
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import java.time.LocalDate
import java.time.ZoneId

/**
 * Aggregates the five dashboard numbers from the repositories.
 *
 * In Task 1 the database is empty, so this flow emits zeros — the
 * DashboardViewModel deliberately shows labelled SAMPLE data instead until
 * real billing/attendance writes land in later tasks. The use case itself
 * is production-shaped and needs no change when that happens.
 */
class GetDashboardStatsUseCase(
    private val billing: BillingRepository,
    private val employees: EmployeeRepository,
    private val attendance: AttendanceRepository,
    private val salary: SalaryRepository
) {
    operator fun invoke(): Flow<DashboardStats> {
        val zone = ZoneId.systemDefault()
        val startOfToday = LocalDate.now().atStartOfDay(zone).toInstant().toEpochMilli()
        val todayEpochDay = LocalDate.now().toEpochDay()

        return combine(
            billing.observeRevenueSince(startOfToday),
            billing.observeBillCountSince(startOfToday),
            employees.observeActiveCount(),
            attendance.observePresentCount(todayEpochDay),
            salary.observePendingTotal()
        ) { revenue, bills, staff, present, pending ->
            DashboardStats(
                todayRevenueInPaise = revenue,
                billsToday = bills,
                totalEmployees = staff,
                presentToday = present,
                pendingSalaryInPaise = pending,
                isSampleData = false
            )
        }
    }
}

/** Stubs for the module use cases that later tasks flesh out. */
class GetServicesUseCase(private val repo: com.dpoise.groomstudio.data.repository.ServiceRepository) {
    operator fun invoke() = repo.observeServices()
}

class GetEmployeesUseCase(private val repo: EmployeeRepository) {
    operator fun invoke() = repo.observeEmployees()
}
