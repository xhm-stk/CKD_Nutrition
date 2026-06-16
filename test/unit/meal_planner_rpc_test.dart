import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI Meal Planner RPC Logic Simulation Test', () {
    test('Calculate Remaining Limits and Filter Foods (Medical Matrix)', () {
      // 1. ตัวแปรสมมุติ (Mock Data)
      const userWeightKg = 60.0;
      const proteinMultiplier = 0.6; // ระยะไต Stage 3b-5

      // วันนี้กินไปแล้ว
      const todayProteinConsumed = 26.0;

      // 2. สมการที่ใช้ใน RPC ที่แก้ใหม่
      // COALESCE(uhp.custom_protein_limit_g, (cr.protein_multiplier * uhp.weight_kg), 60)
      const dynamicProteinLimit =
          proteinMultiplier * userWeightKg; // 0.6 * 60 = 36.0g

      // 3. คำนวณโควต้าที่เหลือ
      const remainingProtein =
          dynamicProteinLimit - todayProteinConsumed; // 36 - 26 = 10.0g

      // 4. การกรองอาหาร (f.protein_g <= v_rem_protein / 3)
      const targetMaxProteinPerMeal = remainingProtein / 3; // 10 / 3 = 3.333g

      // ตรวจสอบความถูกต้องของสมการ
      expect(
        dynamicProteinLimit,
        equals(36.0),
        reason: 'คูณน้ำหนักกับตัวคูณผิดพลาด',
      );
      expect(
        remainingProtein,
        equals(10.0),
        reason: 'ลบโควต้าที่กินไปแล้วผิดพลาด',
      );
      expect(
        targetMaxProteinPerMeal,
        closeTo(3.333, 0.001),
        reason: 'หารเฉลี่ย 3 มื้อผิดพลาด',
      );

      // 5. จำลองตารางอาหาร (Mock Food Master)
      final mockFoods = [
        {'name': 'ไก่ต้ม', 'protein_g': 20.0},
        {'name': 'ข้าวสวย', 'protein_g': 2.5},
        {'name': 'ผัดผัก', 'protein_g': 3.0},
        {'name': 'ไข่ดาว', 'protein_g': 7.0},
      ];

      // ระบบสุ่มจะดึงเฉพาะอาหารที่ <= targetMaxProteinPerMeal
      final eligibleFoods =
          mockFoods
              .where(
                (f) => (f['protein_g'] as double) <= targetMaxProteinPerMeal,
              )
              .toList();

      expect(
        eligibleFoods.length,
        equals(2),
      ); // ต้องเหลือแค่ ข้าวสวย (2.5) กับ ผัดผัก (3.0)
      expect(
        eligibleFoods.any((f) => f['name'] == 'ไก่ต้ม'),
        isFalse,
        reason: 'ไก่ต้มโปรตีนเกิน ต้องไม่ถูกเลือก',
      );
      expect(
        eligibleFoods.any((f) => f['name'] == 'ไข่ดาว'),
        isFalse,
        reason: 'ไข่ดาวโปรตีนเกิน ต้องไม่ถูกเลือก',
      );
    });
  });
}
