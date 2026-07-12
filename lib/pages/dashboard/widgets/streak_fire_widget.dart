import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget แสดงไอคอนไฟ Streak พร้อม Animation หายใจ (ย่อขนาดและวางแทนปุ่มธีม)
/// [streakCount] = จำนวนวันที่บันทึกติดต่อกัน (0 = ไม่มี streak)
class StreakFireWidget extends StatelessWidget {
  final int streakCount;

  const StreakFireWidget({super.key, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    final hasStreak = streakCount > 0;
    // ใช้สีส้มเมื่อมี streak, สีเทาอ่อน/ขาวจางเมื่อเป็น 0
    final fireColor =
        hasStreak ? Colors.orangeAccent : Colors.white.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$streakCount',
            style: TextStyle(
              color: fireColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
                Icons.local_fire_department_rounded,
                color: fireColor,
                size: 20,
                shadows:
                    hasStreak
                        ? [
                          Shadow(
                            color: Colors.orangeAccent.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ]
                        : null,
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.15, 1.15),
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}
