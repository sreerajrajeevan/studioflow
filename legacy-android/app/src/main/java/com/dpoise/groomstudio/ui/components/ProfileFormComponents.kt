package com.dpoise.groomstudio.ui.components

import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.dpoise.groomstudio.domain.model.BrandPresets
import com.dpoise.groomstudio.ui.theme.Branding
import com.dpoise.groomstudio.ui.theme.Spacing
import com.dpoise.groomstudio.util.ProfileValidation

@Composable
fun FormTextField(
    label: String,
    value: String,
    onValueChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    error: String? = null,
    supportingText: String? = null,
    singleLine: Boolean = true,
    minLines: Int = 1
) {
    OutlinedTextField(
        value = value,
        onValueChange = onValueChange,
        label = { Text(label) },
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = Spacing.touchTarget),
        isError = error != null,
        supportingText = {
            when {
                error != null -> Text(error, color = MaterialTheme.colorScheme.error)
                supportingText != null -> Text(supportingText)
            }
        },
        singleLine = singleLine,
        minLines = minLines,
        shape = MaterialTheme.shapes.medium
    )
}

/** Logo preview + Pick/Remove, via the system photo picker (no permissions). */
@Composable
fun LogoPickerRow(
    logoPath: String?,
    businessName: String,
    onLogoPicked: (android.net.Uri?) -> Unit,
    onRemoveLogo: () -> Unit,
    modifier: Modifier = Modifier
) {
    val picker = rememberLauncherForActivityResult(
        ActivityResultContracts.PickVisualMedia()
    ) { uri -> onLogoPicked(uri) }

    Row(modifier = modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        StudioLogo(
            logoPath = logoPath,
            businessName = businessName.ifBlank { "Studio" },
            modifier = Modifier.size(72.dp)
        )
        Spacer(Modifier.width(16.dp))
        Column {
            OutlinedButton(
                onClick = {
                    picker.launch(
                        PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
                    )
                },
                modifier = Modifier.heightIn(min = Spacing.touchTarget),
                shape = MaterialTheme.shapes.medium
            ) { Text(if (logoPath == null) "Choose logo image" else "Change logo") }
            if (logoPath != null) {
                Spacer(Modifier.height(4.dp))
                Box(
                    modifier = Modifier
                        .heightIn(min = Spacing.touchTarget)
                        .clip(MaterialTheme.shapes.small)
                        .clickable(onClick = onRemoveLogo)
                        .padding(horizontal = 12.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        "Remove logo",
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.error
                    )
                }
            }
            Text(
                "Stored privately on this device. Square images look best.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

/**
 * Brand colour picker: preset swatches (incl. the D POISE demo colours),
 * preset bundles, and a custom hex field. Contrast is checked live and the
 * effective on-colour is previewed.
 */
@Composable
fun BrandColorPicker(
    primaryArgb: Long,
    secondaryArgb: Long,
    appliedPresetId: String?,
    onPrimaryChange: (Long) -> Unit,
    onSecondaryChange: (Long) -> Unit,
    onApplyPreset: (com.dpoise.groomstudio.domain.model.BrandPreset) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Text("Brand presets", style = MaterialTheme.typography.titleSmall)
        Spacer(Modifier.height(8.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            BrandPresets.all.forEach { preset ->
                val selected = appliedPresetId == preset.id
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Box(
                        modifier = Modifier
                            .size(52.dp)
                            .clip(CircleShape)
                            .background(Branding.colorFromArgb(preset.primaryColorArgb))
                            .border(
                                width = if (selected) 3.dp else 1.dp,
                                color = if (selected) MaterialTheme.colorScheme.primary
                                else MaterialTheme.colorScheme.outline,
                                shape = CircleShape
                            )
                            .clickable { onApplyPreset(preset) },
                        contentAlignment = Alignment.Center
                    ) {
                        Box(
                            modifier = Modifier
                                .size(18.dp)
                                .clip(CircleShape)
                                .background(Branding.colorFromArgb(preset.secondaryColorArgb))
                        )
                    }
                    Text(
                        preset.label,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }

        Spacer(Modifier.height(20.dp))
        ColorHexField(
            label = "Primary colour",
            argb = primaryArgb,
            onArgbChange = onPrimaryChange
        )
        Spacer(Modifier.height(12.dp))
        ColorHexField(
            label = "Secondary / accent colour",
            argb = secondaryArgb,
            onArgbChange = onSecondaryChange
        )

        Spacer(Modifier.height(16.dp))
        BrandingPreview(primaryArgb = primaryArgb, secondaryArgb = secondaryArgb)
    }
}

@Composable
private fun ColorHexField(
    label: String,
    argb: Long,
    onArgbChange: (Long) -> Unit
) {
    var text by remember(argb) { mutableStateOf(ProfileValidation.toHex(argb)) }
    val error = ProfileValidation.colorHex(text)
    Row(verticalAlignment = Alignment.CenterVertically) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(MaterialTheme.shapes.medium)
                .background(Branding.colorFromArgb(argb))
                .border(1.dp, MaterialTheme.colorScheme.outline, MaterialTheme.shapes.medium)
        )
        Spacer(Modifier.width(14.dp))
        OutlinedTextField(
            value = text,
            onValueChange = { newText ->
                text = newText
                ProfileValidation.parseColorHex(newText)?.let(onArgbChange)
            },
            label = { Text(label) },
            isError = error != null,
            supportingText = {
                if (error != null) Text(error, color = MaterialTheme.colorScheme.error)
                else Text("Hex, e.g. ${ProfileValidation.toHex(argb)}")
            },
            singleLine = true,
            modifier = Modifier
                .weight(1f)
                .heightIn(min = Spacing.touchTarget),
            shape = MaterialTheme.shapes.medium
        )
    }
}

/** Mini preview proving text stays readable on the chosen colours. */
@Composable
fun BrandingPreview(primaryArgb: Long, secondaryArgb: Long, modifier: Modifier = Modifier) {
    val primary = Branding.ensureReadablePrimary(Branding.colorFromArgb(primaryArgb))
    val secondary = Branding.colorFromArgb(secondaryArgb)
    val onPrimary = Branding.onColorFor(primary)
    val aaOk = Branding.meetsAa(onPrimary, primary)
    Column(
        modifier = modifier
            .fillMaxWidth()
            .clip(MaterialTheme.shapes.large)
            .background(primary)
            .padding(18.dp)
    ) {
        Text(
            "Theme preview",
            style = MaterialTheme.typography.titleMedium,
            color = onPrimary
        )
        Text(
            "Buttons, sidebar and invoice accents will use this colour. " +
                if (aaOk) "Text contrast passes WCAG AA." else "Colour was deepened slightly so text stays readable.",
            style = MaterialTheme.typography.bodySmall,
            color = onPrimary.copy(alpha = 0.85f)
        )
        Spacer(Modifier.height(10.dp))
        Box(
            modifier = Modifier
                .clip(MaterialTheme.shapes.medium)
                .background(secondary)
                .padding(horizontal = 14.dp, vertical = 9.dp)
        ) {
            Text(
                "Accent",
                style = MaterialTheme.typography.labelLarge,
                color = Branding.onColorFor(secondary)
            )
        }
    }
}
