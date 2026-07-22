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

  Future<void> addReminder(
    String type,
    String time,
    String itemName, {
    String? date,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(
      100000000,
    ); // 32-bit int safe ID
    final reminder = CustomReminder(
      id: id,
      type: type,
      time: time,
      itemName: itemName,
      isEnabled: true,
      date: date,
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

    final langCode = _prefs.getString('language_code') ?? 'th';
    final isEn = langCode == 'en';

    final isWater = reminder.type == 'water';

    String title;
    String body;
    String testTitle;
    String testBody;

    if (isEn) {
      if (isWater) {
        title = 'Reminder: Scheduled water intake 💧';
        body =
            'Target: ${reminder.itemName}. Sipping water in moderate amounts helps maintain optimal fluid balance for your kidneys.';
      } else {
        title = 'Reminder: Meal nutrition time 🍽️';
        body =
            'Scheduled menu: ${reminder.itemName}. Having your meals on time and logging your intake helps keep your kidney health goals on track.';
      }
      testTitle = '🔔 Reminder set successfully';
      testBody =
          reminder.date != null
              ? 'The system will remind you of "${reminder.itemName}" on ${reminder.date} at ${reminder.time}.'
              : 'The system will remind you of "${reminder.itemName}" daily at ${reminder.time}.';
    } else {
      if (isWater) {
        title = 'แจ้งเตือน: ถึงเวลาดื่มน้ำตามกำหนด 💧';
        body =
            'เป้าหมาย: ${reminder.itemName} แนะนำให้จิบน้ำทีละน้อยเพื่อรักษาสมดุลของไตและหลีกเลี่ยงภาวะน้ำเกินครับ';
      } else {
        title = 'แจ้งเตือน: ถึงเวลาดูแลโภชนาการมื้ออาหาร 🍽️';
        body =
            'เมนูที่กำหนดไว้: ${reminder.itemName} แนะนำให้รับประทานตรงเวลาและบันทึกปริมาณสารอาหารเพื่อควบคุมโควต้าสุขภาพไตประจำวันครับ';
      }
      testTitle = '🔔 ตั้งค่าแจ้งเตือนสำเร็จ';
      testBody =
          reminder.date != null
              ? 'ระบบจะเตือน "${reminder.itemName}" วันที่ ${reminder.date} เวลา ${reminder.time} น. เรียบร้อยแล้วครับ'
              : 'ระบบได้รับการบันทึกการแจ้งเตือนสำหรับ "${reminder.itemName}" ทุกวันเวลา ${reminder.time} น. เรียบร้อยแล้วครับ';
    }

    DateTime? targetDate;
    if (reminder.date != null) {
      targetDate = DateTime.tryParse(reminder.date!);
    }

    try {
      await _notifService.scheduleMealReminder(
        id: reminder.id,
        title: title,
        body: body,
        hour: hour,
        minute: minute,
        targetDate: targetDate,
      );

      // Trigger an instant test notification 3 seconds later so the user can verify
      await _notifService.showInstantReminderTest(
        id: reminder.id,
        title: testTitle,
        body: testBody,
      );
    } catch (e, stack) {
      // ignore: avoid_print
      print('Failed to schedule local notification: $e\n$stack');
    }
  }
}

final customRemindersProvider =
    StateNotifierProvider<CustomRemindersNotifier, List<CustomReminder>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return CustomRemindersNotifier(prefs);
    });
