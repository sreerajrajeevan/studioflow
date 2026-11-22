package com.dpoise.groomstudio.domain.commercial

/**
 * Commercial extension points (Task 1.5) — interfaces ONLY, deliberately
 * unimplemented. They mark where future paid/platform features plug in
 * without touching billing/attendance/payroll code:
 *
 *  - Licence activation & subscription plans
 *  - Multiple branches (v1 is strictly one studio per installation)
 *  - Cloud backup & multi-device sync
 *  - Optional employee accounts
 *  - Additional business types beyond salon/grooming
 *
 * IMPORTANT: no licence check is enforced anywhere in v1, and nothing here
 * should be described as copy protection. When licensing ships, it must be
 * designed honestly (server-verified entitlement) — a local boolean flag
 * would not protect anything and must not be marketed as if it does.
 */
interface LicenceProvider {
    suspend fun currentEntitlement(): LicenceEntitlement
}

enum class LicenceEntitlement { UNLICENSED, TRIAL, ACTIVE, EXPIRED }

interface BackupProvider {
    suspend fun exportBackup(): Result<String>
    suspend fun restoreBackup(source: String): Result<Unit>
}

interface SyncProvider {
    suspend fun syncNow(): Result<Unit>
}

interface BranchProvider {
    /** v1 always returns the single configured studio. */
    suspend fun branches(): List<String>
}
