package com.dpoise.groomstudio.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Transaction
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface ServiceDao {
    @Query("SELECT * FROM services ORDER BY category, name")
    fun observeAll(): Flow<List<ServiceEntity>>

    @Query("SELECT * FROM services WHERE isActive = 1 ORDER BY name")
    fun observeActive(): Flow<List<ServiceEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(service: ServiceEntity): Long

    @Query("SELECT COUNT(*) FROM services")
    suspend fun count(): Int
}

@Dao
interface EmployeeDao {
    @Query("SELECT * FROM employees ORDER BY name")
    fun observeAll(): Flow<List<EmployeeEntity>>

    @Query("SELECT * FROM employees WHERE isActive = 1 ORDER BY name")
    fun observeActive(): Flow<List<EmployeeEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(employee: EmployeeEntity): Long

    @Update
    suspend fun update(employee: EmployeeEntity)

    @Query("SELECT COUNT(*) FROM employees WHERE isActive = 1")
    fun observeActiveCount(): Flow<Int>
}

@Dao
interface BillDao {
    @Query("SELECT * FROM bills ORDER BY createdAtMillis DESC")
    fun observeAll(): Flow<List<BillEntity>>

    @Query("SELECT * FROM bills WHERE createdAtMillis >= :fromMillis ORDER BY createdAtMillis DESC")
    fun observeSince(fromMillis: Long): Flow<List<BillEntity>>

    @Query("SELECT COALESCE(SUM(totalInPaise), 0) FROM bills WHERE createdAtMillis >= :fromMillis AND status = 'PAID'")
    fun observeRevenueSince(fromMillis: Long): Flow<Long>

    @Query("SELECT COUNT(*) FROM bills WHERE createdAtMillis >= :fromMillis")
    fun observeCountSince(fromMillis: Long): Flow<Int>

    @Insert
    suspend fun insert(bill: BillEntity): Long

    @Insert
    suspend fun insertLines(lines: List<BillLineEntity>)

    @Transaction
    @Query("SELECT * FROM bills WHERE id = :billId")
    suspend fun getBill(billId: Long): BillEntity?
}

@Dao
interface AttendanceDao {
    @Query("SELECT * FROM attendance WHERE dateEpochDay = :epochDay ORDER BY employeeId")
    fun observeForDate(epochDay: Long): Flow<List<AttendanceEntity>>

    @Query("SELECT COUNT(*) FROM attendance WHERE dateEpochDay = :epochDay AND status = 'PRESENT'")
    fun observePresentCount(epochDay: Long): Flow<Int>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(record: AttendanceEntity): Long
}

@Dao
interface SalaryDao {
    @Query("SELECT * FROM salaries ORDER BY year DESC, month DESC")
    fun observeAll(): Flow<List<SalaryEntity>>

    @Query(
        "SELECT COALESCE(SUM(baseInPaise - deductionsInPaise + bonusInPaise - paidInPaise), 0) " +
            "FROM salaries WHERE status != 'PAID'"
    )
    fun observePendingTotal(): Flow<Long>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(record: SalaryEntity): Long
}
