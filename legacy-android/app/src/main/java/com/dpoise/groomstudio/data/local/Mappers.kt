package com.dpoise.groomstudio.data.local

import com.dpoise.groomstudio.domain.model.AttendanceRecord
import com.dpoise.groomstudio.domain.model.AttendanceStatus
import com.dpoise.groomstudio.domain.model.Bill
import com.dpoise.groomstudio.domain.model.BillStatus
import com.dpoise.groomstudio.domain.model.Employee
import com.dpoise.groomstudio.domain.model.PaymentMethod
import com.dpoise.groomstudio.domain.model.SalaryRecord
import com.dpoise.groomstudio.domain.model.SalaryStatus
import com.dpoise.groomstudio.domain.model.ServiceItem

fun ServiceEntity.toDomain() = ServiceItem(id, name, category, priceInPaise, durationMinutes, isActive)
fun ServiceItem.toEntity() = ServiceEntity(id, name, category, priceInPaise, durationMinutes, isActive)

fun EmployeeEntity.toDomain() =
    Employee(id, name, role, phone, monthlySalaryInPaise, joiningDateEpochDay, isActive)

fun Employee.toEntity() =
    EmployeeEntity(id, name, role, phone, monthlySalaryInPaise, joiningDateEpochDay, isActive)

fun BillEntity.toDomain(lines: List<com.dpoise.groomstudio.domain.model.BillLine> = emptyList()) = Bill(
    id = id,
    billNumber = billNumber,
    customerName = customerName,
    customerPhone = customerPhone,
    lines = lines,
    discountInPaise = discountInPaise,
    totalInPaise = totalInPaise,
    paymentMethod = runCatching { PaymentMethod.valueOf(paymentMethod) }.getOrDefault(PaymentMethod.CASH),
    status = runCatching { BillStatus.valueOf(status) }.getOrDefault(BillStatus.PAID),
    createdAtMillis = createdAtMillis,
    studioSnapshot = snapshotBusinessName?.let {
        com.dpoise.groomstudio.domain.model.StudioSnapshot(
            businessName = it,
            tagline = snapshotTagline,
            address = snapshotAddress.orEmpty(),
            phone = snapshotPhone.orEmpty(),
            email = snapshotEmail,
            gstin = snapshotGstin,
            logoPath = snapshotLogoPath,
            upiId = snapshotUpiId,
            upiPayeeName = snapshotUpiPayeeName,
            invoicePrefix = snapshotInvoicePrefix ?: "INV",
            invoiceFooter = snapshotInvoiceFooter
        )
    }
)

fun AttendanceEntity.toDomain() = AttendanceRecord(
    id = id,
    employeeId = employeeId,
    dateEpochDay = dateEpochDay,
    status = runCatching { AttendanceStatus.valueOf(status) }.getOrDefault(AttendanceStatus.ABSENT),
    checkInMillis = checkInMillis,
    checkOutMillis = checkOutMillis
)

fun SalaryEntity.toDomain() = SalaryRecord(
    id = id,
    employeeId = employeeId,
    month = month,
    year = year,
    baseInPaise = baseInPaise,
    deductionsInPaise = deductionsInPaise,
    bonusInPaise = bonusInPaise,
    paidInPaise = paidInPaise,
    status = runCatching { SalaryStatus.valueOf(status) }.getOrDefault(SalaryStatus.PENDING)
)
