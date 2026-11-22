package com.dpoise.groomstudio.ui.components

import android.graphics.BitmapFactory
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.produceState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.painter.BitmapPainter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import com.dpoise.groomstudio.ui.theme.BrandFontFamily
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File

/**
 * Shows the studio logo from its app-private file path, or a brand initial
 * tile when no logo is set. Decodes off the main thread; a missing/corrupt
 * file falls back to the initial tile instead of crashing.
 */
@Composable
fun StudioLogo(
    logoPath: String?,
    businessName: String,
    modifier: Modifier = Modifier
) {
    val bitmap by produceState<androidx.compose.ui.graphics.ImageBitmap?>(initialValue = null, logoPath) {
        value = if (logoPath.isNullOrBlank()) null else withContext(Dispatchers.IO) {
            runCatching {
                val file = File(logoPath)
                if (file.exists()) BitmapFactory.decodeFile(file.absolutePath)?.asImageBitmap() else null
            }.getOrNull()
        }
    }

    val loadedBitmap = bitmap
    if (loadedBitmap != null) {
        Image(
            painter = BitmapPainter(loadedBitmap),
            contentDescription = "$businessName logo",
            modifier = modifier.clip(MaterialTheme.shapes.medium),
            contentScale = ContentScale.Crop
        )
    } else {
        Box(
            modifier = modifier
                .clip(MaterialTheme.shapes.medium)
                .background(MaterialTheme.colorScheme.secondary),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = businessName.trim().firstOrNull()?.uppercase() ?: "S",
                style = MaterialTheme.typography.headlineSmall,
                fontFamily = BrandFontFamily,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSecondary
            )
        }
    }
}
