import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> scheduleStreakNotification(DateTime streakExpiryTime) async {
    final fiveHoursBefore = streakExpiryTime.subtract(Duration(hours: 5));

    await _notifications.zonedSchedule(
      0,
      'Save Your Streak!',
      'Your health streak will expire soon. Don’t forget to log your activity.',
      tz.TZDateTime.from(fiveHoursBefore, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_channel_id',
          'Streak Notifications',
          channelDescription: 'Notifies when streak is about to expire',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
