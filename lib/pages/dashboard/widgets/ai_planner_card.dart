import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/meal_providers.dart';

class AiPlannerCardWidget extends ConsumerWidget {
  const AiPlannerCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerAsync = ref.watch(mealPlannerProvider);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1814), // Dark Amber Surface
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เมนูอาหารแนะนำ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFFF59E0B),
                ),
                onPressed: () => ref.invalidate(mealPlannerProvider),
              ),
            ],
          ),
          const SizedBox(height: 16),
          plannerAsync.when(
            data: (meals) {
              if (meals.isEmpty) {
                return Text(
                  'กำลังรอข้อมูลเพื่อจัดเมนูที่ใช่สำหรับคุณ',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                );
              }

              // วนลูปสร้างการ์ดเมนู (โชว์แค่ 1-3 เมนูก็พอเพื่อความสวยงาม)
              return Column(
                children:
                    meals
                        .take(3)
                        .map((m) => _buildMealRow(context, m))
                        .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, st) => Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRow(BuildContext context, Map<String, dynamic> m) {
    // ดึงค่าสารอาหาร
    final protein = (m['protein_g'] as num).toDouble();
    final sodium = (m['sodium_mg'] as num).toDouble();
    final potassium = (m['potassium_mg'] as num).toDouble();

    // จำลองค่าปริมาณและน้ำตาล (เนื่องจากในฐานข้อมูลบางเมนูอาจไม่มี)
    const sugar = 1.0;
    const portion = 160;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ภาพอาหาร (จำลองเป็น Container สีเทามุมโค้งมน)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80',
                ), // ภาพตัวอย่าง
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // รายละเอียดอาหาร
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['name'] ?? 'ไม่มีชื่อ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'ปริมาณต่อจาน ${portion}g',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 12),

                // ไอคอนสารอาหาร
                Row(
                  children: [
                    _buildMacroIcon(
                      context,
                      Icons.set_meal_rounded,
                      Colors.redAccent,
                      '${protein.toStringAsFixed(0)} g',
                    ),
                    const SizedBox(width: 8),
                    _buildMacroIcon(
                      context,
                      Icons.cookie_rounded,
                      Colors.brown,
                      '${sugar.toStringAsFixed(0)} g',
                    ),
                    const SizedBox(width: 8),
                    _buildMacroIcon(
                      context,
                      Icons.science_rounded,
                      Colors.red,
                      '${potassium.toStringAsFixed(0)} mg',
                    ),
                    const SizedBox(width: 8),
                    _buildMacroIcon(
                      context,
                      Icons.water_drop_rounded,
                      Colors.blue,
                      '${sodium.toStringAsFixed(0)} mg',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroIcon(
    BuildContext context,
    IconData icon,
    Color color,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
