import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unplan/app/locator.dart';
import 'package:unplan/app/router.gr.dart' as route;
import 'package:unplan/ui/views/splash/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    _initializeLocalNotificationsPlugin(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: route.Router().onGenerateRoute,
      title: 'unplan',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashView(),
    );
  }

  void _initializeLocalNotificationsPlugin(BuildContext context) {
    var settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestBadgePermission: true,
      requestAlertPermission: true,
      requestSoundPermission: true,
    );
    MyApp.notifications.initialize(
      InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
      onSelectNotification: (payload) async {
        _onSelectNotification(context, payload);
      },
    );
  }

  Future _onSelectNotification(BuildContext context, String payload) async {
    await _navigationService.pushNamedAndRemoveUntil(route.Routes.homeView);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    await _navigationService.pushNamedAndRemoveUntil(route.Routes.homeView);
  }
}
