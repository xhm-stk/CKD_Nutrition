import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ckd_nutrition_app/pages/auth/widgets/register_form.dart';
import 'package:ckd_nutrition_app/repositories/auth_repository.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {
  @override
  GoTrueClient get auth => MockGoTrueClient();
}

class MockGoTrueClient extends Mock implements GoTrueClient {
  @override
  User? get currentUser => null;
}

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? name,
  }) async {}
}

void main() {
  testWidgets('RegisterForm Coverage Test', (tester) async {
    final mockSupabase = MockSupabaseClient();
    final mockAuthRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supabaseProvider.overrideWith((ref) => mockSupabase),
          authRepositoryProvider.overrideWith((ref) => mockAuthRepo),
        ],
        child: const MaterialApp(home: Scaffold(body: RegisterForm())),
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    // expect(find.byType(TextFormField), findsWidgets);

    final saveButton = find.text('สร้างบัญชีผู้ใช้');
  });
}
