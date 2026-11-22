package com.dpoise.groomstudio

import androidx.compose.ui.graphics.Color
import com.dpoise.groomstudio.ui.theme.Branding
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class BrandingTest {
    private val ivory = Color(0xFFFBF9F4)
    private val nearBlack = Color(0xFF1C1C1C)
    private val forest = Color(0xFF1B3A2F)

    @Test fun contrastRatio_blackOnWhite_is21() {
        assertEquals(21.0, Branding.contrastRatio(Color.Black, Color.White), 0.6)
    }
    @Test fun onColor_picksLightTextOnDarkBrand() {
        assertEquals(ivory, Branding.onColorFor(forest))
    }
    @Test fun onColor_picksDarkTextOnLightBrand() {
        assertEquals(nearBlack, Branding.onColorFor(Color(0xFFF3EAD3)))
    }
    @Test fun forest_meetsAaWithChosenOnColor() {
        assertTrue(Branding.meetsAa(Branding.onColorFor(forest), forest))
    }
    @Test fun ensureReadablePrimary_deepensPaleYellow() {
        val pale = Color(0xFFFFE066)
        val fixed = Branding.ensureReadablePrimary(pale)
        assertTrue(Branding.meetsAa(ivory, fixed))
    }
    @Test fun ensureReadablePrimary_keepsGoodColorUnchanged() {
        assertEquals(forest, Branding.ensureReadablePrimary(forest))
    }
    @Test fun containerTint_isLighterThanSource() {
        val tint = Branding.containerTint(forest)
        assertTrue(tint.red > forest.red && tint.green > forest.green)
    }
}
