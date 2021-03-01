import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unplan/app/locator.dart';
import 'package:unplan/app/router.gr.dart';
import 'package:unplan/model/login.dart';
import 'package:unplan/service/shared_pref_service.dart';
import 'package:unplan/utils/utils.dart';

class AuthService {
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackBarService = locator<SnackbarService>();
  var result;

  Future<Map<String, dynamic>> postLogin(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };
    Response response = await post(
      Utils.login_url,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData;
      Login authUser = Login.fromJson(userData);

      await SharedPrefService.storeString('token', authUser.token);
      await SharedPrefService.storeString('email', authUser.userDetail.email);
      await SharedPrefService.storeString('name', authUser.userDetail.name);
      await SharedPrefService.storeInt('id', authUser.userDetail.id);
      await SharedPrefService.storeString('deviceOs', authUser.userDetail.deviceOs);
      await SharedPrefService.storeString('deviceId', authUser.userDetail.deviceId);

      result = {'status': true, 'message': 'code ${response.statusCode} '};
      _snackBarService.showSnackbar(message: 'login Successful');
      _navigationService.pushNamedAndRemoveUntil(
        Routes.homeView,
      );
    } else {
      result = {'status': false, 'message': 'code ${response.statusCode} '};
      _snackBarService.showSnackbar(message: 'login failed!! Enter correct credentials');
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateDeviceInfo(
    String deviceId,
    String deviceOs,
  ) async {
    final Map<String, dynamic> deviceData = {
      'device_id': deviceId,
      'device_os': deviceOs,
    };
    var result;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var empId = preferences.getString("id");
    String authToken = preferences.getString('token');
    Response response = await post(
      Utils.device_info_url + "$empId",
      body: json.encode(deviceData),
      headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $authToken'},
    );
    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'code ${response.statusCode},${response.body} '};
      print(result);
    } else {
      result = {'status': false, 'message': 'code ${response.statusCode},${response.body}'};
      print(result);
    }
    return jsonDecode(response.body);
  }
}
