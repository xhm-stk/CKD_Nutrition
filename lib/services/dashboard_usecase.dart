import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/supabase/daily_log.dart';
import '../models/isar/offline_action.dart';

class DashboardUseCase {
  final SupabaseClient _sb;
  final Isar _isar;
  final SharedPreferences _prefs;

  DashboardUseCase(this._sb, this._isar, this._prefs);

  Future<DailyLog?> getSummary(String todayStr) async {
    final user = _sb.auth.currentUser;
    if (user == null) return null;

    final cacheKey = 'dashboard_${user.id}_$todayStr';

    DailyLog? baseLog;
    Map<String, dynamic> rules = {};
    Map<String, dynamic> profile = {};

    try {
      final profileData =
          await _sb
              .from('user_health_profiles')
              .select('*, ckd_rules(*)')
              .eq('user_id', user.id)
              .maybeSingle();
      if (profileData == null) return null;

      profile = profileData;
      rules = profileData['ckd_rules'] ?? {};

      final data =
          await _sb
              .from('dashboard_summary')
              .select('*')
              .eq('user_id', user.id)
              .eq('log_date', todayStr)
              .maybeSingle();

      if (data != null) {
        baseLog = DailyLog.fromDataAndProfile(
          data,
          healthProfile: {
            'custom_protein_limit_g': data['protein_limit_g'],
            'custom_potassium_limit_mg': data['potassium_limit_mg'],
            'custom_sodium_limit_mg': data['sodium_limit_mg'],
            'custom_sugar_limit_g': data['sugar_limit_g'],
            'custom_carb_limit_g': data['carb_limit_g'],
            'custom_water_limit_ml': data['water_limit_ml'],
          },
        );
        _prefs.setString(cacheKey, jsonEncode(data));
        _prefs.setString('profile_${user.id}', jsonEncode(profileData));
      }
    } catch (e) {
      final cachedProfileStr = _prefs.getString('profile_${user.id}');
      if (cachedProfileStr != null) {
        profile = jsonDecode(cachedProfileStr);
        rules = profile['ckd_rules'] ?? {};
      }

      final cachedDataStr = _prefs.getString(cacheKey);
      if (cachedDataStr != null) {
        final data = jsonDecode(cachedDataStr);
        baseLog = DailyLog.fromDataAndProfile(
          data,
          healthProfile: {
            'custom_protein_limit_g': data['protein_limit_g'],
            'custom_potassium_limit_mg': data['potassium_limit_mg'],
            'custom_sodium_limit_mg': data['sodium_limit_mg'],
            'custom_sugar_limit_g': data['sugar_limit_g'],
            'custom_carb_limit_g': data['carb_limit_g'],
            'custom_water_limit_ml': data['water_limit_ml'],
          },
        );
      }
    }

    final weightKg = (profile['weight_kg'] ?? 60.0).toDouble();
    final proteinMultiplier = (rules['protein_multiplier'] ?? 0.8).toDouble();

    baseLog ??= DailyLog(
      id: 'empty_log',
      userId: user.id,
      logDate: todayStr,
      totalProteinG: 0,
      totalPotassiumMg: 0,
      totalSodiumMg: 0,
      totalSugarG: 0,
      totalCarbG: 0,
      totalWaterMl: 0,
      customProtein:
          (profile['custom_protein_limit_g'] != null)
              ? profile['custom_protein_limit_g'].toDouble()
              : weightKg * proteinMultiplier,
      customPotassium:
          (profile['custom_potassium_limit_mg'] ??
                  rules['potassium_limit_mg'] ??
                  2000.0)
              ?.toDouble(),
      customSodium:
          (profile['custom_sodium_limit_mg'] ??
                  rules['sodium_limit_mg'] ??
                  2000.0)
              ?.toDouble(),
      customSugar:
          (profile['custom_sugar_limit_g'] ?? rules['sugar_limit_g'] ?? 24.0)
              ?.toDouble(),
      customCarb:
          (profile['custom_carb_limit_g'] ?? rules['carb_limit_g'] ?? 150.0)
              ?.toDouble(),
      customWater:
          (profile['custom_water_limit_ml'] ??
                  rules['water_limit_ml'] ??
                  1500.0)
              ?.toDouble(),
    );

    final offlineActions = await _isar.offlineActions.where().findAll();
    for (final action in offlineActions) {
      final p = jsonDecode(action.payloadJson);

      // ดึงเวลาที่กินจริงมาเช็คกับ todayStr
      final eatenAtStr = p['eaten_at'] as String?;
      if (eatenAtStr != null && !eatenAtStr.startsWith(todayStr)) {
        continue; // ข้ามของวันอื่น
      }

      if (action.actionType == 'LOG_MEAL_RPC') {
        baseLog = baseLog!.copyWith(
          totalProteinG:
              baseLog.totalProteinG + ((p['protein'] as num?)?.toDouble() ?? 0),
          totalPotassiumMg:
              baseLog.totalPotassiumMg +
              ((p['potassium'] as num?)?.toDouble() ?? 0),
          totalSodiumMg:
              baseLog.totalSodiumMg + ((p['sodium'] as num?)?.toDouble() ?? 0),
          totalSugarG:
              baseLog.totalSugarG + ((p['sugar'] as num?)?.toDouble() ?? 0),
          totalCarbG:
              baseLog.totalCarbG + ((p['carb'] as num?)?.toDouble() ?? 0),
          totalWaterMl:
              baseLog.totalWaterMl + ((p['water'] as num?)?.toDouble() ?? 0),
          totalPhosphorusMg:
              baseLog.totalPhosphorusMg +
              ((p['phosphorus'] as num?)?.toDouble() ?? 0),
        );
      } else if (action.actionType == 'DELETE_MEAL_RPC') {
        baseLog = baseLog!.copyWith(
          totalProteinG:
              (baseLog.totalProteinG -
                      ((p['protein'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
          totalPotassiumMg:
              (baseLog.totalPotassiumMg -
                      ((p['potassium'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
          totalSodiumMg:
              (baseLog.totalSodiumMg - ((p['sodium'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
          totalSugarG:
              (baseLog.totalSugarG - ((p['sugar'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
          totalCarbG:
              (baseLog.totalCarbG - ((p['carb'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
          totalWaterMl:
              (baseLog.totalWaterMl - ((p['water'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
          totalPhosphorusMg:
              (baseLog.totalPhosphorusMg -
                      ((p['phosphorus'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
        );
      }
    }

    return baseLog;
  }
}
