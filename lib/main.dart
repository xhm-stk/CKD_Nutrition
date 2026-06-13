import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';

import 'models/isar/food_item.dart';
import 'services/isar_seed_service.dart';
import 'providers/core_providers.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // บังคับให้ Flutter สตาร์ท

  // 1. โหลดตัวแปรสภาพแวดล้อมจากไฟล์ .env
  await dotenv.load(fileName: ".env");

  // 2. เชื่อมต่อ Supabase (Cloud) โดยดึงค่าจาก dotenv
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 2. เปิด Isar (Local)
  final dir = await getApplicationDocumentsDirectory();
  final isarInstance = await Isar.open(
    [FoodItemSchema, CkdRuleCacheSchema],
    directory: dir.path,
  );

  // 3. ปั๊มข้อมูลอาหาร 156 เมนูลงเครื่อง (เปิด forceUpdate: true เพื่อล้างและอัปเดตข้อมูลภาษาไทยใหม่ทั้งหมดบนอุปกรณ์)
  await IsarSeedService.seedFoodData(isarInstance, forceUpdate: true);

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isarInstance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CKD Nutrition',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('th'), // ภาษาเริ่มต้นคือไทย
      routerConfig: router,
    );
  }
}