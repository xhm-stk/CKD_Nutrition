import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS Initialization
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification tapped logic here if needed
      },
    );

    // Request permissions for Android 13+ and iOS
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleWaterReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'water_reminder_channel',
      'แจ้งเตือนดื่มน้ำ',
      channelDescription: 'เตือนให้ดื่มน้ำเพื่อสุขภาพไตที่ดี',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Cancel existing reminders first to avoid duplicates
    await flutterLocalNotificationsPlugin.cancel(100);

    // Schedule for every 2 hours.
    // For simplicity in this implementation, we use a periodic notification.
    await flutterLocalNotificationsPlugin.periodicallyShow(
      100,
      'ได้เวลาดื่มน้ำแล้วครับ 💧',
      'จิบน้ำบ่อยๆ ช่วยให้ไตทำงานได้ดีขึ้นนะครับ',
      RepeatInterval.hourly,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
  
  Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
