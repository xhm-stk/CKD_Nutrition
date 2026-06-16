import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:ckd_nutrition_app/providers/meal_providers.dart';
import 'package:ckd_nutrition_app/repositories/meal_repository.dart';
import 'package:ckd_nutrition_app/services/offline_sync_worker.dart';

import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockOfflineSyncWorker extends Mock implements OfflineSyncWorker {}
class MockIsar extends Mock implements Isar {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Providers Test', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late MockOfflineSyncWorker mockSyncWorker;
    late MockIsar mockIsar;
    late MockSharedPreferences mockPrefs;
    late ProviderContainer container;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      mockSyncWorker = MockOfflineSyncWorker();
      mockIsar = MockIsar();
      mockPrefs = MockSharedPreferences();
      when(() => mockSupabase.auth).thenReturn(mockAuth);

      container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabase),
          offlineSyncWorkerProvider.overrideWithValue(mockSyncWorker),
          isarProvider.overrideWithValue(mockIsar),
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('mealRepositoryProvider should return MealRepository', () {
      final repo = container.read(mealRepositoryProvider);
      expect(repo, isA<MealRepository>());
    });

    test('todayMealsProvider returns empty list if user is null', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      // We need to wait for the FutureProvider
      final result = await container.read(todayMealsProvider.future);
      expect(result, isEmpty);
    });
  });
}
