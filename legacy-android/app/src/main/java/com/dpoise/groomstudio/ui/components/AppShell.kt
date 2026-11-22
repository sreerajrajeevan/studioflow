package com.dpoise.groomstudio.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.dpoise.groomstudio.navigation.Destination
import com.dpoise.groomstudio.ui.theme.BrandFontFamily
import com.dpoise.groomstudio.ui.theme.Charcoal800
import com.dpoise.groomstudio.ui.theme.Ivory50
import com.dpoise.groomstudio.ui.theme.Spacing

/**
 * Responsive shell:
 *  - width >= 840dp (landscape tablet): permanent expanded sidebar (264dp)
 *    with brand block, labels and footer.
 *  - 600–839dp (portrait tablet / large phone): icon rail (80dp).
 *  - < 600dp (phone): top brand bar + bottom navigation, so every module
 *    stays one tap away without crushing content.
 */
@Composable
fun AppShell(
    current: Destination,
    onNavigate: (Destination) -> Unit,
    studioName: String,
    studioTagline: String?,
    studioLogoPath: String?,
    content: @Composable () -> Unit
) {
    BoxWithConstraints(Modifier.fillMaxSize()) {
        when {
            maxWidth >= 840.dp -> Row(Modifier.fillMaxSize()) {
                Sidebar(expanded = true, current = current, onNavigate = onNavigate, studioName = studioName, studioTagline = studioTagline, studioLogoPath = studioLogoPath)
                Box(Modifier.weight(1f).fillMaxHeight()) { content() }
            }
            maxWidth >= 600.dp -> Row(Modifier.fillMaxSize()) {
                Sidebar(expanded = false, current = current, onNavigate = onNavigate, studioName = studioName, studioTagline = studioTagline, studioLogoPath = studioLogoPath)
                Box(Modifier.weight(1f).fillMaxHeight()) { content() }
            }
            else -> Column(Modifier.fillMaxSize()) {
                TopBrandBar(studioName = studioName, studioTagline = studioTagline, studioLogoPath = studioLogoPath)
                Box(Modifier.weight(1f).fillMaxWidth()) { content() }
                BottomNavBar(current = current, onNavigate = onNavigate)
            }
        }
    }
}

