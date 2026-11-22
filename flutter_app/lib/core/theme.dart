import 'package:flutter/material.dart';
import '../branding/studio_branding.dart';

/// Centralised theme construction from a [StudioBranding].
///
/// Rules carried over from the Kotlin design system:
/// - The studio's colours drive the scheme — never wallpaper/dynamic colour.
/// - Foregrounds are auto-derived by WCAG contrast; a too-light primary is
///   deepened until ivory text passes AA on it.
/// - Premium minimal: ivory surfaces, charcoal text, restrained shadows,
///   generous radii, 48dp+ touch targets.
class ThemeConfig {
  static const ivory = Color(0xFFF7F3EB);
  static const ivorySurface = Color(0xFFFBF9F4);
  static const charcoal = Color(0xFF232323);
  static const charcoalText = Color(0xFF1C1C1C);
  static const mutedText = Color(0xFF4A4A4A);
  static const outline = Color(0xFFDDD6C6);

  static ThemeData buildTheme(StudioBranding branding) {
    final rawPrimary = branding.primaryColor;
    final primary = ensureReadablePrimary(rawPrimary);
    final secondary = branding.secondaryColor;

    final scheme = ColorScheme.fromSeed(
      seedColor: rawPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      onPrimary: onColorFor(primary),
      primaryContainer: containerTint(rawPrimary),
      onPrimaryContainer: shade(rawPrimary),
      secondary: secondary,
      onSecondary: onColorFor(secondary),
      secondaryContainer: containerTint(secondary),
      onSecondaryContainer: shade(secondary),
      surface: ivorySurface,
      onSurface: charcoalText,
      surfaceContainerLowest: ivorySurface,
      surfaceContainerLow: ivory,
      onSurfaceVariant: mutedText,
      outline: outline,
      outlineVariant: const Color(0xFFE3DCC8),
      error: const Color(0xFFB3261E),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ivory,
      visualDensity: VisualDensity.standard,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: ivory,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: charcoalText,
      ),
      cardTheme: CardThemeData(
        color: ivorySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outline),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: outline),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ivorySurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: charcoal,
        indicatorColor: Colors.white.withValues(alpha: 0.14),
        selectedIconTheme: const IconThemeData(color: ivorySurface, size: 24),
        unselectedIconTheme: IconThemeData(
          color: ivorySurface.withValues(alpha: 0.65),
          size: 24,
        ),
        selectedLabelTextStyle: const TextStyle(
          color: ivorySurface,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: ivorySurface.withValues(alpha: 0.65),
          fontSize: 12,
        ),
        minWidth: 76,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ivorySurface,
        indicatorColor: containerTint(rawPrimary),
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? primary : mutedText,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(color: outline, thickness: 1),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: charcoalText,
        letterSpacing: -0.2,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: charcoalText,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: charcoalText,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: charcoalText,
      ),
      bodyMedium: base.bodyMedium?.copyWith(color: charcoalText),
      bodySmall: base.bodySmall?.copyWith(color: mutedText),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  // --- Contrast helpers (ported from the Kotlin Branding object) ---

  /// Best foreground (near-black or ivory) to sit ON [background].
  static Color onColorFor(Color background) {
    const dark = Color(0xFF1C1C1C);
    const light = Color(0xFFFBF9F4);
    return contrastRatio(background, dark) >= contrastRatio(background, light)
        ? dark
        : light;
  }

  static double contrastRatio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final lighter = la > lb ? la : lb;
    final darker = la > lb ? lb : la;
    return (lighter + 0.05) / (darker + 0.05);
  }

  static bool meetsAa(Color fg, Color bg) => contrastRatio(fg, bg) >= 4.5;

  static Color containerTint(Color color) => Color.from(
        alpha: 1,
        red: color.r + (1 - color.r) * 0.86,
        green: color.g + (1 - color.g) * 0.86,
        blue: color.b + (1 - color.b) * 0.86,
      );

  static Color shade(Color color) => Color.from(
        alpha: 1,
        red: color.r * 0.82,
        green: color.g * 0.82,
        blue: color.b * 0.82,
      );

  /// Deepens a too-light primary until ivory text passes WCAG AA on it.
  static Color ensureReadablePrimary(Color color) {
    var candidate = color;
    var guard = 0;
    while (!meetsAa(const Color(0xFFFBF9F4), candidate) && guard < 12) {
      candidate = shade(candidate);
      guard++;
    }
    return candidate;
  }
}
