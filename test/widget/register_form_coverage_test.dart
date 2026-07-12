import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/core/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ckd_nutrition_app/pages/auth/widgets/register_form.dart';
import 'package:ckd_nutrition_app/repositories/auth_repository.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

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
  Future<Result<void>> register(
    String email,
    String password, {
    String? name,
  }) async {
    return Success(null);
  }
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
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en', ''), Locale('th', '')],
          locale: Locale('th', ''),
          home: Scaffold(body: RegisterForm()),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    // expect(find.byType(TextFormField), findsWidgets);

    expect(find.text('สมัครสมาชิกใหม่'), findsOneWidget);
  });
}
