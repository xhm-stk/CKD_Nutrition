import 'package:flutter/material.dart';
import '../services/quota_engine.dart'; // import ให้ตรงกับโปรเจกต์คุณ

class QuotaBar extends StatelessWidget {
  final NutrientQuota quota;
  const QuotaBar({super.key, required this.quota});

  @override
  Widget build(BuildContext context) {
    // กำหนดสีตามสถานะที่คำนวณมาจาก QuotaEngine
    final color =
        quota.isOverLimit
            ? Colors.red
            : quota.isNearLimit
            ? Colors.orange
            : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quota.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${quota.consumed.toStringAsFixed(1)} / ${quota.limit} ${quota.unit}',
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: quota.percent, // ค่า 0.0 ถึง 1.0
              backgroundColor: Colors.grey[300],
              color: color,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}
