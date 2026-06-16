import 'package:flutter_test/flutter_test.dart';
import 'package:ckd_nutrition_app/services/quota_engine.dart';
import 'package:ckd_nutrition_app/controllers/meal_controller.dart';
import 'package:ckd_nutrition_app/models/supabase/daily_log.dart';
import 'package:ckd_nutrition_app/models/isar/food_item.dart';
import 'package:ckd_nutrition_app/repositories/meal_repository.dart';
import 'package:ckd_nutrition_app/core/result.dart';
import 'package:ckd_nutrition_app/models/supabase/meal.dart';

class FakeMealRepository implements MealRepository {
  @override
  Future<Result<void>> logMealData({
    required String foodId,
    required String foodName,
    required double quantityG,
    required String mealType,
    required double protein,
    required double potassium,
    required double sodium,
    required double sugar,
    required double carb,
    required double water,
    required double phosphorus,
    required DateTime eatenAt,
  }) async {
    return Success(null);
  }

  @override
  Future<Result<void>> deleteMeal(Meal meal) async {
    return Success(null);
  }

  @override
  Future<Result<List<Meal>>> getTodayMeals() async {
    return Success([]);
  }

  @override
  Future<List<Meal>> getTodayMealsWithProjection(dynamic isar, dynamic prefs) async {
    return [];
  }
}

void main() {
  group('QA Master Combinatorial Test Matrix', () {
    late FakeMealRepository fakeRepo;
    late MealController mealController;

    setUp(() {
      fakeRepo = FakeMealRepository();
      mealController = MealController(fakeRepo);
    });

    test('Execute 3360 combinations for QuotaEngine and MealController without crashing', () async {
      final stages = ['Stage 1', 'Stage 2', 'Stage 3a', 'Stage 3b', 'Stage 4', 'Stage 5', 'Dialysis'];
      final weights = [40.0, 60.0, 80.0, 100.0, 120.0];
      final quantities = [0.0, 10.0, 50.0, 100.0, 500.0, 1000.0];
      final densities = ['Low', 'Medium', 'High', 'Extreme'];
      final consumptions = [0.0, 0.5, 0.9, 1.1]; // Multiplier of limit

      int runCount = 0;

      for (final stage in stages) {
        for (final weight in weights) {
          // Generate a rule based on stage and weight
          final rule = CkdRuleCache()
            ..stage = stage
            ..proteinLimitG = weight * 0.8
            ..potassiumLimitMg = 2000.0
            ..sodiumLimitMg = 2000.0
            ..sugarLimitG = 25.0
            ..carbLimitG = 150.0
            ..waterLimitMl = weight * 30.0;

          for (final density in densities) {
            // Setup FoodItem based on density
            double mult = density == 'Low' ? 0.1 : density == 'Medium' ? 1.0 : density == 'High' ? 2.5 : 10.0;
            final food = FoodItem()
              ..foodId = 'F_TEST'
              ..name = 'Test Food $density'
              ..proteinG = 5.0 * mult
              ..potassiumMg = 200.0 * mult
              ..sodiumMg = 200.0 * mult
              ..sugarG = 2.0 * mult
              ..carbG = 15.0 * mult
              ..waterMl = 50.0 * mult;

            for (final consumption in consumptions) {
              // Setup DailyLog based on previous consumption
              final log = DailyLog(
                id: 'L_TEST',
                userId: 'U_TEST',
                logDate: '2026-06-12',
                totalProteinG: rule.proteinLimitG * consumption,
                totalPotassiumMg: rule.potassiumLimitMg * consumption,
                totalSodiumMg: rule.sodiumLimitMg * consumption,
                totalSugarG: rule.sugarLimitG * consumption,
                totalCarbG: rule.carbLimitG * consumption,
                totalWaterMl: rule.waterLimitMl * consumption,
                // Passing custom limits equivalent to rule for this test
                customProtein: rule.proteinLimitG,
                customPotassium: rule.potassiumLimitMg,
                customSodium: rule.sodiumLimitMg,
                customSugar: rule.sugarLimitG,
                customCarb: rule.carbLimitG,
                customWater: rule.waterLimitMl,
              );

              for (final quantity in quantities) {
                // 1. Test QuotaEngine
                final quotas = QuotaEngine.calculate(log: log, rule: rule);
                expect(quotas.length, 6, reason: 'Should return 6 nutrient quotas');
                for (final quota in quotas) {
                  expect(quota.consumed, greaterThanOrEqualTo(0));
                  expect(quota.limit, greaterThanOrEqualTo(0));
                  expect(quota.percent, inInclusiveRange(0.0, 1.0)); // Clamp logic
                  expect(quota.remaining, greaterThanOrEqualTo(0.0)); // Clamp logic
                }

                // 2. Test MealController
                try {
                  final result = await mealController.logMeal(
                    food: food,
                    quantityG: quantity,
                    mealType: 'breakfast',
                  );
                  expect(result, isA<Success<void>>(), reason: 'Logging should succeed without errors');
                } catch (e) {
                  fail('MealController crashed on Combination #$runCount: $e');
                }

                runCount++;
              }
            }
          }
        }
      }

      expect(runCount, 3360); // 7 * 5 * 4 * 4 * 6
    });
  });
}
