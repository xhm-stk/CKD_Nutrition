import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ckd_nutrition_app/main.dart' as app;

// Use 'flutter test integration_test/app_master_test.dart' to run

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Master E2E Test: CKD Nutrition App', () {
    testWidgets(
      'Full Lifecycle: Register -> Setup -> Use Features -> Delete Account',
      (WidgetTester tester) async {
        final uniqueEmail =
            'qa_auto_${DateTime.now().millisecondsSinceEpoch}@example.com';
        app.main();
        await tester.pumpAndSettle();

        debugPrint(
          '▶ [1] กำลังทดสอบ: การลงทะเบียนบัญชีใหม่ (อีเมล: $uniqueEmail)',
        );
        // Wait for login screen
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tap "สมัครสมาชิกใหม่" or "Sign Up" to navigate to Register Page
        var registerTab = find.text('สมัครสมาชิกใหม่');
        if (registerTab.evaluate().isEmpty) {
          registerTab = find.text('Sign Up');
        }
        if (registerTab.evaluate().isNotEmpty) {
          await tester.tap(registerTab);
          await tester.pumpAndSettle();
        }

        // Enter registration details
        await tester.enterText(find.byKey(const Key('reg_email')), uniqueEmail);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('reg_password')),
          'Password123!',
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('reg_confirm_password')),
          'Password123!',
        );
        await tester.pumpAndSettle();

        // Check privacy policy
        await tester.tap(find.byKey(const Key('reg_privacy_checkbox')));
        await tester.pumpAndSettle();

        // Close keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        // Register
        await tester.tap(find.byKey(const Key('btn_register')));

        // Wait for network request and navigation
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Try login if it didn't auto login or if user already exists
        final loginEmailField = find.byKey(const Key('login_email'));
        if (loginEmailField.evaluate().isNotEmpty) {
          debugPrint('▶ เข้าสู่ระบบด้วยบัญชีที่สมัครไว้...');
          await tester.tap(find.text('เข้าสู่ระบบ'));
          await tester.pumpAndSettle();
          await tester.enterText(loginEmailField, uniqueEmail);
          await tester.enterText(
            find.byKey(const Key('login_password')),
            'Password123!',
          );
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('btn_login')));
          await tester.pumpAndSettle(const Duration(seconds: 5));
        }

        debugPrint('▶ [2] กำลังทดสอบ: กรอกข้อมูลสุขภาพพื้นฐาน');
        // Verify we are on health setup page
        expect(find.text('ข้อมูลสุขภาพของคุณ'), findsOneWidget);

        await tester.enterText(find.byKey(const Key('input_weight')), '65.5');
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('input_height')), '170');
        await tester.pumpAndSettle();

        // Close keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        // Select Stage 3b
        await tester.tap(find.byKey(const Key('dropdown_ckd_stage')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('ระยะที่ 3b').last);
        await tester.pumpAndSettle();

        // Save profile
        await tester.tap(find.byKey(const Key('btn_save_profile')));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        debugPrint('▶ [3] กำลังทดสอบ: หน้าแดชบอร์ดและการประมวลผล');
        expect(find.text('โภชนาการวันนี้'), findsOneWidget);

        // Scroll and click FAB
        debugPrint('▶ [4] กำลังทดสอบ: ค้นหาอาหารและบันทึก');
        await tester.tap(find.byKey(const Key('btn_fab_add_food')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // In search page
        await tester.enterText(
          find.byKey(const Key('input_search_food')),
          'ข้าว',
        );
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Close keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        // Tap on the first search result (e.g. ข้าวสวย)
        final firstFoodItem = find.byType(ListTile).first;
        if (firstFoodItem.evaluate().isNotEmpty) {
          await tester.tap(firstFoodItem);
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Bottom sheet
          await tester.enterText(find.byKey(const Key('input_portion')), '1');
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('btn_confirm_eat')));
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        debugPrint('▶ [5] กำลังทดสอบ: หน้าเพิ่มอาหารเอง (Custom Food)');
        // Click FAB again
        await tester.tap(find.byKey(const Key('btn_fab_add_food')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Click Add Custom Food icon in app bar
        await tester.tap(find.byKey(const Key('btn_add_custom_food_page')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Fill custom food form
        await tester.enterText(
          find.byKey(const Key('custom_food_name')),
          'เมนูทดสอบ E2E',
        );
        await tester.enterText(
          find.byKey(const Key('custom_food_protein')),
          '5',
        );
        await tester.enterText(
          find.byKey(const Key('custom_food_sodium')),
          '100',
        );
        await tester.enterText(
          find.byKey(const Key('custom_food_potassium')),
          '50',
        );
        await tester.enterText(find.byKey(const Key('custom_food_sugar')), '0');
        await tester.enterText(find.byKey(const Key('custom_food_carb')), '10');
        await tester.enterText(find.byKey(const Key('custom_food_water')), '0');

        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        // Scroll to save button if needed
        await tester.ensureVisible(
          find.byKey(const Key('btn_save_custom_food')),
        );
        await tester.tap(find.byKey(const Key('btn_save_custom_food')));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Go back to Dashboard
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
        } else {
          await tester.tap(find.byTooltip('Back'));
        }
        await tester.pumpAndSettle();

        debugPrint('▶ [6] กำลังทดสอบ: กลับหน้าแดชบอร์ด ดูประวัติเมนู');
        expect(find.text('โภชนาการวันนี้'), findsOneWidget);

        // Scroll down dashboard
        await tester.drag(
          find.byKey(const Key('dashboard_scrollview')),
          const Offset(0, -500),
        );
        await tester.pumpAndSettle();

        debugPrint('▶ [7] กำลังทดสอบ: กดลบบัญชีถาวร (Clean up)');
        // Open Drawer
        final ScaffoldState state = tester.firstState(find.byType(Scaffold));
        state.openDrawer();
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Click Delete Account in drawer
        await tester.tap(find.byKey(const Key('drawer_delete_account')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // First Dialog -> Proceed
        await tester.tap(find.byKey(const Key('dialog_delete_proceed')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Second Dialog -> Confirm
        await tester.tap(find.byKey(const Key('dialog_delete_confirm')));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Expect to be back at Login page
        expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
        debugPrint('✅ Master E2E Test Completed Successfully!');
      },
    );
  });
}
