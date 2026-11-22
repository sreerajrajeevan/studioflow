package com.dpoise.groomstudio.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.CloudUpload
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.dpoise.groomstudio.ui.components.BrandColorPicker
import com.dpoise.groomstudio.ui.components.EmptyState
import com.dpoise.groomstudio.ui.components.FormTextField
import com.dpoise.groomstudio.ui.components.LogoPickerRow
import com.dpoise.groomstudio.ui.components.ScreenHeader
import com.dpoise.groomstudio.ui.theme.Spacing
import com.dpoise.groomstudio.viewmodel.SettingsViewModel

/**
 * Business Settings — edits the live StudioProfile. Everything saves to the
 * local database and re-themes the app immediately. Historical invoices are
 * NOT affected: they carry their own studio snapshot (Task 1.5 design).
 */
@Composable
fun SettingsScreen(viewModel: SettingsViewModel) {
    val form by viewModel.form.collectAsState()
    val savedMessage by viewModel.savedMessage.collectAsState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 28.dp, vertical = 24.dp)
    ) {
        ScreenHeader(
            title = "Business Settings",
            subtitle = "Your studio's details, branding and billing configuration."
        )
        Spacer(Modifier.height(24.dp))

        val current = form
        if (current == null) {
            CircularProgressIndicator(color = MaterialTheme.colorScheme.primary)
            return@Column
        }

        SettingsSection(title = "Business Details") {
            FormTextField(
                label = "Business name *",
                value = current.businessName,
                onValueChange = { viewModel.update { f -> f.copy(businessName = it) } },
                error = current.businessNameError
            )
            Spacer(Modifier.height(12.dp))
            FormTextField(
                label = "Tagline (optional)",
                value = current.tagline,
                onValueChange = { viewModel.update { f -> f.copy(tagline = it) } },
                error = current.taglineError
            )
            Spacer(Modifier.height(12.dp))
            FormTextField(
                label = "Address",
                value = current.address,
                onValueChange = { viewModel.update { f -> f.copy(address = it) } },
                singleLine = false, minLines = 2
            )
            Spacer(Modifier.height(12.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                FormTextField(
                    label = "Phone",
                    value = current.phone,
                    onValueChange = { v -> viewModel.update { f -> f.copy(phone = v) } },
                    error = current.phoneError,
                    modifier = Modifier.weight(1f)
                )
                FormTextField(
                    label = "Email (optional)",
                    value = current.email,
                    onValueChange = { v -> viewModel.update { f -> f.copy(email = v) } },
                    error = current.emailError,
                    modifier = Modifier.weight(1f)
                )
            }
            Spacer(Modifier.height(12.dp))
            FormTextField(
                label = "GSTIN (optional)",
                value = current.gstin,
                onValueChange = { viewModel.update { f -> f.copy(gstin = it) } },
                error = current.gstinError,
                supportingText = "Printed on invoices when provided."
            )
        }

        SettingsSection(title = "Branding") {
            LogoPickerRow(
                logoPath = current.logoPath,
                businessName = current.businessName,
                onLogoPicked = viewModel::onLogoPicked,
                onRemoveLogo = viewModel::removeLogo
            )
            Spacer(Modifier.height(20.dp))
            BrandColorPicker(
                primaryArgb = current.primaryColorArgb,
                secondaryArgb = current.secondaryColorArgb,
                appliedPresetId = current.appliedPresetId,
                onPrimaryChange = { argb ->
                    viewModel.update { f -> f.copy(primaryColorArgb = argb, appliedPresetId = null) }
                },
                onSecondaryChange = { argb ->
                    viewModel.update { f -> f.copy(secondaryColorArgb = argb, appliedPresetId = null) }
                },
                onApplyPreset = { preset ->
                    // In Settings a preset changes colours only — never the name.
                    viewModel.update { f ->
                        f.copy(
                            primaryColorArgb = preset.primaryColorArgb,
                            secondaryColorArgb = preset.secondaryColorArgb,
                            appliedPresetId = preset.id
                        )
                    }
                }
            )
        }

        SettingsSection(title = "Billing Configuration") {
            Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                FormTextField(
                    label = "Invoice prefix",
                    value = current.invoicePrefix,
                    onValueChange = { v -> viewModel.update { f -> f.copy(invoicePrefix = v) } },
                    error = current.invoicePrefixError,
                    supportingText = "e.g. INV → INV-0001",
                    modifier = Modifier.weight(1f)
                )
                Column(Modifier.weight(1f).padding(top = 8.dp)) {
                    Text("Currency", style = MaterialTheme.typography.labelLarge)
                    Text(
                        "INR (₹) — the supported currency in this version.",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            Spacer(Modifier.height(12.dp))
            FormTextField(
                label = "Invoice footer message (optional)",
                value = current.invoiceFooter,
                onValueChange = { viewModel.update { f -> f.copy(invoiceFooter = it) } },
                supportingText = "e.g. Thank you for visiting us!",
                singleLine = false, minLines = 2
            )
            Spacer(Modifier.height(6.dp))
            Text(
                "Note: editing these details never changes invoices already issued — each bill keeps a snapshot of the details from its own date.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }

        SettingsSection(title = "Payment Details") {
            FormTextField(
                label = "UPI ID (optional)",
                value = current.upiId,
                onValueChange = { viewModel.update { f -> f.copy(upiId = it) } },
                error = current.upiIdError,
                supportingText = "Format: yourname@bank — used for payment QR codes."
            )
            Spacer(Modifier.height(12.dp))
            FormTextField(
                label = "UPI payee name",
                value = current.upiPayeeName,
                onValueChange = { viewModel.update { f -> f.copy(upiPayeeName = it) } },
                error = current.upiPayeeError
            )
        }

        SettingsSection(title = "Data Management") {
            EmptyState(
                title = "Backup & restore — coming later",
                message = "Your data lives only in this device's local database. Cloud backup and export/import will appear here in a future update.",
                icon = Icons.Outlined.CloudUpload
            )
        }

        if (savedMessage != null) {
            Text(
                savedMessage,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier.padding(bottom = 12.dp)
            )
        }

        Button(
            onClick = {
                viewModel.clearSavedMessage()
                viewModel.save()
            },
            enabled = current.allValid,
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(min = 52.dp),
            shape = MaterialTheme.shapes.medium
        ) {
            Text("Save settings", style = MaterialTheme.typography.labelLarge)
        }
        Spacer(Modifier.height(32.dp))
    }
}

@Composable
private fun SettingsSection(
    title: String,
    content: @Composable androidx.compose.foundation.layout.ColumnScope.() -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 20.dp),
        shape = MaterialTheme.shapes.large,
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(Modifier.padding(20.dp)) {
            Text(title, style = MaterialTheme.typography.titleLarge)
            Spacer(Modifier.height(16.dp))
            content()
        }
    }
}
