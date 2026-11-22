package com.dpoise.groomstudio.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

/**
 * Offline-first local store. Single Room database for the configured studio —
 * billing, attendance and salary must all work with no network.
 *
 * Schema v2 (Task 1.5): adds `studio_profile` + invoice snapshot columns on
 * bills. Migrations are explicit and tested — there is deliberately NO
 * destructive fallback, so an app update can never silently erase a
 * customer's studio data.
 */
@Database(
    entities = [
        ServiceEntity::class,
        EmployeeEntity::class,
        BillEntity::class,
        BillLineEntity::class,
        AttendanceEntity::class,
        SalaryEntity::class,
        StudioProfileEntity::class
    ],
    version = 2,
    exportSchema = true
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun serviceDao(): ServiceDao
    abstract fun employeeDao(): EmployeeDao
    abstract fun billDao(): BillDao
    abstract fun attendanceDao(): AttendanceDao
    abstract fun salaryDao(): SalaryDao
    abstract fun studioProfileDao(): StudioProfileDao

    companion object {
        // File name kept from Task 1 on purpose: renaming it would orphan the
        // existing database file and bypass MIGRATION_1_2 entirely.
        const val DB_NAME = "dpoise.db"

        @Volatile
        private var instance: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase =
            instance ?: synchronized(this) {
                instance ?: Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    DB_NAME
                )
                    .addMigrations(*ALL_MIGRATIONS)
                    .build()
                    .also { instance = it }
            }
    }
}
