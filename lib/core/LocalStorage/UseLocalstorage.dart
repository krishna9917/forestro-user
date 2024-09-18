import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
