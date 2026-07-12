import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
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
  WidgetsFlutterBinding.ensureInitialized(); // บังคับให้ Flutter สตาร์ท
  await initializeDateFormatting();

  // บังคับให้แอปเป็นแนวตั้งเท่านั้น เพื่อป้องกัน Layout พัง
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. ตรวจสอบค่า Environment (ค่าเริ่มต้นคือ dev)
  const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // 2. โหลดไฟล์ .env ตาม Environment ที่รัน (ถ้าไม่มีให้ fallback ไปที่ .env.dev)
  await dotenv.load(fileName: '.env.$env');

  // --- Initializing Required Services ---
  // 1. เชื่อมต่อ Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 2. เตรียมคีย์เข้ารหัสลับ 256-bit
  // final isarKey = await EncryptionService.getOrCreateIsarKey(); // Isar v3 does not support encryption natively yet

  // 3. เปิด Isar (Local) แบบเข้ารหัส
  final dir = await getApplicationDocumentsDirectory();
  late Isar isarInstance;
  try {
    isarInstance = await Isar.open(
      [FoodItemSchema, CkdRuleCacheSchema, OfflineActionSchema],
      directory: dir.path,
      // encryptionKey: isarKey, // removed due to Isar v3 not supporting it out-of-the-box
    );
  } catch (e) {
    debugPrint('🚨 Isar open failed: $e');
    // เพื่อไม่ให้ข้อมูลสูญหาย (destructive loss) จะไม่สั่ง deleteFromDisk ทันที
    // ให้พยายามกู้คืนหรือใช้ fallback ก่อน (ตอนนี้ทำแค่โยน error ให้รับรู้ หรือลองเปิดแบบไม่มี key)
    isarInstance = await Isar.open([
      FoodItemSchema,
      CkdRuleCacheSchema,
      OfflineActionSchema,
    ], directory: dir.path);
  }

  // 4. ปั๊มข้อมูลอาหาร 156 เมนูลงเครื่อง (แก้บั๊ก forceUpdate: true ทำให้ช้าทุกครั้งที่เปิดแอป)
  await IsarSeedService.seedFoodData(isarInstance, forceUpdate: false);

  // 5. โหลด SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 6. เปิดระบบการแจ้งเตือนดื่มน้ำ และมื้ออาหาร (Task 6)
  final notifService = NotificationService();
  await notifService.init();
  await notifService.scheduleWaterReminder();

  // Re-schedule meal reminders on app start (especially for iOS where boot receivers don't exist)
  final mealRemindersEnabled = prefs.getBool('meal_reminders_enabled') ?? false;
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

  // 6. เปิดระบบดักจับ Error ด้วย Sentry
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.tracesSampleRate = 1.0; // ดักจับ 100% ในเวอร์ชันแรก
      // เพิ่มฟีเจอร์ช่วยให้เรารู้ว่าแอปแครชเพราะ UI หรือ Logic
      options.attachScreenshot = true;
    },
    appRunner:
        () => runApp(
          ProviderScope(
            overrides: [
              isarProvider.overrideWithValue(isarInstance),
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const MyApp(),
          ),
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
    );
  }
}
