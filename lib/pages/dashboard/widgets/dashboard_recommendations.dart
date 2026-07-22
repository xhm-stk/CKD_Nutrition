import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isar/isar.dart';
import '../../../theme/app_theme.dart';
import '../../../models/isar/food_item.dart';
import '../../../models/supabase/daily_log.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/meal_providers.dart';
import '../../../core/result.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class DashboardRecommendationsWidget extends ConsumerStatefulWidget {
  final DailyLog log;
  const DashboardRecommendationsWidget({super.key, required this.log});

  @override
  ConsumerState<DashboardRecommendationsWidget> createState() =>
      _DashboardRecommendationsWidgetState();
}

class _DashboardRecommendationsWidgetState
    extends ConsumerState<DashboardRecommendationsWidget> {
  List<FoodItem> _recommendations = [];
  bool _isLoading = true;
  String _currentMealType = 'snack';
  String _ckdStage = 'stage_3a';

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      final sb = ref.read(supabaseProvider);
      final user = sb.auth.currentUser;

      String stage = 'stage_3a';
      if (user != null) {
        final prefs = ref.read(sharedPreferencesProvider);
        final profileStr = prefs.getString('profile_${user.id}');
        if (profileStr != null) {
          final profile = jsonDecode(profileStr);
          stage = profile['ckd_stage'] ?? 'stage_3a';
        }
      }

      final hour = DateTime.now().hour;
      List<String> targetCategories = [];
      String mealType = 'snack';

      if (hour >= 5 && hour < 11) {
        targetCategories = ['กับข้าว', 'อาหารจานเดียว/เส้น'];
        mealType = 'breakfast';
      } else if (hour >= 11 && hour < 16) {
        targetCategories = ['อาหารจานเดียว/เส้น', 'กับข้าว'];
        mealType = 'lunch';
      } else if (hour >= 16 && hour < 18) {
        targetCategories = ['ผลไม้', 'เครื่องดื่ม'];
        mealType = 'snack';
      } else if (hour >= 18 && hour < 23) {
        targetCategories = ['กับข้าว', 'อาหารจานเดียว/เส้น'];
        mealType = 'dinner';
      } else {
        targetCategories = ['เครื่องดื่ม', 'ผลไม้'];
        mealType = 'snack';
      }

      // Fetch all foods from Isar
      final allFoods = await isar.foodItems.where().findAll();

      // Apply CKD limits filter
      // For stage 3a, 3b, 4, 5: strict limits (sodium < 250mg, potassium < 350mg)
      final isSevere = stage == 'stage_3a' ||
          stage == 'stage_3b' ||
          stage == 'stage_4' ||
          stage == 'stage_5';

      List<FoodItem> filtered = allFoods.where((f) {
        if (!targetCategories.contains(f.category)) return false;
        if (isSevere) {
          if (f.sodiumMg > 250) return false;
          if (f.potassiumMg > 350) return false;
        }
        return true;
      }).toList();

      // Fallback if empty
      if (filtered.isEmpty) {
        filtered = allFoods
            .where((f) => targetCategories.contains(f.category))
            .toList();
      }
      if (filtered.isEmpty) {
        filtered = allFoods;
      }

      // Shuffle and pick 3 diverse items if possible
      filtered.shuffle();

      // Let's try to pick from different categories to ensure diversity
      final Map<String, List<FoodItem>> grouped = {};
      for (var f in filtered) {
        grouped.putIfAbsent(f.category, () => []).add(f);
      }

      List<FoodItem> selected = [];
      final keys = grouped.keys.toList();
      int keyIdx = 0;
      while (selected.length < 3 && filtered.isNotEmpty) {
        if (keys.isEmpty) {
          selected.addAll(filtered.take(3 - selected.length));
          break;
        }
        final cat = keys[keyIdx % keys.length];
        final list = grouped[cat];
        if (list != null && list.isNotEmpty) {
          selected.add(list.removeAt(0));
        } else {
          keys.remove(cat);
        }
        keyIdx++;
      }

      if (mounted) {
        setState(() {
          _recommendations = selected;
          _currentMealType = mealType;
          _ckdStage = stage;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _quickLogFood(FoodItem food) async {
    final l10n = AppLocalizations.of(context)!;
    
    // Parse quantity from servingSize (e.g. "485g" -> 485)
    double quantityG = 100.0;
    try {
      final sizeStr = food.servingSize;
      if (sizeStr.isNotEmpty) {
        final regExp = RegExp(r'(\d+)\s*g');
        final match = regExp.firstMatch(sizeStr.toLowerCase());
        if (match != null) {
          final weight = double.tryParse(match.group(1) ?? '');
          if (weight != null && weight > 0) {
            quantityG = weight;
          }
        }
      }
    } catch (_) {}

    final result = await ref.read(mealControllerProvider).logMeal(
          food: food,
          quantityG: quantityG,
          mealType: _currentMealType,
        );

    if (mounted) {
      switch (result) {
        case Success():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.localeName == 'th'
                    ? 'บันทึก ${food.name} (${quantityG.toInt()}g) เรียบร้อยแล้ว'
                    : 'Logged ${food.name} (${quantityG.toInt()}g) successfully',
              ),
              backgroundColor: AppTheme.brandPrimary,
            ),
          );
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(todayMealsProvider);
        case Failure(:final userMessage):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error}: $userMessage'),
              backgroundColor: AppTheme.errorBase,
            ),
          );
      }
    }
  }

  String _getStageLabel(String stage) {
    switch (stage) {
      case 'stage_1':
        return 'Stage 1';
      case 'stage_2':
        return 'Stage 2';
      case 'stage_3a':
        return 'Stage 3a';
      case 'stage_3b':
        return 'Stage 3b';
      case 'stage_4':
        return 'Stage 4';
      case 'stage_5':
        return 'Stage 5';
      default:
        return 'Stage 3a';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Header info based on time of day
    String titleText = 'โภชนาการแนะนำสำหรับคุณ';
    IconData headerIcon = Icons.restaurant_menu_rounded;
    Color iconColor = AppTheme.brandPrimary;

    if (_currentMealType == 'breakfast') {
      titleText = l10n.localeName == 'th' ? '☀️ มื้อเช้าแนะนำเพื่อสุขภาพไต' : '☀️ Suggested Breakfast';
      headerIcon = Icons.wb_sunny_rounded;
      iconColor = Colors.orangeAccent;
    } else if (_currentMealType == 'lunch') {
      titleText = l10n.localeName == 'th' ? '⛅ มื้อเที่ยงแนะนำเพื่อสุขภาพไต' : '⛅ Suggested Lunch';
      headerIcon = Icons.wb_cloudy_rounded;
      iconColor = Colors.cyan;
    } else if (_currentMealType == 'dinner') {
      titleText = l10n.localeName == 'th' ? '🌙 มื้อเย็นแนะนำเพื่อสุขภาพไต' : '🌙 Suggested Dinner';
      headerIcon = Icons.dark_mode_rounded;
      iconColor = Colors.indigoAccent;
    } else {
      titleText = l10n.localeName == 'th' ? '🍪 มื้อว่างแนะนำเพื่อสุขภาพไต' : '🍪 Suggested Snack';
      headerIcon = Icons.cookie_outlined;
      iconColor = Colors.brown;
    }

    if (_isLoading) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppTheme.getSurface(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.getBorderColor(context)),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.brandPrimary),
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.getBorderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(headerIcon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        l10n.localeName == 'th'
                            ? 'เมนูที่เหมาะสำหรับผู้ป่วยโรคไต ${_getStageLabel(_ckdStage)}'
                            : 'Suitable menu options for Kidney ${_getStageLabel(_ckdStage)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 22),
                  onPressed: _loadRecommendations,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                  tooltip: l10n.refresh,
                ),
              ],
            ),
          ),

          // Horizontal list of recommendations
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                final food = _recommendations[index];
                return Container(
                  width: 190,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Food Image
                        SizedBox(
                          height: 90,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/food_images/${food.foodId}.webp',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppTheme.brandPrimary.withValues(alpha: 0.08),
                              child: const Center(
                                child: Icon(
                                  Icons.restaurant_menu_rounded,
                                  color: AppTheme.brandPrimary,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  food.servingSize.isNotEmpty
                                      ? food.servingSize
                                      : '1 Serving',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                const Spacer(),
                                // Bottom Row: Nutrients on Left, Add Button on Right (No overlapping)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: [
                                          _buildNutrientChip(
                                            context,
                                            label: 'P',
                                            value: '${food.proteinG.toStringAsFixed(0)}g',
                                            color: Colors.blue,
                                          ),
                                          _buildNutrientChip(
                                            context,
                                            label: 'K',
                                            value: '${food.potassiumMg.toStringAsFixed(0)}mg',
                                            color: Colors.amber.shade700,
                                          ),
                                          _buildNutrientChip(
                                            context,
                                            label: 'Na',
                                            value: '${food.sodiumMg.toStringAsFixed(0)}mg',
                                            color: Colors.redAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => _quickLogFood(food),
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme.brandPrimary,
                                              AppTheme.brandAccent,
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildNutrientChip(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
