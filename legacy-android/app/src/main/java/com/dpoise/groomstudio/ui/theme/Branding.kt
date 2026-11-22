package com.dpoise.groomstudio.ui.theme

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance

/**
 * Centralised branding maths. Given a studio's chosen colours, derive a
 * readable Material scheme: automatic black/white foregrounds by WCAG
 * relative luminance, soft container tints, and contrast guards so a
 * customer can pick almost any brand colour and the UI stays legible.
 * Pure functions — unit-tested.
 */
object Branding {

    fun colorFromArgb(argb: Long): Color = Color(argb.toInt())

    /** Best foreground (near-black or ivory-white) to sit ON [background]. */
    fun onColorFor(background: Color): Color {
        // WCAG contrast: pick whichever of the two candidates contrasts more.
        val dark = Color(0xFF1C1C1C)
        val light = Color(0xFFFBF9F4)
        return if (contrastRatio(background, dark) >= contrastRatio(background, light)) dark else light
    }

    fun contrastRatio(a: Color, b: Color): Double {
        val la = a.luminance().toDouble()
        val lb = b.luminance().toDouble()
        val lighter = maxOf(la, lb)
        val darker = minOf(la, lb)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /** True when [fg] on [bg] meets WCAG AA for normal text (4.5:1). */
    fun meetsAa(fg: Color, bg: Color): Boolean = contrastRatio(fg, bg) >= 4.5

    /** Light tint of [color] for container backgrounds (keeps brand hue). */
    fun containerTint(color: Color): Color = Color(
        red = color.red + (1f - color.red) * 0.86f,
        green = color.green + (1f - color.green) * 0.86f,
        blue = color.blue + (1f - color.blue) * 0.86f,
        alpha = 1f
    )

    /** Slightly deepened shade for pressed/secondary surfaces. */
    fun shade(color: Color): Color = Color(
        red = color.red * 0.82f,
        green = color.green * 0.82f,
        blue = color.blue * 0.82f,
        alpha = 1f
    )

    /**
     * If a picked primary is too light to carry white text at AA, deepen it
     * for text-bearing surfaces. Returns the colour unchanged when it is
     * already dark enough — brand fidelity first, legibility guaranteed.
     */
    fun ensureReadablePrimary(color: Color): Color {
        var candidate = color
        var guard = 0
        while (!meetsAa(Color(0xFFFBF9F4), candidate) && guard < 12) {
            candidate = shade(candidate)
            guard++
        }
        return candidate
    }
}
