package com.dpoise.groomstudio.util

import java.text.NumberFormat
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale

/** Money is stored as paise (Long) everywhere — never Float/Double. */
object CurrencyFormatter {
    private val inr: NumberFormat = NumberFormat.getCurrencyInstance(Locale("en", "IN"))

    fun formatPaise(paise: Long): String = inr.format(paise / 100.0)

    /** Compact label for stat cards, e.g. ₹12,450 */
    fun formatPaiseCompact(paise: Long): String {
        val rupees = paise / 100
        return "₹" + NumberFormat.getNumberInstance(Locale("en", "IN")).format(rupees)
    }
}

object DateTimeUtil {
    private val dayFmt = DateTimeFormatter.ofPattern("EEE, d MMM yyyy", Locale.ENGLISH)
    private val timeFmt = DateTimeFormatter.ofPattern("hh:mm a", Locale.ENGLISH)
    private val shortDayFmt = DateTimeFormatter.ofPattern("d MMM", Locale.ENGLISH)

    fun today(): LocalDate = LocalDate.now()

    fun formatDay(date: LocalDate): String = date.format(dayFmt)

    fun formatShortDay(epochDay: Long): String =
        LocalDate.ofEpochDay(epochDay).format(shortDayFmt)

    fun formatTime(millis: Long): String =
        Instant.ofEpochMilli(millis).atZone(ZoneId.systemDefault()).format(timeFmt)

    fun greeting(): String {
        val hour = java.time.LocalTime.now().hour
        return when {
            hour < 12 -> "Good morning"
            hour < 17 -> "Good afternoon"
            else -> "Good evening"
        }
    }
}

/** Result wrapper for repository calls so the UI never crashes on a data error. */
sealed interface AppResult<out T> {
    data class Success<T>(val data: T) : AppResult<T>
    data class Failure(val message: String, val cause: Throwable? = null) : AppResult<Nothing>
}
