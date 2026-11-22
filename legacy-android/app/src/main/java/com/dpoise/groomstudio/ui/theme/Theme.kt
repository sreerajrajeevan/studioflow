package com.dpoise.groomstudio.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.graphics.Color
import com.dpoise.groomstudio.domain.model.StudioProfile

/**
 * Dynamic studio theming. The active [StudioProfile]'s colours drive the
 * Material 3 scheme — NOT Android wallpaper/dynamic colour, which would
 * fight the studio's own brand. Foregrounds are auto-derived for contrast
 * (see [Branding]). With no profile yet (setup wizard), the neutral product
 * default palette is used.
 */
@Composable
fun StudioFlowTheme(
    profile: StudioProfile? = null,
    content: @Composable () -> Unit
) {
    val colorScheme = remember(profile?.primaryColorArgb, profile?.secondaryColorArgb) {
        if (profile == null) {
            defaultColorScheme()
        } else {
            studioColorScheme(
                primaryArgb = profile.primaryColorArgb,
                secondaryArgb = profile.secondaryColorArgb
            )
        }
    }
    MaterialTheme(
        colorScheme = colorScheme,
        typography = StudioTypography,
        shapes = StudioShapes,
        content = content
    )
}

private fun defaultColorScheme() = studioColorScheme(
    primaryArgb = StudioProfile.DEFAULT_PRIMARY_ARGB,
    secondaryArgb = StudioProfile.DEFAULT_SECONDARY_ARGB
)

fun studioColorScheme(primaryArgb: Long, secondaryArgb: Long) = run {
    val rawPrimary = Branding.colorFromArgb(primaryArgb)
    val primary = Branding.ensureReadablePrimary(rawPrimary)
    val secondary = Branding.colorFromArgb(secondaryArgb)
    lightColorScheme(
        primary = primary,
        onPrimary = Branding.onColorFor(primary),
        primaryContainer = Branding.containerTint(rawPrimary),
        onPrimaryContainer = Branding.shade(rawPrimary),
        secondary = secondary,
        onSecondary = Branding.onColorFor(secondary),
        secondaryContainer = Branding.containerTint(secondary),
        onSecondaryContainer = Branding.shade(secondary),
        tertiary = Charcoal800,
        onTertiary = Ivory50,
        background = Ivory100,
        onBackground = Charcoal900,
        surface = Ivory50,
        onSurface = Charcoal900,
        surfaceVariant = Ivory200,
        onSurfaceVariant = Charcoal600,
        outline = OutlineSoft,
        outlineVariant = Ivory300,
        error = ErrorRed,
        onError = Color.White
    )
}
