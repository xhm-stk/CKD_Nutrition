import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/reminder_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';
import '../../widgets/premium_text_field.dart';
import '../../widgets/premium_dropdown_field.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  void _showAddReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddReminderSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reminders = ref.watch(customRemindersProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MeshGradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          l10n.remindersTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Reminders list
              Expanded(
                child:
                    reminders.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.04),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  size: 64,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                l10n.noReminders,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ).animate().fade(duration: 400.ms)
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          itemCount: reminders.length,
                          itemBuilder: (context, index) {
                            final item = reminders[index];
                            final isWater = item.type == 'water';
                            final accentColor =
                                isWater ? Colors.cyan : AppTheme.brandSecondary;
                            final timeStr =
                                l10n.localeName == 'th'
                                    ? '${item.time} น.'
                                    : item.time;

                            return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.getSurface(context),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppTheme.getBorderColor(context),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isWater
                                              ? Icons.water_drop_rounded
                                              : Icons.restaurant_menu_rounded,
                                          color: accentColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              timeStr,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.itemName,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.7),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (item.date != null) ...[
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_month_rounded,
                                                    size: 13,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.4),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    item.date!,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(alpha: 0.4),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),

                                      // Actions
                                      Switch(
                                        value: item.isEnabled,
                                        activeColor: AppTheme.brandPrimary,
                                        onChanged: (val) {
                                          ref
                                              .read(
                                                customRemindersProvider
                                                    .notifier,
                                              )
                                              .toggleReminder(item.id, val);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppTheme.errorBase,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(
                                                customRemindersProvider
                                                    .notifier,
                                              )
                                              .deleteReminder(item.id);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l10n.reminderDeleted,
                                              ),
                                              backgroundColor:
                                                  AppTheme.errorBase,
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .fade(delay: (index * 50).ms, duration: 300.ms)
                                .slideY(begin: 0.05);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderSheet,
        backgroundColor: AppTheme.brandPrimary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ).animate().scale(delay: 200.ms, duration: 300.ms),
    );
  }
}

class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet();

  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  final TextEditingController _itemCtrl = TextEditingController();
  String _selectedType = 'meal';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.brandPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.brandPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _save() async {
    final l10n = AppLocalizations.of(context)!;
    String name = _itemCtrl.text.trim();
    if (name.isEmpty) {
      if (_selectedType == 'meal') {
        name = l10n.localeName == 'th' ? 'มื้ออาหารตามกำหนด' : 'Scheduled Meal';
      } else {
        name = l10n.localeName == 'th' ? 'จิบน้ำเพื่อสุขภาพ' : 'Drink Water';
      }
    }

    final formattedHour = _selectedTime.hour.toString().padLeft(2, '0');
    final formattedMinute = _selectedTime.minute.toString().padLeft(2, '0');
    final timeStr = '$formattedHour:$formattedMinute';

    String? dateStr;
    if (_selectedDate != null) {
      dateStr = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    }

    await ref
        .read(customRemindersProvider.notifier)
        .addReminder(_selectedType, timeStr, name, date: dateStr);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.reminderSaved),
          backgroundColor: AppTheme.brandPrimary,
        ),
      );
    }
  }

  @override
  void dispose() {
    _itemCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formattedHour = _selectedTime.hour.toString().padLeft(2, '0');
    final formattedMinute = _selectedTime.minute.toString().padLeft(2, '0');
    final displayTime =
        l10n.localeName == 'th'
            ? '$formattedHour:$formattedMinute น.'
            : '$formattedHour:$formattedMinute';

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Stack(
        children: [
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
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.addReminder,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Reminder Type Dropdown
                PremiumDropdownField(
                  label: l10n.reminderType,
                  value: _selectedType,
                  prefixIcon: Icons.alarm_rounded,
                  items: [
                    DropdownMenuItem(
                      value: 'meal',
                      child: Text(l10n.reminderMeal),
                    ),
                    DropdownMenuItem(
                      value: 'water',
                      child: Text(l10n.reminderWater),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedType = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Time Picker Trigger Button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reminderTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectTime,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.02),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              displayTime,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Icon(
                              Icons.access_time_filled_rounded,
                              color: AppTheme.brandPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date Picker Trigger Button (Optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.localeName == 'th' ? 'วันที่ตั้งเตือนล่วงหน้า (ไม่บังคับ)' : 'Reminder Date (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.02),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                    : (l10n.localeName == 'th' ? 'แจ้งเตือนทุกวัน (ไม่กำหนดวัน)' : 'Every day (No specific date)'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedDate != null
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            if (_selectedDate != null)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = null;
                                  });
                                },
                                child: const Icon(
                                  Icons.clear_rounded,
                                  color: AppTheme.errorBase,
                                  size: 20,
                                ),
                              )
                            else
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: AppTheme.brandPrimary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Custom Menu / Fluid input
                PremiumTextField(
                  controller: _itemCtrl,
                  label: _selectedType == 'meal'
                      ? '${l10n.reminderMenu} (${l10n.localeName == 'th' ? 'ไม่บังคับ' : 'Optional'})'
                      : '${l10n.localeName == 'th' ? 'ปริมาณน้ำ / ข้อความเตือน' : 'Water Volume / Message'} (${l10n.localeName == 'th' ? 'ไม่บังคับ' : 'Optional'})',
                  hint:
                      _selectedType == 'meal'
                          ? 'เช่น ข้าวต้มปลา'
                          : 'เช่น น้ำ 250 มล.',
                  prefixIcon:
                      _selectedType == 'meal'
                          ? Icons.restaurant_menu_rounded
                          : Icons.water_drop_rounded,
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.save,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
