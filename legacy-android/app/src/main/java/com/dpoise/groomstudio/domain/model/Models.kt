package com.dpoise.groomstudio.domain.model

/** Domain models — pure Kotlin, no Room/Android annotations. UI and use cases speak only these. */

data class ServiceItem(
    val id: Long = 0,
    val name: String,
    val category: String,
    val priceInPaise: Long,
    val durationMinutes: Int,
    val isActive: Boolean = true
)

data class Employee(
    val id: Long = 0,
    val name: String,
    val role: String,
    val phone: String = "",
    val monthlySalaryInPaise: Long = 0,
    val joiningDateEpochDay: Long = 0,
    val isActive: Boolean = true
)

enum class PaymentMethod { CASH, UPI, CARD }

enum class BillStatus { PAID, PENDING, CANCELLED, REFUNDED }

data class BillLine(
    val serviceId: Long,
    val serviceName: String,
    val priceInPaise: Long,
    val quantity: Int = 1,
    val employeeId: Long? = null
)

data class Bill(
    val id: Long = 0,
    val billNumber: String,
    val customerName: String,
    val customerPhone: String = "",
    val lines: List<BillLine> = emptyList(),
    val discountInPaise: Long = 0,
    val totalInPaise: Long = 0,
    val paymentMethod: PaymentMethod = PaymentMethod.CASH,
    val status: BillStatus = BillStatus.PAID,
    val createdAtMillis: Long = 0,
    /**
     * Immutable studio snapshot taken at creation time (Task 1.5).
     * Invoices render ONLY from this — never from the live StudioProfile —
     * and line prices in [lines] are likewise frozen copies, so later
     * profile or catalog edits cannot alter a historical invoice.
     */
    val studioSnapshot: StudioSnapshot? = null
)

enum class AttendanceStatus { PRESENT, ABSENT, HALF_DAY, LEAVE }

data class AttendanceRecord(
    val id: Long = 0,
    val employeeId: Long,
    val dateEpochDay: Long,
    val status: AttendanceStatus,
    val checkInMillis: Long? = null,
    val checkOutMillis: Long? = null
)

enum class SalaryStatus { PENDING, PAID, PARTIAL }

data class SalaryRecord(
    val id: Long = 0,
    val employeeId: Long,
    val month: Int, // 1-12
    val year: Int,
    val baseInPaise: Long,
    val deductionsInPaise: Long = 0,
    val bonusInPaise: Long = 0,
    val paidInPaise: Long = 0,
    val status: SalaryStatus = SalaryStatus.PENDING
) {
    val netInPaise: Long get() = baseInPaise - deductionsInPaise + bonusInPaise
    val pendingInPaise: Long get() = (netInPaise - paidInPaise).coerceAtLeast(0)
}

data class DashboardStats(
    val todayRevenueInPaise: Long = 0,
    val billsToday: Int = 0,
    val totalEmployees: Int = 0,
    val presentToday: Int = 0,
    val pendingSalaryInPaise: Long = 0,
    val isSampleData: Boolean = true
)
