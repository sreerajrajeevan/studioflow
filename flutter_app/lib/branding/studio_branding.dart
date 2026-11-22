import 'package:flutter/material.dart';

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
  });

  final String id;
  final String label;
  final Color primary;
  final Color secondary;
  final String? businessName;
  final String? tagline;
  final bool isDemo;
}

const dpoiseDemoBranding = StudioBranding(
  businessName: 'D POISE',
  tagline: 'Groom Studio',
  primaryColor: Color(0xFF1B3A2F),
  secondaryColor: Color(0xFFC9A96A),
  invoicePrefix: 'DP',
  invoiceFooter: 'Thank you for visiting D POISE.',
);

const brandingPresets = <BrandingPreset>[
  BrandingPreset(
    id: 'dpoise_demo',
    label: 'D POISE — Demo',
    primary: Color(0xFF1B3A2F),
    secondary: Color(0xFFC9A96A),
    businessName: 'D POISE',
    tagline: 'Groom Studio',
    isDemo: true,
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
