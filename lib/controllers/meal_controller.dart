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
    DateTime? eatenAt,
  }) async {
    if (quantityG <= 0) {
      return Failure('ปริมาณอาหารต้องมากกว่า 0 กรัม');
    }

    // 1. Business Logic: Calculate ratio and nutrition values based on quantity consumed
    // Try to parse the weight from the servingSize (e.g. "440g" or "440 g" -> 440.0)
    // If the database stores values already calculated for a specific portion size (like 440g),
    // then ratio should be quantityG / portionSize instead of quantityG / 100.0.
    double divisor = 100.0;
    try {
      final sizeStr = food.servingSize;
      if (sizeStr.isNotEmpty) {
        final regExp = RegExp(r'(\d+)\s*g');
        final match = regExp.firstMatch(sizeStr.toLowerCase());
        if (match != null) {
          final weight = double.tryParse(match.group(1) ?? '');
          if (weight != null && weight > 0) {
            divisor = weight;
          }
        }
      }
    } catch (_) {
      // In case servingSize is not initialized (e.g. in some unit tests)
    }

    final ratio = quantityG / divisor;

    final protein = food.proteinG * ratio;
    final potassium = food.potassiumMg * ratio;
    final sodium = food.sodiumMg * ratio;
    final sugar = food.sugarG * ratio;
    final carb = food.carbG * ratio;
    // Only count water if it is a pure water beverage (quick water, or items containing "น้ำดื่ม", "น้ำแร่", "น้ำเปล่า", "น้ำสะอาด")
    // This prevents the water content of food recipes (like soup in แกงจืด) from showing up on the dashboard daily water target.
    final isWaterBeverage =
        food.foodId == 'quick_water' ||
        food.name.contains('น้ำดื่ม') ||
        food.name.contains('น้ำแร่') ||
        food.name.contains('น้ำเปล่า') ||
        food.name.contains('น้ำสะอาด');
    final water = isWaterBeverage ? (food.waterMl * ratio) : 0.0;

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
      eatenAt: eatenAt ?? DateTime.now(),
    );

    // 3. Check for high nutrient limit (>= 80%) after logging
    if (result is Success) {
      _checkNutrientLimits();
    }

    return result;
  }

  Future<Result<void>> logUrine(double amountMl) async {
    if (amountMl <= 0) {
      return Failure('ปริมาณปัสสาวะต้องมากกว่า 0 มล.');
    }
    return _repository.logUrine(amountMl);
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
    checkAndAlert(
      'น้ำตาล',
      summary.totalSugarG,
      summary.customSugar ?? 0,
      'sugar',
    );
    checkAndAlert(
      'คาร์โบไฮเดรต',
      summary.totalCarbG,
      summary.customCarb ?? 0,
      'carb',
    );
  }
}
