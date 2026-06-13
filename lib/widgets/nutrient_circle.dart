import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NutrientCircle extends StatelessWidget {
  final String label;
  final double current;
  final double limit;
  final String unit;

  const NutrientCircle({
    super.key,
    required this.label,
    required this.current,
    required this.limit,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // ป้องกันการหารด้วยศูนย์
    final safeLimit = limit > 0 ? limit : 1.0;
    double percent = current / safeLimit;
    if (percent > 1.0) percent = 1.0;
    if (percent < 0.0) percent = 0.0;

    // คำนวณสีตามโควต้า
    Color progressColor;
    if (percent < 0.8) {
      progressColor = Colors.green;
    } else if (percent < 1.0) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.redAccent;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 8.0,
          animation: true,
          percent: percent,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: progressColor,
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          "${current.toStringAsFixed(1)} / ${limit.toStringAsFixed(1)} $unit",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
