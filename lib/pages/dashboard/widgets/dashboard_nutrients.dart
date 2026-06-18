import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../services/quota_engine.dart';

class DashboardNutrientsWidget extends StatelessWidget {
  final List<NutrientQuota> quotas;

  const DashboardNutrientsWidget({super.key, required this.quotas});

  // แมปปิ้งไอคอนและสีให้ตรงกับสารอาหารแต่ละตัว (ดีไซน์จำลองจาก PDF)
  Map<String, dynamic> _getNutrientStyle(String label, bool isDark) {
    Color bg(Color color) =>
        isDark ? color.withValues(alpha: 0.1) : color.withValues(alpha: 0.05);

    switch (label) {
      case 'โปรตีน':
        return {
          'icon': Icons.set_meal_rounded,
          'color': Colors.redAccent.shade200,
          'bg': bg(Colors.redAccent.shade200),
        };
      case 'น้ำตาล':
        return {
          'icon': Icons.cookie_rounded,
          'color': Colors.brown.shade300,
          'bg': bg(Colors.brown.shade300),
        };
      case 'โพแทสเซียม':
        return {
          'icon': Icons.science_rounded,
          'color': Colors.red.shade600,
          'bg': bg(Colors.red.shade600),
        };
      case 'โซเดียม':
        return {
          'icon': Icons.water_drop_rounded,
          'color': Colors.lightBlue,
          'bg': bg(Colors.lightBlue),
        };
      case 'น้ำ':
        return {
          'icon': Icons.local_drink_rounded,
          'color': Colors.blue.shade400,
          'bg': bg(Colors.blue.shade400),
        };
      case 'คาร์บ':
        return {
          'icon': Icons.rice_bowl_rounded,
          'color': Colors.amber.shade600,
          'bg': bg(Colors.amber.shade600),
        };
      default:
        return {
          'icon': Icons.local_dining_rounded,
          'color': Colors.teal,
          'bg': bg(Colors.teal),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดสารอาหารทั้ง 6 ตัวให้ครบ
    final targetLabels = [
      'โปรตีน',
      'คาร์บ',
      'โซเดียม',
      'โพแทสเซียม',
      'น้ำตาล',
      'น้ำ',
    ];
    final displayQuotas =
        quotas.where((q) => targetLabels.contains(q.label)).toList();

    // เรียงลำดับตาม targetLabels เพื่อให้หน้าตาเป๊ะ
    displayQuotas.sort(
      (a, b) => targetLabels
          .indexOf(a.label)
          .compareTo(targetLabels.indexOf(b.label)),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สารอาหารทั้งหมด',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.65, // ปรับให้เหมาะกับความสูงของวงกลม + ข้อความ
            mainAxisSpacing: 16,
            children: List.generate(displayQuotas.length, (index) {
              final q = displayQuotas[index];
              final style = _getNutrientStyle(q.label, isDark);

              final safeLimit = q.limit > 0 ? q.limit : 1.0;
              double percent = q.consumed / safeLimit;
              if (percent > 1.0) percent = 1.0;
              if (percent < 0.0) percent = 0.0;

              // วงแหวนสีตาม percent (ถ้ากินเกิน ให้เปลี่ยนเป็นสีแดงเข้มเพื่อเตือน)
              final ringColor =
                  percent >= 1.0
                      ? Colors.red.shade800
                      : style['color'] as Color;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularPercentIndicator(
                    radius: 38.0,
                    lineWidth: 4.0, // เส้นขอบบางๆ ให้ดูมินิมอลแบบ PDF
                    animation: true,
                    percent: percent,
                    center: CircleAvatar(
                      radius: 28,
                      backgroundColor: style['bg'] as Color,
                      child: Icon(
                        style['icon'] as IconData,
                        color: style['color'] as Color,
                        size: 28,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: ringColor,
                    backgroundColor:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    q.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
