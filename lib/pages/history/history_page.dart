import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/meal_providers.dart';
import '../../providers/core_providers.dart';
import '../../models/supabase/meal.dart';
import '../../core/result.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';

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

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
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
                      'ประวัติการกินอาหาร',
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
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: TableCalendar(
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
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'เดือน',
                  },
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
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'แตะวันที่บนปฏิทินเพื่อดูประวัติ',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
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
    final mealsAsync = ref.watch(historyMealsProvider(dateStr));

    return mealsAsync.when(
      data: (meals) {
        if (meals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_meals_rounded,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'ไม่มีข้อมูลในวันที่ ${DateFormat('d MMM yyyy', 'th').format(displayDate)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        // คำนวณยอดรวม
        double totalProtein = 0, totalSodium = 0, totalPotassium = 0;
        for (final m in meals) {
          totalProtein += m.proteinG;
          totalSodium += m.sodiumMg;
          totalPotassium += m.potassiumMg;
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // สรุปย่อ
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryChip(
                    label: 'โปรตีน',
                    value: '${totalProtein.toStringAsFixed(1)}g',
                  ),
                  _SummaryChip(
                    label: 'โซเดียม',
                    value: '${totalSodium.toStringAsFixed(0)}mg',
                  ),
                  _SummaryChip(
                    label: 'โพแทสเซียม',
                    value: '${totalPotassium.toStringAsFixed(0)}mg',
                  ),
                ],
              ),
            ).animate().fade(duration: 300.ms).slideY(begin: 0.05),

            // รายการอาหาร
            ...meals.asMap().entries.map((entry) {
              final i = entry.key;
              final meal = entry.value;
              return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
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
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'โปรตีน ${meal.proteinG.toStringAsFixed(1)}g · โซเดียม ${meal.sodiumMg.toStringAsFixed(0)}mg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      trailing: Text(
                        '${meal.quantityG.toStringAsFixed(0)}g',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (e, _) => Center(
            child: Text(
              'เกิดข้อผิดพลาด: $e',
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.brandPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
