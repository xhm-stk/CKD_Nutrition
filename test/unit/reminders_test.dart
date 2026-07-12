import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:ckd_nutrition_app/providers/reminder_providers.dart';
import 'package:ckd_nutrition_app/providers/core_providers.dart';

class MockFlutterLocalNotificationsPlatform
    extends FlutterLocalNotificationsPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<void> cancel(int id, {String? tag}) async {}

  @override
  Future<void> cancelAll() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  setUpAll(() {
    // Initialize timezone
    tz.initializeTimeZones();
    // Initialize notification platform instance to prevent LateInitializationError
    FlutterLocalNotificationsPlatform.instance =
        MockFlutterLocalNotificationsPlatform();

    const channel = MethodChannel('dexterous.com/flutter/local_notifications');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return null;
        });
  });

  group('CustomRemindersNotifier Unit Tests', () {
    test('Initial reminders list should be empty', () async {
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final reminders = container.read(customRemindersProvider);
      expect(reminders, isEmpty);
    });

    test(
      'Add reminder should update list and persist to SharedPreferences',
      () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final notifier = container.read(customRemindersProvider.notifier);
        await notifier.addReminder('food', '08:30', 'ไข่ขาวต้ม');

        final reminders = container.read(customRemindersProvider);
        expect(reminders, hasLength(1));
        expect(reminders.first.type, 'food');
        expect(reminders.first.time, '08:30');
        expect(reminders.first.itemName, 'ไข่ขาวต้ม');
        expect(reminders.first.isEnabled, isTrue);

        // Verify persistence
        final saved = prefs.getStringList('custom_reminders');
        expect(saved, isNotNull);
        expect(saved!.length, 1);
      },
    );

    test('Toggle reminder should update status', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final notifier = container.read(customRemindersProvider.notifier);
      await notifier.addReminder('water', '14:00', 'น้ำสะอาด 200ml');

      var reminders = container.read(customRemindersProvider);
      final id = reminders.first.id;

      await notifier.toggleReminder(id, false);

      reminders = container.read(customRemindersProvider);
      expect(reminders.first.isEnabled, isFalse);

      // Toggle back to true
      await notifier.toggleReminder(id, true);
      reminders = container.read(customRemindersProvider);
      expect(reminders.first.isEnabled, isTrue);
    });

    test('Delete reminder should remove from list and preferences', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final notifier = container.read(customRemindersProvider.notifier);
      await notifier.addReminder('food', '18:00', 'ปลาผัดขิง');

      var reminders = container.read(customRemindersProvider);
      expect(reminders, hasLength(1));
      final id = reminders.first.id;

      await notifier.deleteReminder(id);

      reminders = container.read(customRemindersProvider);
      expect(reminders, isEmpty);

      final saved = prefs.getStringList('custom_reminders');
      expect(saved, isEmpty);
    });
  });
}
