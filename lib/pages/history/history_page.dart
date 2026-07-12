import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/meal_providers.dart';
import '../../providers/core_providers.dart';
import '../../models/supabase/meal.dart';
import '../../models/supabase/daily_log.dart';
import '../../core/result.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';
import '../../l10n/app_localizations.dart';

/// Provider สำหรับดึงรายการอาหารของวันที่เลือกในหน้า History
final historyMealsProvider = FutureProvider.autoDispose
    .family<List<Meal>, String>((ref, dateStr) async {
      final repo = ref.watch(mealRepositoryProvider);
      final result = await repo.getMealsByDate(dateStr);
      return switch (result) {
        Success(:final data) => data,
        Failure() => [],
      };
    });

/// Provider สำหรับดึงข้อมูลสรุปโภชนาการประจำวันที่เลือก
final historySummaryProvider = FutureProvider.autoDispose
    .family<DailyLog?, String>((ref, dateStr) async {
      return ref.watch(dashboardUseCaseProvider).getSummary(dateStr);
    });

/// Provider สำหรับดึงวันที่มีข้อมูล (เพื่อแสดง Dot บนปฏิทิน)
final historyDatesProvider = FutureProvider.autoDispose<Set<String>>((
  ref,
) async {
  final sb = ref.watch(supabaseProvider);
  final user = sb.auth.currentUser;
  if (user == null) return {};

  try {
    final data = await sb
        .from('daily_logs')
        .select('log_date')
        .eq('user_id', user.id)
        .isFilter('deleted_at', null);

    return data.map<String>((e) => e['log_date'].toString()).toSet();
  } catch (_) {
    return {};
  }
});

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _formatDate(DateTime day) => DateFormat('yyyy-MM-dd').format(day);

  @override
  Widget build(BuildContext context) {
    final datesAsync = ref.watch(historyDatesProvider);
    final loggedDates = datesAsync.valueOrNull ?? {};

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MeshGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      color: AppTheme.brandPrimary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.eatingHistory,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: -0.05),

              const SizedBox(height: 16),

              // Calendar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),
                child: TableCalendar(
                  locale: Localizations.localeOf(context).toString(),
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: {CalendarFormat.month: l10n.month},
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    weekendStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    weekendTextStyle: const TextStyle(color: Colors.redAccent),
                    selectedDecoration: const BoxDecoration(
                      color: AppTheme.brandPrimary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.brandPrimary.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      final dateStr = _formatDate(date);
                      if (loggedDates.contains(dateStr)) {
                        return Positioned(
                          bottom: 4,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.brandPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ).animate().fade(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Meals List
              Expanded(
                child:
                    _selectedDay == null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 48,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.tapDateToView,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                        : _HistoryMealsList(
                          dateStr: _formatDate(_selectedDay!),
                          displayDate: _selectedDay!,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryMealsList extends ConsumerWidget {
  final String dateStr;
  final DateTime displayDate;

  const _HistoryMealsList({required this.dateStr, required this.displayDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final mealsAsync = ref.watch(historyMealsProvider(dateStr));
    final summaryAsync = ref.watch(historySummaryProvider(dateStr));

    if (mealsAsync.isLoading || summaryAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mealsAsync.hasError) {
      return Center(
        child: Text(
          '${l10n.error}: ${mealsAsync.error}',
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    final meals = mealsAsync.value ?? [];
    final summary = summaryAsync.value;

    final totalProtein = summary?.totalProteinG ?? 0.0;
    final totalSodium = summary?.totalSodiumMg ?? 0.0;
    final totalPotassium = summary?.totalPotassiumMg ?? 0.0;
    final totalSugar = summary?.totalSugarG ?? 0.0;
    final totalCarb = summary?.totalCarbG ?? 0.0;
    final totalWater = summary?.totalWaterMl ?? 0.0;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // สรุปย่อ
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.analytics_rounded,
                    color: AppTheme.brandPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.allNutrients,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.9,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _SummaryChip(
                    label: l10n.protein,
                    value: '${totalProtein.toStringAsFixed(1)}g',
                    icon: Icons.set_meal_rounded,
                    color: const Color(0xFF34D399),
                  ),
                  _SummaryChip(
                    label: l10n.sodium,
                    value: '${totalSodium.toStringAsFixed(0)}mg',
                    icon: Icons.water_drop_rounded,
                    color: const Color(0xFF38BDF8),
                  ),
                  _SummaryChip(
                    label: l10n.potassium,
                    value: '${totalPotassium.toStringAsFixed(0)}mg',
                    icon: Icons.science_rounded,
                    color: const Color(0xFFF87171),
                  ),
                  _SummaryChip(
                    label: l10n.sugar,
                    value: '${totalSugar.toStringAsFixed(1)}g',
                    icon: Icons.cookie_rounded,
                    color: AppTheme.brandSecondary,
                  ),
                  _SummaryChip(
                    label: l10n.carbs,
                    value: '${totalCarb.toStringAsFixed(1)}g',
                    icon: Icons.rice_bowl_rounded,
                    color: const Color(0xFFFBBF24),
                  ),
                  _SummaryChip(
                    label: l10n.water,
                    value: '${totalWater.toStringAsFixed(0)}ml',
                    icon: Icons.local_drink_rounded,
                    color: const Color(0xFF60A5FA),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fade(duration: 300.ms).slideY(begin: 0.05),

        // รายการอาหาร
        if (meals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_meals_rounded,
                    size: 44,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noHistoryThisDay,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...meals.asMap().entries.map((entry) {
            final i = entry.key;
            final meal = entry.value;
            return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.05),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.brandPrimary.withValues(
                        alpha: 0.15,
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        color: AppTheme.brandPrimary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      meal.foodName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      '${l10n.protein} ${meal.proteinG.toStringAsFixed(1)}g · ${l10n.sodium} ${meal.sodiumMg.toStringAsFixed(0)}mg',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: Builder(
                      builder: (context) {
                        final isWater =
                            meal.foodId == 'quick_water' ||
                            meal.foodId.toLowerCase().contains('water') ||
                            meal.foodName == l10n.water;
                        return Text(
                          '${meal.quantityG.toStringAsFixed(0)}${isWater ? 'ml' : 'g'}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ),
                )
                .animate()
                .fade(
                  delay: Duration(milliseconds: 100 + i * 50),
                  duration: 300.ms,
                )
                .slideX(begin: 0.03);
          }),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
