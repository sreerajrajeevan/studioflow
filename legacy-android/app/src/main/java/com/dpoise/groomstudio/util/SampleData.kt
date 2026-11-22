package com.dpoise.groomstudio.util

import com.dpoise.groomstudio.domain.model.AttendanceStatus
import com.dpoise.groomstudio.domain.model.Bill
import com.dpoise.groomstudio.domain.model.BillLine
import com.dpoise.groomstudio.domain.model.BillStatus
import com.dpoise.groomstudio.domain.model.DashboardStats
import com.dpoise.groomstudio.domain.model.PaymentMethod
import java.time.LocalDate
import java.time.LocalTime
import java.time.ZoneId

/**
 * SAMPLE DATA — Task 1 only.
 *
 * Everything here is clearly-labelled placeholder content so the dashboard
 * can be reviewed with realistic shapes. It is NOT real studio data and is
 * never written to the Room database. Later tasks replace these providers
 * with repository flows; the `isSampleData` flags and the on-screen
 * "Sample data" badges must stay until then.
 */
object SampleData {

    data class SampleTransaction(
        val billNumber: String,
        val customerName: String,
        val serviceSummary: String,
        val amountInPaise: Long,
        val paymentMethod: PaymentMethod,
        val timeLabel: String,
        val status: BillStatus = BillStatus.PAID
    )

    data class SampleAttendanceRow(
        val employeeName: String,
        val role: String,
        val status: AttendanceStatus,
        val checkInLabel: String?
    )

    val dashboardStats = DashboardStats(
        todayRevenueInPaise = 1_245_000, // ₹12,450 — SAMPLE
        billsToday = 18,
        totalEmployees = 6,
        presentToday = 5,
        pendingSalaryInPaise = 3_600_000, // ₹36,000 — SAMPLE
        isSampleData = true
    )

    val recentTransactions: List<SampleTransaction> = listOf(
        SampleTransaction("SAMPLE-1042", "Sample Customer A", "Haircut + Beard Trim", 45_000, PaymentMethod.UPI, "11:42 AM"),
        SampleTransaction("SAMPLE-1041", "Sample Customer B", "Hair Colour", 149_900, PaymentMethod.CASH, "11:15 AM"),
        SampleTransaction("SAMPLE-1040", "Sample Customer C", "Facial — Premium", 99_900, PaymentMethod.UPI, "10:48 AM"),
        SampleTransaction("SAMPLE-1039", "Sample Customer D", "Haircut", 29_900, PaymentMethod.CARD, "10:20 AM"),
        SampleTransaction("SAMPLE-1038", "Sample Customer E", "Beard Styling + Head Massage", 64_900, PaymentMethod.UPI, "09:55 AM")
    )

    val attendanceSummary: List<SampleAttendanceRow> = listOf(
        SampleAttendanceRow("Sample Stylist 1", "Senior Stylist", AttendanceStatus.PRESENT, "09:02 AM"),
        SampleAttendanceRow("Sample Stylist 2", "Stylist", AttendanceStatus.PRESENT, "09:10 AM"),
        SampleAttendanceRow("Sample Stylist 3", "Stylist", AttendanceStatus.PRESENT, "09:26 AM"),
        SampleAttendanceRow("Sample Assistant 1", "Assistant", AttendanceStatus.PRESENT, "09:05 AM"),
        SampleAttendanceRow("Sample Assistant 2", "Assistant", AttendanceStatus.HALF_DAY, "01:00 PM"),
        SampleAttendanceRow("Sample Stylist 4", "Stylist", AttendanceStatus.ABSENT, null)
    )

    /** Builds one sample [Bill] for previews/tests — never persisted. */
    fun sampleBill(): Bill {
        val zone = ZoneId.systemDefault()
        val at = LocalDate.now().atTime(LocalTime.of(11, 42)).atZone(zone).toInstant().toEpochMilli()
        return Bill(
            billNumber = "SAMPLE-1042",
            customerName = "Sample Customer A",
            lines = listOf(
                BillLine(serviceId = 1, serviceName = "Haircut", priceInPaise = 29_900),
                BillLine(serviceId = 2, serviceName = "Beard Trim", priceInPaise = 15_100)
            ),
            totalInPaise = 45_000,
            paymentMethod = PaymentMethod.UPI,
            status = BillStatus.PAID,
            createdAtMillis = at
        )
    }
}
