package com.dpoise.groomstudio.di

import android.content.Context
import com.dpoise.groomstudio.data.local.AppDatabase
import com.dpoise.groomstudio.data.repository.AttendanceRepository
import com.dpoise.groomstudio.data.repository.AttendanceRepositoryImpl
import com.dpoise.groomstudio.data.repository.BillingRepository
import com.dpoise.groomstudio.data.repository.BillingRepositoryImpl
import com.dpoise.groomstudio.data.repository.EmployeeRepository
import com.dpoise.groomstudio.data.repository.EmployeeRepositoryImpl
import com.dpoise.groomstudio.data.repository.SalaryRepository
import com.dpoise.groomstudio.data.repository.SalaryRepositoryImpl
import com.dpoise.groomstudio.data.repository.ServiceRepository
import com.dpoise.groomstudio.data.repository.ServiceRepositoryImpl
import com.dpoise.groomstudio.data.repository.StudioProfileRepository
import com.dpoise.groomstudio.data.repository.StudioProfileRepositoryImpl
import com.dpoise.groomstudio.domain.usecase.GetDashboardStatsUseCase
import com.dpoise.groomstudio.util.LogoStorage

/**
 * Manual dependency container (no DI framework — keeps the APK lean and the
 * graph obvious). Swap for Hilt later only if the graph grows.
 */
class AppContainer(context: Context) {
    val database: AppDatabase = AppDatabase.getInstance(context)

    val studioProfileRepository: StudioProfileRepository = StudioProfileRepositoryImpl(database)
    val logoStorage: LogoStorage = LogoStorage(context.applicationContext)

    val serviceRepository: ServiceRepository = ServiceRepositoryImpl(database)
    val employeeRepository: EmployeeRepository = EmployeeRepositoryImpl(database)
    val billingRepository: BillingRepository = BillingRepositoryImpl(database)
    val attendanceRepository: AttendanceRepository = AttendanceRepositoryImpl(database)
    val salaryRepository: SalaryRepository = SalaryRepositoryImpl(database)

    val getDashboardStats: GetDashboardStatsUseCase = GetDashboardStatsUseCase(
        billing = billingRepository,
        employees = employeeRepository,
        attendance = attendanceRepository,
        salary = salaryRepository
    )
}
