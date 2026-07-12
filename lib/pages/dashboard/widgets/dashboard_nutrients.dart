import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../services/quota_engine.dart';
import '../../../theme/app_theme.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class DashboardNutrientsWidget extends StatelessWidget {
  final List<NutrientQuota> quotas;

  const DashboardNutrientsWidget({super.key, required this.quotas});

  // แมปปิ้งไอคอน สี และ unit ให้ตรงกับสารอาหารแต่ละตัว
  Map<String, dynamic> _getNutrientStyle(
    String label,
    bool isDark,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    Color bg(Color color) =>
        isDark ? color.withValues(alpha: 0.12) : color.withValues(alpha: 0.07);

    switch (label) {
      case 'protein':
        return {
          'icon': Icons.set_meal_rounded,
          'color': const Color(0xFF34D399),
          'bg': bg(const Color(0xFF34D399)),
          'unit': l10n.gramsUnit,
        };
      case 'carb':
        return {
          'icon': Icons.rice_bowl_rounded,
          'color': const Color(0xFFFBBF24),
          'bg': bg(const Color(0xFFFBBF24)),
          'unit': l10n.gramsUnit,
        };
      case 'sodium':
        return {
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFF38BDF8),
          'bg': bg(const Color(0xFF38BDF8)),
          'unit': l10n.milligramsUnit,
        };
      case 'potassium':
        return {
          'icon': Icons.science_rounded,
          'color': const Color(0xFFF87171),
          'bg': bg(const Color(0xFFF87171)),
          'unit': l10n.milligramsUnit,
        };
      case 'sugar':
        return {
          'icon': Icons.cookie_rounded,
          'color': AppTheme.brandSecondary,
          'bg': bg(AppTheme.brandSecondary),
          'unit': l10n.gramsUnit,
        };
      case 'water':
        return {
          'icon': Icons.local_drink_rounded,
          'color': const Color(0xFF60A5FA),
          'bg': bg(const Color(0xFF60A5FA)),
          'unit': l10n.millilitersUnit,
        };
      default:
        return {
          'icon': Icons.local_dining_rounded,
          'color': AppTheme.brandPrimary,
          'bg': bg(AppTheme.brandPrimary),
          'unit': '',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    const targetLabels = [
      'protein',
      'carb',
      'sodium',
      'potassium',
      'sugar',
      'water',
    ];
    final displayQuotas =
        quotas.where((q) => targetLabels.contains(q.label)).toList();

    displayQuotas.sort(
      (a, b) => targetLabels
          .indexOf(a.label)
          .compareTo(targetLabels.indexOf(b.label)),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              const Icon(
                Icons.monitor_heart_rounded,
                color: AppTheme.brandPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.allNutrients,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid: 3 columns × 2 rows
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.70,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: List.generate(displayQuotas.length, (index) {
              final q = displayQuotas[index];
              final style = _getNutrientStyle(q.label, isDark, context);
              final accentColor = style['color'] as Color;
              final bgColor = style['bg'] as Color;
              final icon = style['icon'] as IconData;
              final unit = style['unit'] as String;

              final safeLimit = q.limit > 0 ? q.limit : 1.0;
              double percent = q.consumed / safeLimit;
              if (percent > 1.0) percent = 1.0;
              if (percent < 0.0) percent = 0.0;

              final ringColor =
                  percent >= 1.0 ? AppTheme.errorBase : accentColor;

              // Format limit
              final isDecimal = unit == 'g' || unit == 'ml';
              final limitStr =
                  isDecimal
                      ? q.limit.toStringAsFixed(0)
                      : q.limit.toInt().toString();

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white, // Solid white surface
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.brandPrimary.withValues(
                      alpha: 0.08,
                    ), // Soft sky blue border
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular ring
                    CircularPercentIndicator(
                      radius: 32.0,
                      lineWidth: 4.5,
                      animation: true,
                      animationDuration: 1200,
                      percent: percent,
                      center: CircleAvatar(
                        radius: 22,
                        backgroundColor: bgColor,
                        child: Icon(icon, color: accentColor, size: 20),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: ringColor,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    ),
                    const SizedBox(height: 8),

                    // Consumed value (animated)
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: q.consumed),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, child) {
                        final displayVal =
                            isDecimal
                                ? value.toStringAsFixed(1)
                                : value.toInt().toString();
                        return Text(
                          '$displayVal$unit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: accentColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const SizedBox(height: 2),

                    // Limit text
                    Text(
                      '/ $limitStr$unit',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),

                    // Label name
                    Text(
                      _getLocalLabel(context, q.label),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.75),
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

  String _getLocalLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    switch (label) {
      case 'protein':
        return l10n.protein;
      case 'sugar':
        return l10n.sugar;
      case 'potassium':
        return l10n.potassium;
      case 'sodium':
        return l10n.sodium;
      case 'water':
        return l10n.water;
      case 'carb':
        return l10n.carbs;
      default:
        return label;
    }
  }
}
