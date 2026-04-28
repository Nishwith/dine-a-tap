import 'package:dine_a_tap/firebase_options.dart';
import 'package:dine_a_tap/notification_service.dart';
import 'package:dine_a_tap/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print(message);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await PushNotifications.init();
  await PushNotifications.localNotiInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   navigatorKey.currentState!.push(
  //     MaterialPageRoute(
  //       builder: (context) => const PreBookPage(),
  //     ),
  //   );
  // });
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(const Duration(seconds: 1), () {
      // navigatorKey.currentState!.push(
      //   MaterialPageRoute(
      //     builder: (context) => const PreBookPage(),
      //   ),
      // );
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dine A Tap',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
