package com.dpoise.groomstudio

import android.app.Application
import com.dpoise.groomstudio.di.AppContainer

/**
 * Application class for StudioFlow (white-label studio management platform).
 * The Android package/applicationId intentionally remain
 * `com.dpoise.groomstudio` from Task 1 — renaming them would break installs
 * and Room identity for the first customer; the product identity lives in
 * code/naming, not in the package.
 */
class StudioFlowApp : Application() {
    lateinit var container: AppContainer
        private set

    override fun onCreate() {
        super.onCreate()
        container = AppContainer(this)
    }
}
