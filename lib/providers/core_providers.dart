import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';

import '../services/auth_service.dart';
import '../repositories/food_repository.dart';
import '../services/ckd_rule_service.dart';
import '../models/supabase/daily_log.dart';
import '../models/supabase/meal.dart';
import '../repositories/meal_repository.dart';
import '../controllers/meal_controller.dart';
import '../core/result.dart';

// 1. Provider สำหรับ Supabase Client (Dependency Injection)
final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

// 2. Provider สำหรับ Isar (รอรับค่าจาก main ตอนเปิดแอป)
final isarProvider = Provider<Isar>((ref) => throw UnimplementedError('Isar not initialized'));

// 3. Provider ที่ใช้จับตาดูสถานะ Login/Logout ตลอดเวลา (Reactive Auth)
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
});

// 4. Services / Repositories / Controllers Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(isarProvider)));
final foodRepositoryProvider = Provider<FoodRepository>((ref) => FoodRepository(ref.watch(isarProvider), ref.watch(supabaseProvider)));
final ckdRuleServiceProvider = Provider<CkdRuleService>((ref) => CkdRuleService(ref.watch(isarProvider)));
final mealControllerProvider = Provider<MealController>((ref) => MealController(ref.watch(mealRepositoryProvider)));

// 5. Data Providers for Dashboard
final dashboardSummaryProvider = FutureProvider.autoDispose<DailyLog?>((ref) async {
  final sb = ref.watch(supabaseProvider);
  final user = sb.auth.currentUser;
  if (user == null) return null;
  
  final nowThai = DateTime.now().toUtc().add(const Duration(hours: 7));
  final todayStr = nowThai.toIso8601String().substring(0, 10);
  
  // 1. เช็คก่อนว่ามีโปรไฟล์สุขภาพหรือไม่
  final profile = await sb.from('user_health_profiles').select('*, ckd_rules(*)').eq('user_id', user.id).maybeSingle();
  if (profile == null) return null; // ถ้ายังไม่ตั้งค่า ให้ return null (Dashboard จะได้เตะไปหน้ากรอก)
  
  // 2. ถ้ามีโปรไฟล์ ให้ดึงสรุปของวันนี้
  final data = await sb.from('dashboard_summary')
    .select('*')
    .eq('user_id', user.id)
    .eq('log_date', todayStr)
    .maybeSingle();
    
  if (data != null) {
    // มีการกินอาหารแล้ว
    return DailyLog.fromDataAndProfile(data, healthProfile: {
      'custom_protein_limit_g': data['protein_limit_g'],
      'custom_potassium_limit_mg': data['potassium_limit_mg'],
      'custom_sodium_limit_mg': data['sodium_limit_mg'],
      'custom_sugar_limit_g': data['sugar_limit_g'],
      'custom_carb_limit_g': data['carb_limit_g'],
      'custom_water_limit_ml': data['water_limit_ml'],
    });
  }

  // 3. ถ้ายังไม่ได้กินอะไรเลย ให้จำลอง Log เปล่าๆ ออกมา โดยดึงลิมิตจาก Profile หรือ Rules แทน
  final rules = profile['ckd_rules'] ?? {};
  return DailyLog(
    id: 'empty_log',
    userId: user.id,
    logDate: todayStr,
    totalProteinG: 0,
    totalPotassiumMg: 0,
    totalSodiumMg: 0,
    totalSugarG: 0,
    totalCarbG: 0,
    totalWaterMl: 0,
    customProtein: (profile['custom_protein_limit_g'] ?? rules['protein_limit_g'])?.toDouble(),
    customPotassium: (profile['custom_potassium_limit_mg'] ?? rules['potassium_limit_mg'])?.toDouble(),
    customSodium: (profile['custom_sodium_limit_mg'] ?? rules['sodium_limit_mg'])?.toDouble(),
    customSugar: (profile['custom_sugar_limit_g'] ?? rules['sugar_limit_g'])?.toDouble(),
    customCarb: (profile['custom_carb_limit_g'] ?? rules['carb_limit_g'])?.toDouble(),
    customWater: (profile['custom_water_limit_ml'] ?? rules['water_limit_ml'])?.toDouble(),
  );
});

final todayMealsProvider = FutureProvider.autoDispose<List<Meal>>((ref) async {
  final repo = ref.watch(mealRepositoryProvider);
  final result = await repo.getTodayMeals();
  switch (result) {
    case Success(:final data): return data;
    case Failure(): return [];
  }
});

final mealPlannerProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final sb = ref.watch(supabaseProvider);
  final user = sb.auth.currentUser;
  if (user == null) throw Exception('กรุณาเข้าสู่ระบบ');

  // เรียกใช้ RPC recommend_meals ที่ Backend Architect เขียนไว้
  final response = await sb.rpc('recommend_meals', params: {
    'p_user_id': user.id,
  });
  return response as List<dynamic>;
});