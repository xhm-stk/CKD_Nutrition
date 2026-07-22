import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../providers/meal_providers.dart';
import '../core/result.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

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

                final snackBar = SnackBar(
                  content: Text(l10n.deletedMeal(meal.foodName)),
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: l10n.undo,
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _optimisticDeletedIds.remove(meal.id);
                        });
                      }
                    },
                  ),
                );

                scaffoldMessenger.showSnackBar(snackBar).closed.then((reason) {
                  // ถ้ามันปิดไปโดยที่ไม่ได้กด Undo (action) ค่อยยิงลบจริง
                  if (reason != SnackBarClosedReason.action) {
                    repo.deleteMeal(meal).then((res) {
                      if (mounted) {
                        if (res is Success) {
                          ref.invalidate(dashboardSummaryProvider);
                          ref.invalidate(todayMealsProvider);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            // Nutrients Wrap — all 6
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                _buildNutrientTag(
                                  context,
                                  l10n.protein,
                                  '${meal.proteinG.toStringAsFixed(1)}${l10n.gramsUnit}',
                                  const Color(0xFF34D399),
                                ),
                                _buildNutrientTag(
                                  context,
                                  l10n.carbs,
                                  '${meal.carbG.toStringAsFixed(1)}${l10n.gramsUnit}',
                                  const Color(0xFFFBBF24),
                                ),
                                _buildNutrientTag(
                                  context,
                                  l10n.sugar,
                                  '${meal.sugarG.toStringAsFixed(1)}${l10n.gramsUnit}',
                                  AppTheme.brandSecondary,
                                ),
                                _buildNutrientTag(
                                  context,
                                  l10n.sodium,
                                  '${meal.sodiumMg.toStringAsFixed(0)}${l10n.milligramsUnit}',
                                  const Color(0xFF38BDF8),
                                ),
                                _buildNutrientTag(
                                  context,
                                  l10n.potassium,
                                  '${meal.potassiumMg.toStringAsFixed(0)}${l10n.milligramsUnit}',
                                  const Color(0xFFF87171),
                                ),
                                _buildNutrientTag(
                                  context,
                                  l10n.water,
                                  '${meal.waterMl.toStringAsFixed(0)}${l10n.millilitersUnit}',
                                  const Color(0xFF60A5FA),
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
                            _getMealTypeName(meal.mealType),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.localeName == 'th'
                                ? '${meal.eatenAt.hour.toString().padLeft(2, '0')}:${meal.eatenAt.minute.toString().padLeft(2, '0')} น.'
                                : '${meal.eatenAt.hour.toString().padLeft(2, '0')}:${meal.eatenAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading:
          () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          ),
      error: (e, st) => Center(child: Text('${l10n.error}: $e')),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'breakfast':
        return Icons.wb_twilight;
      case 'lunch':
        return Icons.wb_sunny;
      case 'dinner':
        return Icons.nights_stay;
      default:
        return Icons.local_cafe;
    }
  }

  String _getMealTypeName(String type) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
