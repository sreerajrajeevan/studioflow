import 'package:flutter/material.dart';

/// Sentinel [StudioBranding.logoAssetPath] value meaning "the embedded
/// original D POISE logo" (see poise_logo_data.dart). Only the D POISE
/// preset uses it; other studios keep the typographic mark until they
/// can supply their own logo.
const poiseLogoAssetKey = 'embedded:poise-logo';

/// White-label studio identity + configuration. This is the ONLY source of
/// studio name, colours, contact, tax and payment details in the app —
/// shared widgets and business logic never hardcode a brand.
///
/// Mirrors the Kotlin `StudioProfile` (legacy-android) field for field so
/// the future backend payload is identical on both generations.
@immutable
class StudioBranding {
  const StudioBranding({
    required this.businessName,
    this.tagline,
    this.logoAssetPath,
    required this.primaryColor,
    required this.secondaryColor,
    this.address = '',
    this.phone = '',
    this.email,
    this.gstin,
    this.upiId,
    this.upiPayeeName,
    this.currencyCode = 'INR',
    this.invoicePrefix = 'INV',
    this.invoiceFooter,
    this.dark = false,
  });

  final String businessName;
  final String? tagline;

  /// Path/URL of the studio logo image, or null for the typographic mark.
  final String? logoAssetPath;
  final Color primaryColor;
  final Color secondaryColor;
  final String address;
  final String phone;
  final String? email;
  final String? gstin;

  /// The studio's OWN merchant UPI details (their soundbox/PSP account).
  /// Payments are always addressed to the studio — never to us.
  final String? upiId;
  final String? upiPayeeName;
  final String currencyCode;
  final String invoicePrefix;
  final String? invoiceFooter;

  /// Dark design system (Task 5.1): near-black surfaces with the
  /// studio's primary as the accent. The D POISE preset is dark
  /// (black & gold); other presets keep the light system until their
  /// studio chooses otherwise.
  final bool dark;

  StudioBranding copyWith({
    String? businessName,
    String? tagline,
    String? logoAssetPath,
    Color? primaryColor,
    Color? secondaryColor,
    String? address,
    String? phone,
    String? email,
    String? gstin,
    String? upiId,
    String? upiPayeeName,
    String? currencyCode,
    String? invoicePrefix,
    String? invoiceFooter,
    bool? dark,
  }) {
    return StudioBranding(
      businessName: businessName ?? this.businessName,
      tagline: tagline ?? this.tagline,
      logoAssetPath: logoAssetPath ?? this.logoAssetPath,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      upiId: upiId ?? this.upiId,
      upiPayeeName: upiPayeeName ?? this.upiPayeeName,
      currencyCode: currencyCode ?? this.currencyCode,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceFooter: invoiceFooter ?? this.invoiceFooter,
      dark: dark ?? this.dark,
    );
  }
}

/// Selectable branding presets. The D POISE preset is the demonstration
/// brand (Task 1 colours) — optional, never forced on a new installation.
class BrandingPreset {
  const BrandingPreset({
    required this.id,
    required this.label,
    required this.primary,
    required this.secondary,
    this.businessName,
    this.tagline,
    this.isDemo = false,
    this.dark = false,
    this.logoAssetPath,
  });

  final String id;
  final String label;
  final Color primary;
  final Color secondary;
  final String? businessName;
  final String? tagline;
  final bool isDemo;
  final bool dark;
  final String? logoAssetPath;
}

const dpoiseDemoBranding = StudioBranding(
  businessName: 'D POISE',
  tagline: 'Groom Studio',
  primaryColor: Color(0xFFF5D442),
  secondaryColor: Color(0xFFC9A96A),
  invoicePrefix: 'DP',
  invoiceFooter: 'Thank you for visiting D POISE.',
  logoAssetPath: poiseLogoAssetKey,
  dark: true,
);

const brandingPresets = <BrandingPreset>[
  BrandingPreset(
    id: 'dpoise_demo',
    label: 'D POISE — Demo',
    primary: Color(0xFFF5D442),
    secondary: Color(0xFFC9A96A),
    businessName: 'D POISE',
    tagline: 'Groom Studio',
    isDemo: true,
    dark: true,
    logoAssetPath: poiseLogoAssetKey,
  ),
  BrandingPreset(
    id: 'classic_charcoal',
    label: 'Classic Charcoal',
    primary: Color(0xFF232323),
    secondary: Color(0xFFC9A96A),
  ),
  BrandingPreset(
    id: 'ocean',
    label: 'Ocean Blue',
    primary: Color(0xFF14486B),
    secondary: Color(0xFF7FB3D5),
  ),
  BrandingPreset(
    id: 'maroon',
    label: 'Royal Maroon',
    primary: Color(0xFF5E2129),
    secondary: Color(0xFFD4AF37),
  ),
  BrandingPreset(
    id: 'plum',
    label: 'Modern Plum',
    primary: Color(0xFF3E2A56),
    secondary: Color(0xFFB79CED),
  ),
];
