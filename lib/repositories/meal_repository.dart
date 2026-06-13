import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/supabase/meal.dart';
import '../core/result.dart';
import '../providers/core_providers.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(ref.watch(supabaseProvider));
});

class MealRepository {
  final SupabaseClient _sb;
  
  MealRepository(this._sb);

  Future<Result<List<Meal>>> getTodayMeals() async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return Failure('ผู้ใช้ยังไม่ได้เข้าสู่ระบบ');

      final nowThai = DateTime.now().toUtc().add(const Duration(hours: 7));
      final todayStr = nowThai.toIso8601String().substring(0, 10);

      // ดึง daily_log ของวันนี้ก่อนเพื่อเอา log_id
      final logData = await _sb.from('daily_logs')
        .select('id')
        .eq('user_id', user.id)
        .eq('log_date', todayStr)
        .maybeSingle();

      if (logData == null) {
        return Success([]); // ยังไม่ได้กินอะไรวันนี้
      }

      final logId = logData['id'];

      // ดึงอาหารในมื้อของวันนี้ ที่ยังไม่โดน soft delete
      final mealsData = await _sb.from('meals')
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

  Future<Result<void>> deleteMeal(String mealId) async {
    try {
      // เรียกใช้ RPC เพื่อให้มันหักลบยอดโภชนาการใน daily_logs ด้วย
      await _sb.rpc('delete_meal', params: {
        'p_meal_id': mealId,
      });
      
      return Success(null);
    } catch (e, stack) {
      debugPrint('🚨 [MealRepository] deleteMeal failed: $e');
      debugPrint('$stack');
      return Failure('ลบมื้ออาหารล้มเหลว', e);
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
  }) async {
    try {
      await _sb.rpc('log_meal', params: {
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
      });
      return Success(null);
    } catch (e) {
      debugPrint('🚨 [MealRepository] logMeal failed: $e');
      return Failure('ไม่สามารถบันทึกได้ กรุณาเช็คอินเทอร์เน็ต', e);
    }
  }
}
