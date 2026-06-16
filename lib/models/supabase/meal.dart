// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

@freezed
class Meal with _$Meal {
  const factory Meal({
    required String id,
    @JsonKey(name: 'log_id') required String logId,
    @JsonKey(name: 'food_id') required String foodId,
    @JsonKey(name: 'food_name') required String foodName,
    @JsonKey(name: 'quantity_g') required double quantityG,
    @JsonKey(name: 'meal_type') required String mealType,
    @JsonKey(name: 'protein_g') required double proteinG,
    @JsonKey(name: 'potassium_mg') required double potassiumMg,
    @JsonKey(name: 'sodium_mg') required double sodiumMg,
    @JsonKey(name: 'sugar_g') required double sugarG,
    @JsonKey(name: 'carb_g') required double carbG,
    @JsonKey(name: 'water_ml') required double waterMl,
    @JsonKey(name: 'phosphorus_mg') required double phosphorusMg,
    @JsonKey(name: 'eaten_at') required DateTime eatenAt,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
