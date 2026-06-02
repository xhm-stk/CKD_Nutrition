import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/isar/food_item.dart';
import '../models/supabase/daily_log.dart'; // โมเดลที่คุณสร้างไว้ใน Phase 3 step 4

class FoodService {
  final Isar _isar;
  final _sb = Supabase.instance.client;
  
  FoodService(this._isar);

  // ค้นหาอาหารจาก Isar (หาจากชื่อ หรือ Keyword)
  Future<List<FoodItem>> searchFood(String query) async {
    if (query.isEmpty) return _isar.foodItems.where().limit(20).findAll();
    
    return _isar.foodItems.filter()
      .nameContains(query, caseSensitive: false)
      .or()
      .searchKeywordsContains(query, caseSensitive: false)
      .findAll();
  }

  // ส่งบันทึกมื้ออาหารขึ้นคลาวด์
  Future<String?> logMeal({required FoodItem food, required double quantityG, required String mealType}) async {
    try {
      final uid = _sb.auth.currentUser!.id;
      // แก้ปัญหา Timezone ของคนไทย (UTC+7) เพื่อไม่ให้มื้ออาหารไปโผล่ผิดวัน
      final nowThai = DateTime.now().toUtc().add(const Duration(hours: 7));
      final todayStr = nowThai.toIso8601String().substring(0, 10);
      
      // เทียบบัญญัติไตรยางศ์ (กรัมที่กินจริง / 100)
      final ratio = quantityG / 100;

      // สร้าง หรือ ดึง DailyLog ของวันนี้
      final log = await _sb.from('daily_logs').upsert(
        {'user_id': uid, 'log_date': todayStr}, 
        onConflict: 'user_id,log_date'
      ).select().single();

      // แทรกลงตาราง meals
      await _sb.from('meals').insert({
        'log_id':      log['id'], 
        'food_id':     food.foodId, 
        'food_name':   food.name,
        'quantity_g':  quantityG, 
        'meal_type':   mealType,
        'protein_g':   food.proteinG * ratio, 
        'potassium_mg':food.potassiumMg * ratio,
        'sodium_mg':   food.sodiumMg * ratio, 
        'sugar_g':     food.sugarG * ratio,
        'carb_g':      food.carbG * ratio,    
        'water_ml':    food.waterMl * ratio,
      });
      return null; // สำเร็จ
    } catch (e) {
      return 'ไม่สามารถบันทึกได้ กรุณาเช็คอินเทอร์เน็ต';
    }
  }

  // โหลดยอดรวมของวันนี้มาแสดงที่ Dashboard
  Future<DailyLog?> getTodayLog() async {
    final uid = _sb.auth.currentUser!.id;
    final nowThai = DateTime.now().toUtc().add(const Duration(hours: 7));
    final todayStr = nowThai.toIso8601String().substring(0, 10);
    
    // 1) ดึง daily_logs ของวันนี้ (ไม่ JOIN เพราะไม่มี FK เชื่อมกับ user_health_profiles)
    final data = await _sb.from('daily_logs')
      .select('*')
      .eq('user_id', uid)
      .eq('log_date', todayStr)
      .maybeSingle();
      
    if (data == null) return null;

    // 2) ดึง custom limits จาก user_health_profiles แยกต่างหาก
    Map<String, dynamic>? healthProfile;
    try {
      healthProfile = await _sb.from('user_health_profiles')
        .select('custom_protein_limit_g, custom_potassium_limit_mg, custom_sodium_limit_mg, custom_sugar_limit_g, custom_carb_limit_g, custom_water_limit_ml')
        .eq('user_id', uid)
        .maybeSingle();
    } catch (_) {
      // ถ้าตาราง user_health_profiles ยังไม่มีข้อมูล ให้ใช้ค่าจาก CKD Rule แทน
      healthProfile = null;
    }

    return DailyLog.fromJson(data, healthProfile: healthProfile);
  }
}