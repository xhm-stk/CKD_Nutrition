import 'package:flutter/material.dart';
import '../services/quota_engine.dart';

class WarningBanner extends StatelessWidget {
  final List<NutrientQuota> quotas;
  const WarningBanner({super.key, required this.quotas});

  @override
  Widget build(BuildContext context) {
    // กรองหาชื่อสารอาหารที่เกินกำหนด
    final over = quotas.where((q) => q.isOverLimit).map((q) => q.label).join(', ');
    final near = quotas.where((q) => q.isNearLimit).map((q) => q.label).join(', ');

    // ถ้าไม่มีอะไรน่าเป็นห่วง ไม่ต้องโชว์ป้ายนี้ (หดตัวหายไปเลย)
    if (over.isEmpty && near.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: over.isNotEmpty ? Colors.red[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: over.isNotEmpty ? Colors.red : Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: over.isNotEmpty ? Colors.red : Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              over.isNotEmpty 
                ? 'ระวัง! คุณทาน $over เกินโควต้าแล้ว' 
                : 'แจ้งเตือน: ปริมาณ $near ใกล้เกินกำหนด (เกิน 80%)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}