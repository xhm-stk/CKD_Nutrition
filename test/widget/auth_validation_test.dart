import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ckd_nutrition_app/pages/auth/login_page.dart';
import 'package:ckd_nutrition_app/repositories/auth_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginPage Validation Tests', () {
    late MockAuthRepository mockAuthRepo;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('th', ''),
          ],
          home: LoginPage(),
        ),
      );
    }

    testWidgets('Shows validation errors on empty submission', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap on login button (which has text 'Login' or 'เข้าสู่ระบบ')
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      expect(find.text('กรุณากรอกอีเมล'), findsOneWidget);
      expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);
    });

    testWidgets('Shows validation error on invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      expect(find.text('กรุณากรอกอีเมลที่ถูกต้อง'), findsOneWidget);
      expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);
    });
  });
}
