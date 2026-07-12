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

    final balanceStr =
        balance >= 0
            ? '+${balance.toStringAsFixed(0)}'
            : balance.toStringAsFixed(0);
    final balanceColor =
        balance >= 0 ? const Color(0xFF60A5FA) : const Color(0xFFF87171);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.opacity_rounded,
                  color: Colors.cyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.fluidBalanceTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF59E0B,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: const Text(
                            'BETA',
                            style: TextStyle(
                              color: Color(0xFFD97706),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.fluidBalanceSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Fluid intake vs output grid-row
          Row(
            children: [
              // Fluid Intake Card
              Expanded(
                child: _buildItemCard(
                  context,
                  title: l10n.waterIntake,
                  val: '${intake.toStringAsFixed(0)} ${l10n.millilitersUnit}',
                  icon: Icons.local_drink_rounded,
                  color: const Color(0xFF60A5FA),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              // Urine Output Card
              Expanded(
                child: _buildItemCard(
                  context,
                  title: l10n.urineOutput,
                  val: '${output.toStringAsFixed(0)} ${l10n.millilitersUnit}',
                  icon: Icons.opacity_rounded,
                  color: Colors.amber.shade600,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Net Fluid Balance Card (Full Width)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: balanceColor.withValues(alpha: 0.05),
              border: Border.all(color: balanceColor.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.scale_rounded, color: balanceColor, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.netWaterBalance,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          l10n.localeName == 'th'
                              ? (balance >= 0
                                  ? 'สมดุลน้ำเป็นบวก (สะสมน้ำ)'
                                  : 'สมดุลน้ำเป็นลบ (สูญเสียน้ำ)')
                              : (balance >= 0
                                  ? 'Positive fluid balance'
                                  : 'Negative fluid balance'),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$balanceStr ${l10n.millilitersUnit}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: balanceColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Doctor Tip Info Box
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.fluidBalanceDoctorTip,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
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

  Widget _buildItemCard(
    BuildContext context, {
    required String title,
    required String val,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            val,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
