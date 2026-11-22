package com.dpoise.groomstudio.data.local

import androidx.room.Dao
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import com.dpoise.groomstudio.domain.model.StudioProfile
import kotlinx.coroutines.flow.Flow

/**
 * Storage shape for the single studio profile. One row, id = 1.
 * The logo IMAGE lives in app-private storage; only its path is stored here.
 */
@Entity(tableName = "studio_profile")
data class StudioProfileEntity(
    @PrimaryKey val id: Long = StudioProfile.SINGLETON_ID,
    val businessName: String,
    val tagline: String? = null,
    val logoPath: String? = null,
    val primaryColorArgb: Long,
    val secondaryColorArgb: Long,
    val address: String = "",
    val phone: String = "",
    val email: String? = null,
    val gstin: String? = null,
    val upiId: String? = null,
    val upiPayeeName: String? = null,
    val currencyCode: String = "INR",
    val invoicePrefix: String = "INV",
    val invoiceFooter: String? = null,
    val createdAtMillis: Long = 0,
    val updatedAtMillis: Long = 0
)

@Dao
interface StudioProfileDao {
    @Query("SELECT * FROM studio_profile WHERE id = 1")
    fun observeProfile(): Flow<StudioProfileEntity?>

    @Query("SELECT * FROM studio_profile WHERE id = 1")
    suspend fun getProfile(): StudioProfileEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(profile: StudioProfileEntity)

    @Query("SELECT COUNT(*) FROM studio_profile")
    suspend fun count(): Int
}

fun StudioProfileEntity.toDomain() = StudioProfile(
    id = id, businessName = businessName, tagline = tagline, logoPath = logoPath,
    primaryColorArgb = primaryColorArgb, secondaryColorArgb = secondaryColorArgb,
    address = address, phone = phone, email = email, gstin = gstin,
    upiId = upiId, upiPayeeName = upiPayeeName, currencyCode = currencyCode,
    invoicePrefix = invoicePrefix, invoiceFooter = invoiceFooter,
    createdAtMillis = createdAtMillis, updatedAtMillis = updatedAtMillis
)

fun StudioProfile.toEntity() = StudioProfileEntity(
    id = id, businessName = businessName, tagline = tagline, logoPath = logoPath,
    primaryColorArgb = primaryColorArgb, secondaryColorArgb = secondaryColorArgb,
    address = address, phone = phone, email = email, gstin = gstin,
    upiId = upiId, upiPayeeName = upiPayeeName, currencyCode = currencyCode,
    invoicePrefix = invoicePrefix, invoiceFooter = invoiceFooter,
    createdAtMillis = createdAtMillis, updatedAtMillis = updatedAtMillis
)
