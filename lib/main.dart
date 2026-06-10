import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/isar/food_item.dart';
import 'services/isar_seed_service.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
// import หน้าจอต่างๆ ของคุณ...
import 'pages/dashboard/dashboard_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/health_setup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // บังคับให้ Flutter สตาร์ท

  // 1. เชื่อมต่อ Supabase (Cloud)
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  // 2. เปิด Isar (Local)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [FoodItemSchema, CkdRuleCacheSchema],
    directory: dir.path,
  );

  // 3. ปั๊มข้อมูลอาหาร 156 เมนูลงเครื่อง
  await IsarSeedService.seedFoodData(isar);

  // สร้าง Singleton Instance ของ AuthService
  final authService = AuthService(isar);

  runApp(
    Provider<AuthService>.value(
      value: authService,
      child: MyApp(isar: isar),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CKD Nutrition',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('th'), // ภาษาเริ่มต้นคือไทย
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          
          final session = snap.data!.session;
          if (session != null) {
            // เมื่อผู้ใช้ล็อกอินอยู่ ให้ตรวจสอบว่ามีข้อมูลโปรไฟล์สุขภาพในฐานข้อมูลแล้วหรือยัง
            return FutureBuilder<Map<String, dynamic>?>(
              future: Supabase.instance.client
                  .from('user_health_profiles')
                  .select('id')
                  .eq('user_id', session.user.id)
                  .maybeSingle(),
              builder: (futureCtx, futureSnap) {
                // ระหว่างรอผล Query ให้แสดงตัวโหลดหมุนวน
                if (futureSnap.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                
                // หากพบข้อมูลโปรไฟล์สุขภาพแล้ว ให้เข้าหน้า Dashboard ได้ทันที
                if (futureSnap.hasData && futureSnap.data != null) {
                  return DashboardPage(isar: isar);
                }
                
                // หากยังไม่มีข้อมูลสุขภาพ ให้นำทางผู้ใช้ไปยังหน้าตั้งค่าก่อน (HealthSetupPage)
                return HealthSetupPage(isar: isar);
              },
            );
          } else {
            // หากไม่ได้ล็อกอิน ให้กลับไปหน้าล็อกอินปกติ
            return LoginPage(isar: isar);
          }
        },
      ),
    );
  }
}