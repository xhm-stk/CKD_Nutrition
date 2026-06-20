import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/providers/auth_providers.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {
  @override
  GoTrueClient get auth => MockGoTrueClient();
}

class MockGoTrueClient extends Mock implements GoTrueClient {
  @override
  Stream<AuthState> get onAuthStateChange => const Stream.empty();

  @override
  User? get currentUser => const User(
    id: 'test-user',
    appMetadata: {},
    userMetadata: {},
    aud: 'authenticated',
    createdAt: '2026-06-16T00:00:00Z',
  );
}

void main() {
  test('authProviders initialization', () {
    final container = ProviderContainer(
      overrides: [supabaseProvider.overrideWith((ref) => MockSupabaseClient())],
    );

    // Test authStateProvider
    final authStream = container.read(authStateProvider);
    expect(authStream, isA<Stream<AuthState>>());

    // Test sessionUnlockedProvider
    final isUnlocked = container.read(sessionUnlockedProvider);
    expect(isUnlocked, false);
  });
}
