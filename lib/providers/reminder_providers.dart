import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/custom_reminder.dart';
import '../services/notification_service.dart';
import 'core_providers.dart';

class CustomRemindersNotifier extends StateNotifier<List<CustomReminder>> {
  final SharedPreferences _prefs;
  final NotificationService _notifService = NotificationService();

  CustomRemindersNotifier(this._prefs) : super([]) {
    _loadReminders();
  }

  void _loadReminders() {
    final listStr = _prefs.getStringList('custom_reminders') ?? [];
    state =
        listStr.map((str) {
          return CustomReminder.fromJson(jsonDecode(str));
        }).toList();
  }

  Future<void> _saveReminders(List<CustomReminder> list) async {
    final listStr = list.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList('custom_reminders', listStr);
    state = list;
  }

  Future<void> addReminder(String type, String time, String itemName) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(
      100000000,
    ); // 32-bit int safe ID
    final reminder = CustomReminder(
      id: id,
      type: type,
      time: time,
      itemName: itemName,
      isEnabled: true,
    );

    final updated = [...state, reminder];
    await _saveReminders(updated);
    await _scheduleReminder(reminder);
  }

  Future<void> deleteReminder(int id) async {
    final updated = state.where((item) => item.id != id).toList();
    await _saveReminders(updated);
    await _notifService.flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> toggleReminder(int id, bool isEnabled) async {
    final updated =
        state.map((item) {
          if (item.id == id) {
            final newItem = item.copyWith(isEnabled: isEnabled);
            if (isEnabled) {
              _scheduleReminder(newItem);
            } else {
              _notifService.flutterLocalNotificationsPlugin.cancel(id);
            }
            return newItem;
          }
          return item;
        }).toList();
    await _saveReminders(updated);
  }

  Future<void> _scheduleReminder(CustomReminder reminder) async {
    if (!reminder.isEnabled) return;

    // Parse time
    final parts = reminder.time.split(':');
    if (parts.length != 2) return;
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts[1]) ?? 0;

    final isWater = reminder.type == 'water';
    final title =
        isWater ? 'ได้เวลาดื่มน้ำแล้วครับ 💧' : 'ได้เวลารับประทานมื้ออาหาร 🍽️';
    final body =
        isWater
            ? 'เป้าหมาย: ${reminder.itemName} ค่อยๆ จิบน้ำเพื่อสุขภาพไตที่ดีนะครับ'
            : 'เมนูของคุณวันนี้: ${reminder.itemName} อย่าลืมรับประทานและบันทึกโภชนาการนะครับ';

    await _notifService.scheduleMealReminder(
      id: reminder.id,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
    );

    // Trigger an instant test notification 3 seconds later so the user can verify
    await _notifService.showInstantReminderTest(
      id: reminder.id,
      title: '🔔 ตั้งเวลาสำเร็จ! (BETA)',
      body:
          'ระบบจะเตือน "${reminder.itemName}" ทุกวันเวลา ${reminder.time} น. ของคุณครับ',
    );
  }
}

final customRemindersProvider =
    StateNotifierProvider<CustomRemindersNotifier, List<CustomReminder>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return CustomRemindersNotifier(prefs);
    });
