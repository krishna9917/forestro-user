import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  static Future<Response> sendsignal<T>() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user_id = prefs.getString('user_id');
      String? sToken = prefs.getString("externalId");
      print("sToken=======$sToken");
      ApiRequest apiRequest = ApiRequest("$apiUrl/user-signal-notifaction-send",
          method: ApiMethod.POST,
          body: packFormData({
            'user_id': user_id,
            "signal_id": sToken.toString(),
          }));
      return await apiRequest.send<T>();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
