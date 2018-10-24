import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharePreUtils {
  Future<String> getPref(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var value = pref.getString(key);
    return value;
  }

}
