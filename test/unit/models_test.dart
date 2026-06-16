import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/models/supabase/daily_log.dart';
import 'package:ckd_nutrition_app/models/supabase/meal.dart';

void main() {
  group('Models JSON Serialization Tests', () {
    test('DailyLog fromJson and toJson', () {
      final json = {
        'id': 'log-123',
        'user_id': 'user-123',
        'log_date': '2026-06-11',
        'total_protein_g': 25.5,
        'total_potassium_mg': 1000.0,
        'total_sodium_mg': 500.0,
        'total_sugar_g': 10.0,
        'total_carb_g': 150.0,
        'total_water_ml': 800.0,
        'customProtein': 50.0,
      };

      final dailyLog = DailyLog.fromJson(json);

      expect(dailyLog.id, 'log-123');
      expect(dailyLog.userId, 'user-123');
      expect(dailyLog.logDate, '2026-06-11');
      expect(dailyLog.totalProteinG, 25.5);
      expect(dailyLog.customProtein, 50.0);

      final outJson = dailyLog.toJson();
      expect(outJson['user_id'], 'user-123');
      expect(outJson['customProtein'], 50.0);
    });

    test('DailyLog fromDataAndProfile', () {
      final data = {
        'id': 'log-123',
        'user_id': 'user-123',
        'log_date': '2026-06-11',
      };

      final profile = {
        'custom_protein_limit_g': 55.0,
        'custom_potassium_limit_mg': 2000.0,
      };

      final dailyLog = DailyLog.fromDataAndProfile(data, healthProfile: profile);

      expect(dailyLog.customProtein, 55.0);
      expect(dailyLog.customPotassium, 2000.0);
      expect(dailyLog.customSodium, isNull);
    });

    test('Meal fromJson and toJson', () {
      final now = DateTime.now();
      final json = {
        'id': 'meal-1',
        'log_id': 'log-1',
        'food_id': 'F001',
        'food_name': 'Apple',
        'quantity_g': 100.0,
        'meal_type': 'Snack',
        'protein_g': 0.3,
        'potassium_mg': 107.0,
        'sodium_mg': 1.0,
        'sugar_g': 10.4,
        'carb_g': 13.8,
        'water_ml': 86.0,
        'phosphorus_mg': 11.0,
        'eaten_at': now.toIso8601String(),
      };

      final meal = Meal.fromJson(json);

      expect(meal.id, 'meal-1');
      expect(meal.foodName, 'Apple');
      expect(meal.quantityG, 100.0);

      final outJson = meal.toJson();
      expect(outJson['meal_type'], 'Snack');
      expect(outJson['food_id'], 'F001');
    });
  });
}
