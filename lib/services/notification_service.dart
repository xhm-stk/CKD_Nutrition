import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:ui';
import 'dart:io';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    try {
      tz.initializeTimeZones();
      try {
        // Set local location to Bangkok timezone (GMT+7) for Thai users
        tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
      } catch (e) {
        // Fallback to UTC if Bangkok is not found
        tz.setLocalLocation(tz.UTC);
      }

      // Android Initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS Initialization
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (
          NotificationResponse notificationResponse,
        ) async {
          // Handle notification tapped logic here if needed
        },
      );

      // Request permissions for Android 13+ and iOS
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e, stack) {
      // ignore: avoid_print
      print('NotificationService init error: $e\n$stack');
    }
  }

  Future<void> scheduleWaterReminder() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'th';
    final isEn = langCode == 'en';

    final String title = isEn
        ? 'Reminder: Time to drink water 💧'
        : 'แจ้งเตือน: ได้เวลาดื่มน้ำเพื่อสุขภาพไต 💧';
    final String body = isEn
        ? 'Please sip water regularly to support kidney function and help clear metabolic wastes efficiently.'
        : 'ควรทยอยจิบน้ำอย่างสม่ำเสมอ เพื่อช่วยให้ระบบขับถ่ายของเสียทำงานได้อย่างมีประสิทธิภาพและรักษาสมดุลของร่างกายครับ';

    final String channelName = isEn ? 'Water Intake Reminders' : 'แจ้งเตือนดื่มน้ำ';
    final String channelDesc = isEn
        ? 'Reminds you to sip water regularly for better kidney health'
        : 'เตือนให้ดื่มน้ำเพื่อสุขภาพไตที่ดี';

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'water_reminder_channel',
          channelName,
          channelDescription: channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Cancel existing reminders first to avoid duplicates
    await flutterLocalNotificationsPlugin.cancel(100);

    // Schedule for every 2 hours.
    // For simplicity in this implementation, we use a periodic notification.
    await flutterLocalNotificationsPlugin.periodicallyShow(
      100,
      title,
      body,
      RepeatInterval.hourly,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleMealReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    DateTime? targetDate,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'meal_reminder_channel',
          'แจ้งเตือนมื้ออาหาร',
          channelDescription: 'เตือนให้รับประทานอาหารตรงเวลา',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (_) {}

    var now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate;

    if (targetDate != null) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        return; // Past date, do not schedule
      }
    } else {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: targetDate != null
            ? DateTimeComponents.dateAndTime
            : DateTimeComponents.time,
      );
    } catch (e, stack) {
      // ignore: avoid_print
      print('Exact alarm scheduling failed, falling back to inexact: $e\n$stack');
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: targetDate != null
              ? DateTimeComponents.dateAndTime
              : DateTimeComponents.time,
        );
      } catch (e2, stack2) {
        // ignore: avoid_print
        print('Inexact alarm scheduling fallback failed: $e2\n$stack2');
      }
    }
  }

  Future<void> showHighNutrientAlert(
    String nutrientName,
    int percentage,
  ) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;

    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'th';
    final isEn = langCode == 'en';

    String title;
    String body;
    String channelName;
    String channelDesc;

    if (isEn) {
      channelName = 'Nutrient Quota Alerts';
      channelDesc = 'Alerts when nutrient intake approaches the limit';
      
      String name = nutrientName;
      if (nutrientName == 'โปรตีน') name = 'Protein';
      if (nutrientName == 'โซเดียม') name = 'Sodium';
      if (nutrientName == 'โพแทสเซียม') name = 'Potassium';
      if (nutrientName == 'น้ำตาล') name = 'Sugar';
      if (nutrientName == 'คาร์โบไฮเดรต') name = 'Carbohydrates';

      title = 'Notice: High $name Intake';
      body = 'Your daily $name intake has reached $percentage% of the recommended limit. Please manage your subsequent meals carefully.';
    } else {
      channelName = 'แจ้งเตือนสารอาหารเกินกำหนด';
      channelDesc = 'เตือนเมื่อบริโภคสารอาหารเข้าใกล้ขีดจำกัด';

      String name = nutrientName;
      if (nutrientName == 'Protein') name = 'โปรตีน';
      if (nutrientName == 'Sodium') name = 'โซเดียม';
      if (nutrientName == 'Potassium') name = 'โพแทสเซียม';
      if (nutrientName == 'Sugar') name = 'น้ำตาล';
      if (nutrientName == 'Carbohydrates') name = 'คาร์โบไฮเดรต';

      title = 'แจ้งเตือน: ปริมาณ $name สูง';
      body = 'ปริมาณ $name ที่คุณบริโภคในวันนี้สูงถึง $percentage% ของเกณฑ์ควบคุมแล้ว แนะนำให้ดูแลและจำกัดปริมาณในมื้ออาหารที่เหลือของวันครับ';
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'alert_channel',
          channelName,
          channelDescription: channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFFFF5252), // Red alert
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    final int alertId = 200 + (nutrientName.hashCode % 100).abs();

    await flutterLocalNotificationsPlugin.show(
      alertId, // Unique ID per nutrient
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> showInstantReminderTest({
    required int id,
    required String title,
    required String body,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'reminder_test_channel',
          'ทดสอบแจ้งเตือน',
          channelDescription: 'ใช้สำหรับทดสอบการทำงานของระบบแจ้งเตือน',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 3));

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id + 99999,
        title,
        body,
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, stack) {
      // ignore: avoid_print
      print('Exact test alarm scheduling failed, falling back to inexact: $e\n$stack');
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id + 99999,
          title,
          body,
          scheduledDate,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e2, stack2) {
        // ignore: avoid_print
        print('Inexact test alarm scheduling fallback failed: $e2\n$stack2');
      }
    }
  }

  Future<void> cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
