package com.dpoise.groomstudio.data.local

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

/**
 * Room entities — storage shape only. Domain models live in domain.model and
 * repositories map between the two, so the schema can evolve without
 * touching the UI.
 */

@Entity(tableName = "services")
data class ServiceEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val name: String,
    val category: String,
    val priceInPaise: Long,
    val durationMinutes: Int,
    val isActive: Boolean = true
)

@Entity(tableName = "employees")
data class EmployeeEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val name: String,
    val role: String,
    val phone: String = "",
    val monthlySalaryInPaise: Long = 0,
    val joiningDateEpochDay: Long = 0,
    val isActive: Boolean = true
)

@Entity(tableName = "bills")
data class BillEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val billNumber: String,
    val customerName: String,
    val customerPhone: String = "",
    val discountInPaise: Long = 0,
    val totalInPaise: Long = 0,
    val paymentMethod: String = "CASH",
    val status: String = "PAID",
    val createdAtMillis: Long = 0,
    // --- Immutable studio snapshot (Task 1.5, schema v2) ---
    // Copied from StudioProfile at bill-creation time. Never updated after
    // insert: later profile edits must not rewrite historical invoices.
    val snapshotBusinessName: String? = null,
    val snapshotTagline: String? = null,
    val snapshotAddress: String? = null,
    val snapshotPhone: String? = null,
    val snapshotEmail: String? = null,
    val snapshotGstin: String? = null,
    val snapshotLogoPath: String? = null,
    val snapshotUpiId: String? = null,
    val snapshotUpiPayeeName: String? = null,
    val snapshotInvoicePrefix: String? = null,
    val snapshotInvoiceFooter: String? = null
)

@Entity(
    tableName = "bill_lines",
    foreignKeys = [
        ForeignKey(
            entity = BillEntity::class,
            parentColumns = ["id"],
            childColumns = ["billId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("billId")]
)
data class BillLineEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val billId: Long,
    val serviceId: Long,
    val serviceName: String,
    val priceInPaise: Long,
    val quantity: Int = 1,
    val employeeId: Long? = null
)

@Entity(
    tableName = "attendance",
    indices = [Index(value = ["employeeId", "dateEpochDay"], unique = true)]
)
data class AttendanceEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val employeeId: Long,
    val dateEpochDay: Long,
    val status: String,
    val checkInMillis: Long? = null,
    val checkOutMillis: Long? = null
)

@Entity(
    tableName = "salaries",
    indices = [Index(value = ["employeeId", "month", "year"], unique = true)]
)
data class SalaryEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val employeeId: Long,
    val month: Int,
    val year: Int,
    val baseInPaise: Long,
    val deductionsInPaise: Long = 0,
    val bonusInPaise: Long = 0,
    val paidInPaise: Long = 0,
    val status: String = "PENDING"
)
