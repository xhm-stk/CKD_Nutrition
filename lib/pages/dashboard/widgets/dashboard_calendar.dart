import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../providers/core_providers.dart';

class DashboardCalendar extends ConsumerWidget {
  const DashboardCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
          24,
        ), // ลดลงถ้าตามแผนข้อ 16 แต่ Dashboard อาจจะต้องการความโค้งมนแยกกัน (ใช้ 16 ก็พอ)
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TableCalendar(
        firstDay: DateTime(2023, 1, 1),
        lastDay: DateTime.now().add(
          const Duration(days: 365),
        ), // เผื่อดูวันข้างหน้าได้ แต่บันทึกไม่ได้
        focusedDay: selectedDate,
        currentDay: DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          ref.read(selectedDateProvider.notifier).state = selectedDay;
        },
        availableCalendarFormats: const {CalendarFormat.week: 'สัปดาห์'},
        calendarFormat:
            CalendarFormat.week, // ให้แสดงแบบสัปดาห์จะได้ไม่กินพื้นที่แนวตั้ง
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
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
          ),
          weekendStyle: const TextStyle(color: Colors.redAccent),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
