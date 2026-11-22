package com.dpoise.groomstudio.domain.model

/**
 * White-label studio configuration — the single source of truth for who this
 * installation belongs to. v1: exactly one profile per installation
 * (row id = [SINGLETON_ID]). No business logic may hardcode a studio name,
 * colour, UPI id or tax id; everything reads from here.
 */
data class StudioProfile(
    val id: Long = SINGLETON_ID,
    val businessName: String,
    val tagline: String? = null,
    /** Absolute path inside app-private storage (files/logos/…), or null. */
    val logoPath: String? = null,
    /** Brand colours as ARGB ints (Compose Color.value shrinks to these). */
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
) {
    companion object {
        const val SINGLETON_ID = 1L
        const val DEFAULT_PRIMARY_ARGB = 0xFF1B3A2FL
        const val DEFAULT_SECONDARY_ARGB = 0xFFC9A96AL
    }
}

/**
 * Immutable snapshot of the studio's public details, copied onto a bill at
 * the moment it is created. Later edits to [StudioProfile] (name, logo,
 * address, GSTIN…) must NEVER rewrite history — invoices render from this
 * snapshot, not from the live profile. See docs/INVOICE_SNAPSHOT.md.
 */
data class StudioSnapshot(
    val businessName: String,
    val tagline: String?,
    val address: String,
    val phone: String,
    val email: String?,
    val gstin: String?,
    val logoPath: String?,
    val upiId: String?,
    val upiPayeeName: String?,
    val invoicePrefix: String,
    val invoiceFooter: String?
) {
    companion object {
        fun from(profile: StudioProfile): StudioSnapshot = StudioSnapshot(
            businessName = profile.businessName,
            tagline = profile.tagline,
            address = profile.address,
            phone = profile.phone,
            email = profile.email,
            gstin = profile.gstin,
            logoPath = profile.logoPath,
            upiId = profile.upiId,
            upiPayeeName = profile.upiPayeeName,
            invoicePrefix = profile.invoicePrefix,
            invoiceFooter = profile.invoiceFooter
        )
    }
}

/** A selectable branding preset in the setup wizard / settings. */
data class BrandPreset(
    val id: String,
    val label: String,
    val businessName: String,
    val tagline: String?,
    val primaryColorArgb: Long,
    val secondaryColorArgb: Long,
    val isDemo: Boolean = false
)

object BrandPresets {
    /** Task 1's look, preserved as the optional demonstration preset. */
    val dpoiseDemo = BrandPreset(
        id = "dpoise_demo",
        label = "D POISE — Demo",
        businessName = "D POISE",
        tagline = "Groom Studio",
        primaryColorArgb = 0xFF1B3A2FL,
        secondaryColorArgb = 0xFFC9A96AL,
        isDemo = true
    )

    val all: List<BrandPreset> = listOf(
        dpoiseDemo,
        BrandPreset(
            id = "classic_charcoal", label = "Classic Charcoal",
            businessName = "", tagline = null,
            primaryColorArgb = 0xFF232323L, secondaryColorArgb = 0xFFC9A96AL
        ),
        BrandPreset(
            id = "ocean", label = "Ocean Blue",
            businessName = "", tagline = null,
            primaryColorArgb = 0xFF14486BL, secondaryColorArgb = 0xFF7FB3D5L
        ),
        BrandPreset(
            id = "maroon", label = "Royal Maroon",
            businessName = "", tagline = null,
            primaryColorArgb = 0xFF5E2129L, secondaryColorArgb = 0xFFD4AF37L
        ),
        BrandPreset(
            id = "plum", label = "Modern Plum",
            businessName = "", tagline = null,
            primaryColorArgb = 0xFF3E2A56L, secondaryColorArgb = 0xFFB79CEDL
        )
    )
}
