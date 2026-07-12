import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/quota_engine.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class DashboardWarningsWidget extends ConsumerWidget {
  final List<NutrientQuota> quotas;

  const DashboardWarningsWidget({super.key, required this.quotas});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // แปลง English key → localized label แล้วค่อย join
    String localizeLabels(Iterable<NutrientQuota> items) {
      return items.map((q) => _getLocalLabel(l10n, q.label)).join(', ');
    }

    final overLabels = localizeLabels(quotas.where((q) => q.isOverLimit));
    final nearLabels = localizeLabels(quotas.where((q) => q.isNearLimit));

    if (overLabels.isEmpty && nearLabels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            overLabels.isNotEmpty
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              overLabels.isNotEmpty
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onTertiaryContainer,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  overLabels.isNotEmpty
                      ? Theme.of(
                        context,
                      ).colorScheme.onErrorContainer.withValues(alpha: 0.2)
                      : Theme.of(
                        context,
                      ).colorScheme.onTertiaryContainer.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color:
                  overLabels.isNotEmpty
                      ? Theme.of(context).colorScheme.onErrorContainer
                      : Theme.of(context).colorScheme.onTertiaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.warning,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        overLabels.isNotEmpty
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  overLabels.isNotEmpty
                      ? l10n.warningOverLimitDash(overLabels)
                      : l10n.warningNearLimitDash(nearLabels),
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        overLabels.isNotEmpty
                            ? Theme.of(context).colorScheme.onErrorContainer
                                .withValues(alpha: 0.8)
                            : Theme.of(context).colorScheme.onTertiaryContainer
                                .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// แปลง English key → localized label
  String _getLocalLabel(AppLocalizations l10n, String label) {
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
