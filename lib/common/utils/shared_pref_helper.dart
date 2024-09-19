import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefHelper {
  static void saveStringValues(String key, String? value) async {
    var prefs = await SharedPreferences.getInstance();
    if (value != null) {
      prefs.setString(key, value).then((value) {
        print('saved ${value}');
      }).catchError((error) {
        print('saved ${error}');
      });
    } else {
      // If the value is null, you can handle it here (e.g., remove the key)
      prefs.remove(key).then((value) {
        print('Key removed: $key');
      }).catchError((error) {
        print('Error removing key: $error');
      });
    }
  }

  static Future<String?> retrieveStringValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key).then((value) {
      print('FCM Token is removed successfully');
    }).catchError((error) {
      print('Failed to remove FCM Token locally');
    });
  }

  static void saveBooleanValues(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value).then((value) {
      print('saved ${value}');
    }).catchError((error) {
      print('saved ${error}');
    });
  }

  static Future<bool> retrieveBooleanValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static const String _userKey = 'user';

/*  static Future<void> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }*/

  static Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