@Composable
private fun Sidebar(
    expanded: Boolean,
    current: Destination,
    onNavigate: (Destination) -> Unit,
    studioName: String,
    studioTagline: String?,
    studioLogoPath: String?
) {
    Column(
        modifier = Modifier
            .width(if (expanded) Spacing.sidebarExpanded else Spacing.sidebarRail)
            .fillMaxHeight()
            .background(Charcoal800)
            .padding(vertical = 20.dp, horizontal = if (expanded) 16.dp else 10.dp)
    ) {
        if (expanded) BrandBlockExpanded(studioName, studioTagline, studioLogoPath) else BrandMarkCompact(studioName, studioLogoPath)
        Spacer(Modifier.height(28.dp))
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            Destination.entries.forEach { dest ->
                SidebarItem(
                    dest = dest,
                    selected = dest == current,
                    expanded = expanded,
                    onClick = { onNavigate(dest) }
                )
            }
        }
        HorizontalDivider(color = Ivory50.copy(alpha = 0.14f))
        Spacer(Modifier.height(12.dp))
        if (expanded) {
            Text(
                "Offline mode — data stays on this device",
                style = MaterialTheme.typography.bodySmall,
                color = Ivory50.copy(alpha = 0.6f)
            )
            Text(
                "StudioFlow · v1.1.0",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.secondary
            )
        } else {
            Text(
                "v1.1",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.secondary,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

@Composable
private fun BrandBlockExpanded(studioName: String, studioTagline: String?, studioLogoPath: String?) {
    Column(Modifier.padding(horizontal = 8.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            StudioLogo(
                logoPath = studioLogoPath,
                businessName = studioName,
                modifier = Modifier.size(44.dp)
            )
            Spacer(Modifier.width(12.dp))
            Column {
                Text(
                    studioName.uppercase(),
                    style = MaterialTheme.typography.titleLarge,
                    fontFamily = BrandFontFamily,
                    fontWeight = FontWeight.SemiBold,
                    color = Ivory50
                )
                Text(
                    (studioTagline ?: "StudioFlow").uppercase(),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.secondary
                )
            }
        }
    }
}

@Composable
private fun BrandMarkCompact(studioName: String, studioLogoPath: String?) {
    Box(
        modifier = Modifier.fillMaxWidth(),
        contentAlignment = Alignment.Center
    ) {
        StudioLogo(
            logoPath = studioLogoPath,
            businessName = studioName,
            modifier = Modifier.size(44.dp)
        )
    }
}

@Composable
private fun SidebarItem(
    dest: Destination,
    selected: Boolean,
    expanded: Boolean,
    onClick: () -> Unit
) {
    val bg = if (selected) Ivory50.copy(alpha = 0.12f) else androidx.compose.ui.graphics.Color.Transparent
    val fg = if (selected) Ivory50 else Ivory50.copy(alpha = 0.68f)
    val accent = if (selected) MaterialTheme.colorScheme.secondary else androidx.compose.ui.graphics.Color.Transparent
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .heightIn(min = Spacing.touchTarget)
            .clip(MaterialTheme.shapes.small)
            .background(bg)
            .clickable(onClick = onClick)
            .padding(horizontal = if (expanded) 12.dp else 0.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = if (expanded) Arrangement.Start else Arrangement.Center
    ) {
        Box(
            modifier = Modifier
                .width(3.dp)
                .height(22.dp)
                .background(accent)
        )
        Spacer(Modifier.width(if (expanded) 10.dp else 6.dp))
        Icon(dest.icon, contentDescription = dest.label, tint = fg, modifier = Modifier.size(22.dp))
        if (expanded) {
            Spacer(Modifier.width(12.dp))
            Text(
                dest.label,
                style = MaterialTheme.typography.labelLarge,
                color = fg,
                fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium
            )
        }
    }
}

@Composable
private fun TopBrandBar(studioName: String, studioTagline: String?, studioLogoPath: String?) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(Charcoal800)
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        StudioLogo(
            logoPath = studioLogoPath,
            businessName = studioName,
            modifier = Modifier.size(36.dp)
        )
        Spacer(Modifier.width(10.dp))
        Column {
            Text(
                studioName.uppercase(),
                style = MaterialTheme.typography.titleMedium,
                fontFamily = BrandFontFamily,
                color = Ivory50,
                fontWeight = FontWeight.SemiBold
            )
            Text(
                (studioTagline ?: "StudioFlow").uppercase(),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.secondary
            )
        }
    }
}

@Composable
private fun BottomNavBar(current: Destination, onNavigate: (Destination) -> Unit) {
    // Phones: first five modules in the bar; the rest remain reachable from
    // the Dashboard quick actions. Full 9-item navigation is a tablet pattern.
    val primary = listOf(
        Destination.Dashboard, Destination.NewBill, Destination.Attendance,
        Destination.Salary, Destination.Settings
    )
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(Ivory50)
            .padding(horizontal = 4.dp, vertical = 6.dp),
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        primary.forEach { dest ->
            val selected = dest == current
            Column(
                modifier = Modifier
                    .heightIn(min = Spacing.touchTarget)
                    .clip(MaterialTheme.shapes.small)
                    .clickable { onNavigate(dest) }
                    .padding(horizontal = 10.dp, vertical = 6.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    dest.icon, contentDescription = dest.label,
                    tint = if (selected) MaterialTheme.colorScheme.primary
                    else MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.size(22.dp)
                )
                Text(
                    dest.label,
                    style = MaterialTheme.typography.labelSmall,
                    color = if (selected) MaterialTheme.colorScheme.primary
                    else MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
