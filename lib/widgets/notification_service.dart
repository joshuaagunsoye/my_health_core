import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> scheduleStreakNotification(DateTime streakExpiryTime) async {
    final testTime = DateTime.now().add(Duration(seconds: 5));

    // Convert to TZDateTime properly
    final scheduledTime = tz.TZDateTime.from(testTime, tz.local);
    print('Scheduling notification for: $scheduledTime');

    await _notifications.zonedSchedule(
      0,
      'TEST Save Your Streak!',
      'TEST Your health streak will expire soon',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_channel_id',
          'Streak Notifications',
          channelDescription: 'Test Channel',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
