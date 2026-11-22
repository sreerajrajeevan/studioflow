package com.dpoise.groomstudio.data.repository

import com.dpoise.groomstudio.data.local.AppDatabase
import com.dpoise.groomstudio.data.local.toDomain
import com.dpoise.groomstudio.domain.model.AttendanceRecord
import com.dpoise.groomstudio.domain.model.Bill
import com.dpoise.groomstudio.domain.model.Employee
import com.dpoise.groomstudio.domain.model.SalaryRecord
import com.dpoise.groomstudio.domain.model.ServiceItem
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/**
 * Repository contracts. ViewModels depend on these interfaces only, so a
 * later task can add sync/backup behind the same API without UI changes.
 * Task 1 wires the Room-backed implementations but the write paths for
 * billing / attendance / salary are exercised from their own tasks.
 */
interface ServiceRepository {
    fun observeServices(): Flow<List<ServiceItem>>
    suspend fun upsert(service: ServiceItem): Long
}

interface EmployeeRepository {
    fun observeEmployees(): Flow<List<Employee>>
    fun observeActiveCount(): Flow<Int>
    suspend fun upsert(employee: Employee): Long
}

interface BillingRepository {
    fun observeBills(): Flow<List<Bill>>
    fun observeRevenueSince(fromMillis: Long): Flow<Long>
    fun observeBillCountSince(fromMillis: Long): Flow<Int>
}

interface AttendanceRepository {
    fun observeForDate(epochDay: Long): Flow<List<AttendanceRecord>>
    fun observePresentCount(epochDay: Long): Flow<Int>
}

interface SalaryRepository {
    fun observeSalaries(): Flow<List<SalaryRecord>>
    fun observePendingTotal(): Flow<Long>
}

class ServiceRepositoryImpl(private val db: AppDatabase) : ServiceRepository {
    override fun observeServices(): Flow<List<ServiceItem>> =
        db.serviceDao().observeAll().map { list -> list.map { it.toDomain() } }

    override suspend fun upsert(service: ServiceItem): Long =
        db.serviceDao().upsert(
            com.dpoise.groomstudio.data.local.ServiceEntity(
                id = service.id, name = service.name, category = service.category,
                priceInPaise = service.priceInPaise,
                durationMinutes = service.durationMinutes, isActive = service.isActive
            )
        )
}

class EmployeeRepositoryImpl(private val db: AppDatabase) : EmployeeRepository {
    override fun observeEmployees(): Flow<List<Employee>> =
        db.employeeDao().observeAll().map { list -> list.map { it.toDomain() } }

    override fun observeActiveCount(): Flow<Int> = db.employeeDao().observeActiveCount()

    override suspend fun upsert(employee: Employee): Long =
        db.employeeDao().upsert(
            com.dpoise.groomstudio.data.local.EmployeeEntity(
                id = employee.id, name = employee.name, role = employee.role,
                phone = employee.phone, monthlySalaryInPaise = employee.monthlySalaryInPaise,
                joiningDateEpochDay = employee.joiningDateEpochDay, isActive = employee.isActive
            )
        )
}

class BillingRepositoryImpl(private val db: AppDatabase) : BillingRepository {
    override fun observeBills(): Flow<List<Bill>> =
        db.billDao().observeAll().map { list -> list.map { it.toDomain() } }

    override fun observeRevenueSince(fromMillis: Long): Flow<Long> =
        db.billDao().observeRevenueSince(fromMillis)

    override fun observeBillCountSince(fromMillis: Long): Flow<Int> =
        db.billDao().observeCountSince(fromMillis)
}

class AttendanceRepositoryImpl(private val db: AppDatabase) : AttendanceRepository {
    override fun observeForDate(epochDay: Long): Flow<List<AttendanceRecord>> =
        db.attendanceDao().observeForDate(epochDay).map { list -> list.map { it.toDomain() } }

    override fun observePresentCount(epochDay: Long): Flow<Int> =
        db.attendanceDao().observePresentCount(epochDay)
}

class SalaryRepositoryImpl(private val db: AppDatabase) : SalaryRepository {
    override fun observeSalaries(): Flow<List<SalaryRecord>> =
        db.salaryDao().observeAll().map { list -> list.map { it.toDomain() } }

    override fun observePendingTotal(): Flow<Long> = db.salaryDao().observePendingTotal()
}
