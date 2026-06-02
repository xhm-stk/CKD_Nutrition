import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/isar/food_item.dart';
import 'services/isar_seed_service.dart';
// import หน้าจอต่างๆ ของคุณ...
import 'pages/dashboard/dashboard_page.dart';
import 'pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // บังคับให้ Flutter สตาร์ท

  // 1. เชื่อมต่อ Supabase (Cloud)
  await Supabase.initialize(
    url: 'https://wgjvfqsdhozgvxrqvgyo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndnanZmcXNkaG96Z3Z4cnF2Z3lvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAxMzkzODcsImV4cCI6MjA5NTcxNTM4N30.rOjV3ef49bMzXiafBpJmdgV-8Pw9m0O5lDl0fz7Wuek',
  );

  // 2. เปิด Isar (Local)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [FoodItemSchema, CkdRuleCacheSchema],
    directory: dir.path,
  );

  // 3. ปั๊มข้อมูลอาหาร 156 เมนูลงเครื่อง
  await IsarSeedService.seedFoodData(isar);

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          // เช็ค Session ว่าล็อกอินอยู่หรือไม่
          return snap.data!.session != null
            ? DashboardPage(isar: isar)
            : LoginPage(isar: isar);
        },
      ),
    );
  }
}