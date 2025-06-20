import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // สร้างเพียงครั้งเดียวและสามารถใช้ได้ทั้งหน้า (หรือทั้งแอป) โดยไม่ต้องเรียก await SharedPreferences.getInstance(); ซ้ำ ๆ ใช้ Singleton pattern
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("SharedPreferences ยังไม่ได้ถูก initialized! เรียก SharedPrefHelper.init() ก่อนใช้งาน");
    }
    return _prefs!;
  }

  static Future<void> clearPreferencesExcept(List<String> ignoreKeys) async {
    // Get all keys
    final Set<String> allKeys = prefs.getKeys();

    // Remove keys that are not in the ignore list
    for (String key in allKeys) {
      log('key : $key');
      if (!ignoreKeys.contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  static Future<void> logAllPreferencesKeys() async {
    // Get all keys
    final Set<String> allKeys = prefs.getKeys();
    for (String key in allKeys) {
      log('key : $key');
    }
  }
}
