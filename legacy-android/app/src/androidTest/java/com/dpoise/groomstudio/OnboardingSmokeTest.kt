package com.dpoise.groomstudio

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithText
import org.junit.Rule
import org.junit.Test

/**
 * Fresh-install behaviour depends on device state: with no profile the
 * wizard must show; after setup the dashboard must show. On a fresh test
 * install (no profile) the wizard assertion applies.
 */
class OnboardingSmokeTest {
    @get:Rule
    val composeRule = createAndroidComposeRule<MainActivity>()

    @Test
    fun appLaunches_toWizardOrDashboard() {
        val wizard = runCatching {
            composeRule.onNodeWithText("Welcome to StudioFlow").assertIsDisplayed()
            true
        }.getOrDefault(false)
        if (!wizard) {
            // Setup already completed on this device — dashboard must render.
            composeRule.onNodeWithText("Quick actions").assertIsDisplayed()
        }
    }
}
