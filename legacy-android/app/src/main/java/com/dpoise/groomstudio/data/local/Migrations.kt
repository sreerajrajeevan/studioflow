package com.dpoise.groomstudio.data.local

import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase

/**
 * Explicit migrations ONLY. The destructive fallback from Task 1 is removed:
 * a customer update must never silently erase studio data. Every schema
 * change from here on gets a numbered, tested migration.
 *
 * 1 → 2 (Task 1.5, white-label):
 *  - creates `studio_profile` (single-row configuration)
 *  - adds immutable studio snapshot columns to `bills` so historical
 *    invoices keep the name/address/GSTIN/logo/prefix/footer that were
 *    live on the transaction date (see docs/INVOICE_SNAPSHOT.md)
 */
val MIGRATION_1_2 = object : Migration(1, 2) {
    override fun migrate(db: SupportSQLiteDatabase) {
        db.execSQL(
            """
            CREATE TABLE IF NOT EXISTS `studio_profile` (
                `id` INTEGER NOT NULL,
                `businessName` TEXT NOT NULL,
                `tagline` TEXT,
                `logoPath` TEXT,
                `primaryColorArgb` INTEGER NOT NULL,
                `secondaryColorArgb` INTEGER NOT NULL,
                `address` TEXT NOT NULL,
                `phone` TEXT NOT NULL,
                `email` TEXT,
                `gstin` TEXT,
                `upiId` TEXT,
                `upiPayeeName` TEXT,
                `currencyCode` TEXT NOT NULL,
                `invoicePrefix` TEXT NOT NULL,
                `invoiceFooter` TEXT,
                `createdAtMillis` INTEGER NOT NULL,
                `updatedAtMillis` INTEGER NOT NULL,
                PRIMARY KEY(`id`)
            )
            """.trimIndent()
        )
        // Invoice snapshot columns on bills — all nullable so pre-1.5 bills
        // (none exist in production yet) stay valid; new bills must fill them.
        listOf(
            "snapshotBusinessName" to "TEXT",
            "snapshotTagline" to "TEXT",
            "snapshotAddress" to "TEXT",
            "snapshotPhone" to "TEXT",
            "snapshotEmail" to "TEXT",
            "snapshotGstin" to "TEXT",
            "snapshotLogoPath" to "TEXT",
            "snapshotUpiId" to "TEXT",
            "snapshotUpiPayeeName" to "TEXT",
            "snapshotInvoicePrefix" to "TEXT",
            "snapshotInvoiceFooter" to "TEXT"
        ).forEach { (column, type) ->
            db.execSQL("ALTER TABLE `bills` ADD COLUMN `$column` $type")
        }
    }
}

val ALL_MIGRATIONS = arrayOf(MIGRATION_1_2)
