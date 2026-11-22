package com.dpoise.groomstudio

import android.content.Context
import androidx.room.Room
import androidx.sqlite.db.SupportSQLiteDatabase
import androidx.sqlite.db.framework.FrameworkSQLiteOpenHelperFactory
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.dpoise.groomstudio.data.local.AppDatabase
import com.dpoise.groomstudio.data.local.MIGRATION_1_2
import com.dpoise.groomstudio.data.local.StudioProfileEntity
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import java.io.File

/**
 * Migration 1→2 must preserve existing data (Task 1.5 requirement: updates
 * can never silently erase a customer's studio data).
 */
@RunWith(AndroidJUnit4::class)
class MigrationTest {

    private fun createV1Database(context: Context, name: String): SupportSQLiteDatabase {
        val factory = FrameworkSQLiteOpenHelperFactory()
        val config = androidx.sqlite.db.SupportSQLiteOpenHelper.Configuration.builder(context)
            .name(name)
            .callback(object : androidx.sqlite.db.SupportSQLiteOpenHelper.Callback(1) {
                override fun onCreate(db: SupportSQLiteDatabase) {
                    // Minimal v1 schema: the bills table as Task 1 shipped it.
                    db.execSQL(
                        "CREATE TABLE IF NOT EXISTS `bills` (" +
                            "`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
                            "`billNumber` TEXT NOT NULL, `customerName` TEXT NOT NULL, " +
                            "`customerPhone` TEXT NOT NULL, `discountInPaise` INTEGER NOT NULL, " +
                            "`totalInPaise` INTEGER NOT NULL, `paymentMethod` TEXT NOT NULL, " +
                            "`status` TEXT NOT NULL, `createdAtMillis` INTEGER NOT NULL)"
                    )
                    db.execSQL(
                        "INSERT INTO bills (billNumber, customerName, customerPhone, " +
                            "discountInPaise, totalInPaise, paymentMethod, status, createdAtMillis) " +
                            "VALUES ('INV-0001', 'Existing Customer', '', 0, 45000, 'UPI', 'PAID', 1700000000000)"
                    )
                }
                override fun onUpgrade(db: SupportSQLiteDatabase, old: Int, new: Int) = Unit
            })
            .build()
        return factory.create(config).writableDatabase
    }

    @Test
    fun migration1to2_preservesBills_andCreatesProfileTable() {
        val context = ApplicationProvider.getApplicationContext<Context>()
        val dbName = "migration-test.db"
        context.deleteDatabase(dbName)
        val db = createV1Database(context, dbName)

        MIGRATION_1_2.migrate(db)

        db.query("SELECT billNumber, totalInPaise FROM bills").use { cursor ->
            assertTrue(cursor.moveToFirst())
            assertEquals("INV-0001", cursor.getString(0))
            assertEquals(45000L, cursor.getLong(1))
        }
        db.query(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='studio_profile'"
        ).use { cursor -> assertTrue(cursor.moveToFirst()) }
        db.query("SELECT snapshotBusinessName FROM bills LIMIT 1").use { cursor ->
            assertTrue(cursor.moveToFirst())
            assertTrue(cursor.isNull(0)) // pre-migration bills have no snapshot
        }
        db.close()
        context.deleteDatabase(dbName)
    }
}

/**
 * Settings persistence: a saved profile must survive a full database
 * close/reopen (the closest instrumented proxy for an app restart).
 */
@RunWith(AndroidJUnit4::class)
class ProfilePersistenceTest {

    @Test
    fun profile_survivesDatabaseReopen() = runBlocking {
        val context = ApplicationProvider.getApplicationContext<Context>()
        val dbFile = File(context.cacheDir, "profile-persistence-test.db")
        dbFile.delete()

        fun buildDb(): AppDatabase = Room.databaseBuilder(
            context, AppDatabase::class.java, dbFile.absolutePath
        ).addMigrations(MIGRATION_1_2).build()

        val profile = StudioProfileEntity(
            businessName = "Persistence Salon", tagline = "We persist",
            primaryColorArgb = 0xFF14486BL, secondaryColorArgb = 0xFF7FB3D5L,
            address = "1 Test Street", phone = "9876543210",
            upiId = "persist@okaxis", upiPayeeName = "Persistence Salon",
            invoicePrefix = "PS", createdAtMillis = 1L, updatedAtMillis = 2L
        )

        val db1 = buildDb()
        db1.studioProfileDao().upsert(profile)
        db1.close()

        val db2 = buildDb()
        val loaded = db2.studioProfileDao().observeProfile().first()
        assertNotNull(loaded)
        assertEquals("Persistence Salon", loaded!!.businessName)
        assertEquals("persist@okaxis", loaded.upiId)
        assertEquals(0xFF14486BL, loaded.primaryColorArgb)
        db2.close()
        dbFile.delete()
        Unit
    }
}
