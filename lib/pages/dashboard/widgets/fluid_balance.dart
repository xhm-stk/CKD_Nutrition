import 'package:flutter/material.dart';
import '../../../models/supabase/daily_log.dart';
import '../../../theme/app_theme.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class FluidBalanceWidget extends StatelessWidget {
  final DailyLog log;

  const FluidBalanceWidget({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final intake = log.totalWaterMl;
    final output = log.totalUrineMl;
    final balance = intake - output;
    final targetWater = (log.customWater ?? 2000).toDouble();

    final balanceStr =
        balance >= 0
            ? '+${balance.toStringAsFixed(0)}'
            : balance.toStringAsFixed(0);
            
    final Color balanceColor = balance > 500
        ? const Color(0xFFF59E0B)
        : (balance >= 0 ? const Color(0xFF0284C7) : const Color(0xFF10B981));

    final String statusText = l10n.localeName == 'th'
        ? (balance > 0
            ? 'มีน้ำสะสมค้างในร่างกาย +${balance.toInt()} มล.'
            : (balance < 0
                ? 'ขับน้ำออกมากกว่าน้ำดื่ม ${balance.abs().toInt()} มล.'
                : 'น้ำดื่มและปัสสาวะสมดุลกันเป็นอย่างดี'))
        : (balance > 0
            ? 'Net fluid retention: +${balance.toInt()} ml'
            : (balance < 0
                ? 'Fluid loss exceeds intake: ${balance.abs().toInt()} ml'
                : 'Fluid intake and output are perfectly balanced'));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fluidBalanceTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.fluidBalanceSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Fluid intake vs output 2 cards
          Row(
            children: [
              // Fluid Intake Card
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: l10n.waterIntake,
                  value: '${intake.toInt()} ${l10n.millilitersUnit}',
                  subText: 'โควต้า ${targetWater.toInt()} ${l10n.millilitersUnit}',
                  icon: Icons.local_drink_rounded,
                  color: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFE0F2FE),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              // Urine Output Card
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: l10n.urineOutput,
                  value: '${output.toInt()} ${l10n.millilitersUnit}',
                  subText: l10n.localeName == 'th' ? 'ขับปัสสาวะสะสม' : 'Output total',
                  icon: Icons.opacity_rounded,
                  color: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFEF3C7),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Net Fluid Balance Card (Clear, Un-truncated)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: balanceColor.withValues(alpha: isDark ? 0.15 : 0.08),
              border: Border.all(
                color: balanceColor.withValues(alpha: 0.25),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: balanceColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.scale_rounded,
                    color: balanceColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.localeName == 'th' ? 'ยอดดุลน้ำสะสมสุทธิ' : 'Net Fluid Balance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$balanceStr ${l10n.millilitersUnit}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: balanceColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Doctor Tip Info Box
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.45),
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.fluidBalanceDoctorTip,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.45),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subText,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.brandPrimary.withValues(alpha: 0.08),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: bgColor,
                child: Icon(icon, color: color, size: 15),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subText,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
