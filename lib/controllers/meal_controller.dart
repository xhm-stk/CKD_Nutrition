import '../models/isar/food_item.dart';
import '../repositories/meal_repository.dart';
import '../core/result.dart';

class MealController {
  final MealRepository _repository;

  MealController(this._repository);

  Future<Result<void>> logMeal({required FoodItem food, required double quantityG, required String mealType}) async {
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
    return _repository.logMealData(
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
  }
}
