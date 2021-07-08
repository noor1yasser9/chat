import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat/service/auth.dart';
import 'package:chat/service/network.dart';
import 'package:chat/ui/LoginScreen.dart';
import 'package:chat/ui/MainScreen.dart';
import 'package:chat/ui/shared/Loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setUpLocator() {
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => NetworkService());
}

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.notification.body}');

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      //   'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ]);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('tttt ${settings.authorizationStatus}');
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(preferences: await SharedPreferences.getInstance())));
}
