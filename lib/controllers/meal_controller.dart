import '../models/isar/food_item.dart';
import '../repositories/meal_repository.dart';
import '../services/dashboard_usecase.dart';
import '../services/notification_service.dart';
import '../core/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MealController {
  final MealRepository _repository;
  final DashboardUseCase _dashboardUseCase;
  final SharedPreferences _prefs;

  MealController(this._repository, this._dashboardUseCase, this._prefs);

  Future<Result<void>> logMeal({
    required FoodItem food,
    required double quantityG,
    required String mealType,
  }) async {
    if (quantityG <= 0) {
      return Failure('ปริมาณอาหารต้องมากกว่า 0 กรัม');
    }

    // 1. Business Logic: Calculate ratio and nutrition values based on quantity consumed
    final ratio = quantityG / 100.0;

    final protein = food.proteinG * ratio;
    final potassium = food.potassiumMg * ratio;
    final sodium = food.sodiumMg * ratio;
    final sugar = food.sugarG * ratio;
    final carb = food.carbG * ratio;
    final water = food.waterMl * ratio;
    final phosphorus = food.phosphorusMg * ratio;

    // 2. Delegate to repository for persistence
    final result = await _repository.logMealData(
      foodId: food.foodId,
      foodName: food.name,
      quantityG: quantityG,
      mealType: mealType,
      protein: protein,
      potassium: potassium,
      sodium: sodium,
      sugar: sugar,
      carb: carb,
      water: water,
      phosphorus: phosphorus,
      eatenAt: DateTime.now(),
    );

    // 3. Check for high nutrient limit (>= 80%) after logging
    if (result is Success) {
      _checkNutrientLimits();
    }

    return result;
  }

  Future<void> _checkNutrientLimits() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final summary = await _dashboardUseCase.getSummary(todayStr);

    if (summary == null) return;

    final notifService = NotificationService();

    void checkAndAlert(String name, double current, double limit, String key) {
      if (limit > 0) {
        final percent = current / limit;
        if (percent >= 0.8) {
          final alertKey = 'alert_${key}_$todayStr';
          if (_prefs.getBool(alertKey) != true) {
            notifService.showHighNutrientAlert(name, (percent * 100).toInt());
            _prefs.setBool(alertKey, true);
          }
        }
      }
    }

    checkAndAlert(
      'โปรตีน',
      summary.totalProteinG,
      summary.customProtein ?? 0,
      'protein',
    );
    checkAndAlert(
      'โซเดียม',
      summary.totalSodiumMg,
      summary.customSodium ?? 0,
      'sodium',
    );
    checkAndAlert(
      'โพแทสเซียม',
      summary.totalPotassiumMg,
      summary.customPotassium ?? 0,
      'potassium',
    );
  }
}
