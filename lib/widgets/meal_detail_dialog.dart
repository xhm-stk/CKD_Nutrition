import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'smart_food_image.dart';

class MealDetailDialog {
  static void show(BuildContext context, dynamic meal) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.getSurface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SmartFoodImage(
                      foodId: meal.foodId,
                      foodName: meal.foodName,
                      width: 60,
                      height: 60,
                      borderRadius: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.foodName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getMealTypeName(context, meal.mealType)} • ${meal.quantityG.toStringAsFixed(0)}${l10n.gramsUnit}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                l10n.localeName == 'th' ? 'คุณค่าทางโภชนาการทั้งหมด' : 'Nutritional Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(context, l10n.protein, '${meal.proteinG.toStringAsFixed(1)}${l10n.gramsUnit}', const Color(0xFF059669)),
              _buildDetailRow(context, l10n.carbs, '${meal.carbG.toStringAsFixed(1)}${l10n.gramsUnit}', const Color(0xFFD97706)),
              _buildDetailRow(context, l10n.sugar, '${meal.sugarG.toStringAsFixed(1)}${l10n.gramsUnit}', const Color(0xFFEA580C)),
              _buildDetailRow(context, l10n.sodium, '${meal.sodiumMg.toStringAsFixed(0)}${l10n.milligramsUnit}', const Color(0xFF0284C7)),
              _buildDetailRow(context, l10n.potassium, '${meal.potassiumMg.toStringAsFixed(0)}${l10n.milligramsUnit}', const Color(0xFFDC2626)),
              _buildDetailRow(context, l10n.localeName == 'th' ? 'ฟอสฟอรัส' : 'Phosphorus', '${meal.phosphorusMg.toStringAsFixed(0)}${l10n.milligramsUnit}', const Color(0xFF9333EA)),
              if (meal.waterMl > 0)
                _buildDetailRow(context, l10n.water, '${meal.waterMl.toStringAsFixed(0)}${l10n.millilitersUnit}', const Color(0xFF60A5FA)),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  static String _getMealTypeName(BuildContext context, String mealType) {
    final l10n = AppLocalizations.of(context)!;
    switch (mealType) {
      case 'breakfast':
        return l10n.breakfast;
      case 'lunch':
        return l10n.lunch;
      case 'dinner':
        return l10n.dinner;
      default:
        return l10n.localeName == 'th' ? 'มื้ออาหาร' : 'Meal';
    }
  }

  static Widget _buildDetailRow(BuildContext context, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
