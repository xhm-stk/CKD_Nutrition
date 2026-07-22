import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

void main() {
  HttpOverrides.global = null;

  File envFile = File('.env');
  if (!envFile.existsSync()) {
    envFile = File('.env.dev');
  }
  String url = 'https://mock.supabase.co';
  String anonKey = 'mock_key';
  if (envFile.existsSync()) {
    final envContent = envFile.readAsStringSync();
    for (var line in envContent.split('\n')) {
      if (line.startsWith('SUPABASE_URL=')) url = line.split('=')[1].trim();
      if (line.startsWith('SUPABASE_ANON_KEY=')) {
        final parts = line.split('=');
        if (parts.length > 1) anonKey = parts.sublist(1).join('=').trim();
      }
    }
  }

  // ข้อมูลจำลองสำหรับ 5 บัญชี
  final List<Map<String, dynamic>> testUsers = [
    {
      'name': 'User 1 (Stage 1)',
      'email_prefix': 'sim_user_1',
      'weight': 75.0,
      'height': 175.0,
      'gender': 'male',
      'ckd_stage': 'stage_1',
      'meals': [
        {
          'food_id': 'F101',
          'food_name': 'ข้าวต้มหมูสับ',
          'quantity_g': 200.0,
          'meal_type': 'breakfast',
          'protein': 12.0,
          'potassium': 160.0,
          'sodium': 350.0,
          'sugar': 1.0,
          'carb': 38.0,
          'water': 150.0,
        },
        {
          'food_id': 'F102',
          'food_name': 'ผัดกะเพราไก่ไข่ดาว',
          'quantity_g': 250.0,
          'meal_type': 'lunch',
          'protein': 22.0,
          'potassium': 220.0,
          'sodium': 580.0,
          'sugar': 2.0,
          'carb': 42.0,
          'water': 100.0,
        },
        {
          'food_id': 'F103',
          'food_name': 'สลัดผักรวม',
          'quantity_g': 150.0,
          'meal_type': 'snack',
          'protein': 2.0,
          'potassium': 280.0,
          'sodium': 120.0,
          'sugar': 4.0,
          'carb': 12.0,
          'water': 80.0,
        },
        {
          'food_id': 'F104',
          'food_name': 'นมจืด',
          'quantity_g': 200.0,
          'meal_type': 'snack',
          'protein': 6.5,
          'potassium': 300.0,
          'sodium': 90.0,
          'sugar': 9.5,
          'carb': 10.0,
          'water': 180.0,
        },
        {
          'food_id': 'F105',
          'food_name': 'ข้าวกล้องอกไก่',
          'quantity_g': 300.0,
          'meal_type': 'dinner',
          'protein': 28.0,
          'potassium': 350.0,
          'sodium': 400.0,
          'sugar': 0.5,
          'carb': 50.0,
          'water': 120.0,
        },
      ],
      'expected': {
        'protein': 70.5,
        'potassium': 1310.0,
        'sodium': 1540.0,
        'sugar': 17.0,
        'carb': 152.0,
        'water': 630.0,
      },
    },
    {
      'name': 'User 2 (Stage 2)',
      'email_prefix': 'sim_user_2',
      'weight': 52.0,
      'height': 158.0,
      'gender': 'female',
      'ckd_stage': 'stage_2',
      'meals': [
        {
          'food_id': 'F201',
          'food_name': 'ขนมปังโฮลวีท',
          'quantity_g': 80.0,
          'meal_type': 'breakfast',
          'protein': 7.0,
          'potassium': 110.0,
          'sodium': 260.0,
          'sugar': 3.0,
          'carb': 32.0,
          'water': 20.0,
        },
        {
          'food_id': 'F202',
          'food_name': 'แกงจืดเต้าหู้หมูสับ',
          'quantity_g': 200.0,
          'meal_type': 'lunch',
          'protein': 11.5,
          'potassium': 180.0,
          'sodium': 320.0,
          'sugar': 1.5,
          'carb': 6.0,
          'water': 170.0,
        },
        {
          'food_id': 'F203',
          'food_name': 'มะละกอสุก',
          'quantity_g': 120.0,
          'meal_type': 'snack',
          'protein': 0.8,
          'potassium': 240.0,
          'sodium': 5.0,
          'sugar': 10.0,
          'carb': 13.0,
          'water': 100.0,
        },
        {
          'food_id': 'F204',
          'food_name': 'ปลานึ่งซีอิ๊วกับข้าวสวย',
          'quantity_g': 220.0,
          'meal_type': 'dinner',
          'protein': 18.0,
          'potassium': 210.0,
          'sodium': 450.0,
          'sugar': 2.5,
          'carb': 40.0,
          'water': 120.0,
        },
        {
          'food_id': 'F205',
          'food_name': 'ฝรั่งสุก',
          'quantity_g': 100.0,
          'meal_type': 'snack',
          'protein': 1.0,
          'potassium': 150.0,
          'sodium': 2.0,
          'sugar': 7.0,
          'carb': 11.0,
          'water': 80.0,
        },
      ],
      'expected': {
        'protein': 38.3,
        'potassium': 890.0,
        'sodium': 1037.0,
        'sugar': 24.0,
        'carb': 102.0,
        'water': 490.0,
      },
    },
    {
      'name': 'User 3 (Stage 3a)',
      'email_prefix': 'sim_user_3',
      'weight': 80.0,
      'height': 180.0,
      'gender': 'male',
      'ckd_stage': 'stage_3a',
      'meals': [
        {
          'food_id': 'F301',
          'food_name': 'โจ๊กไก่ใส่ไข่',
          'quantity_g': 250.0,
          'meal_type': 'breakfast',
          'protein': 14.0,
          'potassium': 190.0,
          'sodium': 420.0,
          'sugar': 1.0,
          'carb': 35.0,
          'water': 200.0,
        },
        {
          'food_id': 'F302',
          'food_name': 'ผัดผักกาดขาวหมูชิ้น',
          'quantity_g': 180.0,
          'meal_type': 'lunch',
          'protein': 8.5,
          'potassium': 200.0,
          'sodium': 380.0,
          'sugar': 2.0,
          'carb': 8.0,
          'water': 120.0,
        },
        {
          'food_id': 'F303',
          'food_name': 'แอปเปิ้ลเขียว',
          'quantity_g': 100.0,
          'meal_type': 'snack',
          'protein': 0.3,
          'potassium': 120.0,
          'sodium': 1.0,
          'sugar': 9.0,
          'carb': 12.0,
          'water': 85.0,
        },
        {
          'food_id': 'F304',
          'food_name': 'ปลากะพงย่างเกลือ',
          'quantity_g': 150.0,
          'meal_type': 'dinner',
          'protein': 24.0,
          'potassium': 260.0,
          'sodium': 290.0,
          'sugar': 0.0,
          'carb': 0.0,
          'water': 90.0,
        },
        {
          'food_id': 'F305',
          'food_name': 'น้ำดื่มสะอาด',
          'quantity_g': 300.0,
          'meal_type': 'snack',
          'protein': 0.0,
          'potassium': 0.0,
          'sodium': 0.0,
          'sugar': 0.0,
          'carb': 0.0,
          'water': 300.0,
        },
      ],
      'expected': {
        'protein': 46.8,
        'potassium': 770.0,
        'sodium': 1091.0,
        'sugar': 12.0,
        'carb': 55.0,
        'water': 795.0,
      },
    },
    {
      'name': 'User 4 (Stage 3b)',
      'email_prefix': 'sim_user_4',
      'weight': 58.0,
      'height': 153.0,
      'gender': 'female',
      'ckd_stage': 'stage_3b',
      'meals': [
        {
          'food_id': 'F401',
          'food_name': 'ไข่ต้ม 2 ฟอง',
          'quantity_g': 100.0,
          'meal_type': 'breakfast',
          'protein': 13.0,
          'potassium': 130.0,
          'sodium': 120.0,
          'sugar': 0.6,
          'carb': 1.0,
          'water': 75.0,
        },
        {
          'food_id': 'F402',
          'food_name': 'ผัดวุ้นเส้นใส่ไข่',
          'quantity_g': 200.0,
          'meal_type': 'lunch',
          'protein': 6.0,
          'potassium': 110.0,
          'sodium': 410.0,
          'sugar': 3.0,
          'carb': 44.0,
          'water': 80.0,
        },
        {
          'food_id': 'F403',
          'food_name': 'ส้มเขียวหวาน',
          'quantity_g': 120.0,
          'meal_type': 'snack',
          'protein': 0.8,
          'potassium': 180.0,
          'sodium': 2.0,
          'sugar': 11.0,
          'carb': 14.0,
          'water': 100.0,
        },
        {
          'food_id': 'F404',
          'food_name': 'ต้มจืดมะระโครงไก่',
          'quantity_g': 220.0,
          'meal_type': 'dinner',
          'protein': 7.5,
          'potassium': 140.0,
          'sodium': 330.0,
          'sugar': 1.2,
          'carb': 5.0,
          'water': 190.0,
        },
        {
          'food_id': 'F405',
          'food_name': 'น้ำแร่ธรรมชาติ',
          'quantity_g': 250.0,
          'meal_type': 'snack',
          'protein': 0.0,
          'potassium': 5.0,
          'sodium': 10.0,
          'sugar': 0.0,
          'carb': 0.0,
          'water': 250.0,
        },
      ],
      'expected': {
        'protein': 27.3,
        'potassium': 565.0,
        'sodium': 872.0,
        'sugar': 15.8,
        'carb': 64.0,
        'water': 695.0,
      },
    },
    {
      'name': 'User 5 (Stage 4)',
      'email_prefix': 'sim_user_5',
      'weight': 65.0,
      'height': 168.0,
      'gender': 'male',
      'ckd_stage': 'stage_4',
      'meals': [
        {
          'food_id': 'F501',
          'food_name': 'ซาลาเปาไส้ครีม',
          'quantity_g': 80.0,
          'meal_type': 'breakfast',
          'protein': 4.5,
          'potassium': 70.0,
          'sodium': 180.0,
          'sugar': 12.0,
          'carb': 36.0,
          'water': 25.0,
        },
        {
          'food_id': 'F502',
          'food_name': 'เกาเหลาลูกชิ้นปลา',
          'quantity_g': 250.0,
          'meal_type': 'lunch',
          'protein': 12.0,
          'potassium': 140.0,
          'sodium': 650.0,
          'sugar': 2.0,
          'carb': 8.0,
          'water': 210.0,
        },
        {
          'food_id': 'F503',
          'food_name': 'สับปะรด',
          'quantity_g': 100.0,
          'meal_type': 'snack',
          'protein': 0.5,
          'potassium': 110.0,
          'sodium': 1.0,
          'sugar': 10.0,
          'carb': 13.0,
          'water': 85.0,
        },
        {
          'food_id': 'F504',
          'food_name': 'ก๋วยเตี๋ยวเส้นหมี่น้ำใสอกไก่ฉีก',
          'quantity_g': 200.0,
          'meal_type': 'dinner',
          'protein': 14.5,
          'potassium': 160.0,
          'sodium': 520.0,
          'sugar': 1.5,
          'carb': 32.0,
          'water': 150.0,
        },
        {
          'food_id': 'F505',
          'food_name': 'วุ้นเส้นแกงจืดเต้าหู้ขาว',
          'quantity_g': 180.0,
          'meal_type': 'snack',
          'protein': 8.0,
          'potassium': 130.0,
          'sodium': 300.0,
          'sugar': 1.0,
          'carb': 15.0,
          'water': 140.0,
        },
      ],
      'expected': {
        'protein': 39.5,
        'potassium': 610.0,
        'sodium': 1651.0,
        'sugar': 26.5,
        'carb': 104.0,
        'water': 610.0,
      },
    },
  ];

  test(
    'E2E Simulation: Register, Set Health Profile, Log 5 Meals for 5 Accounts',
    () async {
      expect(url, isNotEmpty, reason: 'SUPABASE_URL must be defined');
      expect(anonKey, isNotEmpty, reason: 'SUPABASE_ANON_KEY must be defined');

      SupabaseClient makeClient() => SupabaseClient(
        url,
        anonKey,
        authOptions: const AuthClientOptions(
          authFlowType: AuthFlowType.implicit,
        ),
      );

      final client = makeClient();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      debugPrint(
        '================================================================',
      );
      debugPrint(
        '🚀 เริ่มต้นการรันระบบจำลองการใช้งาน (Simulation) 5 บัญชีผู้ใช้งาน',
      );
      debugPrint(
        '================================================================',
      );

      for (int i = 0; i < testUsers.length; i++) {
        final userDef = testUsers[i];
        final email = '${userDef['email_prefix']}_$timestamp@ckdtest.com';
        const password = 'Password123!';

        debugPrint(
          '\n👤 กำลังดำเนินการสำหรับผู้ใช้งานลำดับที่ ${i + 1}: ${userDef['name']}',
        );
        debugPrint('   - อีเมล: $email');

        // 1. สมัครบัญชีใหม่ (Sign Up)
        final signUpResult = await client.auth.signUp(
          email: email,
          password: password,
        );
        expect(signUpResult.user, isNotNull, reason: 'ควรสมัครสมาชิกได้สำเร็จ');
        final userId = signUpResult.user!.id;
        debugPrint('   ✅ 1. สมัครสมาชิกสำเร็จ! ID: $userId');

        // รอให้ trigger ในระบบหลังบ้านบันทึก profile สักครู่
        await Future.delayed(const Duration(milliseconds: 500));

        // 2. บันทึกข้อมูลสุขภาพ (Save Health Profile)
        debugPrint('   - กำลังบันทึกโปรไฟล์สุขภาพ:');
        debugPrint(
          '     น้ำหนัก: ${userDef['weight']} kg, ส่วนสูง: ${userDef['height']} cm, เพศ: ${userDef['gender']}, ระยะโรคไต: ${userDef['ckd_stage']}',
        );

        final profileResult =
            await client.from('user_health_profiles').upsert({
              'user_id': userId,
              'weight_kg': userDef['weight'],
              'height_cm': userDef['height'],
              'gender': userDef['gender'],
              'ckd_stage': userDef['ckd_stage'],
            }, onConflict: 'user_id').select();

        expect(profileResult, isNotEmpty, reason: 'ควรเซฟโปรไฟล์ได้สำเร็จ');
        debugPrint('   ✅ 2. บันทึกโปรไฟล์สุขภาพสำเร็จ!');

        // 3. บันทึกเมนูอาหาร 5 เมนู (Log 5 Meals)
        debugPrint('   - กำลังบันทึกมื้ออาหารจำลองจำนวน 5 มื้อ:');
        final meals = userDef['meals'] as List<Map<String, dynamic>>;
        for (int m = 0; m < meals.length; m++) {
          final meal = meals[m];
          debugPrint(
            '     -> มื้อที่ ${m + 1}: ${meal['food_name']} (${meal['quantity_g']}g)',
          );

          // เรียก RPC 'log_meal' เลียนแบบการกดบันทึกของแอป
          await client.rpc(
            'log_meal',
            params: {
              'p_food_id': meal['food_id'],
              'p_food_name': meal['food_name'],
              'p_quantity_g': meal['quantity_g'],
              'p_meal_type': meal['meal_type'],
              'p_protein': meal['protein'],
              'p_potassium': meal['potassium'],
              'p_sodium': meal['sodium'],
              'p_sugar': meal['sugar'],
              'p_carb': meal['carb'],
              'p_water': meal['water'],
            },
          );
        }
        debugPrint('   ✅ 3. บันทึกมื้ออาหารครบ 5 มื้อสำเร็จ!');

        // 4. ดึงข้อมูลสรุปรายวันเพื่อยืนยันความถูกต้อง (Verify daily log totals)
        debugPrint('   - กำลังตรวจสอบค่าสะสมในสรุปโภชนาการรายวัน (Daily Log):');
        final todayStr = DateTime.now()
            .toUtc()
            .add(const Duration(hours: 7))
            .toIso8601String()
            .substring(0, 10);

        final todayLog =
            await client
                .from('daily_logs')
                .select()
                .eq('user_id', userId)
                .eq('log_date', todayStr)
                .maybeSingle();

        expect(todayLog, isNotNull, reason: 'ควรพบสรุปของวันนี้ในระบบ');

        final expected = userDef['expected'] as Map<String, double>;

        // ดึงค่าจริงจาก DB มาเทียบ
        final actualProtein = (todayLog!['total_protein_g'] as num).toDouble();
        final actualPotassium =
            (todayLog['total_potassium_mg'] as num).toDouble();
        final actualSodium = (todayLog['total_sodium_mg'] as num).toDouble();
        final actualSugar = (todayLog['total_sugar_g'] as num).toDouble();
        final actualCarb = (todayLog['total_carb_g'] as num).toDouble();
        final actualWater = (todayLog['total_water_ml'] as num).toDouble();

        debugPrint(
          '     🧪 ผลเปรียบเทียบโภชนาการ (ค่าคาดหวัง vs ค่าบันทึกจริง):',
        );
        debugPrint(
          '        • โปรตีน: ${expected['protein']}g vs ${actualProtein}g',
        );
        debugPrint(
          '        • โพแทสเซียม: ${expected['potassium']}mg vs ${actualPotassium}mg',
        );
        debugPrint(
          '        • โซเดียม: ${expected['sodium']}mg vs ${actualSodium}mg',
        );
        debugPrint(
          '        • น้ำตาล: ${expected['sugar']}g vs ${actualSugar}g',
        );
        debugPrint(
          '        • คาร์โบไฮเดรต: ${expected['carb']}g vs ${actualCarb}g',
        );
        debugPrint(
          '        • น้ำสะอาด: ${expected['water']}ml vs ${actualWater}ml',
        );

        // ตรวจสอบค่าความถูกต้อง (ยอมรับความคลาดเคลื่อนทางทศนิยม 0.01)
        expect(actualProtein, closeTo(expected['protein']!, 0.01));
        expect(actualPotassium, closeTo(expected['potassium']!, 0.01));
        expect(actualSodium, closeTo(expected['sodium']!, 0.01));
        expect(actualSugar, closeTo(expected['sugar']!, 0.01));
        expect(actualCarb, closeTo(expected['carb']!, 0.01));
        expect(actualWater, closeTo(expected['water']!, 0.01));

        debugPrint('   ✅ 4. ยอดสะสมโภชนาการรายวันถูกต้องสมบูรณ์ 100%!');

        // ออกจากระบบ เพื่อเตรียมดำเนินการกับผู้ใช้งานคนถัดไป
        await client.auth.signOut();
        debugPrint('👤 ล็อกเอาต์สำเร็จสำหรับบัญชีนี้\n');
      }

      debugPrint(
        '================================================================',
      );
      debugPrint(
        '🎉 การทดสอบจำลอง (Simulation) 5 บัญชีสำเร็จสมบูรณ์ ไร้ข้อผิดพลาด!',
      );
      debugPrint(
        '================================================================',
      );
    },
  );
}
