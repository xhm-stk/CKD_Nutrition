import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/supabase/meal.dart';
import '../repositories/meal_repository.dart';
import '../controllers/meal_controller.dart';
import 'core_providers.dart'; // To access supabaseProvider, isarProvider, offlineSyncWorkerProvider, sharedPreferencesProvider
import '../core/utils/date_utils.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(
    ref.watch(supabaseProvider),
    ref.watch(offlineSyncWorkerProvider),
  );
});

final mealControllerProvider = Provider<MealController>((ref) {
  return MealController(ref.watch(mealRepositoryProvider));
});

final todayMealsProvider = FutureProvider.autoDispose<List<Meal>>((ref) async {
  final repo = ref.watch(mealRepositoryProvider);
  final isar = ref.watch(isarProvider);
  final prefs = ref.watch(sharedPreferencesProvider);

  final selectedDate = ref.watch(selectedDateProvider);
  final dateStr = AppDateUtils.formatDate(selectedDate);

  return repo.getMealsWithProjection(isar, prefs, dateStr);
});

final mealPlannerProvider = FutureProvider.autoDispose<List<dynamic>>((
  ref,
) async {
  final sb = ref.watch(supabaseProvider);
  final user = sb.auth.currentUser;
  if (user == null) throw Exception('กรุณาเข้าสู่ระบบ');

  // เรียกใช้ RPC recommend_meals ที่ Backend Architect เขียนไว้
  final response = await sb.rpc('recommend_meals');
  return response as List<dynamic>;
});

final monthlySummaryProvider = FutureProvider.autoDispose
    .family<List<dynamic>, DateTime>((ref, targetMonth) async {
      final sb = ref.watch(supabaseProvider);
      final user = sb.auth.currentUser;
      if (user == null) throw Exception('กรุณาเข้าสู่ระบบ');

      final response = await sb.rpc(
        'get_monthly_summary',
        params: {
          'target_month': targetMonth.toIso8601String().substring(0, 10),
        },
      );
      return response as List<dynamic>;
    });
