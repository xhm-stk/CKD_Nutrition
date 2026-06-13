import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
import '../../repositories/auth_repository.dart';
import '../../services/quota_engine.dart';
import '../../widgets/nutrient_circle.dart';
import '../../widgets/meals_list.dart';
import '../../widgets/warning_banner.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await ref.read(authRepositoryProvider).logout();
              },
            ),
          ],
        ),
      ),
      body: dashboardAsync.when(
        data: (log) {
          if (log == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/health-setup');
            });
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
        color: Colors.blue.shade50,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.blue.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🧠 AI แนะนำเมนูอาหาร (อยู่ในโควต้า)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () => ref.invalidate(mealPlannerProvider),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              plannerAsync.when(
                data: (meals) {
                  if (meals.isEmpty) {
                    return const Text('ไม่พบเมนูที่เหมาะสมกับโควต้าของคุณ');
                  }
                  return Column(
                    children: meals.map<Widget>((m) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(m['name'] ?? 'ไม่มีชื่อ')),
                          Text('${m['protein_g']}g โปรตีน', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    )).toList(),
                  );
                },
                loading: () => const Center(child: LinearProgressIndicator()),
                error: (err, st) => const Text('รอการอัปเดตระบบจาก Supabase...', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}