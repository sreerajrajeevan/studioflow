import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../branding/brand_logo.dart';
import '../branding/studio_branding.dart';
import 'state.dart';

/// Branded startup view (Task 5.1). Shown as the first route; [main]
/// has already completed initialization (database, profile, draft
/// recovery) before the first frame, so this view adds NO artificial
/// delay — it forwards to the billing flow on the first post-frame
/// callback.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go('/billing');
    });
  }

  @override
  Widget build(BuildContext context) {
    final branding = ref.watch(brandingProvider);
    return Scaffold(body: SplashView(branding: branding));
  }
}

/// The splash's visual content, separated from navigation so tests and
/// screenshots can render it directly. The original logo keeps its
/// proportions and transparency on the brand background.
class SplashView extends StatelessWidget {
  const SplashView({super.key, required this.branding});

  final StudioBranding branding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BrandLogo(branding: branding, size: 230),
                    if (branding.logoAssetPath != poiseLogoAssetKey) ...[
                      const SizedBox(height: 18),
                      Text(
                        branding.businessName,
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (branding.tagline != null)
                        Text(
                          branding.tagline!,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Text(
                'Powered by StudioFlow',
                style: theme.textTheme.bodySmall?.copyWith(
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
