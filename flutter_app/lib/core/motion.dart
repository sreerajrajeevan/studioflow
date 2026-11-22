import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// StudioFlow motion system (Task 5.2).
///
/// One animation language for the whole app — restrained, fast, and
/// never blocking input:
///
/// - [fast] (120ms): pressed states, selection acknowledgement, badges.
/// - [standard] (200ms): page transitions, state changes, indicators.
/// - [emphasis] (300ms): the rare moment that deserves weight (sheets).
///
/// Every duration resolves through [Motion.durationOf], which returns
/// [Duration.zero] when the user has enabled reduced motion
/// (MediaQuery.disableAnimations) — motion is decoration, never a
/// requirement, and no interaction ever waits on an animation.
abstract final class Motion {
  static const fast = Duration(milliseconds: 120);
  static const standard = Duration(milliseconds: 200);
  static const emphasis = Duration(milliseconds: 300);

  /// Ease-out for things arriving; things should start quick and settle.
  static const curve = Curves.easeOutCubic;
  static const curveEmphasis = Curves.easeInOutCubic;

  /// The token duration, or zero under reduced motion.
  static Duration durationOf(BuildContext context, Duration token) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : token;

  /// Subtle selection haptic where the platform supports it.
  /// Fire-and-forget: a POS tap must never wait on, or fail because of,
  /// the vibrator.
  static void selectionHaptic() {
    try {
      HapticFeedback.selectionClick();
    } catch (_) {
      // Unsupported platform — feedback is optional by design.
    }
  }
}

/// Page transition for the whole app: a short fade with a small upward
/// settle — consistent in both directions, no exaggerated sliding.
/// Under reduced motion the page simply appears.
class FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Motion.curve,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.012),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// The transitions theme applied by both the light and dark themes.
const appPageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeSlidePageTransitionsBuilder(),
    TargetPlatform.iOS: FadeSlidePageTransitionsBuilder(),
    TargetPlatform.macOS: FadeSlidePageTransitionsBuilder(),
    TargetPlatform.linux: FadeSlidePageTransitionsBuilder(),
    TargetPlatform.windows: FadeSlidePageTransitionsBuilder(),
  },
);
