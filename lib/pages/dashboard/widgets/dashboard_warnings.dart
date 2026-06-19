import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../services/quota_engine.dart';

class DashboardWarningsWidget extends StatelessWidget {
  final List<NutrientQuota> quotas;

  const DashboardWarningsWidget({super.key, required this.quotas});

  @override
  Widget build(BuildContext context) {
    const int mockStreak = 0; // จำลองว่าคุมได้ 0 วันติดต่อกัน

    // กรองหาชื่อสารอาหารที่เกินกำหนด
    final over = quotas
        .where((q) => q.isOverLimit)
        .map((q) => q.label)
        .join(', ');
    final near = quotas
        .where((q) => q.isNearLimit)
        .map((q) => q.label)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. กล่องข้อควรระวัง (แสดงเฉพาะเมื่อมีสารอาหารเกินหรือใกล้เกิน)
        if (over.isNotEmpty || near.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  over.isNotEmpty
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    over.isNotEmpty
                        ? Theme.of(context).colorScheme.onErrorContainer
                        : Theme.of(context).colorScheme.onTertiaryContainer,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        over.isNotEmpty
                            ? Theme.of(context).colorScheme.onErrorContainer
                                .withValues(alpha: 0.2)
                            : Theme.of(context).colorScheme.onTertiaryContainer
                                .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color:
                        over.isNotEmpty
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onTertiaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อควรระวัง',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              over.isNotEmpty
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        over.isNotEmpty
                            ? 'คุณทาน $over เกินกำหนดประจำวันแล้ว!'
                            : 'ปริมาณ $near ใกล้เกินกำหนดแล้ว ระวังด้วยนะ',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              over.isNotEmpty
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer
                                      .withValues(alpha: 0.8)
                                  : Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer
                                      .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // 2. กล่อง Streak คุมอาหารดีเยี่ยม
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow:
                Theme.of(context).brightness == Brightness.dark
                    ? []
                    : [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.08),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                // ปรับไอคอนไฟ ย่อขนาด และเพิ่มแอนิเมชันกระพริบ
                child: const Text('🔥', style: TextStyle(fontSize: 20))
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.2, 1.2),
                      duration: 800.ms,
                      curve: Curves.easeInOut,
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยอดเยี่ยมมาก!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // ดึงตัวเลขจาก mockStreak มาแสดง
                    Text(
                      'คุณคุมอาหารได้ดีติดต่อกัน $mockStreak วันแล้ว',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
