import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/pendingrequest_model.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingRequest extends GetxController {
  var pendingRequestDataList = <Data>[].obs;
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await pendingRequestData();
  }

  Future<void> pendingRequestData() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId = prefs.getString('user_id');
      if (token == null || userId == null) {
        return;
      }
      final Map<String, dynamic> queryParams = {'user_id': userId};
      final url = '$apiUrl/user-pending-request';
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(url, queryParameters: queryParams);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData['status'] == true) {
          final dataList = responseData['data'];
          if (dataList != null && dataList is List) {
            List<Data> parsedDataList =
                dataList.map((item) => Data.fromJson(item)).toList();
            pendingRequestDataList.value = parsedDataList;
          }
        }
      }
    } catch (e) {
      print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
