package com.dpoise.groomstudio.util

import android.content.Context
import android.net.Uri
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File

/**
 * Copies a picked logo image into app-private storage (files/logos/) and
 * returns the stored absolute path for StudioProfile.logoPath. The database
 * never holds image bytes or a content Uri (Uris lose permission over time).
 * Works fully offline; the system photo picker needs no storage permission.
 */
class LogoStorage(private val context: Context) {

    private val logoDir: File
        get() = File(context.filesDir, "logos").apply { mkdirs() }

    suspend fun saveFromUri(uri: Uri): String? = withContext(Dispatchers.IO) {
        runCatching {
            val file = File(logoDir, "logo_${System.currentTimeMillis()}.img")
            context.contentResolver.openInputStream(uri)?.use { input ->
                file.outputStream().use { output -> input.copyTo(output) }
            } ?: return@runCatching null
            if (file.length() == 0L) {
                file.delete()
                null
            } else {
                file.absolutePath
            }
        }.getOrNull()
    }

    /** Deletes a previously stored logo file (best-effort cleanup on replace). */
    suspend fun delete(path: String?) = withContext(Dispatchers.IO) {
        if (path.isNullOrBlank()) return@withContext
        runCatching {
            val file = File(path)
            // Only ever delete inside our own logos directory.
            if (file.parentFile?.absolutePath == logoDir.absolutePath) file.delete()
        }
        Unit
    }
}
