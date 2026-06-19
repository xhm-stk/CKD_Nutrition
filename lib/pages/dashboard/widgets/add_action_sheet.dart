import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result.dart';
import '../../../models/isar/food_item.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/meal_providers.dart';
import 'water_entry_sheet.dart';

class AddActionSheet extends ConsumerWidget {
  const AddActionSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B), // bgElevated
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ขีดตรงกลางด้านบน (Drag Handle)
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'เพิ่มมื้ออาหารของคุณ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'เลือกวิธีเพิ่มอาหารที่คุณทานในวันนี้',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ปุ่มตัวเลือกต่างๆ
            _buildActionItem(
              context,
              icon: Icons.restaurant_menu_rounded,
              title: 'เพิ่มเมนูจากแอป',
              subtitle: 'เลือกจากรายการอาหารสุขภาพในแอป',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                context.push('/food-search');
              },
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              icon: Icons.edit_note_rounded,
              title: 'กำหนดเมนูอาหารทำเอง',
              subtitle: 'กรอกข้อมูลโภชนาการด้วยตัวเอง',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                context.push('/food-add');
              },
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              icon: Icons.water_drop_rounded,
              title: 'บันทึกดื่มน้ำ',
              subtitle: 'บันทึกปริมาณน้ำที่ดื่ม',
              color: Colors.lightBlue,
              onTap: () {
                Navigator.pop(context); // ปิด ActionSheet ก่อน

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (ctx) => WaterEntrySheet(
                        onSave: (ml) async {
                          final food =
                              FoodItem()
                                ..foodId = 'quick_water'
                                ..name = 'น้ำเปล่า'
                                ..waterMl = ml.toDouble()
                                ..proteinG = 0
                                ..sodiumMg = 0
                                ..potassiumMg = 0
                                ..phosphorusMg = 0
                                ..sugarG = 0
                                ..carbG = 0;

                          final result = await ref
                              .read(mealControllerProvider)
                              .logMeal(
                                food: food,
                                quantityG: ml.toDouble(),
                                mealType: 'snack',
                              );

                          if (context.mounted) {
                            switch (result) {
                              case Success():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'บันทึกดื่มน้ำ +$ml ml เรียบร้อยแล้ว',
                                    ),
                                  ),
                                );
                                ref.invalidate(dashboardSummaryProvider);
                                ref.invalidate(todayMealsProvider);
                              case Failure(:final userMessage):
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'บันทึกผิดพลาด: $userMessage',
                                    ),
                                  ),
                                );
                            }
                          }
                        },
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
