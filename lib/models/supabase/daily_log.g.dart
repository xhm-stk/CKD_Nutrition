// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyLogImpl _$$DailyLogImplFromJson(Map<String, dynamic> json) =>
    _$DailyLogImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      logDate: json['log_date'] as String,
      totalProteinG: (json['total_protein_g'] as num?)?.toDouble() ?? 0.0,
      totalPotassiumMg: (json['total_potassium_mg'] as num?)?.toDouble() ?? 0.0,
      totalSodiumMg: (json['total_sodium_mg'] as num?)?.toDouble() ?? 0.0,
      totalSugarG: (json['total_sugar_g'] as num?)?.toDouble() ?? 0.0,
      totalCarbG: (json['total_carb_g'] as num?)?.toDouble() ?? 0.0,
      totalWaterMl: (json['total_water_ml'] as num?)?.toDouble() ?? 0.0,
      totalUrineMl: (json['total_urine_ml'] as num?)?.toDouble() ?? 0.0,
      customProtein: (json['customProtein'] as num?)?.toDouble(),
      customPotassium: (json['customPotassium'] as num?)?.toDouble(),
      customSodium: (json['customSodium'] as num?)?.toDouble(),
      customSugar: (json['customSugar'] as num?)?.toDouble(),
      customCarb: (json['customCarb'] as num?)?.toDouble(),
      customWater: (json['customWater'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DailyLogImplToJson(_$DailyLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'log_date': instance.logDate,
      'total_protein_g': instance.totalProteinG,
      'total_potassium_mg': instance.totalPotassiumMg,
      'total_sodium_mg': instance.totalSodiumMg,
      'total_sugar_g': instance.totalSugarG,
      'total_carb_g': instance.totalCarbG,
      'total_water_ml': instance.totalWaterMl,
      'total_urine_ml': instance.totalUrineMl,
      'customProtein': instance.customProtein,
      'customPotassium': instance.customPotassium,
      'customSodium': instance.customSodium,
      'customSugar': instance.customSugar,
      'customCarb': instance.customCarb,
      'customWater': instance.customWater,
    };
