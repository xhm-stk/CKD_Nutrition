import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/supabase/meal.dart';
import '../models/isar/offline_action.dart';
import '../services/offline_sync_worker.dart';
import '../core/utils/date_utils.dart';
import '../core/result.dart';

// (ลบ Provider เก่าออกเพราะย้ายไปอยู่ core_providers.dart แล้ว)

class MealRepository {
  final SupabaseClient _sb;
  final OfflineSyncWorker _syncWorker;

  MealRepository(this._sb, this._syncWorker);

  Future<Result<List<Meal>>> getTodayMeals() async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return Failure('ผู้ใช้ยังไม่ได้เข้าสู่ระบบ');

      final todayStr = AppDateUtils.getTodayString();

      // ดึง daily_log ของวันนี้ก่อนเพื่อเอา log_id
      final logData =
          await _sb
              .from('daily_logs')
              .select('id')
              .eq('user_id', user.id)
              .eq('log_date', todayStr)
              .maybeSingle();

      if (logData == null) {
        return Success([]); // ยังไม่ได้กินอะไรวันนี้
      }

      final logId = logData['id'];

      // ดึงอาหารในมื้อของวันนี้ ที่ยังไม่โดน soft delete
      final mealsData = await _sb
          .from('meals')
          .select('*')
          .eq('log_id', logId)
          .isFilter('deleted_at', null)
          .order('eaten_at', ascending: false);

      final meals = mealsData.map((e) => Meal.fromJson(e)).toList();
      return Success(meals);
    } catch (e, stack) {
      debugPrint('🚨 [MealRepository] getTodayMeals failed: $e');
      debugPrint('$stack');
      return Failure('ไม่สามารถดึงข้อมูลมื้ออาหารได้', e);
    }
  }

  Future<Result<void>> deleteMeal(Meal meal) async {
    try {
      // เรียกใช้ RPC เพื่อให้มันหักลบยอดโภชนาการใน daily_logs ด้วย
      await _sb.rpc('delete_meal', params: {'p_meal_id': meal.id});

      return Success(null);
    } catch (e) {
      debugPrint(
        '🚨 [MealRepository] deleteMeal Supabase failed: $e, Falling back to Offline Queue...',
      );

      // เอาลงคิว พร้อมเก็บค่าสารอาหารไปหักลบด้วยตอนคำนวณ State Projection
      await _syncWorker.enqueueAction('DELETE_MEAL_RPC', {
        'meal_id': meal.id,
        'protein': meal.proteinG,
        'potassium': meal.potassiumMg,
        'sodium': meal.sodiumMg,
        'sugar': meal.sugarG,
        'carb': meal.carbG,
        'water': meal.waterMl,
        'phosphorus': meal.phosphorusMg,
        'eaten_at': meal.eatenAt.toIso8601String(),
      });

      return Success(null);
    }
  }

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
    try {
      await _sb.rpc(
        'log_meal',
        params: {
          'p_food_id': foodId,
          'p_food_name': foodName,
          'p_quantity_g': quantityG,
          'p_meal_type': mealType,
          'p_protein': protein,
          'p_potassium': potassium,
          'p_sodium': sodium,
          'p_sugar': sugar,
          'p_carb': carb,
          'p_water': water,
          'p_phosphorus': phosphorus,
          'p_eaten_at': eatenAt.toUtc().toIso8601String(),
        },
      );
      return Success(null);
    } catch (e) {
      debugPrint(
        '🚨 [MealRepository] logMeal Supabase failed: $e, Falling back to Offline Queue...',
      );

      // แปลงข้อมูลเป็น Payload เพื่อเก็บลง Isar Queue
      final payload = {
        'food_id': foodId,
        'food_name': foodName,
        'quantity_g': quantityG,
        'meal_type': mealType,
        'protein': protein,
        'potassium': potassium,
        'sodium': sodium,
        'sugar': sugar,
        'carb': carb,
        'water': water,
        'phosphorus': phosphorus,
        'eaten_at': eatenAt.toUtc().toIso8601String(),
      };

      await _syncWorker.enqueueAction('LOG_MEAL_RPC', payload);

      // คืนค่าบอก UI ว่าบันทึกสำเร็จ (แบบออฟไลน์)
      return Success(null); // หรืออาจสร้างคลาส SuccessOffline แยกต่างหาก
    }
  }

  Future<List<Meal>> getTodayMealsWithProjection(
    Isar isar,
    SharedPreferences prefs,
  ) async {
    final user = _sb.auth.currentUser;
    if (user == null) return [];

    final todayStr = AppDateUtils.getTodayString();
    final cacheKey = 'meals_${user.id}_$todayStr';

    List<Meal> baseMeals = [];

    try {
      final result = await getTodayMeals();
      switch (result) {
        case Success(:final data):
          baseMeals = data;
          prefs.setString(
            cacheKey,
            jsonEncode(data.map((m) => m.toJson()).toList()),
          );
          break;
        case Failure():
          throw Exception('Failed to fetch meals');
      }
    } catch (e) {
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) {
        final List<dynamic> list = jsonDecode(cachedStr);
        baseMeals = list.map((e) => Meal.fromJson(e)).toList();
      }
    }

    final offlineActions = await isar.offlineActions.where().findAll();
    for (final action in offlineActions) {
      if (action.actionType == 'LOG_MEAL_RPC') {
        final p = jsonDecode(action.payloadJson);
        baseMeals.insert(
          0,
          Meal(
            id: 'offline_${action.id}',
            logId: 'offline_log',
            foodId: p['food_id'],
            foodName: p['food_name'] + ' (รอส่ง ⏳)',
            quantityG: (p['quantity_g'] as num).toDouble(),
            mealType: p['meal_type'],
            proteinG: (p['protein'] as num).toDouble(),
            potassiumMg: (p['potassium'] as num).toDouble(),
            sodiumMg: (p['sodium'] as num).toDouble(),
            sugarG: (p['sugar'] as num).toDouble(),
            carbG: (p['carb'] as num).toDouble(),
            waterMl: (p['water'] as num).toDouble(),
            phosphorusMg: (p['phosphorus'] as num?)?.toDouble() ?? 0.0,
            eatenAt: DateTime.parse(p['eaten_at']),
          ),
        );
      } else if (action.actionType == 'DELETE_MEAL_RPC') {
        final p = jsonDecode(action.payloadJson);
        baseMeals.removeWhere((m) => m.id == p['meal_id']);
      }
    }

    return baseMeals;
  }
}
