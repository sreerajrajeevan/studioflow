package com.dpoise.groomstudio.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.dpoise.groomstudio.ui.components.BrandColorPicker
import com.dpoise.groomstudio.ui.components.BrandingPreview
import com.dpoise.groomstudio.ui.components.FormTextField
import com.dpoise.groomstudio.ui.components.LogoPickerRow
import com.dpoise.groomstudio.ui.components.StudioLogo
import com.dpoise.groomstudio.ui.theme.Spacing
import com.dpoise.groomstudio.util.ProfileValidation
import com.dpoise.groomstudio.viewmodel.SetupViewModel

private val STEP_TITLES = listOf(
    "Your studio" to "Tell us about the business. This appears on invoices and the app sidebar.",
    "Studio logo" to "Optional — add your logo now or later in Settings.",
    "Brand colour" to "Pick a preset or your own colour. Text stays readable automatically.",
    "Payments" to "Optional — add your UPI details to accept QR payments later. You can skip this.",
    "Confirm" to "Check everything looks right, then start using StudioFlow."
)

/**
 * First-run wizard. Shown only while no StudioProfile exists; finishing
 * writes the profile and the root gate swaps to the dashboard. Fully
 * offline, no account or registration.
 */
@Composable
fun SetupScreen(viewModel: SetupViewModel) {
    val step by viewModel.step.collectAsState()
    val form by viewModel.form.collectAsState()
    val saving by viewModel.saving.collectAsState()
    val saveError by viewModel.saveError.collectAsState()

    val canContinue = when (step) {
        0 -> form.step1Valid
        3 -> form.upiValid
        else -> true
    }

    BoxWithConstraints(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        val horizontalPad = if (maxWidth >= 840.dp) 48.dp else 24.dp
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = horizontalPad, vertical = 28.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Column(Modifier.widthIn(max = 760.dp).fillMaxWidth()) {
                Text(
                    "Welcome to StudioFlow",
                    style = MaterialTheme.typography.headlineMedium
                )
                Text(
                    "Set up your studio in under a minute. Everything stays on this device.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(Modifier.height(20.dp))

                Text(
                    "Step ${step + 1} of ${STEP_TITLES.size} — ${STEP_TITLES[step].first}",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(Modifier.height(8.dp))
                LinearProgressIndicator(
                    progress = { (step + 1f) / STEP_TITLES.size },
                    modifier = Modifier.fillMaxWidth(),
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(Modifier.height(6.dp))
                Text(
                    STEP_TITLES[step].second,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(Modifier.height(24.dp))

                when (step) {
                    0 -> {
                        FormTextField(
                            label = "Business name *",
                            value = form.businessName,
                            onValueChange = { viewModel.update { f -> f.copy(businessName = it) } },
                            error = if (form.businessName.isNotEmpty() || form.businessNameError == null)
                                form.businessNameError else "Business name is required."
                        )
                        Spacer(Modifier.height(14.dp))
                        FormTextField(
                            label = "Tagline (optional)",
                            value = form.tagline,
                            onValueChange = { viewModel.update { f -> f.copy(tagline = it) } },
                            error = form.taglineError,
                            supportingText = "e.g. Groom Studio, Unisex Salon"
                        )
                        Spacer(Modifier.height(14.dp))
                        FormTextField(
                            label = "Studio address",
                            value = form.address,
                            onValueChange = { viewModel.update { f -> f.copy(address = it) } },
                            singleLine = false, minLines = 2
                        )
                        Spacer(Modifier.height(14.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                            FormTextField(
                                label = "Phone",
                                value = form.phone,
                                onValueChange = { v -> viewModel.update { f -> f.copy(phone = v) } },
                                error = form.phoneError,
                                modifier = Modifier.weight(1f)
                            )
                            FormTextField(
                                label = "Email (optional)",
                                value = form.email,
                                onValueChange = { v -> viewModel.update { f -> f.copy(email = v) } },
                                error = form.emailError,
                                modifier = Modifier.weight(1f)
                            )
                        }
                        Spacer(Modifier.height(14.dp))
                        FormTextField(
                            label = "GSTIN (optional)",
                            value = form.gstin,
                            onValueChange = { viewModel.update { f -> f.copy(gstin = it) } },
                            error = form.gstinError,
                            supportingText = "Printed on invoices when provided."
                        )
                    }

                    1 -> {
                        LogoPickerRow(
                            logoPath = form.logoPath,
                            businessName = form.businessName,
                            onLogoPicked = viewModel::onLogoPicked,
                            onRemoveLogo = viewModel::removeLogo
                        )
                    }

                    2 -> {
                        BrandColorPicker(
                            primaryArgb = form.primaryColorArgb,
                            secondaryArgb = form.secondaryColorArgb,
                            appliedPresetId = form.appliedPresetId,
                            onPrimaryChange = { argb ->
                                viewModel.update { f -> f.copy(primaryColorArgb = argb, appliedPresetId = null) }
                            },
                            onSecondaryChange = { argb ->
                                viewModel.update { f -> f.copy(secondaryColorArgb = argb, appliedPresetId = null) }
                            },
                            onApplyPreset = { preset ->
                                viewModel.update { f -> f.applyPreset(preset) }
                            }
                        )
                        if (form.appliedPresetId == "dpoise_demo") {
                            Spacer(Modifier.height(10.dp))
                            Text(
                                "Demo preset applied — name and colours filled from the D POISE demonstration brand. Edit anything freely.",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }

                    3 -> {
                        FormTextField(
                            label = "UPI ID (optional)",
                            value = form.upiId,
                            onValueChange = { viewModel.update { f -> f.copy(upiId = it) } },
                            error = form.upiIdError,
                            supportingText = "Format: yourname@bank — used for payment QR codes."
                        )
                        Spacer(Modifier.height(14.dp))
                        FormTextField(
                            label = "UPI payee name",
                            value = form.upiPayeeName,
                            onValueChange = { viewModel.update { f -> f.copy(upiPayeeName = it) } },
                            error = form.upiPayeeError,
                            supportingText = "The name customers see when paying."
                        )
                    }

                    4 -> {
                        Card(
                            shape = MaterialTheme.shapes.large,
                            colors = CardDefaults.cardColors(
                                containerColor = MaterialTheme.colorScheme.surface
                            ),
                            border = androidx.compose.foundation.BorderStroke(
                                1.dp, MaterialTheme.colorScheme.outline
                            )
                        ) {
                            Column(Modifier.padding(20.dp)) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    StudioLogo(
                                        logoPath = form.logoPath,
                                        businessName = form.businessName,
                                        modifier = Modifier.height(56.dp).width(56.dp)
                                    )
                                    Spacer(Modifier.width(14.dp))
                                    Column {
                                        Text(
                                            form.businessName,
                                            style = MaterialTheme.typography.titleLarge,
                                            fontWeight = FontWeight.SemiBold
                                        )
                                        if (form.tagline.isNotBlank()) {
                                            Text(
                                                form.tagline,
                                                style = MaterialTheme.typography.bodyMedium,
                                                color = MaterialTheme.colorScheme.onSurfaceVariant
                                            )
                                        }
                                    }
                                }
                                Spacer(Modifier.height(14.dp))
                                SummaryLine("Address", form.address.ifBlank { "—" })
                                SummaryLine("Phone", form.phone.ifBlank { "—" })
                                SummaryLine("Email", form.email.ifBlank { "—" })
                                SummaryLine("GSTIN", form.gstin.ifBlank { "—" })
                                SummaryLine(
                                    "UPI",
                                    if (form.upiId.isBlank()) "Not set (can add later)"
                                    else "${form.upiId} · ${form.upiPayeeName}"
                                )
                                SummaryLine("Brand colour", ProfileValidation.toHex(form.primaryColorArgb))
                                SummaryLine("Invoice prefix", form.invoicePrefix.ifBlank { "INV" })
                            }
                        }
                        Spacer(Modifier.height(16.dp))
                        BrandingPreview(
                            primaryArgb = form.primaryColorArgb,
                            secondaryArgb = form.secondaryColorArgb
                        )
                    }
                }

                if (saveError != null) {
                    Spacer(Modifier.height(16.dp))
                    Text(
                        saveError,
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.error
                    )
                }

                Spacer(Modifier.height(28.dp))
                Row(
                    Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    if (step > 0) {
                        OutlinedButton(
                            onClick = viewModel::back,
                            modifier = Modifier.heightIn(min = Spacing.touchTarget),
                            shape = MaterialTheme.shapes.medium
                        ) { Text("Back") }
                    } else {
                        Spacer(Modifier.width(1.dp))
                    }
                    if (step < SetupViewModel.LAST_STEP) {
                        Button(
                            onClick = viewModel::next,
                            enabled = canContinue,
                            modifier = Modifier.heightIn(min = 52.dp),
                            shape = MaterialTheme.shapes.medium
                        ) {
                            Text(
                                if (step == 3 && form.upiId.isBlank()) "Skip & continue" else "Continue",
                                style = MaterialTheme.typography.labelLarge
                            )
                        }
                    } else {
                        Button(
                            onClick = viewModel::finish,
                            enabled = form.allValid && !saving,
                            modifier = Modifier.heightIn(min = 52.dp),
                            shape = MaterialTheme.shapes.medium
                        ) {
                            if (saving) {
                                CircularProgressIndicator(
                                    modifier = Modifier.height(20.dp).width(20.dp),
                                    color = MaterialTheme.colorScheme.onPrimary,
                                    strokeWidth = 2.dp
                                )
                                Spacer(Modifier.width(10.dp))
                            }
                            Text("Finish setup", style = MaterialTheme.typography.labelLarge)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun SummaryLine(label: String, value: String) {
    Row(
        Modifier
            .fillMaxWidth()
            .padding(vertical = 5.dp)
    ) {
        Text(
            label,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.width(110.dp)
        )
        Text(value, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Medium)
    }
}
