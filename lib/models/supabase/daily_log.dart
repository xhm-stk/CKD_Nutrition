// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_log.freezed.dart';
part 'daily_log.g.dart';

@freezed
class DailyLog with _$DailyLog {
  const factory DailyLog({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'log_date') required String logDate,
    @JsonKey(name: 'total_protein_g') @Default(0.0) double totalProteinG,
    @JsonKey(name: 'total_potassium_mg') @Default(0.0) double totalPotassiumMg,
    @JsonKey(name: 'total_sodium_mg') @Default(0.0) double totalSodiumMg,
    @JsonKey(name: 'total_sugar_g') @Default(0.0) double totalSugarG,
    @JsonKey(name: 'total_carb_g') @Default(0.0) double totalCarbG,
    @JsonKey(name: 'total_water_ml') @Default(0.0) double totalWaterMl,
    
    // Custom Limits
    double? customProtein,
    double? customPotassium,
    double? customSodium,
    double? customSugar,
    double? customCarb,
    double? customWater,
  }) = _DailyLog;

  const DailyLog._();

  factory DailyLog.fromJson(Map<String, dynamic> json) => _$DailyLogFromJson(json);

  // Helper factory เพื่อรองรับการนำข้อมูลจาก profile มาประกอบ
  factory DailyLog.fromDataAndProfile(Map<String, dynamic> data, {Map<String, dynamic>? healthProfile}) {
    final combined = Map<String, dynamic>.from(data);
    if (healthProfile != null) {
      combined['customProtein'] = (healthProfile['custom_protein_limit_g'] as num?)?.toDouble();
      combined['customPotassium'] = (healthProfile['custom_potassium_limit_mg'] as num?)?.toDouble();
      combined['customSodium'] = (healthProfile['custom_sodium_limit_mg'] as num?)?.toDouble();
      combined['customSugar'] = (healthProfile['custom_sugar_limit_g'] as num?)?.toDouble();
      combined['customCarb'] = (healthProfile['custom_carb_limit_g'] as num?)?.toDouble();
      combined['customWater'] = (healthProfile['custom_water_limit_ml'] as num?)?.toDouble();
    }
    return DailyLog.fromJson(combined);
  }
}