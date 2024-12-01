import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationUtils {
  static Future<void> initializeFCM() async {
    
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await _requestNotificationPermission();
    String? token = await _getFirebaseCloudMessageToken();
    print('Firebase Token: $token');
    // _initializeFCM();
  }

  static Future<NotificationSettings> _requestNotificationPermission() async {
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return notificationSettings;
  }

  static Future<String?> _getFirebaseCloudMessageToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      print('Error getting Firebase token: $e');
      return null;
    }
  }
}
