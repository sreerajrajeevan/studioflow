package com.dpoise.groomstudio.data.repository

import com.dpoise.groomstudio.data.local.AppDatabase
import com.dpoise.groomstudio.data.local.toDomain
import com.dpoise.groomstudio.data.local.toEntity
import com.dpoise.groomstudio.domain.model.StudioProfile
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

interface StudioProfileRepository {
    /** Null until first-run setup completes — that null IS the setup gate. */
    fun observeProfile(): Flow<StudioProfile?>
    suspend fun getProfile(): StudioProfile?
    suspend fun save(profile: StudioProfile)
}

class StudioProfileRepositoryImpl(private val db: AppDatabase) : StudioProfileRepository {
    override fun observeProfile(): Flow<StudioProfile?> =
        db.studioProfileDao().observeProfile().map { it?.toDomain() }

    override suspend fun getProfile(): StudioProfile? =
        db.studioProfileDao().getProfile()?.toDomain()

    override suspend fun save(profile: StudioProfile) {
        val now = System.currentTimeMillis()
        val existing = db.studioProfileDao().getProfile()
        db.studioProfileDao().upsert(
            profile.copy(
                createdAtMillis = existing?.createdAtMillis ?: profile.createdAtMillis.ifZero(now),
                updatedAtMillis = now
            ).toEntity()
        )
    }

    private fun Long.ifZero(fallback: Long): Long = if (this == 0L) fallback else this
}
