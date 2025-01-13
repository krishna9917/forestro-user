import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BannerList extends GetxController {
  final _isLoading = RxBool(false);
  List<String> dataList = [];
  bool get isLoading => _isLoading.value;

  // @override
  // Future<void> onInit() async {
  //   super.onInit();
  //   await fetchProfileData();
  // }

  Future<void> fetchProfileData() async {
    try {
      _isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = '$apiUrl/banners';

      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        url,
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData != null && responseData['status'] == true) {
          final dataListFromResponse = responseData['data'];
          dataList = List<String>.from(dataListFromResponse);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading.value = false;
    }
  }
}
