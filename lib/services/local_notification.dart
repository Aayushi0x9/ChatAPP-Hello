import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();

  static LocalNotificationService localNotificationService =
      LocalNotificationService._();

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  Future<void> permissionRequest() async {
    PermissionStatus status = await Permission.notification.request();
    PermissionStatus alarmStatus =
        await Permission.scheduleExactAlarm.request();
    log("Status : ${status.isDenied}");
    if (status.isDenied && alarmStatus.isDenied) {
      await permissionRequest();
    } else if (status.isPermanentlyDenied) {
      log("Permission permanently denied. Open settings.");
      await openAppSettings();
    }
  }

  Future<void> initNotification() async {
    // await permissionRequest();

    plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings iOS = const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await plugin
        .initialize(
          initializationSettings,
        )
        .then(
          (value) => log("Notification Init Done....."),
        )
        .onError(
          (error, _) => log("Notification Init Failed"),
        );
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails notificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Hello',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails details =
        NotificationDetails(android: notificationDetails);
    await plugin.show(
        DateTime.now().microsecondsSinceEpoch, title, body, details);
  }

  Future<void> showSchedulingNotification({
    required String title,
    required String body,
    required DateTime timeDate,
  }) async {
    AndroidNotificationDetails notificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Hello',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details =
        NotificationDetails(android: notificationDetails);
    await plugin.zonedSchedule(
      DateTime.now().microsecondsSinceEpoch,
      title,
      body,
      tz.TZDateTime.from(timeDate, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showPeriodicNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails notificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Hello',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details =
        NotificationDetails(android: notificationDetails);
    await plugin.periodicallyShow(
      DateTime.now().microsecondsSinceEpoch,
      title,
      body,
      RepeatInterval.everyMinute,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String url,
  }) async {
    http.Response res = await http.get(Uri.parse(url));
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File("${directory.path}/image.jpg");
    await file.writeAsBytes(res.bodyBytes);

    AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
      '101',
      'Hello',
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: FilePathAndroidBitmap(file.path),
      styleInformation:
          BigPictureStyleInformation(FilePathAndroidBitmap(file.path)),
      // sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails details = NotificationDetails(
      android: notificationDetails,
    );
    await plugin.show(
        DateTime.now().microsecondsSinceEpoch, title, body, details);
  }
}
