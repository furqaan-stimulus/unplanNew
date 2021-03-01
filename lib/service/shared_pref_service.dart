import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<Map> storeString(String key, String value) async {
    Map<String, Object> result = new Map();
    result['isStored'] = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result['isStored'] = await prefs.setString(key, value);
    } catch (e) {
      result['error'] = 'Error occurred while storing ' + key + ': ' + e.toString();
    }
    return result;
  }

  static Future<Map> storeInt(String key, int value) async {
    Map<String, Object> result = new Map();
    result['isStored'] = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result['isStored'] = await prefs.setInt(key, value);
    } catch (e) {
      result['error'] = 'Error occurred while storing ' + key + ': ' + e.toString();
    }
    return result;
  }

  static Future<Map> fetchFromSharedPref(String key) async {
    Map<String, Object> result = new Map();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result[key] = prefs.getString(key);
    } catch (e) {
      result['error'] = 'Error occurred while getting ' + key + ': ' + e.toString();
    }
    return result;
  }

  static Future<Map> clear() async {
    Map<String, Object> result = new Map();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result['cleared'] = prefs.clear();
      print('Persistence storage cleared.');
    } catch (e) {
      result['error'] = 'Error occurred while clearing shared preferences : ' + e.toString();
    }
    return result;
  }
}
