import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/health_profile_service.dart';
import '../services/offline_sync_worker.dart';
import '../repositories/food_repository.dart';
import '../services/ckd_rule_service.dart';
import '../services/dashboard_usecase.dart';
import '../core/utils/date_utils.dart';
import '../models/supabase/daily_log.dart';

// 0. Provider สำหรับ SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

// 1. Provider สำหรับ Supabase Client (Dependency Injection)
final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

// 2. Provider สำหรับ Isar (รอรับค่าจาก main ตอนเปิดแอป)
final isarProvider = Provider<Isar>((ref) => throw UnimplementedError('Isar not initialized'));

// 3. Services / Repositories Providers
final healthProfileServiceProvider = Provider<HealthProfileService>((ref) => HealthProfileService(ref.watch(isarProvider)));
final offlineSyncWorkerProvider = Provider<OfflineSyncWorker>((ref) {
  final worker = OfflineSyncWorker(ref.watch(isarProvider), ref.watch(supabaseProvider));
  ref.onDispose(() => worker.dispose());
  return worker;
});
final foodRepositoryProvider = Provider<FoodRepository>((ref) => FoodRepository(ref.watch(isarProvider), ref.watch(supabaseProvider), ref.watch(offlineSyncWorkerProvider)));
final ckdRuleServiceProvider = Provider<CkdRuleService>((ref) => CkdRuleService(ref.watch(isarProvider)));

// 4. UseCase Providers
final dashboardUseCaseProvider = Provider<DashboardUseCase>((ref) => 
    DashboardUseCase(ref.watch(supabaseProvider), ref.watch(isarProvider), ref.watch(sharedPreferencesProvider)));

// 5. Data Providers for Dashboard
final dashboardSummaryProvider = FutureProvider.autoDispose<DailyLog?>((ref) async {
  final todayStr = AppDateUtils.getTodayString();
  return ref.watch(dashboardUseCaseProvider).getSummary(todayStr);
});