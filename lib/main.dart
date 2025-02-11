import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hello/firebase_options.dart';
import 'package:hello/services/local_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  log("===========? Token : $token");
  tz.initializeTimeZones();
  await LocalNotificationService.localNotificationService.initNotification();

  runApp(const MyApp());
}
