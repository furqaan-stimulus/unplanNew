import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unplan/model/attendance_log.dart';
import 'package:unplan/service/shared_pref_service.dart';
import 'package:unplan/utils/utils.dart';

class AttendanceService {
  Future<Map<String, dynamic>> markLog(
    String type,
    String currentAddress,
    double latitude,
    double longitude,
    int present,
    double totalHours,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int empId = preferences.getInt('id');
    DateTime now = DateTime.now();
    final Map<String, dynamic> logData = {
      'emp_id': empId,
      'date_time': DateTime.now().toString(),
      'time': DateTime.now().toString(),
      'date': DateTime(now.year, now.month, now.day).toString(),
      'type': type,
      'location': currentAddress,
      'currunt_lat': latitude,
      'currunt_long': longitude,
      'present': present,
      'total_hour': totalHours,
      'avg_hour': 0,
    };

    var result;
    var token = preferences.getString('token');

    Response response = await post(
      Utils.attendance_url,
      body: json.encode(logData),
      headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    // if (response.body.toString().contains("Enter valid details")) {
    //   _navigationService.pushNamedAndRemoveUntil(Routes.loginView);
    // } else

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      var logData = responseData;
      AttendanceLog authUser = AttendanceLog.fromJson(logData);
      await SharedPrefService.storeString('date_time', authUser.dateTime.toString());
      await SharedPrefService.storeString('type', authUser.type);
      result = {'status': true, 'message': 'code ${response.statusCode},${response.body} '};
      print(result);
    } else {
      result = {'status': false, 'message': 'code ${response.statusCode},${response.body}'};
      print(result);
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> postLeave(
    String type,
    String fromDate,
    String toDate,
    String reasonOfLeave,
    int totalDays,
    int paidLeave,
    int sickLeave,
    int unpaidLeave,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int empId = preferences.getInt('id');
    var token = preferences.getString('token');
    var result;
    final Map<String, dynamic> logData = {
      'apply_date': DateTime.now().toString(),
      'from': fromDate,
      'to': toDate,
      'unpaid_leave': unpaidLeave,
      'paid_leave': paidLeave,
      'sick_leave': sickLeave,
      'leave_type': type,
      'reason_of_leave': reasonOfLeave,
      'status': 'notapproved',
      'total_days': totalDays,
    };
    Response response = await post(
      Utils.post_leave_url + "$empId",
      body: json.encode(logData),
      headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'code ${response.statusCode},${response.body}'};
      print("success $result");
    } else {
      result = {'status': true, 'message': 'code ${response.statusCode},${response.body}'};
      print("failed $result");
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateLeavesCount(int remainPaid, int remainSick) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int empId = preferences.getInt('id');
    var slug = preferences.getString('slug');
    var token = preferences.getString('token');
    var result;
    final Map<String, dynamic> leaveData = {
      'unsc_leave': remainPaid,
      'sick_leave': remainSick,
    };

    Response response = await post(
      Utils.update_employee_info_url + "$slug" + Utils.PS + "$empId",
      body: json.encode(leaveData),
      headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'code ${response.statusCode},${response.body} '};
      print(result);
    } else {
      result = {'status': true, 'message': 'code ${response.statusCode}'};
      print(result);
    }
    return jsonDecode(response.body);
  }
}
