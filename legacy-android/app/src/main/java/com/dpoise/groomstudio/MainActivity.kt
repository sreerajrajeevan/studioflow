package com.dpoise.groomstudio

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.dpoise.groomstudio.navigation.StudioFlowNavHost
import com.dpoise.groomstudio.ui.screens.SetupScreen
import com.dpoise.groomstudio.ui.theme.BrandFontFamily
import com.dpoise.groomstudio.ui.theme.StudioFlowTheme
import com.dpoise.groomstudio.viewmodel.SetupViewModel
import com.dpoise.groomstudio.viewmodel.StudioProfileViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val container = (application as StudioFlowApp).container
        setContent {
            val profileViewModel: StudioProfileViewModel = viewModel(
                factory = StudioProfileViewModel.Factory(container.studioProfileRepository)
            )
            val gate by profileViewModel.gateState.collectAsState()

            when (val state = gate) {
                is StudioProfileViewModel.GateState.Loading -> {
                    StudioFlowTheme(null) {
                        Surface(modifier = Modifier.fillMaxSize()) {
                            Box(
                                Modifier
                                    .fillMaxSize()
                                    .background(MaterialTheme.colorScheme.background),
                                contentAlignment = Alignment.Center
                            ) {
                                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                    Text(
                                        "StudioFlow",
                                        style = MaterialTheme.typography.headlineMedium,
                                        fontFamily = BrandFontFamily
                                    )
                                    Spacer(Modifier.height(16.dp))
                                    CircularProgressIndicator(
                                        color = MaterialTheme.colorScheme.primary
                                    )
                                }
                            }
                        }
                    }
                }

                is StudioProfileViewModel.GateState.Loaded -> {
                    val profile = state.profile
                    // Once a profile exists it drives the whole app theme.
                    // During setup (profile == null) the product default
                    // palette is used; the wizard's BrandingPreview card
                    // shows the picked colours before they are saved.
                    StudioFlowTheme(profile) {
                        Surface(modifier = Modifier.fillMaxSize()) {
                            if (profile == null) {
                                val setupViewModel: SetupViewModel = viewModel(
                                    factory = SetupViewModel.Factory(
                                        container.studioProfileRepository,
                                        container.logoStorage
                                    )
                                )
                                SetupScreen(viewModel = setupViewModel)
                            } else {
                                StudioFlowNavHost(profile = profile)
                            }
                        }
                    }
                }
            }
        }
    }
}
