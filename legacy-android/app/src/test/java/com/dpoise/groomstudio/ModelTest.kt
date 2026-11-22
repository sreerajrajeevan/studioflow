package com.dpoise.groomstudio

import com.dpoise.groomstudio.domain.model.SalaryRecord
import com.dpoise.groomstudio.domain.model.SalaryStatus
import com.dpoise.groomstudio.util.CurrencyFormatter
import com.dpoise.groomstudio.util.SampleData
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ModelTest {
    @Test
    fun salary_netAndPending_areComputedFromPaise() {
        val record = SalaryRecord(
            employeeId = 1, month = 11, year = 2026,
            baseInPaise = 2_000_000, deductionsInPaise = 100_000,
            bonusInPaise = 50_000, paidInPaise = 500_000,
            status = SalaryStatus.PARTIAL
        )
        assertEquals(1_950_000L, record.netInPaise)
        assertEquals(1_450_000L, record.pendingInPaise)
    }

    @Test
    fun currency_formatsRupees() {
        assertTrue(CurrencyFormatter.formatPaiseCompact(1_245_000).startsWith("₹"))
        assertTrue(CurrencyFormatter.formatPaiseCompact(1_245_000).contains("12,450"))
    }

    @Test
    fun sampleData_isFlaggedAsSample() {
        assertTrue(SampleData.dashboardStats.isSampleData)
        assertTrue(SampleData.recentTransactions.all { it.billNumber.startsWith("SAMPLE") })
    }
}
