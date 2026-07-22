import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'models/isar/food_item.dart';
import 'models/isar/offline_action.dart';
import 'services/isar_seed_service.dart';
import 'services/notification_service.dart';
import 'providers/core_providers.dart';
import 'router/app_router.dart';
import 'providers/auth_providers.dart';
import 'services/biometric_service.dart';
import 'theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting();
  } catch (e) {
    debugPrint('⚠️ DateFormatting warning: $e');
  }

  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint('⚠️ Orientation setting warning: $e');
  }

  // 1. ตรวจสอบค่า Environment (ค่าเริ่มต้นคือ dev)
  const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // 2. โหลดไฟล์ .env ตาม Environment ที่รัน (ปลอดภัยจากการแครช White Screen บน iOS ถ้าไฟล์ขาด)
  try {
    await dotenv.load(fileName: '.env.$env');
  } catch (e) {
    debugPrint('⚠️ Dotenv load warning (using fallback env): $e');
  }

  // --- Initializing Required Services ---
  // 1. เชื่อมต่อ Supabase พร้อม Fallback ป้องกัน NullCheckError บน iOS
  final supabaseUrl =
      dotenv.env['SUPABASE_URL'] ?? 'https://wgjvfqsdhozgvxrqvgyo.supabase.co';
  final supabaseAnonKey =
      dotenv.env['SUPABASE_ANON_KEY'] ??
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndnanZmcXNkaG96Z3Z4cnF2Z3lvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAxMzkzODcsImV4cCI6MjA5NTcxNTM4N30.rOjV3ef49bMzXiafBpJmdgV-8Pw9m0O5lDl0fz7Wuek';

  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  } catch (e) {
    debugPrint('⚠️ Supabase init warning: $e');
  }

  // 3. เปิด Isar (Local DB)
  late Isar isarInstance;
  final dir = await getApplicationDocumentsDirectory();
  try {
    isarInstance = await Isar.open([
      FoodItemSchema,
      CkdRuleCacheSchema,
      OfflineActionSchema,
    ], directory: dir.path);
  } catch (e) {
    debugPrint('🚨 Isar open fallback: $e');
    isarInstance = await Isar.open([
      FoodItemSchema,
      CkdRuleCacheSchema,
      OfflineActionSchema,
    ], directory: dir.path);
  }

  // 4. ปั๊มข้อมูลอาหาร 156 เมนูลงเครื่อง
  try {
    await IsarSeedService.seedFoodData(isarInstance, forceUpdate: false);
  } catch (e) {
    debugPrint('⚠️ Isar seed warning: $e');
  }

  // 5. โหลด SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 6. เปิดระบบการแจ้งเตือนดื่มน้ำ และมื้ออาหาร (Non-blocking background initialization)
  Future.microtask(() async {
    try {
      final notifService = NotificationService();
      await notifService.init();
      await notifService.scheduleWaterReminder();

      final mealRemindersEnabled =
          prefs.getBool('meal_reminders_enabled') ?? false;
      if (mealRemindersEnabled) {
        notifService.scheduleMealReminder(
          id: 101,
          title: 'ได้เวลาอาหารเช้า',
          body: 'อย่าลืมทานอาหารให้ตรงเวลาและบันทึกโภชนาการนะครับ',
          hour: 8,
          minute: 0,
        );
        notifService.scheduleMealReminder(
          id: 102,
          title: 'ได้เวลาอาหารเที่ยง',
          body: 'พักเที่ยงแล้ว ทานอาหารที่เหมาะสมกับสุขภาพไตด้วยนะครับ',
          hour: 12,
          minute: 0,
        );
        notifService.scheduleMealReminder(
          id: 103,
          title: 'ได้เวลาอาหารเย็น',
          body: 'ทานอาหารเย็นแต่พอดี และอย่าลืมบันทึกข้อมูลนะครับ',
          hour: 18,
          minute: 0,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Notification init warning: $e');
    }
  });

  // 7. Mount Flutter UI ทันที การันตีไม่มีการค้างหน้าจอขาวบน iOS
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isarInstance),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppLifecycleListener _listener;
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();

    // Check biometrics and auto-unlock if not available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final biometricService = ref.read(biometricServiceProvider);
      final canCheck = await biometricService.canCheckBiometrics();
      if (!canCheck) {
        ref.read(sessionUnlockedProvider.notifier).state = true;
      }
    });

    _listener = AppLifecycleListener(
      onPause: () {
        _pausedTime = DateTime.now();
      },
      onResume: () {
        if (_pausedTime != null) {
          final diff = DateTime.now().difference(_pausedTime!);
          // หากพับแอปไปเกิน 1 นาที ให้เด้งหน้าจอล็อก
          if (diff.inMinutes >= 1) {
            final router = ref.read(routerProvider);
            final currentPath =
                router.routerDelegate.currentConfiguration.uri.path;
            if (currentPath != '/lock') {
              router.push('/lock');
            }
          }
        }
        _pausedTime = null;
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    // ปลุก OfflineSyncWorker ให้ตื่นขึ้นมาจับตาดูสถานะอินเทอร์เน็ตทันทีที่เปิดแอป
    ref.watch(offlineSyncWorkerProvider);

    return MaterialApp.router(
      title: 'CKD Nutrition',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      theme: AppTheme.lightTheme(),
      darkTheme:
          AppTheme.lightTheme(), // Force light theme even if OS is in dark mode
      themeMode: ThemeMode.light, // Strictly enforce light mode
      routerConfig: router,
      builder: (context, child) => child ?? const SizedBox.shrink(),
    );
  }
}
