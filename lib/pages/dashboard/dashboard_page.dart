import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
import '../../providers/meal_providers.dart';
import '../../controllers/auth_controller.dart';
import '../../services/quota_engine.dart';
import '../../widgets/nutrient_circle.dart';
import '../../widgets/meals_list.dart';
import '../../widgets/warning_banner.dart';
import '../../widgets/offline_banner.dart';
import '../../models/supabase/daily_log.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<DailyLog?>>(dashboardSummaryProvider, (previous, next) {
      if (next is AsyncData && next.value == null) {
        context.go('/health-setup');
      }
    });

    final dashboardAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('โภชนาการวันนี้'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: () {
              ref.invalidate(dashboardSummaryProvider);
              ref.invalidate(todayMealsProvider);
            }
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('เมนูหลัก', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('AI แนะนำอาหาร 3 มื้อ'),
              onTap: () {
                Navigator.pop(context); // ปิด Drawer
                context.push('/meal-planner');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('ประวัติและสรุปรายเดือน'),
              onTap: () {
                Navigator.pop(context);
                context.push('/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('ข้อมูลสุขภาพ / โปรไฟล์'),
              onTap: () {
                Navigator.pop(context);
                context.push('/health-setup');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.orange)),
              onTap: () async {
                await ref.read(authControllerProvider).logout();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('ลบบัญชีถาวร', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // ปิด Drawer ก่อน
                _showDeleteAccountDialog(context, ref);
              },
            ),
          ],
        ),
      ),
      body: dashboardAsync.when(
        data: (log) {
          if (log == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final quotas = QuotaEngine.calculate(log: log);
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardSummaryProvider);
              ref.invalidate(todayMealsProvider);
            },
            child: ListView(
              children: [
                const OfflineBanner(),
                WarningBanner(quotas: quotas),
                const SizedBox(height: 16),
                
                // AI Planner Box
                _buildAiPlannerSection(context, ref),
                
                const Divider(height: 32, thickness: 1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'โควต้าสารอาหารประจำวัน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 3x2 Grid สำหรับหลอดวงกลมโควต้า
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.8,
                  children: quotas.map((q) => NutrientCircle(
                    label: q.label,
                    current: q.consumed,
                    limit: q.limit,
                    unit: q.unit,
                  )).toList(),
                ),
                
                const Divider(height: 32, thickness: 1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'รายการมื้ออาหารวันนี้',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // รายการมื้ออาหาร (สามารถ Swipe to delete ได้)
                const MealsListWidget(),
                
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('บันทึกมื้ออาหาร'),
        onPressed: () async {
          // ไปหน้าเลือกอาหาร
          await context.push('/food-search');
          // เมื่อกลับมาให้รีเฟรชข้อมูล
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(todayMealsProvider);
          ref.invalidate(mealPlannerProvider);
        },
      ),
    );
  }

  Widget _buildAiPlannerSection(BuildContext context, WidgetRef ref) {
    final plannerAsync = ref.watch(mealPlannerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.teal.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.teal.shade100, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.teal, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'AI แนะนำเมนูอาหาร',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.teal, size: 28),
                    onPressed: () => ref.invalidate(mealPlannerProvider),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              plannerAsync.when(
                data: (meals) {
                  if (meals.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('ไม่พบเมนูที่เหมาะสมกับโควต้าของคุณในขณะนี้', style: TextStyle(fontSize: 16)),
                    );
                  }
                  return Column(
                    children: meals.map<Widget>((m) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          radius: 24,
                          child: const Icon(Icons.restaurant, color: Colors.teal, size: 24),
                        ),
                        title: Text(
                          m['name'] ?? 'ไม่มีชื่อ',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'โปรตีน ${(m['protein_g'] as num).toDouble().toStringAsFixed(1)}g',
                                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'โซเดียม ${(m['sodium_mg'] as num).toDouble().toStringAsFixed(0)}mg',
                                  style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, st) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('รอซิงก์ข้อมูลกับระบบออนไลน์...', style: TextStyle(color: Colors.red.shade400, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ระบบป้องกันการเผลอกดลบบัญชีโดยไม่ได้ตั้งใจ (2-Step Warning)
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ คำเตือน: ลบบัญชีถาวร', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          'การกระทำนี้ไม่สามารถย้อนกลับได้\n\n'
          'ข้อมูลประวัติการกินอาหาร ข้อมูลสุขภาพ และบัญชีของคุณ จะถูกลบออกจากระบบของแอปพลิเคชันอย่างถาวรตามนโยบายความเป็นส่วนตัว\n\n'
          'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชี?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx); // ปิด Dialog แรก
              _showFinalConfirmationDialog(context, ref); // เปิด Dialog ยืนยันขั้นสุดท้าย
            },
            child: const Text('ดำเนินการต่อ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันครั้งสุดท้าย', style: TextStyle(color: Colors.red)),
        content: const Text('คุณกำลังจะลบข้อมูลทั้งหมดทิ้งถาวร กดยืนยันเพื่อดำเนินการทันที'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx); // ปิด Dialog
              
              // แสดง Loading ชั่วคราว (ถ้าทำได้)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('กำลังลบข้อมูลบัญชีของคุณ...')),
              );
              Navigator.pop(context); // ปิด Dialog โหลด
              final error = await ref.read(authControllerProvider).deleteAccount();
              if (error != null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
                  );
                }
              } else {
                // ถ้าลบสำเร็จ state จะเปลี่ยนและเด้งไปหน้า login อัตโนมัติ (ผ่าน GoRouter refresh)
              }
            },
            child: const Text('ลบทิ้งถาวร', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}