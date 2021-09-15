// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveProgress {
  Future<void> getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // SharedPreferencesから値を取得.
    // keyが存在しない場合はnullを返す.
    print(preferences.getInt("test_int_key"));
    print(preferences.getString("test_string_key"));
    print(preferences.getBool("test_bool_key"));
    print(preferences.getDouble("test_double_key"));
  }

  Future<void> setPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // SharedPreferencesに値を設定.
    preferences.setInt("test_int_key", 1);
    preferences.setString("test_string_key", "message");
    preferences.setBool("test_bool_key", true);
    preferences.setDouble("test_double_key", 1.0);
  }

  Future<void> deletePreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // SharedPreferencesにkeyが存在するかどうか.
    if (preferences.containsKey(key)) {
      // SharedPreferencesからkeyに設定している値を削除.
      await preferences.remove(key);
    }
  }

  Future<void> deleteAllPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // SharedPreferencesの値を全て削除.
    await preferences.clear();
  }
}
