import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result.dart';
import '../../../models/isar/food_item.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/meal_providers.dart';
import 'water_entry_sheet.dart';
import 'urine_entry_sheet.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class AddActionSheet extends ConsumerWidget {
  const AddActionSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Stack(
        children: [
          // Background layer with Mesh Gradient
          Positioned.fill(
            child: Stack(
              children: [
                Container(color: Theme.of(context).scaffoldBackgroundColor),
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -60,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandAccent.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'เพิ่มมื้ออาหารของคุณ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'เลือกวิธีเพิ่มอาหารที่คุณทานในวันนี้',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ปุ่มตัวเลือกต่างๆ
                  _buildActionItem(
                    context,
                    icon: Icons.restaurant_menu_rounded,
                    title: AppLocalizations.of(context)!.addAppMenu,
                    subtitle: AppLocalizations.of(context)!.addAppMenuDesc,
                    color: AppTheme.brandSecondary,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/food-search');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildActionItem(
                    context,
                    icon: Icons.edit_note_rounded,
                    title: AppLocalizations.of(context)!.createCustomFood,
                    subtitle: AppLocalizations.of(context)!.addCustomMenu,
                    color: AppTheme.brandAccent,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/food-add');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildActionItem(
                    context,
                    icon: Icons.water_drop_rounded,
                    title: AppLocalizations.of(context)!.logWater,
                    subtitle: AppLocalizations.of(context)!.logWaterDesc,
                    color: Colors.cyan,
                    onTap: () {
                      final l10n = AppLocalizations.of(context)!;
                      final waterName = l10n.water;
                      final waterSuccess = l10n.waterLoggedSuccess;
                      final errText = l10n.error;

                      Navigator.pop(context); // ปิด ActionSheet ก่อน

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        builder:
                            (ctx) => Consumer(
                              builder:
                                  (consumerCtx, sheetRef, _) => WaterEntrySheet(
                                    onSave: (ml) async {
                                      final food =
                                          FoodItem()
                                            ..foodId = 'quick_water'
                                            ..name = waterName
                                            ..waterMl =
                                                100.0 // ตั้งค่าเป็น 100ml ต่อ 100g เพื่อให้คำนวณถูกต้อง
                                            ..proteinG = 0
                                            ..sodiumMg = 0
                                            ..potassiumMg = 0
                                            ..sugarG = 0
                                            ..carbG = 0;

                                      final result = await sheetRef
                                          .read(mealControllerProvider)
                                          .logMeal(
                                            food: food,
                                            quantityG: ml.toDouble(),
                                            mealType: 'snack',
                                          );

                                      if (ctx.mounted) {
                                        switch (result) {
                                          case Success():
                                            ScaffoldMessenger.of(
                                              ctx,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(waterSuccess),
                                              ),
                                            );
                                            sheetRef.invalidate(
                                              dashboardSummaryProvider,
                                            );
                                            sheetRef.invalidate(
                                              todayMealsProvider,
                                            );
                                          case Failure(:final userMessage):
                                            ScaffoldMessenger.of(
                                              ctx,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '$errText: $userMessage',
                                                ),
                                              ),
                                            );
                                        }
                                      }
                                    },
                                  ),
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildActionItem(
                    context,
                    icon: Icons.opacity_rounded,
                    title: AppLocalizations.of(context)!.logUrine,
                    subtitle: AppLocalizations.of(context)!.logUrineDesc,
                    color: Colors.amber,
                    isBeta: true,
                    onTap: () {
                      final l10n = AppLocalizations.of(context)!;
                      final urineSuccess = l10n.urineLoggedSuccess;
                      final errText = l10n.error;

                      Navigator.pop(context); // ปิด ActionSheet ก่อน

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        builder:
                            (ctx) => Consumer(
                              builder:
                                  (consumerCtx, sheetRef, _) => UrineEntrySheet(
                                    onSave: (ml) async {
                                      final result = await sheetRef
                                          .read(mealControllerProvider)
                                          .logUrine(ml.toDouble());

                                      if (ctx.mounted) {
                                        switch (result) {
                                          case Success():
                                            ScaffoldMessenger.of(
                                              ctx,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(urineSuccess),
                                              ),
                                            );
                                            sheetRef.invalidate(
                                              dashboardSummaryProvider,
                                            );
                                          case Failure(:final userMessage):
                                            ScaffoldMessenger.of(
                                              ctx,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '$errText: $userMessage',
                                                ),
                                              ),
                                            );
                                        }
                                      }
                                    },
                                  ),
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isBeta = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (isBeta) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'BETA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
