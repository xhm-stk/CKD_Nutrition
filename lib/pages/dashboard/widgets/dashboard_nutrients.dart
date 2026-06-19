import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../services/quota_engine.dart';
import '../../../theme/app_theme.dart';

class DashboardNutrientsWidget extends StatelessWidget {
  final List<NutrientQuota> quotas;

  const DashboardNutrientsWidget({super.key, required this.quotas});

  // แมปปิ้งไอคอนและสีให้ตรงกับสารอาหารแต่ละตัว (Emerald Edition)
  Map<String, dynamic> _getNutrientStyle(String label, bool isDark) {
    Color bg(Color color) =>
        isDark ? color.withValues(alpha: 0.1) : color.withValues(alpha: 0.05);

    switch (label) {
      case 'โปรตีน':
        return {
          'icon': Icons.set_meal_rounded,
          'color': const Color(0xFF34D399), // Mint
          'bg': bg(const Color(0xFF34D399)),
        };
      case 'น้ำตาล':
        return {
          'icon': Icons.cookie_rounded,
          'color': AppTheme.brandSecondary,
          'bg': bg(AppTheme.brandSecondary),
        };
      case 'โพแทสเซียม':
        return {
          'icon': Icons.science_rounded,
          'color': const Color(0xFFF87171), // Soft Red
          'bg': bg(const Color(0xFFF87171)),
        };
      case 'โซเดียม':
        return {
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFF38BDF8), // Sky Blue
          'bg': bg(const Color(0xFF38BDF8)),
        };
      case 'น้ำ':
        return {
          'icon': Icons.local_drink_rounded,
          'color': const Color(0xFF60A5FA), // Indigo Light
          'bg': bg(const Color(0xFF60A5FA)),
        };
      case 'คาร์บ':
        return {
          'icon': Icons.rice_bowl_rounded,
          'color': const Color(0xFFFBBF24), // Amber
          'bg': bg(const Color(0xFFFBBF24)),
        };
      default:
        return {
          'icon': Icons.local_dining_rounded,
          'color': AppTheme.brandPrimary,
          'bg': bg(AppTheme.brandPrimary),
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
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
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
            childAspectRatio: 0.85, // ปรับให้กระชับขึ้น
            mainAxisSpacing: 8, // ลดระยะห่างแนวตั้ง
            crossAxisSpacing: 4, // ลดระยะห่างแนวนอน
            children: List.generate(displayQuotas.length, (index) {
              final q = displayQuotas[index];
              final style = _getNutrientStyle(q.label, isDark);

              final safeLimit = q.limit > 0 ? q.limit : 1.0;
              double percent = q.consumed / safeLimit;
              if (percent > 1.0) percent = 1.0;
              if (percent < 0.0) percent = 0.0;

              // วงแหวนสีตาม percent (ถ้ากินเกิน ให้เปลี่ยนเป็นสีแดงเข้มเพื่อเตือน)
              final ringColor =
                  percent >= 1.0 ? AppTheme.errorBase : style['color'] as Color;

              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularPercentIndicator(
                      radius: 34.0, // ย่อวงแหวนลงเล็กน้อย
                      lineWidth: 4.0,
                      animation: true,
                      animationDuration: 1200,
                      percent: percent,
                      center: CircleAvatar(
                        radius: 24, // ย่อวงกลมด้านใน
                        backgroundColor: style['bg'] as Color,
                        child: Icon(
                          style['icon'] as IconData,
                          color: style['color'] as Color,
                          size: 24, // ย่อไอคอน
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: ringColor,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    ),
                    const SizedBox(height: 8),
                    // Number Ticker
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: q.consumed),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, child) {
                        return Text(
                          '${value.toInt()}/${q.limit.toInt()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Text(
                      q.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
