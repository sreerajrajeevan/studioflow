import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/state.dart';
import 'core/theme.dart';
import 'data/providers.dart';
import 'data/repositories_impl.dart';
import 'features/billing/cart.dart';

/// Startup sequence:
/// 1. Open the database and seed the sample catalog on first run.
/// 2. Load the saved studio profile (branding) if one exists.
/// 3. RECOVER the most recent unfinished draft into the cart — if the app
///    crashed or the tablet lost power mid-bill, the bill is simply there
///    again, with the same draft id, quantities and snapshot prices.
/// Any storage failure still starts the app on in-memory demo state:
/// a POS that won't open is worse than one that can't persist.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  try {
    final db = container.read(appDatabaseProvider);
    await seedSampleDataIfEmpty(db);
    final profile =
        await container.read(studioConfigRepositoryProvider).load();
    if (profile != null) {
      container.read(brandingProvider.notifier).state = profile;
    }
    final drafts = await container.read(draftStoreProvider).listDrafts();
    if (drafts.isNotEmpty) {
      container.read(cartProvider.notifier).restore(drafts.first);
      container.read(draftAutosaverProvider).noteClean(drafts.first);
    }
  } catch (_) {
    // Persistence unavailable — continue in-memory (see header comment).
  }
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StudioFlowApp(),
    ),
  );
}

/// StudioFlow — white-label salon & studio management (Flutter).
/// The active [brandingProvider] drives the entire theme; no widget or
/// business rule hardcodes a studio.
class StudioFlowApp extends ConsumerWidget {
  const StudioFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(persistenceBootstrapProvider);
    final branding = ref.watch(brandingProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'StudioFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.buildTheme(branding),
      routerConfig: router,
    );
  }
}
