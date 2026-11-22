import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studioflow/data/database.dart';
import 'package:studioflow/data/providers.dart';
import 'package:studioflow/data/repositories_impl.dart';

/// Shared test fixture: ONE in-memory database per test file, seeded with
/// the sample catalog, injected wherever the app asks for its database —
/// widget tests must never touch the on-device file database (its
/// path_provider channel does not exist under the test engine).
Future<Override> seededTestDatabase() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedSampleDataIfEmpty(db);
  return appDatabaseProvider.overrideWithValue(db);
}
