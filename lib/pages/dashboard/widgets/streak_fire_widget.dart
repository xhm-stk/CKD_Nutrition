import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget แสดงไอคอนไฟ Streak พร้อม Animation หายใจ
/// [streakCount] = จำนวนวันที่บันทึกติดต่อกัน (0 = ไม่มี streak)
class StreakFireWidget extends StatelessWidget {
  final int streakCount;

  const StreakFireWidget({super.key, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    final hasStreak = streakCount > 0;
    final fireColor = hasStreak ? Colors.orangeAccent : Colors.grey.shade600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ตัวเลข streak
        if (hasStreak)
          Text(
            '$streakCount',
            style: TextStyle(
              color: fireColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

        const SizedBox(width: 4),

        // ไอคอนไฟ + animation หายใจ
        Icon(
              Icons.local_fire_department_rounded,
              color: fireColor,
              size: 28,
              shadows:
                  hasStreak
                      ? [
                        Shadow(
                          color: Colors.orangeAccent.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ]
                      : null,
            )
            .animate(
              onPlay:
                  (controller) =>
                      hasStreak ? controller.repeat(reverse: true) : null,
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end:
                  hasStreak ? const Offset(1.15, 1.15) : const Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}
