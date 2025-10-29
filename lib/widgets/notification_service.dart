import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';
import 'dart:io';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  // Reminder messages by category
  static const List<String> homeScreenReminders = [
    'New articles are waiting — check MyHealthCore and tap the carousel to explore what\'s new. 🤳🏾',
    'Looking for something specific in MyHealthCore? Use the search bar to find it fast. 🤳🏾',
    'Your Quick Exit is always ready for privacy — explore safely and confidently. 🤳🏾',
  ];

  static const List<String> educationReminders = [
    'Learn something new today — check out a quick topic in MyHealthEducation! 📚',
    'Just 5 minutes in MyHealthEducation can boost your knowledge and confidence. 📚',
    'Keep your learning streak going - take a quick quiz and test what you\'ve learned! 📚',
    'Stay informed, stay empowered. New info in MyHealthEducation is waiting for you. 📚',
  ];

  static const List<String> locatorReminders = [
    'Need to find a nearby service? Find one in MyHealthLocator today. 📍',
    'Your next appointment is just a tap away — check MyHealthLocator for directions. 📍',
    'Support is always within reach. Explore nearby resources in MyHealthLocator 📍',
  ];

  static const List<String> trackerReminders = [
    'Consistency counts — check your health progress in MyHealthTracker. 🗓️',
    'Have an appointment this week? MyHealthTracker makes it easy to remember. 🗓️',
    'How are you feeling today? One quick update in MyHealthTracker helps you stay in control of your health. 🗓️',
  ];

  static const List<String> connectReminders = [
    'You\'re not alone — connect with someone who understands your journey. 💬',
    'Have a question? Reach out to a provider or peer today for support and guidance. 💬',
    'Take a moment to connect and share — community makes us stronger. 💬',
  ];

  static Future<void> scheduleStreakNotification(DateTime streakExpiryTime) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(Duration(seconds: 5));
    print('Scheduling streak notification for: $scheduledTime');

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

  // Get random message from all categories
  static String _getRandomReminderMessage() {
    final Random random = Random();
    final List<List<String>> allReminders = [
      homeScreenReminders,
      educationReminders,
      locatorReminders,
      trackerReminders,
      connectReminders,
    ];
    
    final List<String> selectedCategory = allReminders[random.nextInt(allReminders.length)];
    return selectedCategory[random.nextInt(selectedCategory.length)];
  }

  // Schedule daily reminders (2 per day)
  static Future<void> scheduleDailyReminders() async {
    // Cancel existing reminder notifications (but keep streak notifications)
    await cancelReminderNotifications();
    
    final DateTime now = DateTime.now();
    
    // Schedule 2 notifications per day for the next 30 days
    for (int day = 0; day < 30; day++) {
      final DateTime targetDate = now.add(Duration(days: day));
      
      // First notification at 10:00 AM (ID: 1000 + day*2)
      final DateTime morningTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        10,
        0,
      );
      
      // Second notification at 6:00 PM (ID: 1000 + day*2 + 1)
      final DateTime eveningTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        18,
        0,
      );
      
      // Only schedule future notifications
      if (morningTime.isAfter(now)) {
        await _scheduleReminderNotification(
          1000 + day * 2, // Unique ID starting from 1000
          morningTime,
        );
      }
      
      if (eveningTime.isAfter(now)) {
        await _scheduleReminderNotification(
          1000 + day * 2 + 1, // Unique ID for evening
          eveningTime,
        );
      }
    }
  }

  // Private method to schedule individual reminder
  static Future<void> _scheduleReminderNotification(int id, DateTime scheduledTime) async {
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
      scheduledTime.second,
    );
    
    await _notifications.zonedSchedule(
      id,
      'MyHealthCore Reminder',
      _getRandomReminderMessage(),
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'myhealth_reminders',
          'MyHealth Reminders',
          channelDescription: 'Daily reminders for MyHealthCore app',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancel all reminder notifications (IDs 1000+)
  static Future<void> cancelReminderNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications = 
        await _notifications.pendingNotificationRequests();
    
    for (final notification in pendingNotifications) {
      if (notification.id >= 1000) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Test notification (10 seconds delay)
  static Future<void> scheduleTestNotification() async {
    print('🔔 Scheduling test notification...');
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(Duration(seconds: 10));
    print('🔔 Current time: $now');
    print('🔔 Scheduled time: $scheduledTime');
    print('🔔 Local timezone: ${tz.local.name}');
    
    try {
      await _notifications.zonedSchedule(
        999, // Use ID 999 for test notifications
        'Test Reminder 🧪',
        _getRandomReminderMessage(),
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_reminders',
            'Test Reminders',
            channelDescription: 'Test notifications to preview reminder functionality',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('🔔 Test notification scheduled successfully');
    } catch (e) {
      print('🔔 Error scheduling test notification: $e');
    }
  }

  // Debug method to check pending notifications
  static Future<void> debugPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('🔔 Pending notifications: ${pending.length}');
    for (final notification in pending) {
      print('🔔 ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }

  // Immediate test notification
  static Future<void> showImmediateTestNotification() async {
    print('🔔 Showing immediate test notification...');
    
    // Check and request permissions first
    final bool? result = await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    print('🔔 Android permission result: $result');
    
    final bool? iosResult = await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    print('🔔 iOS permission result: $iosResult');
    
    try {
      await _notifications.show(
        998,
        'Immediate Test 🚀',
        'This is an immediate test notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_reminders',
            'Test Reminders',
            channelDescription: 'Test notifications to preview reminder functionality',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      print('🔔 Immediate notification shown successfully');
    } catch (e) {
      print('🔔 Error showing immediate notification: $e');
    }
  }

  // Check notification permissions
  static Future<void> checkNotificationPermissions() async {
    print('🔔 Checking notification permissions...');
    
    if (Platform.isAndroid) {
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImplementation?.areNotificationsEnabled();
      print('🔔 Android notifications enabled: $granted');
    }
    
    if (Platform.isIOS) {
      final iosImplementation = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final bool? granted = await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      print('🔔 iOS notification permissions: $granted');
    }
  }
}
