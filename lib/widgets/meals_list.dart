import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../providers/meal_providers.dart';
import '../core/result.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'meal_detail_dialog.dart';
import '../pages/history/history_page.dart';

class MealsListWidget extends ConsumerStatefulWidget {
  const MealsListWidget({super.key});

  @override
  ConsumerState<MealsListWidget> createState() => _MealsListWidgetState();
}

class _MealsListWidgetState extends ConsumerState<MealsListWidget> {
  final Set<String> _optimisticDeletedIds = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mealsAsync = ref.watch(todayMealsProvider);

    return mealsAsync.when(
      data: (rawMeals) {
        final meals =
            rawMeals
                .where((m) => !_optimisticDeletedIds.contains(m.id))
                .toList();

        if (meals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                l10n.noMealsToday,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Dismissible(
              key: Key(meal.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white),
              ),

              onDismissed: (direction) {
                // Optimistically remove from UI to prevent Dismissible assertion error
                setState(() {
                  _optimisticDeletedIds.add(meal.id);
                });

                // Get ScaffoldMessenger before async gap to fix lint warning
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final repo = ref.read(mealRepositoryProvider);

                final eatenAt = meal.eatenAt;
                final dateStr =
                    '${eatenAt.year}-${eatenAt.month.toString().padLeft(2, '0')}-${eatenAt.day.toString().padLeft(2, '0')}';

                // ยิงลบลงฐานข้อมูลทันทีแบบไม่บล็อก UI
                repo.deleteMeal(meal).then((res) {
                  if (mounted) {
                    if (res is Success) {
                      ref.invalidate(dashboardSummaryProvider);
                      ref.invalidate(todayMealsProvider);
                      ref.invalidate(historyMealsProvider(dateStr));
                      ref.invalidate(historySummaryProvider(dateStr));
                      ref.invalidate(historyDatesProvider);
                    } else if (res is Failure) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(res.userMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                      setState(() {
                        _optimisticDeletedIds.remove(meal.id);
                      });
                    }
                  }
                });

                final snackBar = SnackBar(
                  content: Text(l10n.deletedMeal(meal.foodName)),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: l10n.undo,
                    onPressed: () {
                      if (mounted) {
                        // เพิ่มมื้ออาหารกลับมาถ้าผู้ใช้กด Undo
                        ref
                            .read(mealRepositoryProvider)
                            .logMealData(
                              foodId: meal.foodId,
                              foodName: meal.foodName,
                              quantityG: meal.quantityG,
                              mealType: meal.mealType,
                              protein: meal.proteinG,
                              potassium: meal.potassiumMg,
                              sodium: meal.sodiumMg,
                              sugar: meal.sugarG,
                              carb: meal.carbG,
                              water: meal.waterMl,
                              phosphorus: meal.phosphorusMg,
                              eatenAt: meal.eatenAt,
                            )
                            .then((_) {
                              if (mounted) {
                                setState(() {
                                  _optimisticDeletedIds.remove(meal.id);
                                });
                                ref.invalidate(dashboardSummaryProvider);
                                ref.invalidate(todayMealsProvider);
                                ref.invalidate(historyMealsProvider(dateStr));
                                ref.invalidate(historySummaryProvider(dateStr));
                                ref.invalidate(historyDatesProvider);
                              }
                            });
                      }
                    },
                  ),
                );

                scaffoldMessenger.showSnackBar(snackBar).closed.then((reason) {
                  // ถ้า SnackBar ถูกปิดตัวลงไปเฉยๆ (โดยที่ผู้ใช้ไม่ได้กดปุ่ม Undo)
                  // ให้เคลียร์ ID ตัวนี้ออกจากรายการลบจำลอง เพื่อให้ข้อมูลซิงก์ได้อย่างสมบูรณ์
                  if (reason != SnackBarClosedReason.action && mounted) {
                    setState(() {
                      _optimisticDeletedIds.remove(meal.id);
                    });
                  }
                });
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                color: AppTheme.getSurface(context),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => MealDetailDialog.show(context, meal),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Leading meal type icon
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.brandPrimary.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.brandPrimary.withValues(
                                  alpha: 0.25,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              'assets/food_images/${meal.foodId}.webp',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    _getMealIcon(meal.mealType),
                                    color: AppTheme.brandAccent,
                                    size: 26,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Middle: Title, serving weight, and 6 nutrients
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      meal.foodName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Builder(
                                    builder: (context) {
                                      final isWater =
                                          meal.foodId == 'quick_water' ||
                                          meal.foodId.toLowerCase().contains(
                                            'water',
                                          ) ||
                                          meal.foodName == l10n.water;
                                      final unit =
                                          isWater
                                              ? l10n.millilitersUnit
                                              : l10n.gramsUnit;
                                      return Text(
                                        '${meal.quantityG.toStringAsFixed(0)}$unit',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.6),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Nutrients Wrap — including phosphorus
                              Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  _buildNutrientTag(
                                    context,
                                    l10n.protein,
                                    '${meal.proteinG.toStringAsFixed(1)}${l10n.gramsUnit}',
                                    const Color(0xFF059669),
                                  ),
                                  _buildNutrientTag(
                                    context,
                                    l10n.carbs,
                                    '${meal.carbG.toStringAsFixed(1)}${l10n.gramsUnit}',
                                    const Color(0xFFD97706),
                                  ),
                                  _buildNutrientTag(
                                    context,
                                    l10n.sugar,
                                    '${meal.sugarG.toStringAsFixed(1)}${l10n.gramsUnit}',
                                    const Color(0xFFEA580C),
                                  ),
                                  _buildNutrientTag(
                                    context,
                                    l10n.sodium,
                                    '${meal.sodiumMg.toStringAsFixed(0)}${l10n.milligramsUnit}',
                                    const Color(0xFF0284C7),
                                  ),
                                  _buildNutrientTag(
                                    context,
                                    l10n.potassium,
                                    '${meal.potassiumMg.toStringAsFixed(0)}${l10n.milligramsUnit}',
                                    const Color(0xFFDC2626),
                                  ),
                                  _buildNutrientTag(
                                    context,
                                    l10n.localeName == 'th'
                                        ? 'ฟอสฟอรัส'
                                        : 'Phosphorus',
                                    '${meal.phosphorusMg.toStringAsFixed(0)}${l10n.milligramsUnit}',
                                    const Color(0xFF9333EA),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Trailing: meal type name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getMealTypeName(context, meal.mealType),
                              style: const TextStyle(
                                color: AppTheme.brandPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${meal.eatenAt.toLocal().hour.toString().padLeft(2, '0')}:${meal.eatenAt.toLocal().minute.toString().padLeft(2, '0')} น.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'breakfast':
        return Icons.wb_sunny_rounded;
      case 'lunch':
        return Icons.wb_cloudy_rounded;
      case 'dinner':
        return Icons.dark_mode_rounded;
      case 'snack':
        return Icons.cookie_outlined;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  String _getMealTypeName(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'breakfast':
        return l10n.breakfast;
      case 'lunch':
        return l10n.lunch;
      case 'dinner':
        return l10n.dinner;
      case 'snack':
        return l10n.snack;
      default:
        return type;
    }
  }

  Widget _buildNutrientTag(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color:
            isDark
                ? color.withValues(alpha: 0.18)
                : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.0),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? color : color.withValues(alpha: 0.95),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
