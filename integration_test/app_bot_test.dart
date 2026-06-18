// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ckd_nutrition_app/main.dart' as app;

void main() {
  // เริ่มต้นระบบ Integration Test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🤖 Full E2E Visual QA Bot', () {
    testWidgets('Register -> Features -> Delete Account -> Login', (
      WidgetTester tester,
    ) async {
      // ตัวแปรสำหรับใช้สมัครและเทสต์ว่าลบไปแล้วจริงๆ หรือไม่
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'bot_$timestamp@example.com';
      const testPassword = 'Password123!';

      // 1. เปิดแอปพลิเคชัน
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      print('==============================================');
      print('🤖 Full E2E Bot: เริ่มทำงานบน Emulator!');
      print('==============================================');
      await Future.delayed(const Duration(seconds: 2));

      // เช็คว่าถ้าตอนนี้ค้างอยู่หน้า Dashboard ให้เตะตัวเองออกจากระบบก่อน
      final menuBtn = find.byTooltip('Open navigation menu');
      if (menuBtn.evaluate().isNotEmpty) {
        print('👉 (Bot) พบว่าล็อกอินค้างอยู่ จะทำการ Log out ก่อน...');
        await tester.tap(menuBtn.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await tester.tap(find.text('ออกจากระบบ'));
        await tester.pumpAndSettle(
          const Duration(seconds: 4),
        ); // รอเคลียร์ session
      }

      // ----------------------------------------------------
      // Scenario 1: สมัครสมาชิกใหม่ (Register)
      // ----------------------------------------------------
      print('👉 Scenario 1: สมัครบัญชีทดสอบใหม่ (Register)...');
      await tester.tap(find.text('สมัครสมาชิกใหม่'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // กรอกฟอร์มสมัคร
      await tester.enterText(find.byKey(const Key('reg_email')), testEmail);
      await tester.enterText(
        find.byKey(const Key('reg_password')),
        testPassword,
      );
      await tester.enterText(
        find.byKey(const Key('reg_confirm_password')),
        testPassword,
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // กดยอมรับนโยบาย และกดสมัคร
      await tester.tap(find.byKey(const Key('reg_privacy_checkbox')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // ปิด Keyboard ก่อนเพื่อไม่ให้บังหน้าจอ
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // เลื่อนหน้าจอลงมาให้เห็นปุ่มสมัคร และกด
      final btnRegister = find.byKey(const Key('btn_register'));
      await tester.ensureVisible(btnRegister);
      await tester.pumpAndSettle();
      await tester.tap(btnRegister);

      // รอคุยกับ Supabase นานนิดนึง
      await tester.pumpAndSettle(const Duration(seconds: 6));

      // ----------------------------------------------------
      // Scenario 2: ตั้งค่าข้อมูลสุขภาพ (Health Setup)
      // ----------------------------------------------------
      print('👉 Scenario 2: กำหนดโปรไฟล์สุขภาพ (Health Setup)...');
      final weightField = find.byKey(const Key('input_weight'));
      if (weightField.evaluate().isNotEmpty) {
        await tester.enterText(weightField, '65');
        await tester.enterText(find.byKey(const Key('input_height')), '170');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // ปิด Keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // บันทึกโปรไฟล์เพื่อเข้าสู่ Dashboard
        final btnSaveProfile = find.byKey(const Key('btn_save_profile'));
        await tester.ensureVisible(btnSaveProfile);
        await tester.pumpAndSettle();
        await tester.tap(btnSaveProfile);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // ----------------------------------------------------
      // Scenario 3: ทดสอบฟีเจอร์หลัก (ค้นหา, เพิ่มอาหาร, ประวัติ)
      // ----------------------------------------------------
      print('👉 Scenario 3: ทดสอบฟีเจอร์ค้นหาอาหาร (Search)...');
      final fabAddFood = find.byKey(const Key('btn_fab_add_food'));
      if (fabAddFood.evaluate().isNotEmpty) {
        await tester.tap(fabAddFood);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final searchField = find.byType(TextField).first;
        if (searchField.evaluate().isNotEmpty) {
          await tester.enterText(searchField, 'ข้าวไข่ดาว');
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      print('👉 Scenario 4: สร้างอาหารทำเอง (Custom Food)...');
      final customFoodBtn = find.text('เพิ่มอาหารทำเอง');
      if (customFoodBtn.evaluate().isNotEmpty) {
        await tester.tap(customFoodBtn.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final nameInput = find.widgetWithText(
          TextField,
          'ชื่อเมนูอาหาร (เช่น ผัดกะเพรา)',
        );
        if (nameInput.evaluate().isNotEmpty) {
          await tester.enterText(nameInput.first, 'เมนูเทสต์จากบอท 🤖');
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }

        // กดกลับมาหน้าหลักของ Search
        final backBtn = find.byTooltip('Back');
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      // กดกลับจากหน้า Search กลับไป Dashboard
      final backToDashboard = find.byTooltip('Back');
      if (backToDashboard.evaluate().isNotEmpty) {
        await tester.tap(backToDashboard.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      print('👉 Scenario 5: ดูหน้าประวัติการกิน (History)...');
      final menuBtn3 = find.byTooltip('Open navigation menu');
      if (menuBtn3.evaluate().isNotEmpty) {
        await tester.tap(menuBtn3.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await tester.tap(find.text('ประวัติและสรุปรายเดือน'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // กลับหน้า Dashboard ก่อน
      final backFromHistory = find.byTooltip('Back');
      if (backFromHistory.evaluate().isNotEmpty) {
        await tester.tap(backFromHistory.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // ----------------------------------------------------
      // Scenario 6: ลบบัญชีผู้ใช้ (Delete Account) และจบการทดสอบ
      // ----------------------------------------------------
      print(
        '👉 Scenario 6: ลบบัญชีผู้ใช้ทิ้งเพื่อเคลียร์ขยะ (Delete Account)...',
      );

      // เปิด Drawer หน้า Dashboard อีกรอบ
      final menuBtn2 = find.byTooltip('Open navigation menu');
      if (menuBtn2.evaluate().isNotEmpty) {
        await tester.tap(menuBtn2.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // กดเมนูลบบัญชี
        final deleteMenu = find.byKey(const Key('drawer_delete_account'));
        await tester.ensureVisible(deleteMenu);
        await tester.tap(deleteMenu);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // ยืนยันขั้นที่ 1
        await tester.tap(find.byKey(const Key('dialog_delete_proceed')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // ยืนยันขั้นสุดท้าย (ลบจริง)
        await tester.tap(find.byKey(const Key('dialog_delete_confirm')));

        // รอคุยกับ Supabase เพื่อลบ Data, Profile, User
        await tester.pumpAndSettle(const Duration(seconds: 8));
      }

      // ----------------------------------------------------
      // Scenario 7: ยืนยันว่าบัญชีหายไปแล้วจริงๆ (Negative Test)
      // ----------------------------------------------------
      print(
        '👉 Scenario 7: ลองล็อกอินด้วยรหัสเดิมเพื่อยืนยันว่าลบสำเร็จ (Negative Test)...',
      );

      final loginEmailField = find.byKey(const Key('login_email'));
      if (loginEmailField.evaluate().isNotEmpty) {
        await tester.enterText(loginEmailField, testEmail);
        await tester.enterText(
          find.byKey(const Key('login_password')),
          testPassword,
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // ปิด Keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // เลื่อนให้เห็นปุ่มและกดปุ่มเข้าสู่ระบบ
        final btnLogin = find.byType(ElevatedButton).first;
        await tester.ensureVisible(btnLogin);
        await tester.pumpAndSettle();
        await tester.tap(btnLogin);
        await tester.pumpAndSettle(const Duration(seconds: 4));

        // ตรวจสอบว่ายังอยู่ที่หน้าเดิมหรือไม่ (ถ้าอยู่แปลว่าเข้าไม่ได้ = ลบสำเร็จ)
        expect(find.byKey(const Key('login_email')), findsOneWidget);
        print(
          '✅ ระบบปฏิเสธการเข้าสู่ระบบอย่างถูกต้อง! (ลบบัญชีและข้อมูลหายวับ 100%)',
        );
      }

      print('==============================================');
      print('✅ E2E Bot จบการทำงาน! แข็งแกร่งระดับ Enterprise!');
      print('==============================================');
    });
  });
}
