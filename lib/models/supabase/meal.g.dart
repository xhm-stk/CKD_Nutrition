// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
      id: json['id'] as String,
      logId: json['log_id'] as String,
      foodId: json['food_id'] as String,
      foodName: json['food_name'] as String,
      quantityG: (json['quantity_g'] as num).toDouble(),
      mealType: json['meal_type'] as String,
      proteinG: (json['protein_g'] as num).toDouble(),
      potassiumMg: (json['potassium_mg'] as num).toDouble(),
      sodiumMg: (json['sodium_mg'] as num).toDouble(),
      sugarG: (json['sugar_g'] as num).toDouble(),
      carbG: (json['carb_g'] as num).toDouble(),
      waterMl: (json['water_ml'] as num).toDouble(),
      eatenAt: DateTime.parse(json['eaten_at'] as String),
    );

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'log_id': instance.logId,
      'food_id': instance.foodId,
      'food_name': instance.foodName,
      'quantity_g': instance.quantityG,
      'meal_type': instance.mealType,
      'protein_g': instance.proteinG,
      'potassium_mg': instance.potassiumMg,
      'sodium_mg': instance.sodiumMg,
      'sugar_g': instance.sugarG,
      'carb_g': instance.carbG,
      'water_ml': instance.waterMl,
      'eaten_at': instance.eatenAt.toIso8601String(),
    };
