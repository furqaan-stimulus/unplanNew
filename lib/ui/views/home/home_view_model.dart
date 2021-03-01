import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:unplan/model/attendance_log.dart';
import 'package:unplan/utils/utils.dart';

class HomeViewModel extends BaseViewModel {
  // Position _currentPosition;
  // String _currentAddress;
  String _name;
  List<AttendanceLog> _logs = [];

  // Position get currentPosition => _currentPosition;
  //
  // String get currentAddress => _currentAddress;

  String get name => _name;

  Future getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setBusy(true);
    _name = preferences.getString('name');
    return _name;
  }

  // Future getCurrentLocation() async {
  //   Geolocator.getPositionStream(
  //     desiredAccuracy: LocationAccuracy.high,
  //     distanceFilter: 10,
  //     intervalDuration: Duration(minutes: 10),
  //   ).listen((Position position) {
  //     _currentPosition = position;
  //     getAddressFromLatLng();
  //     notifyListeners();
  //   });
  // }
  //
  // Future getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await placemarkFromCoordinates(double.parse((currentPosition.latitude).toStringAsFixed(2)),
  //         double.parse((currentPosition.longitude).toStringAsFixed(2)));
  //     Placemark place = p[0];
  //     _currentAddress = "${place.subLocality}, ${place.locality}";
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future initializeNotification() async {
    DateTime notificationDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 30, 00);
    DateTime notificationDate1 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 30, 00);
    DateTime notificationDate2 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 30, 00);
    DateTime notificationDate3 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 25, 00);
    var sat = DateTime.saturday;
    var currentDay = DateTime.now().weekday;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('unplan_channel_id', 'Unplan', 'Unplan',
        priority: Priority.high, importance: Importance.max);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    setBusy(true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');

    Response response;
    if (authToken != null) {
      response = await get(
        Utils.attendance_log_url + '$empId',
        headers: {'Authorization': 'Bearer $authToken'},
      );
    }
    _logs = (json.decode(response.body)['Employee Detail'] as List).map((e) => AttendanceLog.fromJson(e)).toList();
    setBusy(false);

    if (_logs.length != 0) {
      if (currentDay == sat) {
        if (_logs.last.type == Utils.CLOCKIN) {
          await MyApp.notifications.zonedSchedule(0, 'Sign Off!', "Did you finish your day?",
              tz.TZDateTime.from(notificationDate3, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          await MyApp.notifications.zonedSchedule(0, 'Alert!', "Did you finish your day?",
              tz.TZDateTime.from(notificationDate, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          await MyApp.notifications.zonedSchedule(1, 'Alert!!', "Did you forget to logout?",
              tz.TZDateTime.from(notificationDate1, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          await MyApp.notifications.zonedSchedule(2, 'Alert!!', "You will be clocked-out in 29 minutes.",
              tz.TZDateTime.from(notificationDate2, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
        }
      } else {
        if (_logs.last.type == Utils.CLOCKIN) {
          await MyApp.notifications.zonedSchedule(0, 'Sign Off!', "Did you finish your day?",
              tz.TZDateTime.from(notificationDate, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          await MyApp.notifications.zonedSchedule(1, 'Alert!!', "Did you forget to logout?",
              tz.TZDateTime.from(notificationDate1, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          await MyApp.notifications.zonedSchedule(2, 'Alert!!', "You will be clocked-out in 29 minutes.",
              tz.TZDateTime.from(notificationDate2, tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
        }
      }
    }
  }
}
