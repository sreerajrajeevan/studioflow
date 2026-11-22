package com.dpoise.groomstudio

import com.dpoise.groomstudio.domain.model.BrandPresets
import com.dpoise.groomstudio.domain.model.StudioProfile
import com.dpoise.groomstudio.domain.model.StudioSnapshot
import com.dpoise.groomstudio.util.ProfileValidation
import com.dpoise.groomstudio.viewmodel.ProfileFormState
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class WhiteLabelTest {

    // --- Business name validation (setup + settings share these rules) ---
    @Test fun emptyBusinessName_isRejected() {
        assertNotNull(ProfileValidation.businessName(""))
        assertNotNull(ProfileValidation.businessName("   "))
    }
    @Test fun normalBusinessName_isAccepted() {
        assertNull(ProfileValidation.businessName("Glow & Co Salon"))
    }

    // --- UPI validation ---
    @Test fun validUpiIds_areAccepted() {
        assertNull(ProfileValidation.upiId("glowco@okhdfcbank"))
        assertNull(ProfileValidation.upiId("9876543210@paytm"))
        assertNull(ProfileValidation.upiId("")) // optional
        assertNull(ProfileValidation.upiId(null))
    }
    @Test fun invalidUpiIds_areRejected() {
        assertNotNull(ProfileValidation.upiId("noatsign"))
        assertNotNull(ProfileValidation.upiId("a@b"))
        assertNotNull(ProfileValidation.upiId("bad id@bank"))
        assertNotNull(ProfileValidation.upiId("@bank"))
    }
    @Test fun payeeName_requiredWhenUpiSet() {
        assertNotNull(ProfileValidation.upiPayeeName("", "glowco@okhdfcbank"))
        assertNull(ProfileValidation.upiPayeeName("", ""))
        assertNull(ProfileValidation.upiPayeeName("Glow Co", "glowco@okhdfcbank"))
    }

    // --- GSTIN / prefix / colour ---
    @Test fun gstinValidation() {
        assertNull(ProfileValidation.gstin("32ABCDE1234F1Z5"))
        assertNull(ProfileValidation.gstin(""))
        assertNotNull(ProfileValidation.gstin("32ABCDE1234F1Z"))   // too short
        assertNotNull(ProfileValidation.gstin("GSTIN1234567890"))  // wrong shape
    }
    @Test fun invoicePrefixValidation() {
        assertNull(ProfileValidation.invoicePrefix("INV"))
        assertNull(ProfileValidation.invoicePrefix("GC-26"))
        assertNotNull(ProfileValidation.invoicePrefix(""))
        assertNotNull(ProfileValidation.invoicePrefix("WAY TOO LONG!"))
    }
    @Test fun colorHexRoundTrip() {
        assertEquals(0xFF1B3A2FL, ProfileValidation.parseColorHex("#1B3A2F"))
        assertEquals(0xFF1B3A2FL, ProfileValidation.parseColorHex("1b3a2f"))
        assertNull(ProfileValidation.parseColorHex("ZZZZZZ"))
        assertEquals("#1B3A2F", ProfileValidation.toHex(0xFF1B3A2FL))
    }

    // --- Demo preset ---
    @Test fun dpoiseDemoPreset_fillsNameAndTask1Colors() {
        val form = ProfileFormState().applyPreset(BrandPresets.dpoiseDemo)
        assertEquals("D POISE", form.businessName)
        assertEquals("Groom Studio", form.tagline)
        assertEquals(0xFF1B3A2FL, form.primaryColorArgb)
        assertEquals(0xFFC9A96AL, form.secondaryColorArgb)
        assertTrue(BrandPresets.dpoiseDemo.isDemo)
    }
    @Test fun nonDemoPreset_neverOverwritesBusinessName() {
        val form = ProfileFormState(businessName = "My Salon")
            .applyPreset(BrandPresets.all.first { it.id == "ocean" })
        assertEquals("My Salon", form.businessName)
        assertEquals(0xFF14486BL, form.primaryColorArgb)
    }

    // --- Invoice snapshot independence ---
    @Test fun snapshot_isFrozenWhenProfileLaterChanges() {
        val original = StudioProfile(
            businessName = "Old Name Studio", tagline = "Old tag",
            primaryColorArgb = 0xFF1B3A2FL, secondaryColorArgb = 0xFFC9A96AL,
            address = "Old address", phone = "9000000000", gstin = "32ABCDE1234F1Z5",
            invoicePrefix = "INV"
        )
        val snapshot = StudioSnapshot.from(original)
        val edited = original.copy(businessName = "New Name", address = "New address", gstin = null)
        // The snapshot taken earlier must be untouched by the later edit.
        assertEquals("Old Name Studio", snapshot.businessName)
        assertEquals("Old address", snapshot.address)
        assertEquals("32ABCDE1234F1Z5", snapshot.gstin)
        assertEquals("New Name", edited.businessName)
    }

    // --- Form → profile mapping ---
    @Test fun formToProfile_trimsAndNormalizes() {
        val profile = ProfileFormState(
            businessName = "  Glow & Co  ", gstin = "32abcde1234f1z5",
            invoicePrefix = "gc", upiId = " glowco@okhdfcbank ", upiPayeeName = " Glow Co "
        ).toProfile()
        assertEquals("Glow & Co", profile.businessName)
        assertEquals("32ABCDE1234F1Z5", profile.gstin)
        assertEquals("GC", profile.invoicePrefix)
        assertEquals("glowco@okhdfcbank", profile.upiId)
        assertEquals("INR", profile.currencyCode)
        assertEquals(StudioProfile.SINGLETON_ID, profile.id)
    }
}
