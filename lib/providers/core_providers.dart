import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

// 1. Provider สำหรับ Supabase Client (Dependency Injection)
final supabaseProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

// 2. Provider สำหรับ Isar (รอรับค่าจาก main ตอนเปิดแอป)
final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('Isar not initialized'),
);

// 3. Services / Repositories Providers
final healthProfileServiceProvider = Provider<HealthProfileService>(
  (ref) => HealthProfileService(ref.watch(isarProvider)),
);
final offlineSyncWorkerProvider = Provider<OfflineSyncWorker>((ref) {
  final worker = OfflineSyncWorker(
    ref.watch(isarProvider),
    ref.watch(supabaseProvider),
  );
  ref.onDispose(() => worker.dispose());
  return worker;
});
final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) => FoodRepository(
    ref.watch(isarProvider),
    ref.watch(supabaseProvider),
    ref.watch(offlineSyncWorkerProvider),
  ),
);
final ckdRuleServiceProvider = Provider<CkdRuleService>(
  (ref) => CkdRuleService(ref.watch(isarProvider)),
);

// 4. UseCase Providers
final dashboardUseCaseProvider = Provider<DashboardUseCase>(
  (ref) => DashboardUseCase(
    ref.watch(supabaseProvider),
    ref.watch(isarProvider),
    ref.watch(sharedPreferencesProvider),
  ),
);

// 5. Data Providers for Dashboard
final dashboardSummaryProvider = FutureProvider.autoDispose<DailyLog?>((
  ref,
) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final dateStr = AppDateUtils.formatDate(selectedDate);
  return ref.watch(dashboardUseCaseProvider).getSummary(dateStr);
});

// 6. Connectivity Provider
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

// 6.1. Offline Mode Toggle Provider
final offlineModeProvider = StateProvider<bool>((ref) => false);

// 7. Selected Date Provider (For Dashboard & Calendar)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// 8. Streak Count Provider (นับจำนวนวันที่บันทึกติดต่อกัน)
final streakCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final sb = ref.watch(supabaseProvider);
  final user = sb.auth.currentUser;
  if (user == null) return 0;

  try {
    final data = await sb
        .from('daily_logs')
        .select('log_date')
        .eq('user_id', user.id)
        .isFilter('deleted_at', null)
        .order('log_date', ascending: false)
        .limit(60);

    if (data.isEmpty) return 0;

    final dates =
        data
            .map<DateTime>((e) => DateTime.parse(e['log_date'].toString()))
            .toList();

    int streak = 0;
    var checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (final d in dates) {
      final logDay = DateTime(d.year, d.month, d.day);
      if (logDay == checkDate ||
          logDay == checkDate.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = logDay.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  } catch (_) {
    return 0;
  }
});
