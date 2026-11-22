import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../app/app_shell.dart';
import 'poise_logo_data.dart';
import 'studio_branding.dart';

Uint8List? _cachedLogoBytes;

/// The decoded original logo bytes, decoded once and cached.
Uint8List poiseLogoBytes() =>
    _cachedLogoBytes ??= base64Decode(poiseLogoBase64Chunks.join());

/// The studio's logo as it should appear in headers and splash views:
/// the ORIGINAL artwork for a branding that carries one, otherwise the
/// typographic [BrandMark]. The artwork is never redrawn or restyled.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.branding, this.size = 44});

  final StudioBranding branding;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (branding.logoAssetPath == poiseLogoAssetKey) {
      return Image.memory(
        poiseLogoBytes(),
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      );
    }
    return BrandMark(branding: branding, size: size);
  }
}
