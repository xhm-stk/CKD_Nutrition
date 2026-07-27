import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/models/supabase/daily_log.dart';
import 'package:ckd_nutrition_app/models/supabase/meal.dart';

void main() {
  group('Dashboard Zero-State & Single Source of Truth Tests', () {
    test('Empty active meals forces total nutrients to 0.0', () {
      // จำลอง DailyLog เก่าที่มีค่าค้างอยู่ (เช่น 20g โปรตีน)
      const staleLog = DailyLog(
        id: 'stale-log-id',
        userId: 'user-123',
        logDate: '2026-07-25',
        totalProteinG: 20.0,
        totalSodiumMg: 90.0,
        totalPotassiumMg: 300.0,
        totalSugarG: 0.0,
        totalCarbG: 1.0,
        totalPhosphorusMg: 355.0,
        customProtein: 72.0,
        customSodium: 2000.0,
      );

      final List<Meal> activeMeals = []; // มื้ออาหารว่างเปล่า (โดนลบหมดแล้ว)

      // จำลองตรรกะ Single Source of Truth
      DailyLog verifiedLog = staleLog;
      if (activeMeals.isEmpty) {
        verifiedLog = verifiedLog.copyWith(
          totalProteinG: 0.0,
          totalPotassiumMg: 0.0,
          totalSodiumMg: 0.0,
          totalSugarG: 0.0,
          totalCarbG: 0.0,
          totalWaterMl: 0.0,
          totalPhosphorusMg: 0.0,
        );
      }

      expect(verifiedLog.totalProteinG, equals(0.0));
      expect(verifiedLog.totalSodiumMg, equals(0.0));
      expect(verifiedLog.totalPotassiumMg, equals(0.0));
      expect(verifiedLog.totalSugarG, equals(0.0));
      expect(verifiedLog.totalCarbG, equals(0.0));
      expect(verifiedLog.totalPhosphorusMg, equals(0.0));
    });

    test('Sum nutrients from active meals matches exact total', () {
      final activeMeals = [
        Meal(
          id: 'm1',
          logId: 'l1',
          foodId: 'F001',
          foodName: 'ข้าวต้มปลา',
          quantityG: 200,
          mealType: 'breakfast',
          proteinG: 18.0,
          potassiumMg: 320.0,
          sodiumMg: 140.0,
          sugarG: 1.0,
          carbG: 30.0,
          waterMl: 300.0,
          phosphorusMg: 74.0,
          eatenAt: DateTime.now(),
        ),
      ];

      double calcProtein = 0, calcPotassium = 0, calcSodium = 0;
      double calcSugar = 0, calcCarb = 0, calcWater = 0, calcPhosphorus = 0;

      for (final m in activeMeals) {
        calcProtein += m.proteinG;
        calcPotassium += m.potassiumMg;
        calcSodium += m.sodiumMg;
        calcSugar += m.sugarG;
        calcCarb += m.carbG;
        calcWater += m.waterMl;
        calcPhosphorus += m.phosphorusMg;
      }

      expect(calcProtein, equals(18.0));
      expect(calcPotassium, equals(320.0));
      expect(calcSodium, equals(140.0));
      expect(calcSugar, equals(1.0));
      expect(calcCarb, equals(30.0));
      expect(calcWater, equals(300.0));
      expect(calcPhosphorus, equals(74.0));
    });
  });
}
