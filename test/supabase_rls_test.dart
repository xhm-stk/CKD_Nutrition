import 'dart:io';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

void main() {
  HttpOverrides.global = null;

  final envFile = File('.env').readAsStringSync();
  String url = '';
  String anonKey = '';
  for (var line in envFile.split('\n')) {
    if (line.startsWith('SUPABASE_URL=')) url = line.split('=')[1].trim();
    if (line.startsWith('SUPABASE_ANON_KEY=')) {
      anonKey = line.substring(18).trim();
    }
  }

  // ตัวแปรเก็บผลทดสอบ
  int passed = 0;
  int failed = 0;
  final List<String> failedTests = [];

  /// ฟังก์ชันช่วยบันทึกผลแต่ละเทส
  void recordResult(String name, bool success, [String? detail]) {
    if (success) {
      passed++;
      debugPrint('🛡️ $name: ผ่าน!${detail != null ? " ($detail)" : ""}');
    } else {
      failed++;
      failedTests.add(name);
      debugPrint('🚨 $name: ไม่ผ่าน!${detail != null ? " ($detail)" : ""}');
    }
  }

  test('Comprehensive Supabase RLS Security Audit', () async {
    expect(url, isNotEmpty, reason: 'SUPABASE_URL must be defined');
    expect(anonKey, isNotEmpty, reason: 'SUPABASE_ANON_KEY must be defined');

    SupabaseClient makeClient() => SupabaseClient(
      url,
      anonKey,
      authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
    );

    final client = makeClient();

    debugPrint(
      '================================================================',
    );
    debugPrint('🚀 Comprehensive RLS Security Audit — CKD Nutrition App');
    debugPrint(
      '================================================================',
    );

    String generateRandomEmail() {
      final rand = Random().nextInt(1000000);
      return 'test_rls_$rand@example.com';
    }

    // =================================================================
    // PHASE 1: สร้าง User A + ข้อมูลครบ (profiles, health, daily_logs, meals)
    // =================================================================
    debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📌 PHASE 1: สร้างข้อมูลทดสอบของ User A');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final emailA = generateRandomEmail();
    final authA = await client.auth.signUp(
      email: emailA,
      password: 'TestPassword123!',
    );
    expect(authA.user, isNotNull);
    final userAId = authA.user!.id;
    debugPrint('✅ User A สมัครสำเร็จ: $userAId');

    // 1.1 ตรวจสอบว่า profiles ถูกสร้างจาก Trigger
    final profileA =
        await client.from('profiles').select().eq('id', userAId).maybeSingle();
    debugPrint('✅ Profile ของ User A: ${profileA != null ? "พบ" : "ไม่พบ"}');

    // 1.2 เพิ่มข้อมูลสุขภาพ
    final healthA =
        await client.from('user_health_profiles').insert({
          'user_id': userAId,
          'weight_kg': 65.0,
          'height_cm': 170.0,
          'gender': 'male',
          'ckd_stage': 'stage_3a',
        }).select();
    expect(healthA, isNotEmpty);
    debugPrint('✅ Health Profile ของ User A บันทึกสำเร็จ');

    // 1.3 เพิ่ม daily_log
    final logA =
        await client.from('daily_logs').insert({
          'user_id': userAId,
          'log_date': '2026-06-09',
        }).select();
    expect(logA, isNotEmpty);
    final logAId = logA[0]['id'];
    debugPrint('✅ Daily Log ของ User A บันทึกสำเร็จ (id: $logAId)');

    // 1.4 เพิ่ม meal เข้าไปใน log ของ User A
    String? mealAId;
    try {
      final mealA =
          await client.from('meals').insert({
            'log_id': logAId,
            'food_id': 'F001',
            'food_name': 'ข้าวต้มหมู',
            'quantity_g': 200,
            'meal_type': 'breakfast',
            'protein_g': 10.0,
            'potassium_mg': 150.0,
            'sodium_mg': 300.0,
            'sugar_g': 2.0,
            'carb_g': 40.0,
            'water_ml': 180.0,
          }).select();
      mealAId = mealA.isNotEmpty ? mealA[0]['id'].toString() : null;
      debugPrint('✅ Meal ของ User A บันทึกสำเร็จ (id: $mealAId)');
    } on PostgrestException catch (e) {
      debugPrint(
        '⚠️ ตาราง meals อาจยังไม่มี RLS หรือ schema ไม่ตรง: ${e.message}',
      );
    }

    await client.auth.signOut();
    debugPrint('👋 ล็อกเอาต์ User A');

    // =================================================================
    // PHASE 2: สร้าง User B แล้วโจมตีข้อมูลของ User A ทุกรูปแบบ
    // =================================================================
    debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📌 PHASE 2: ทดสอบการโจมตีข้อมูลข้ามบัญชี (User B → User A)');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final emailB = generateRandomEmail();
    final authB = await client.auth.signUp(
      email: emailB,
      password: 'TestPassword456!',
    );
    expect(authB.user, isNotNull);
    final userBId = authB.user!.id;
    debugPrint('✅ User B สมัครสำเร็จ: $userBId');

    // ---------- SELECT Tests (อ่านข้อมูลคนอื่น) ----------
    debugPrint('\n🔎 กลุ่มที่ 1: ทดสอบการแอบอ่านข้อมูลคนอื่น (SELECT)');

    // Check 1: profiles
    final s1 = await client.from('profiles').select().eq('id', userAId);
    recordResult(
      'Check 1: SELECT profiles ของ User A',
      s1.isEmpty,
      'ผลลัพธ์: $s1',
    );

    // Check 2: user_health_profiles
    final s2 = await client
        .from('user_health_profiles')
        .select()
        .eq('user_id', userAId);
    recordResult(
      'Check 2: SELECT health ของ User A',
      s2.isEmpty,
      'ผลลัพธ์: $s2',
    );

    // Check 3: daily_logs
    final s3 = await client.from('daily_logs').select().eq('user_id', userAId);
    recordResult(
      'Check 3: SELECT daily_logs ของ User A',
      s3.isEmpty,
      'ผลลัพธ์: $s3',
    );

    // Check 4: meals (ถ้ามี)
    try {
      final s4 = await client.from('meals').select().eq('log_id', logAId);
      recordResult(
        'Check 4: SELECT meals ของ User A',
        s4.isEmpty,
        'ผลลัพธ์: $s4',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 4: SELECT meals ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // ---------- UPDATE Tests (แก้ไขข้อมูลคนอื่น) ----------
    debugPrint('\n✏️ กลุ่มที่ 2: ทดสอบการแอบแก้ไขข้อมูลคนอื่น (UPDATE)');

    // Check 5: UPDATE profiles
    try {
      final u1 =
          await client
              .from('profiles')
              .update({'display_name': 'HACKED'})
              .eq('id', userAId)
              .select();
      recordResult(
        'Check 5: UPDATE profiles ของ User A',
        u1.isEmpty,
        'ผลลัพธ์: $u1',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 5: UPDATE profiles ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 6: UPDATE user_health_profiles
    try {
      final u2 =
          await client
              .from('user_health_profiles')
              .update({'ckd_stage': 'stage_5'})
              .eq('user_id', userAId)
              .select();
      recordResult(
        'Check 6: UPDATE health ของ User A',
        u2.isEmpty,
        'ผลลัพธ์: $u2',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 6: UPDATE health ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 7: UPDATE daily_logs
    try {
      final u3 =
          await client
              .from('daily_logs')
              .update({'total_protein_g': 9999})
              .eq('user_id', userAId)
              .select();
      recordResult(
        'Check 7: UPDATE daily_logs ของ User A',
        u3.isEmpty,
        'ผลลัพธ์: $u3',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 7: UPDATE daily_logs ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // ---------- DELETE Tests (ลบข้อมูลคนอื่น) ----------
    debugPrint('\n🗑️ กลุ่มที่ 3: ทดสอบการแอบลบข้อมูลคนอื่น (DELETE)');

    // Check 8: DELETE daily_logs ของ User A
    try {
      final d1 =
          await client
              .from('daily_logs')
              .delete()
              .eq('user_id', userAId)
              .select();
      recordResult(
        'Check 8: DELETE daily_logs ของ User A',
        d1.isEmpty,
        'ผลลัพธ์: $d1',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 8: DELETE daily_logs ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 9: DELETE user_health_profiles ของ User A
    try {
      final d2 =
          await client
              .from('user_health_profiles')
              .delete()
              .eq('user_id', userAId)
              .select();
      recordResult(
        'Check 9: DELETE health ของ User A',
        d2.isEmpty,
        'ผลลัพธ์: $d2',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 9: DELETE health ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 10: DELETE profiles ของ User A
    try {
      final d3 =
          await client.from('profiles').delete().eq('id', userAId).select();
      recordResult(
        'Check 10: DELETE profiles ของ User A',
        d3.isEmpty,
        'ผลลัพธ์: $d3',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 10: DELETE profiles ของ User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // ---------- INSERT Impersonation Tests (แอบสวมรอยเป็นคนอื่น) ----------
    debugPrint(
      '\n🎭 กลุ่มที่ 4: ทดสอบการสวมรอย (INSERT ด้วย user_id ของคนอื่น)',
    );

    // Check 11: INSERT health ด้วย user_id ของ User A (ขณะที่ล็อกอินเป็น User B)
    try {
      await client.from('user_health_profiles').insert({
        'user_id': userAId,
        'weight_kg': 100.0,
        'height_cm': 180.0,
        'gender': 'male',
        'ckd_stage': 'stage_5',
      });
      recordResult(
        'Check 11: INSERT health สวมรอยเป็น User A',
        false,
        'ข้อมูลถูกแทรกสำเร็จ!',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 11: INSERT health สวมรอยเป็น User A',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 12: INSERT daily_logs ด้วย user_id ของ User A
    try {
      await client.from('daily_logs').insert({
        'user_id': userAId,
        'log_date': '2026-12-31',
      });
      recordResult(
        'Check 12: INSERT daily_logs สวมรอยเป็น User A',
        false,
        'ข้อมูลถูกแทรกสำเร็จ!',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 12: INSERT daily_logs สวมรอยเป็น User A',
        true,
        'Exception: ${e.message}',
      );
    }

    await client.auth.signOut();
    debugPrint('👋 ล็อกเอาต์ User B');

    // =================================================================
    // PHASE 3: ทดสอบการเข้าถึงโดยไม่ล็อกอินเลย (Unauthenticated)
    // =================================================================
    debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📌 PHASE 3: ทดสอบการเข้าถึงโดยไม่ล็อกอิน (Unauthenticated)');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    // สร้าง client ใหม่ที่ไม่มี session ใด ๆ เลย
    final anonClient = makeClient();

    // Check 13: SELECT profiles โดยไม่ล็อกอิน
    try {
      final a1 = await anonClient.from('profiles').select();
      recordResult(
        'Check 13: SELECT profiles (ไม่ล็อกอิน)',
        a1.isEmpty,
        'ผลลัพธ์: ${a1.length} rows',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 13: SELECT profiles (ไม่ล็อกอิน)',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 14: SELECT user_health_profiles โดยไม่ล็อกอิน
    try {
      final a2 = await anonClient.from('user_health_profiles').select();
      recordResult(
        'Check 14: SELECT health (ไม่ล็อกอิน)',
        a2.isEmpty,
        'ผลลัพธ์: ${a2.length} rows',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 14: SELECT health (ไม่ล็อกอิน)',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 15: SELECT daily_logs โดยไม่ล็อกอิน
    try {
      final a3 = await anonClient.from('daily_logs').select();
      recordResult(
        'Check 15: SELECT daily_logs (ไม่ล็อกอิน)',
        a3.isEmpty,
        'ผลลัพธ์: ${a3.length} rows',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 15: SELECT daily_logs (ไม่ล็อกอิน)',
        true,
        'Exception: ${e.message}',
      );
    }

    // Check 16: INSERT profiles โดยไม่ล็อกอิน
    try {
      await anonClient.from('profiles').insert({
        'id': '00000000-0000-0000-0000-000000000000',
        'email': 'hacker@evil.com',
      });
      recordResult(
        'Check 16: INSERT profiles (ไม่ล็อกอิน)',
        false,
        'แทรกข้อมูลสำเร็จ!',
      );
    } on PostgrestException catch (e) {
      recordResult(
        'Check 16: INSERT profiles (ไม่ล็อกอิน)',
        true,
        'Exception: ${e.message}',
      );
    }

    // =================================================================
    // PHASE 4: ตรวจยืนยันว่า User A ยังมีข้อมูลครบถ้วน (ไม่ถูกลบโดย User B)
    // =================================================================
    debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint(
      '📌 PHASE 4: ยืนยันว่าข้อมูลของ User A ยังปลอดภัยอยู่ (Data Integrity)',
    );
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // ล็อกอินกลับเข้ามาเป็น User A เพื่อตรวจสอบข้อมูล
    await client.auth.signInWithPassword(
      email: emailA,
      password: 'TestPassword123!',
    );

    // Check 17: Profile ยังอยู่
    final verifyProfile =
        await client.from('profiles').select().eq('id', userAId).maybeSingle();
    recordResult(
      'Check 17: Profile ของ User A ยังคงอยู่',
      verifyProfile != null,
    );

    // Check 18: Health Profile ยังอยู่ + ค่าไม่ถูกแก้ไข
    final verifyHealth =
        await client
            .from('user_health_profiles')
            .select()
            .eq('user_id', userAId)
            .maybeSingle();
    final healthIntact =
        verifyHealth != null && verifyHealth['ckd_stage'] == 'stage_3a';
    recordResult(
      'Check 18: Health ของ User A ยังอยู่ + ค่าไม่ถูกเปลี่ยน',
      healthIntact,
      'ckd_stage: ${verifyHealth?['ckd_stage']}',
    );

    // Check 19: Daily Log ยังอยู่
    final verifyLog = await client
        .from('daily_logs')
        .select()
        .eq('user_id', userAId);
    recordResult(
      'Check 19: Daily Log ของ User A ยังคงอยู่',
      verifyLog.isNotEmpty,
      '${verifyLog.length} rows',
    );

    await client.auth.signOut();

    // =================================================================
    // SUMMARY
    // =================================================================
    debugPrint(
      '\n================================================================',
    );
    debugPrint('📊 สรุปผลการทดสอบความปลอดภัย RLS');
    debugPrint(
      '================================================================',
    );
    debugPrint('✅ ผ่าน: $passed ข้อ');
    debugPrint('❌ ไม่ผ่าน: $failed ข้อ');
    if (failedTests.isNotEmpty) {
      debugPrint('\n🚨 รายการที่ไม่ผ่าน:');
      for (final t in failedTests) {
        debugPrint('   - $t');
      }
    }
    debugPrint(
      '================================================================',
    );

    expect(
      failed,
      0,
      reason:
          'มีการทดสอบความปลอดภัยไม่ผ่าน $failed ข้อ: ${failedTests.join(", ")}',
    );
  });
}
