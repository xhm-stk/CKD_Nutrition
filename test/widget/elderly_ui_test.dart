import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ckd_nutrition_app/pages/dashboard/dashboard_page.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';
import 'package:ckd_nutrition_app/providers/meal_providers.dart';
import 'package:ckd_nutrition_app/models/supabase/daily_log.dart';

void main() {
  testWidgets('DashboardPage rendering with Elderly Font Scale (200%)', (WidgetTester tester) async {
    // กำหนดขนาดหน้าจอจำลอง (Phone Portrait)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    // ข้อมูลจำลองสำหรับ Dashboard
    const mockLog = DailyLog(
      id: 'log1',
      userId: 'user1',
      logDate: '2026-06-16',
      totalProteinG: 10,
      totalSodiumMg: 500,
      customProtein: 60,
      customSodium: 2000,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardSummaryProvider.overrideWith((ref) => mockLog),
          todayMealsProvider.overrideWith((ref) => []),
          mealPlannerProvider.overrideWith((ref) => []),
        ],
        child: const MediaQuery(
          // จำลองการตั้งค่า Text Scale บนเครื่องผู้สูงอายุเป็น 200%
          data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: MaterialApp(
            home: DashboardPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // ค้นหาข้อความหลักในหน้า Dashboard ว่าแสดงผลได้ครบถ้วนหรือไม่
    expect(find.text('โภชนาการวันนี้'), findsOneWidget);
    
    // หากมี RenderFlex overflow (หน้าจอแตก) tester จะโยน Exception อัตโนมัติระหว่างที่ pumpAndSettle
    // ถ้าผ่านมาถึงบรรทัดนี้ได้แปลว่าหน้าจอสามารถรองรับฟอนต์ใหญ่ได้โดยไม่พัง
    
    // reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
