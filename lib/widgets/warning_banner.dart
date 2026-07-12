import 'package:flutter/material.dart';
import '../services/quota_engine.dart';
import '../l10n/app_localizations.dart';

class WarningBanner extends StatelessWidget {
  final List<NutrientQuota> quotas;
  const WarningBanner({super.key, required this.quotas});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // แปลง English key → localized label ก่อน join
    String localizeLabels(Iterable<NutrientQuota> items) {
      return items.map((q) => _getLocalLabel(l10n, q.label)).join(', ');
    }

    final over = localizeLabels(quotas.where((q) => q.isOverLimit));
    final near = localizeLabels(quotas.where((q) => q.isNearLimit));

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
          Icon(
            Icons.warning_amber_rounded,
            color: over.isNotEmpty ? Colors.red : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              over.isNotEmpty
                  ? l10n.warningOverLimit(over)
                  : l10n.warningNearLimit(near),
              style: const TextStyle(fontWeight: FontWeight.bold),
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
