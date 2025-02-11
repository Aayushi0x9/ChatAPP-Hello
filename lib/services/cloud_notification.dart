import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class CloudNotification {
  CloudNotification._();
  static CloudNotification cloudNotification = CloudNotification._();

  Future<String?> getAccessToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print(token);
    }
    return token;
  }
}
