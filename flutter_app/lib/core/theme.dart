import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../branding/studio_branding.dart';
import 'motion.dart';

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


  /// The system-bar treatment for a brightness (Task 5.2): transparent
  /// bars over the app's own background (edge-to-edge), icon contrast
  /// matched to the theme. Applied app-wide via AnnotatedRegion in the
  /// app root AND on AppBars, so shell screens without an AppBar get
  /// the same correct contrast.
  static SystemUiOverlayStyle overlayStyle(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: dark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          dark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    );
  }

  static ThemeData buildTheme(StudioBranding branding) {
    if (branding.dark) return buildDarkTheme(branding);
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
      pageTransitionsTheme: appPageTransitionsTheme,
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

  // --- Dark design system (Task 5.1, D POISE black & gold) ---
  //
  // Fixed neutrals from the brief; the studio's primary is the accent
  // (gold for D POISE) and is used for emphasis, active controls, key
  // prices and primary actions — never as a wash over everything.
  static const darkBackground = Color(0xFF050505);
  static const darkSurface = Color(0xFF171717);
  static const darkCard = Color(0xFF222222);
  static const darkText = Color(0xFFFFFFFF);
  static const darkMutedText = Color(0xFFA9A9A9);
  static const darkBorder = Color(0xFF363636);

  static ThemeData buildDarkTheme(StudioBranding branding) {
    final accent = branding.primaryColor;
    final secondary = branding.secondaryColor;

    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: accent,
      onPrimary: const Color(0xFF050505),
      primaryContainer: const Color(0xFF2E2A12),
      onPrimaryContainer: accent,
      secondary: secondary,
      onSecondary: const Color(0xFF050505),
      secondaryContainer: const Color(0xFF262626),
      onSecondaryContainer: const Color(0xFFE8E8E8),
      tertiary: accent,
      onTertiary: const Color(0xFF050505),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      surface: darkSurface,
      onSurface: darkText,
      onSurfaceVariant: darkMutedText,
      surfaceContainerLowest: darkBackground,
      surfaceContainerLow: darkSurface,
      surfaceContainer: const Color(0xFF1C1C1C),
      surfaceContainerHigh: darkCard,
      surfaceContainerHighest: const Color(0xFF262626),
      outline: darkBorder,
      outlineVariant: const Color(0xFF2A2A2A),
      inverseSurface: const Color(0xFFF2F2F2),
      onInverseSurface: const Color(0xFF1C1C1C),
      inversePrimary: accent,
      shadow: Colors.black,
      scrim: Colors.black,
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: darkBackground,
      visualDensity: VisualDensity.standard,
    );

    return base.copyWith(
      pageTransitionsTheme: appPageTransitionsTheme,
      textTheme: _darkTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: darkText,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarContrastEnforced: false,
          systemStatusBarContrastEnforced: false,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: darkBorder),
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
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: darkText,
          side: const BorderSide(color: darkBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        backgroundColor: darkSurface,
        selectedColor: accent,
        checkmarkColor: const Color(0xFF050505),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: darkBorder),
        labelStyle: const TextStyle(fontFamily: 'Roboto', color: darkText),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF050505),
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        hintStyle: const TextStyle(color: darkMutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFB4AB)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color(0xFF0B0B0B),
        indicatorColor: accent.withValues(alpha: 0.22),
        selectedIconTheme: IconThemeData(color: accent, size: 24),
        unselectedIconTheme: const IconThemeData(
          color: darkMutedText,
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          color: darkMutedText,
          fontSize: 12,
        ),
        minWidth: 76,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0B0B0B),
        indicatorColor: accent.withValues(alpha: 0.25),
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? accent : darkMutedText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? accent : darkMutedText,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(color: darkBorder, thickness: 1),
      dialogTheme: const DialogThemeData(backgroundColor: darkSurface),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        modalBackgroundColor: darkSurface,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: TextStyle(color: darkText),
      ),
      popupMenuTheme: const PopupMenuThemeData(color: darkCard),
      listTileTheme: const ListTileThemeData(
        textColor: darkText,
        iconColor: darkMutedText,
      ),
    );
  }

  static TextTheme _darkTextTheme(TextTheme base) {
    return base.copyWith(
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: darkText,
        letterSpacing: -0.2,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      bodyMedium: base.bodyMedium?.copyWith(color: darkText),
      bodySmall: base.bodySmall?.copyWith(color: darkMutedText),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
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
