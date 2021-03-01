import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/model/address_detail.dart';
import 'package:unplan/model/attendance_log.dart';
import 'package:unplan/model/today_log.dart';
import 'package:unplan/ui/views/homelog/home_log_view_model.dart';
import 'package:unplan/utils/view_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unplan/enum/log_type.dart';
import 'package:unplan/utils/date_time_format.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/widgets/break_button.dart';
import 'package:unplan/widgets/clock_out_button.dart';
import 'package:unplan/widgets/confirm_button.dart';

class HomeLogView extends StatefulWidget {
  @override
  _HomeLogViewState createState() => _HomeLogViewState();
}

class _HomeLogViewState extends State<HomeLogView> {
  Position _currentPosition;
  String _currentAddress;
  double officeDist;
  double homeDist;
  List<AddressDetail> userAddressList = [];
  List<AttendanceLog> logList = [];
  List<TodayLog> todayLogList = [];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeLogViewModel>.reactive(
      viewModelBuilder: () => HomeLogViewModel(),
      onModelReady: (model) {
        _getCurrentLocation();
        getUserAddress();
        getLogs();
        getTodayLogs();
      },
      builder: (context, model, child) => Scaffold(
        body: Container(
          color: ViewColor.background_purple_color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 35.0,
                  right: 35.0,
                  top: 40.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: FutureBuilder(
                    future: getLogs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: ViewColor.button_green_color,
                            ),
                          ),
                        );
                      } else if (logList.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: ViewColor.button_green_color,
                            ),
                          ),
                        );
                      } else {
                        return FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: (logList.last.type == null)
                              ? ViewColor.button_grey_color
                              : (logList.last.type == Utils.CLOCKIN)
                                  ? ViewColor.button_green_color
                                  : ViewColor.button_grey_color,
                          onPressed: () {
                            _getCurrentLocation();
                            _getAddressFromLatLng();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                if (logList.last.type != null) {
                                  if (_currentPosition == null) {
                                    return Container(
                                      height: 300,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          (_currentPosition != null)
                                              ? (officeDist <= 10.0)
                                                  ? SvgPicture.asset(
                                                      'assets/svg/office.svg',
                                                      height: 45,
                                                      width: 45,
                                                    )
                                                  : (homeDist <= 10.0)
                                                      ? SvgPicture.asset(
                                                          'assets/svg/home.svg',
                                                          height: 45,
                                                          width: 45,
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svg/other.svg',
                                                          height: 45,
                                                          width: 45,
                                                        )
                                              : Text(''),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          (logList.last.type == null)
                                              ? Text(
                                                  'Logging out from',
                                                  style: TextStyles.buttonTextStyle2,
                                                )
                                              : (logList.last.type == Utils.CLOCKIN)
                                                  ? Text(
                                                      'Logging out from',
                                                      style: TextStyles.buttonTextStyle2,
                                                    )
                                                  : Text(
                                                      'You are',
                                                      style: TextStyles.buttonTextStyle2,
                                                    ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.CLOCKOUT)
                                              ? (_currentPosition != null)
                                                  ? (officeDist <= 10.0)
                                                      ? Text(
                                                          Utils.officeLocation,
                                                          style: TextStyles.bottomTextStyle,
                                                        )
                                                      : (homeDist <= 10.0)
                                                          ? Text(
                                                              Utils.homeLocation,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                          : Text(
                                                              Utils.unknownLocation,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                  : Text('')
                                              : (_currentPosition != null)
                                                  ? (officeDist <= 10.0)
                                                      ? Text(
                                                          Utils.office,
                                                          style: TextStyles.bottomTextStyle,
                                                        )
                                                      : (homeDist <= 10.0)
                                                          ? Text(
                                                              Utils.home,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                          : Text(
                                                              Utils.unknown,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                  : Text(''),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (_currentPosition != null)
                                              ? (officeDist <= 10.0)
                                                  ? Text(
                                                      _currentAddress,
                                                      style: TextStyles.bottomTextStyle2,
                                                    )
                                                  : (homeDist <= 10.0)
                                                      ? Text(
                                                          _currentAddress,
                                                          style: TextStyles.bottomTextStyle2,
                                                        )
                                                      : Text(
                                                          _currentAddress,
                                                          style: TextStyles.bottomTextStyle2,
                                                        )
                                              : Text(''),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.TIMEOUT)
                                              ? (DateTimeFormat.difference().inMinutes <= 5)
                                                  ? Text(
                                                      Utils.early,
                                                      style: TextStyles.bottomTextStyle3,
                                                    )
                                                  : (DateTimeFormat.difference().inMinutes <= 20)
                                                      ? Text(
                                                          Utils.late,
                                                          style: TextStyles.alertTextStyle,
                                                        )
                                                      : (DateTimeFormat.difference().inMinutes <= 60)
                                                          ? Text(
                                                              Utils.veryLate,
                                                              style: TextStyles.alertTextStyle1,
                                                            )
                                                          : (DateTimeFormat.difference().inMinutes <= 210)
                                                              ? Text(
                                                                  Utils.halfDay,
                                                                  style: TextStyles.alertTextStyle1,
                                                                )
                                                              : Text(
                                                                  '',
                                                                  style: TextStyles.alertTextStyle1,
                                                                )
                                              : Text(''),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          (_currentPosition == null)
                                              ? Text("")
                                              : (logList.last.type == Utils.CLOCKOUT ||
                                                      logList.last.type == Utils.TIMEOUT)
                                                  ? ConfirmButton(
                                                      firstLog: true,
                                                      pressed: getLastLog(LogType.clockIn),
                                                      type: LogType.clockIn,
                                                      onPressed: () {
                                                        if (_currentPosition == null) {
                                                          Flushbar(
                                                            messageText: Center(
                                                              child: Text(
                                                                "Current Position cannot be fetched",
                                                                style: TextStyles.notificationTextStyle1,
                                                              ),
                                                            ),
                                                            backgroundColor: ViewColor.notification_green_color,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            flushbarStyle: FlushbarStyle.FLOATING,
                                                            duration: Duration(seconds: 2),
                                                          )..show(context);
                                                        } else {
                                                          Navigator.of(context).pop();
                                                          model.markClockIn(context, _currentPosition.latitude,
                                                              _currentPosition.longitude, _currentAddress);
                                                          Flushbar(
                                                            messageText: Center(
                                                              child: Text(
                                                                Utils.msgClockIn,
                                                                style: TextStyles.notificationTextStyle1,
                                                              ),
                                                            ),
                                                            backgroundColor: ViewColor.notification_green_color,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            flushbarStyle: FlushbarStyle.FLOATING,
                                                            duration: Duration(seconds: 2),
                                                          )..show(context);
                                                        }
                                                      },
                                                    )
                                                  : Center(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          BreakButton(
                                                            type: LogType.timeout,
                                                            firstLog: false,
                                                            pressed: getLastLog(LogType.timeout),
                                                            onPressed: () {
                                                              if (_currentPosition == null) {
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      "Current Position cannot be fetched",
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              } else {
                                                                Navigator.of(context).pop();
                                                                model.markClockTimeOut(
                                                                    context,
                                                                    _currentPosition.latitude,
                                                                    _currentPosition.longitude,
                                                                    _currentAddress);
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      Utils.msgClockBreak,
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          ClockOutButton(
                                                            firstLog: false,
                                                            type: LogType.clockOut,
                                                            pressed: getLastLog(LogType.clockOut),
                                                            onPressed: () {
                                                              if (_currentPosition == null) {
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      "Current Position cannot be fetched",
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              } else {
                                                                Navigator.of(context).pop();
                                                                model.markClockOut(
                                                                    DateTimeFormat.calculateHoursForSingleDay(
                                                                        todayLogList),
                                                                    context,
                                                                    _currentPosition.latitude,
                                                                    _currentPosition.longitude,
                                                                    _currentAddress);
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      Utils.msgClockOut,
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    officeDist = Geolocator.distanceBetween(
                                        double.parse((userAddressList.first.officeLatitude)),
                                        double.parse((userAddressList.first.officeLongitude)),
                                        _currentPosition.latitude,
                                        _currentPosition.longitude);
                                    homeDist = Geolocator.distanceBetween(
                                        double.parse((userAddressList.first.homeLatitude)),
                                        double.parse((userAddressList.first.homeLongitude)),
                                        _currentPosition.latitude,
                                        _currentPosition.longitude);
                                  }
                                } else {
                                  return Text('');
                                }
                                if (logList.last.type != null) {
                                  if (_currentPosition == null) {
                                    return Container(
                                      height: 300,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          (_currentPosition != null)
                                              ? (officeDist <= 10.0)
                                                  ? SvgPicture.asset(
                                                      'assets/svg/office.svg',
                                                      height: 45,
                                                      width: 45,
                                                    )
                                                  : (homeDist <= 10.0)
                                                      ? SvgPicture.asset(
                                                          'assets/svg/home.svg',
                                                          height: 45,
                                                          width: 45,
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svg/other.svg',
                                                          height: 45,
                                                          width: 45,
                                                        )
                                              : Text(''),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          (logList.last.type == null)
                                              ? Text(
                                                  'Logging out from',
                                                  style: TextStyles.buttonTextStyle2,
                                                )
                                              : (logList.last.type == Utils.CLOCKIN)
                                                  ? Text(
                                                      'Logging out from',
                                                      style: TextStyles.buttonTextStyle2,
                                                    )
                                                  : Text(
                                                      'You are',
                                                      style: TextStyles.buttonTextStyle2,
                                                    ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.CLOCKOUT)
                                              ? (_currentPosition != null)
                                                  ? (officeDist <= 10.0)
                                                      ? Text(
                                                          Utils.officeLocation,
                                                          style: TextStyles.bottomTextStyle,
                                                        )
                                                      : (homeDist <= 10.0)
                                                          ? Text(
                                                              Utils.homeLocation,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                          : Text(
                                                              Utils.unknownLocation,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                  : Text('')
                                              : (_currentPosition != null)
                                                  ? (officeDist <= 10.0)
                                                      ? Text(
                                                          Utils.office,
                                                          style: TextStyles.bottomTextStyle,
                                                        )
                                                      : (homeDist <= 10.0)
                                                          ? Text(
                                                              Utils.home,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                          : Text(
                                                              Utils.unknown,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                  : Text(''),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (_currentPosition != null)
                                              ? (officeDist <= 10.0)
                                                  ? Text(
                                                      _currentAddress,
                                                      style: TextStyles.bottomTextStyle2,
                                                    )
                                                  : (homeDist <= 10.0)
                                                      ? Text(
                                                          _currentAddress,
                                                          style: TextStyles.bottomTextStyle2,
                                                        )
                                                      : Text(
                                                          _currentAddress,
                                                          style: TextStyles.bottomTextStyle2,
                                                        )
                                              : Text(''),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.TIMEOUT)
                                              ? (DateTimeFormat.difference().inMinutes <= 5)
                                                  ? Text(
                                                      Utils.early,
                                                      style: TextStyles.bottomTextStyle3,
                                                    )
                                                  : (DateTimeFormat.difference().inMinutes <= 20)
                                                      ? Text(
                                                          Utils.late,
                                                          style: TextStyles.alertTextStyle,
                                                        )
                                                      : (DateTimeFormat.difference().inMinutes <= 60)
                                                          ? Text(
                                                              Utils.veryLate,
                                                              style: TextStyles.alertTextStyle1,
                                                            )
                                                          : (DateTimeFormat.difference().inMinutes <= 210)
                                                              ? Text(
                                                                  Utils.halfDay,
                                                                  style: TextStyles.alertTextStyle1,
                                                                )
                                                              : Text(
                                                                  '',
                                                                  style: TextStyles.alertTextStyle1,
                                                                )
                                              : Text(''),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          (_currentPosition == null)
                                              ? Text("")
                                              : (logList.last.type == Utils.CLOCKOUT ||
                                                      logList.last.type == Utils.TIMEOUT)
                                                  ? ConfirmButton(
                                                      firstLog: true,
                                                      pressed: getLastLog(LogType.clockIn),
                                                      type: LogType.clockIn,
                                                      onPressed: () {
                                                        if (_currentPosition == null) {
                                                          Flushbar(
                                                            messageText: Center(
                                                              child: Text(
                                                                "Current Position cannot be fetched",
                                                                style: TextStyles.notificationTextStyle1,
                                                              ),
                                                            ),
                                                            backgroundColor: ViewColor.notification_green_color,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            flushbarStyle: FlushbarStyle.FLOATING,
                                                            duration: Duration(seconds: 2),
                                                          )..show(context);
                                                        } else {
                                                          Navigator.of(context).pop();
                                                          model.markClockIn(context, _currentPosition.latitude,
                                                              _currentPosition.longitude, _currentAddress);
                                                          Flushbar(
                                                            messageText: Center(
                                                              child: Text(
                                                                Utils.msgClockIn,
                                                                style: TextStyles.notificationTextStyle1,
                                                              ),
                                                            ),
                                                            backgroundColor: ViewColor.notification_green_color,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            flushbarStyle: FlushbarStyle.FLOATING,
                                                            duration: Duration(seconds: 2),
                                                          )..show(context);
                                                        }
                                                      },
                                                    )
                                                  : Center(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          BreakButton(
                                                            type: LogType.timeout,
                                                            firstLog: false,
                                                            pressed: getLastLog(LogType.timeout),
                                                            onPressed: () {
                                                              if (_currentPosition == null) {
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      "Current Position cannot be fetched",
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              } else {
                                                                Navigator.of(context).pop();
                                                                model.markClockTimeOut(
                                                                    context,
                                                                    _currentPosition.latitude,
                                                                    _currentPosition.longitude,
                                                                    _currentAddress);
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      Utils.msgClockBreak,
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          ClockOutButton(
                                                            firstLog: false,
                                                            type: LogType.clockOut,
                                                            pressed: getLastLog(LogType.clockOut),
                                                            onPressed: () {
                                                              if (_currentPosition == null) {
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      "Current Position cannot be fetched",
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              } else {
                                                                Navigator.of(context).pop();
                                                                model.markClockOut(
                                                                    DateTimeFormat.calculateHoursForSingleDay(
                                                                        todayLogList),
                                                                    context,
                                                                    _currentPosition.latitude,
                                                                    _currentPosition.longitude,
                                                                    _currentAddress);
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      Utils.msgClockOut,
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 300,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          (_currentPosition != null)
                                              ? (officeDist <= 10.0)
                                                  ? SvgPicture.asset(
                                                      'assets/svg/office.svg',
                                                      height: 45,
                                                      width: 45,
                                                    )
                                                  : (homeDist <= 10.0)
                                                      ? SvgPicture.asset(
                                                          'assets/svg/home.svg',
                                                          height: 45,
                                                          width: 45,
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svg/other.svg',
                                                          height: 45,
                                                          width: 45,
                                                        )
                                              : Text(''),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          (logList.last.type == null)
                                              ? Text(
                                                  'Logging out from',
                                                  style: TextStyles.buttonTextStyle2,
                                                )
                                              : (logList.last.type == Utils.CLOCKIN)
                                                  ? Text(
                                                      'Logging out from',
                                                      style: TextStyles.buttonTextStyle2,
                                                    )
                                                  : Text(
                                                      'You are',
                                                      style: TextStyles.buttonTextStyle2,
                                                    ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.CLOCKOUT)
                                              ? (_currentPosition != null)
                                                  ? (officeDist <= 10.0)
                                                      ? Text(
                                                          Utils.officeLocation,
                                                          style: TextStyles.bottomTextStyle,
                                                        )
                                                      : (homeDist <= 10.0)
                                                          ? Text(
                                                              Utils.homeLocation,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                          : Text(
                                                              Utils.unknownLocation,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                  : Text('')
                                              : (_currentPosition != null)
                                                  ? (officeDist <= 10.0)
                                                      ? Text(
                                                          Utils.office,
                                                          style: TextStyles.bottomTextStyle,
                                                        )
                                                      : (homeDist <= 10.0)
                                                          ? Text(
                                                              Utils.home,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                          : Text(
                                                              Utils.unknown,
                                                              style: TextStyles.bottomTextStyle,
                                                            )
                                                  : Text(''),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (_currentPosition != null)
                                              ? (officeDist <= 10.0)
                                                  ? Text(
                                                      _currentAddress,
                                                      style: TextStyles.bottomTextStyle2,
                                                    )
                                                  : (homeDist <= 10.0)
                                                      ? Text(
                                                          _currentAddress,
                                                          style: TextStyles.bottomTextStyle2,
                                                        )
                                                      : Text(
                                                          _currentAddress,
                                                          style: TextStyles.bottomTextStyle2,
                                                        )
                                              : Text(''),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.TIMEOUT)
                                              ? (DateTimeFormat.difference().inMinutes <= 5)
                                                  ? Text(
                                                      Utils.early,
                                                      style: TextStyles.bottomTextStyle3,
                                                    )
                                                  : (DateTimeFormat.difference().inMinutes <= 20)
                                                      ? Text(
                                                          Utils.late,
                                                          style: TextStyles.alertTextStyle,
                                                        )
                                                      : (DateTimeFormat.difference().inMinutes <= 60)
                                                          ? Text(
                                                              Utils.veryLate,
                                                              style: TextStyles.alertTextStyle1,
                                                            )
                                                          : (DateTimeFormat.difference().inMinutes <= 210)
                                                              ? Text(
                                                                  Utils.halfDay,
                                                                  style: TextStyles.alertTextStyle1,
                                                                )
                                                              : Text(
                                                                  '',
                                                                  style: TextStyles.alertTextStyle1,
                                                                )
                                              : Text(''),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          (_currentPosition == null)
                                              ? Text("")
                                              : (logList.last.type == Utils.CLOCKOUT ||
                                                      logList.last.type == Utils.TIMEOUT)
                                                  ? ConfirmButton(
                                                      firstLog: true,
                                                      pressed: getLastLog(LogType.clockIn),
                                                      type: LogType.clockIn,
                                                      onPressed: () {
                                                        if (_currentPosition == null) {
                                                          Flushbar(
                                                            messageText: Center(
                                                              child: Text(
                                                                "Current Position cannot be fetched",
                                                                style: TextStyles.notificationTextStyle1,
                                                              ),
                                                            ),
                                                            backgroundColor: ViewColor.notification_green_color,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            flushbarStyle: FlushbarStyle.FLOATING,
                                                            duration: Duration(seconds: 2),
                                                          )..show(context);
                                                        } else {
                                                          Navigator.of(context).pop();
                                                          model.markClockIn(context, _currentPosition.latitude,
                                                              _currentPosition.longitude, _currentAddress);
                                                          Flushbar(
                                                            messageText: Center(
                                                              child: Text(
                                                                Utils.msgClockIn,
                                                                style: TextStyles.notificationTextStyle1,
                                                              ),
                                                            ),
                                                            backgroundColor: ViewColor.notification_green_color,
                                                            flushbarPosition: FlushbarPosition.TOP,
                                                            flushbarStyle: FlushbarStyle.FLOATING,
                                                            duration: Duration(seconds: 2),
                                                          )..show(context);
                                                        }
                                                      },
                                                    )
                                                  : Center(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          BreakButton(
                                                            type: LogType.timeout,
                                                            firstLog: false,
                                                            pressed: getLastLog(LogType.timeout),
                                                            onPressed: () {
                                                              if (_currentPosition == null) {
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      "Current Position cannot be fetched",
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              } else {
                                                                Navigator.of(context).pop();
                                                                model.markClockTimeOut(
                                                                    context,
                                                                    _currentPosition.latitude,
                                                                    _currentPosition.longitude,
                                                                    _currentAddress);
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      Utils.msgClockBreak,
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          ClockOutButton(
                                                            firstLog: false,
                                                            type: LogType.clockOut,
                                                            pressed: getLastLog(LogType.clockOut),
                                                            onPressed: () {
                                                              if (_currentPosition == null) {
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      "Current Position cannot be fetched",
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              } else {
                                                                Navigator.of(context).pop();
                                                                model.markClockOut(
                                                                    DateTimeFormat.calculateHoursForSingleDay(
                                                                        todayLogList),
                                                                    context,
                                                                    _currentPosition.latitude,
                                                                    _currentPosition.longitude,
                                                                    _currentAddress);
                                                                Flushbar(
                                                                  messageText: Center(
                                                                    child: Text(
                                                                      Utils.msgClockOut,
                                                                      style: TextStyles.notificationTextStyle1,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: ViewColor.notification_green_color,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  flushbarStyle: FlushbarStyle.FLOATING,
                                                                  duration: Duration(seconds: 2),
                                                                )..show(context);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  return Container(
                                    height: 300,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        (_currentPosition != null)
                                            ? (officeDist <= 10.0)
                                                ? SvgPicture.asset(
                                                    'assets/svg/office.svg',
                                                    height: 45,
                                                    width: 45,
                                                  )
                                                : (homeDist <= 10.0)
                                                    ? SvgPicture.asset(
                                                        'assets/svg/home.svg',
                                                        height: 45,
                                                        width: 45,
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svg/other.svg',
                                                        height: 45,
                                                        width: 45,
                                                      )
                                            : Text(''),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        (logList.last.type == null)
                                            ? Text(
                                                'Logging out from',
                                                style: TextStyles.buttonTextStyle2,
                                              )
                                            : (logList.last.type == Utils.CLOCKIN)
                                                ? Text(
                                                    'Logging out from',
                                                    style: TextStyles.buttonTextStyle2,
                                                  )
                                                : Text(
                                                    'You are',
                                                    style: TextStyles.buttonTextStyle2,
                                                  ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.CLOCKOUT)
                                            ? (_currentPosition != null)
                                                ? (officeDist <= 10.0)
                                                    ? Text(
                                                        Utils.officeLocation,
                                                        style: TextStyles.bottomTextStyle,
                                                      )
                                                    : (homeDist <= 10.0)
                                                        ? Text(
                                                            Utils.homeLocation,
                                                            style: TextStyles.bottomTextStyle,
                                                          )
                                                        : Text(
                                                            Utils.unknownLocation,
                                                            style: TextStyles.bottomTextStyle,
                                                          )
                                                : Text('')
                                            : (_currentPosition != null)
                                                ? (officeDist <= 10.0)
                                                    ? Text(
                                                        Utils.office,
                                                        style: TextStyles.bottomTextStyle,
                                                      )
                                                    : (homeDist <= 10.0)
                                                        ? Text(
                                                            Utils.home,
                                                            style: TextStyles.bottomTextStyle,
                                                          )
                                                        : Text(
                                                            Utils.unknown,
                                                            style: TextStyles.bottomTextStyle,
                                                          )
                                                : Text(''),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        (_currentPosition != null)
                                            ? (officeDist <= 10.0)
                                                ? Text(
                                                    _currentAddress,
                                                    style: TextStyles.bottomTextStyle2,
                                                  )
                                                : (homeDist <= 10.0)
                                                    ? Text(
                                                        _currentAddress,
                                                        style: TextStyles.bottomTextStyle2,
                                                      )
                                                    : Text(
                                                        _currentAddress,
                                                        style: TextStyles.bottomTextStyle2,
                                                      )
                                            : Text(''),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.TIMEOUT)
                                            ? (DateTimeFormat.difference().inMinutes <= 5)
                                                ? Text(
                                                    Utils.early,
                                                    style: TextStyles.bottomTextStyle3,
                                                  )
                                                : (DateTimeFormat.difference().inMinutes <= 20)
                                                    ? Text(
                                                        Utils.late,
                                                        style: TextStyles.alertTextStyle,
                                                      )
                                                    : (DateTimeFormat.difference().inMinutes <= 60)
                                                        ? Text(
                                                            Utils.veryLate,
                                                            style: TextStyles.alertTextStyle1,
                                                          )
                                                        : (DateTimeFormat.difference().inMinutes <= 210)
                                                            ? Text(
                                                                Utils.halfDay,
                                                                style: TextStyles.alertTextStyle1,
                                                              )
                                                            : Text(
                                                                '',
                                                                style: TextStyles.alertTextStyle1,
                                                              )
                                            : Text(''),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        (_currentPosition == null)
                                            ? Text("")
                                            : (logList.last.type == Utils.CLOCKOUT ||
                                                    logList.last.type == Utils.TIMEOUT)
                                                ? ConfirmButton(
                                                    firstLog: true,
                                                    pressed: getLastLog(LogType.clockIn),
                                                    type: LogType.clockIn,
                                                    onPressed: () {
                                                      if (_currentPosition == null) {
                                                        Flushbar(
                                                          messageText: Center(
                                                            child: Text(
                                                              "Current Position cannot be fetched",
                                                              style: TextStyles.notificationTextStyle1,
                                                            ),
                                                          ),
                                                          backgroundColor: ViewColor.notification_green_color,
                                                          flushbarPosition: FlushbarPosition.TOP,
                                                          flushbarStyle: FlushbarStyle.FLOATING,
                                                          duration: Duration(seconds: 2),
                                                        )..show(context);
                                                      } else {
                                                        Navigator.of(context).pop();
                                                        model.markClockIn(context, _currentPosition.latitude,
                                                            _currentPosition.longitude, _currentAddress);
                                                        Flushbar(
                                                          messageText: Center(
                                                            child: Text(
                                                              Utils.msgClockIn,
                                                              style: TextStyles.notificationTextStyle1,
                                                            ),
                                                          ),
                                                          backgroundColor: ViewColor.notification_green_color,
                                                          flushbarPosition: FlushbarPosition.TOP,
                                                          flushbarStyle: FlushbarStyle.FLOATING,
                                                          duration: Duration(seconds: 2),
                                                        )..show(context);
                                                      }
                                                    },
                                                  )
                                                : Center(
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        BreakButton(
                                                          type: LogType.timeout,
                                                          firstLog: false,
                                                          pressed: getLastLog(LogType.timeout),
                                                          onPressed: () {
                                                            if (_currentPosition == null) {
                                                              Flushbar(
                                                                messageText: Center(
                                                                  child: Text(
                                                                    "Current Position cannot be fetched",
                                                                    style: TextStyles.notificationTextStyle1,
                                                                  ),
                                                                ),
                                                                backgroundColor: ViewColor.notification_green_color,
                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                flushbarStyle: FlushbarStyle.FLOATING,
                                                                duration: Duration(seconds: 2),
                                                              )..show(context);
                                                            } else {
                                                              Navigator.of(context).pop();
                                                              model.markClockTimeOut(context, _currentPosition.latitude,
                                                                  _currentPosition.longitude, _currentAddress);
                                                              Flushbar(
                                                                messageText: Center(
                                                                  child: Text(
                                                                    Utils.msgClockBreak,
                                                                    style: TextStyles.notificationTextStyle1,
                                                                  ),
                                                                ),
                                                                backgroundColor: ViewColor.notification_green_color,
                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                flushbarStyle: FlushbarStyle.FLOATING,
                                                                duration: Duration(seconds: 2),
                                                              )..show(context);
                                                            }
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        ClockOutButton(
                                                          firstLog: false,
                                                          type: LogType.clockOut,
                                                          pressed: getLastLog(LogType.clockOut),
                                                          onPressed: () {
                                                            if (_currentPosition == null) {
                                                              Flushbar(
                                                                messageText: Center(
                                                                  child: Text(
                                                                    "Current Position cannot be fetched",
                                                                    style: TextStyles.notificationTextStyle1,
                                                                  ),
                                                                ),
                                                                backgroundColor: ViewColor.notification_green_color,
                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                flushbarStyle: FlushbarStyle.FLOATING,
                                                                duration: Duration(seconds: 2),
                                                              )..show(context);
                                                            } else {
                                                              Navigator.of(context).pop();
                                                              model.markClockOut(
                                                                  DateTimeFormat.calculateHoursForSingleDay(
                                                                      todayLogList),
                                                                  context,
                                                                  _currentPosition.latitude,
                                                                  _currentPosition.longitude,
                                                                  _currentAddress);
                                                              Flushbar(
                                                                messageText: Center(
                                                                  child: Text(
                                                                    Utils.msgClockOut,
                                                                    style: TextStyles.notificationTextStyle1,
                                                                  ),
                                                                ),
                                                                backgroundColor: ViewColor.notification_green_color,
                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                flushbarStyle: FlushbarStyle.FLOATING,
                                                                duration: Duration(seconds: 2),
                                                              )..show(context);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: (logList.length == null)
                                ? Text(
                                    Utils.buttonIn,
                                    style: TextStyles.buttonTextStyle2,
                                  )
                                : (logList.last.type == Utils.CLOCKIN)
                                    ? Text(
                                        Utils.buttonOut,
                                        style: TextStyles.buttonTextStyle2,
                                      )
                                    : Text(
                                        Utils.buttonIn,
                                        style: TextStyles.buttonTextStyle2,
                                      ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: (logList.length == 0)
                          ? Text('')
                          : (logList.length != 0)
                              ? RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(text: Utils.last, style: TextStyles.homeText),
                                    (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.TIMEOUT)
                                        ? TextSpan(text: Utils.homeOut, style: TextStyles.homeText)
                                        : TextSpan(text: Utils.homeIn, style: TextStyles.homeText),
                                    (logList.last.type == Utils.CLOCKOUT || logList.last.type == Utils.TIMEOUT)
                                        ? TextSpan(
                                            text: DateTimeFormat.formatDateTime(logList.last.dateTime.toString()),
                                            style: TextStyles.homeText)
                                        : TextSpan(
                                            text: DateTimeFormat.formatDateTime(logList.last.dateTime.toString()),
                                            style: TextStyles.homeText),
                                  ]),
                                )
                              : Text(''),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: (logList.length == 0)
                          ? Text('')
                          : RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: Utils.hourToday, style: TextStyles.homeText1),
                                  TextSpan(
                                      text: "${DateTimeFormat.calculateHoursForSingleDay(todayLogList)}",
                                      style: TextStyles.homeText1),
                                  TextSpan(text: Utils.Hrs, style: TextStyles.homeText1),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: (logList.length == 0)
                          ? Text('')
                          : RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: Utils.avgMonth, style: TextStyles.homeText1),
                                  TextSpan(text: '00:00', style: TextStyles.homeText1),
                                  TextSpan(text: Utils.Hrs, style: TextStyles.homeText1),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<AddressDetail>> getUserAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    if (authToken != null) {
      response = await get(
        Utils.address_info_url + "$empId",
        headers: {'Authorization': 'Bearer $authToken'},
      );
    }
    setState(() {
      userAddressList =
          (json.decode(response.body)['Employee Detail'] as List).map((e) => AddressDetail.fromJson(e)).toList();
    });
    preferences.setString("homeLat", userAddressList.first.homeLatitude);
    preferences.setString("homeLong", userAddressList.first.homeLongitude);
    preferences.setString("officeLat", userAddressList.first.officeLatitude);
    preferences.setString("officeLong", userAddressList.first.officeLongitude);
    return (json.decode(response.body)['Employee Detail'] as List).map((e) => AddressDetail.fromJson(e)).toList();
  }

  Future<List<AttendanceLog>> getLogs() async {
    Future.delayed(const Duration(seconds: 5));
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
    setState(() {
      logList = (json.decode(response.body)['Employee Detail'] as List).map((e) => AttendanceLog.fromJson(e)).toList();
    });
    return (json.decode(response.body)['Employee Detail'] as List).map((e) => AttendanceLog.fromJson(e)).toList();
  }

  getLastLog(LogType type) {
    if (type == LogType.clockIn) {
      return logList.length == 0 ? false : logList.first.type == type;
    } else if (type == LogType.timeout) {
      return logList.length == 0 ? true : logList.first.type == type;
    } else {
      return logList.length == 0 ? true : logList.first.type == type;
    }
  }

  Future<List<TodayLog>> getTodayLogs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    DateTime now = DateTime.now();

    var queryParameters = {
      'date': DateTime(now.year, now.month, now.day).toString(),
    };
    var uri = Uri.https('dev.stimulusco.com', '/api/attendenceByDate/$empId', queryParameters);
    if (authToken != null) {
      response = await get(
        uri,
        headers: {'Authorization': 'Bearer $authToken'},
      );
    }
    setState(() {
      todayLogList = (json.decode(response.body)['Attendence Data'] as List).map((e) => TodayLog.fromJson(e)).toList();
    });
    return (json.decode(response.body)['Attendence Data'] as List).map((e) => TodayLog.fromJson(e)).toList();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.subLocality}, ${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }
}
