package com.dpoise.groomstudio.viewmodel

import com.dpoise.groomstudio.domain.model.BrandPreset
import com.dpoise.groomstudio.domain.model.StudioProfile
import com.dpoise.groomstudio.util.ProfileValidation

/** Editable form state shared by the setup wizard and Business Settings. */
data class ProfileFormState(
    val businessName: String = "",
    val tagline: String = "",
    val address: String = "",
    val phone: String = "",
    val email: String = "",
    val gstin: String = "",
    val upiId: String = "",
    val upiPayeeName: String = "",
    val invoicePrefix: String = "INV",
    val invoiceFooter: String = "",
    val primaryColorArgb: Long = StudioProfile.DEFAULT_PRIMARY_ARGB,
    val secondaryColorArgb: Long = StudioProfile.DEFAULT_SECONDARY_ARGB,
    val logoPath: String? = null,
    val appliedPresetId: String? = null
) {
    // Field errors (null = valid). Computed, never stored.
    val businessNameError: String? get() = ProfileValidation.businessName(businessName)
    val taglineError: String? get() = ProfileValidation.tagline(tagline)
    val phoneError: String? get() = ProfileValidation.phone(phone)
    val emailError: String? get() = ProfileValidation.email(email)
    val gstinError: String? get() = ProfileValidation.gstin(gstin)
    val upiIdError: String? get() = ProfileValidation.upiId(upiId)
    val upiPayeeError: String? get() = ProfileValidation.upiPayeeName(upiPayeeName, upiId)
    val invoicePrefixError: String? get() = ProfileValidation.invoicePrefix(invoicePrefix)

    val step1Valid: Boolean
        get() = businessNameError == null && taglineError == null &&
            phoneError == null && emailError == null && gstinError == null

    val upiValid: Boolean
        get() = upiIdError == null && upiPayeeError == null

    val allValid: Boolean
        get() = step1Valid && upiValid && invoicePrefixError == null

    fun applyPreset(preset: BrandPreset): ProfileFormState = copy(
        primaryColorArgb = preset.primaryColorArgb,
        secondaryColorArgb = preset.secondaryColorArgb,
        appliedPresetId = preset.id,
        businessName = if (preset.isDemo) preset.businessName else businessName,
        tagline = if (preset.isDemo) (preset.tagline ?: "") else tagline
    )

    fun toProfile(existing: StudioProfile? = null): StudioProfile = StudioProfile(
        id = StudioProfile.SINGLETON_ID,
        businessName = businessName.trim(),
        tagline = tagline.trim().ifBlank { null },
        logoPath = logoPath,
        primaryColorArgb = primaryColorArgb,
        secondaryColorArgb = secondaryColorArgb,
        address = address.trim(),
        phone = phone.trim(),
        email = email.trim().ifBlank { null },
        gstin = gstin.trim().uppercase().ifBlank { null },
        upiId = upiId.trim().ifBlank { null },
        upiPayeeName = upiPayeeName.trim().ifBlank { null },
        currencyCode = existing?.currencyCode ?: "INR",
        invoicePrefix = invoicePrefix.trim().uppercase().ifBlank { "INV" },
        invoiceFooter = invoiceFooter.trim().ifBlank { null },
        createdAtMillis = existing?.createdAtMillis ?: 0L,
        updatedAtMillis = existing?.updatedAtMillis ?: 0L
    )

    companion object {
        fun fromProfile(profile: StudioProfile): ProfileFormState = ProfileFormState(
            businessName = profile.businessName,
            tagline = profile.tagline.orEmpty(),
            address = profile.address,
            phone = profile.phone,
            email = profile.email.orEmpty(),
            gstin = profile.gstin.orEmpty(),
            upiId = profile.upiId.orEmpty(),
            upiPayeeName = profile.upiPayeeName.orEmpty(),
            invoicePrefix = profile.invoicePrefix,
            invoiceFooter = profile.invoiceFooter.orEmpty(),
            primaryColorArgb = profile.primaryColorArgb,
            secondaryColorArgb = profile.secondaryColorArgb,
            logoPath = profile.logoPath
        )
    }
}
