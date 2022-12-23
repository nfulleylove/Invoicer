import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:invoicer/extensions/datetime_extensions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings =
      const InitializationSettings(
          android: AndroidInitializationSettings('ic_launcher'));

  Future<void> setup() async {
    tz.initializeTimeZones();
    WidgetsFlutterBinding.ensureInitialized();
    _plugin.initialize(initializationSettings);

    bool? hasPermission = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    if (hasPermission != null && hasPermission) {
      await scheduleWeeklyReminder();
    }
  }

  Future<void> scheduleWeeklyReminder() async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('1961', 'Invoicer'));

    await _plugin.zonedSchedule(
        1961,
        'Invoice Reminder',
        'Have you created an invoice this week?',
        _nextSunday(),
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  tz.TZDateTime _nextSunday() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    var nextSunday = DateTime.now().next(DateTime.sunday);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, nextSunday.year, nextSunday.month, nextSunday.day, 19);

    while (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}
