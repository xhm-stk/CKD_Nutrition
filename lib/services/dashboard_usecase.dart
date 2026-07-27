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
    List<dynamic> activeMeals = [];

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

      // Single Source of Truth Validation: ดึงมื้ออาหารจริงที่ไม่ถูกลบของ log_id หรือวันปัจจุบันเพื่อสอบทานความถูกต้อง 100%
      if (data != null && data['id'] != null) {
        activeMeals = await _sb
            .from('meals')
            .select('*')
            .eq('log_id', data['id'])
            .isFilter('deleted_at', null);
      } else {
        activeMeals = [];
      }

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

    // ดึงตัวคูณโปรตีนจากคอลัมน์จริง protein_limit_g (แทน protein_multiplier เดิมที่มีบั๊ก)
    double proteinMultiplier = (rules['protein_limit_g'] ?? 0.8).toDouble();

    // หากเป็นคนไข้ระยะ 5 และยังไม่ได้ฟอกไต ให้ใช้โควต้าโปรตีนแบบคุมเข้มงวดเป็นพิเศษ (0.6 g/kg)
    final ckdStage = profile['ckd_stage'] ?? '';
    final isOnDialysis = profile['is_on_dialysis'] ?? false;
    if (ckdStage == 'stage_5' && !isOnDialysis) {
      proteinMultiplier = 0.6;
    }

    final dynamicProtein = weightKg * proteinMultiplier;
    final dynamicPotassium = (rules['potassium_limit_mg'] ?? 2000.0).toDouble();
    final dynamicSodium = (rules['sodium_limit_mg'] ?? 2000.0).toDouble();
    final dynamicSugar = (rules['sugar_limit_g'] ?? 24.0).toDouble();

    // คำนวณคาร์โบไฮเดรตแบบไดนามิกต่อน้ำหนักตัว (weightKg * multiplier)
    final carbMultiplier = (rules['carb_limit_g'] ?? 4.5).toDouble();
    final dynamicCarb = weightKg * carbMultiplier;

    // คำนวณโควต้าน้ำดื่มไดนามิก ปัสสาวะ + 500 มล. สำหรับระยะ 4-5
    final waterLimitInDb = (rules['water_limit_ml'] ?? 1500.0).toDouble();
    double dynamicWater = waterLimitInDb;
    if (waterLimitInDb == -1) {
      final urineMl = (baseLog?.totalUrineMl ?? 0.0).toDouble();
      dynamicWater = urineMl + 500.0;
      if (dynamicWater < 500.0) {
        dynamicWater = 500.0;
      }
    }

    // ใช้ค่าที่คำนวณ dynamic เป็น limit เสมอ (override ค่าจาก View)
    if (baseLog != null) {
      baseLog = baseLog.copyWith(
        customProtein: dynamicProtein,
        customPotassium: dynamicPotassium,
        customSodium: dynamicSodium,
        customSugar: dynamicSugar,
        customCarb: dynamicCarb,
        customWater: dynamicWater,
      );
    }

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
      totalUrineMl: 0,
      customProtein: dynamicProtein,
      customPotassium: dynamicPotassium,
      customSodium: dynamicSodium,
      customSugar: dynamicSugar,
      customCarb: dynamicCarb,
      customWater: dynamicWater,
    );

    // Single Source of Truth Validation (ย้ายมาไว้ข้างล่างสุด): 
    // ตรวจทานและบังคับใช้ค่าสารอาหารสะสมจริงจากรายการอาหารกับ baseLog ทุกสถานะ (รวมถึง empty_log ที่สร้างขึ้นจำลองด้วย)
    if (activeMeals.isEmpty) {
      baseLog = baseLog.copyWith(
        totalProteinG: 0.0,
        totalPotassiumMg: 0.0,
        totalSodiumMg: 0.0,
        totalSugarG: 0.0,
        totalCarbG: 0.0,
        totalWaterMl: 0.0,
        totalPhosphorusMg: 0.0,
      );
    } else {
      double calcProtein = 0, calcPotassium = 0, calcSodium = 0;
      double calcSugar = 0, calcCarb = 0, calcWater = 0, calcPhosphorus = 0;
      for (final m in activeMeals) {
        calcProtein += (m['protein_g'] as num?)?.toDouble() ?? 0;
        calcPotassium += (m['potassium_mg'] as num?)?.toDouble() ?? 0;
        calcSodium += (m['sodium_mg'] as num?)?.toDouble() ?? 0;
        calcSugar += (m['sugar_g'] as num?)?.toDouble() ?? 0;
        calcCarb += (m['carb_g'] as num?)?.toDouble() ?? 0;
        calcWater += (m['water_ml'] as num?)?.toDouble() ?? 0;
        calcPhosphorus += (m['phosphorus_mg'] as num?)?.toDouble() ?? 0;
      }
      baseLog = baseLog.copyWith(
        totalProteinG: calcProtein,
        totalPotassiumMg: calcPotassium,
        totalSodiumMg: calcSodium,
        totalSugarG: calcSugar,
        totalCarbG: calcCarb,
        totalWaterMl: calcWater,
        totalPhosphorusMg: calcPhosphorus,
      );
    }

    final offlineActions = await _isar.offlineActions.where().findAll();
    for (final action in offlineActions) {
      final p = jsonDecode(action.payloadJson);

      // ดึงเวลาที่กิน/บันทึกจริงมาเช็คกับ todayStr
      final dateStr = (p['eaten_at'] ?? p['logged_at']) as String?;
      if (dateStr != null) {
        final localDateStr = DateTime.tryParse(
          dateStr,
        )?.toLocal().toIso8601String().substring(0, 10);
        if (localDateStr != null && localDateStr != todayStr) {
          continue; // ข้ามของวันอื่น
        }
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
      } else if (action.actionType == 'LOG_URINE_RPC') {
        baseLog = baseLog!.copyWith(
          totalUrineMl:
              baseLog.totalUrineMl +
              ((p['amount_ml'] as num?)?.toDouble() ?? 0),
        );
      } else if (action.actionType == 'DELETE_URINE_RPC') {
        baseLog = baseLog!.copyWith(
          totalUrineMl:
              (baseLog.totalUrineMl -
                      ((p['amount_ml'] as num?)?.toDouble() ?? 0))
                  .clamp(0, double.infinity)
                  .toDouble(),
        );
      }
    }

    // หลังจากวนลูปคำนวณยอดสะสมออฟไลน์เสร็จสิ้นแล้ว
    // ค่อยมาประมวลผลโควต้าน้ำดื่มแบบไดนามิกอีกครั้ง เพื่อให้ยอดปัสสาวะออฟไลน์ถูกนำมารวมคำนวณอย่างถูกต้อง
    if (waterLimitInDb == -1 && baseLog != null) {
      final urineMl = baseLog.totalUrineMl;
      double finalDynamicWater = urineMl + 500.0;
      if (finalDynamicWater < 500.0) {
        finalDynamicWater = 500.0;
      }
      baseLog = baseLog.copyWith(customWater: finalDynamicWater);
    }

    return baseLog;
  }
}
