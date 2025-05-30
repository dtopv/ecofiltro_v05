import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken;

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Get and store the FCM token
    fcmToken = await _firebaseMessaging.getToken();
    print('═══════════════════════════════════════');
    print('📱 FCM Token: $fcmToken');
    print('═══════════════════════════════════════');

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      print('═══════════════════════════════════════');
      print('📱 New FCM Token: $newToken');
      print('═══════════════════════════════════════');
    });
  }

  // Método para obtener el token actual
  static Future<String?> getCurrentToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}
