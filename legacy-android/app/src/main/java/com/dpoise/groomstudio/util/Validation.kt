package com.dpoise.groomstudio.util

/**
 * Input validation for studio profile fields. Pure functions — unit-tested,
 * shared by the setup wizard and Settings so the rules can never drift.
 * Every validator returns an error message or null (valid).
 */
object ProfileValidation {

    fun businessName(raw: String): String? {
        val name = raw.trim()
        return when {
            name.isEmpty() -> "Business name is required."
            name.length < 2 -> "Business name is too short."
            name.length > 60 -> "Business name must be 60 characters or fewer."
            else -> null
        }
    }

    fun tagline(raw: String?): String? =
        if (raw != null && raw.trim().length > 40) "Tagline must be 40 characters or fewer." else null

    fun phone(raw: String): String? {
        val digits = raw.replace(Regex("[\\s-]"), "").removePrefix("+91")
        return when {
            raw.isBlank() -> null // phone is collected in step 1 but may be added later
            digits.length != 10 || !digits.all { it.isDigit() } ->
                "Enter a valid 10-digit phone number."
            else -> null
        }
    }

    fun email(raw: String?): String? {
        val value = raw?.trim().orEmpty()
        if (value.isEmpty()) return null
        val ok = Regex("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$").matches(value)
        return if (ok) null else "Enter a valid email address."
    }

    fun gstin(raw: String?): String? {
        val value = raw?.trim()?.uppercase().orEmpty()
        if (value.isEmpty()) return null
        // 15 chars: 2 state digits, 5 letters, 4 digits, 1 letter, 1 alnum, Z, 1 alnum.
        val ok = Regex("^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$").matches(value)
        return if (ok) null else "GSTIN must be a valid 15-character GSTIN (or leave blank)."
    }

    /** UPI VPA format: local@provider, e.g. dpoise@okhdfcbank. Optional field. */
    fun upiId(raw: String?): String? {
        val value = raw?.trim().orEmpty()
        if (value.isEmpty()) return null
        val ok = Regex("^[A-Za-z0-9._-]{2,}@[A-Za-z]{2,}[A-Za-z0-9]*$").matches(value)
        return if (ok) null else "UPI ID looks invalid — expected format: yourname@bank."
    }

    fun upiPayeeName(raw: String?, upiId: String?): String? {
        val hasUpi = !upiId.isNullOrBlank()
        return when {
            hasUpi && raw.isNullOrBlank() -> "Payee name is required when a UPI ID is set."
            !raw.isNullOrBlank() && raw.trim().length > 50 -> "Payee name is too long."
            else -> null
        }
    }

    fun invoicePrefix(raw: String): String? {
        val value = raw.trim().uppercase()
        return when {
            value.isEmpty() -> "Invoice prefix is required (e.g. INV)."
            value.length > 8 -> "Invoice prefix must be 8 characters or fewer."
            !value.all { it.isLetterOrDigit() || it == '-' } ->
                "Use letters, digits or '-' only."
            else -> null
        }
    }

    fun colorHex(raw: String): String? {
        val value = raw.trim().removePrefix("#")
        val ok = value.length == 6 && value.all { it.isDigit() || it.lowercaseChar() in 'a'..'f' }
        return if (ok) null else "Enter a 6-digit hex colour, e.g. 1B3A2F."
    }

    /** Parses "#1B3A2F" / "1B3A2F" into an ARGB Long, or null when invalid. */
    fun parseColorHex(raw: String): Long? {
        if (colorHex(raw) != null) return null
        val value = raw.trim().removePrefix("#")
        return 0xFF000000L or value.toLong(16)
    }

    fun toHex(argb: Long): String =
        "#" + (argb and 0xFFFFFFL).toString(16).uppercase().padStart(6, '0')
}
