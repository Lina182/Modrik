import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'screens/start_screen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

String? fcmToken = await FirebaseMessaging.instance.getToken();

print("FCM TOKEN: $fcmToken");

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

const InitializationSettings initializationSettings =
    InitializationSettings(
  android: initializationSettingsAndroid,
);

await flutterLocalNotificationsPlugin.initialize(
  initializationSettings,
);

FirebaseMessaging.onMessage.listen((RemoteMessage message) {

  RemoteNotification? notification = message.notification;

  if (notification != null) {

    flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,

      const NotificationDetails(
        android: AndroidNotificationDetails(
          'modik_channel',
          'Modik Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
      theme: ThemeData(fontFamily: 'Sans-serif'),
    );
  }
}
