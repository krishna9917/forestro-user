import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/remedy_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemedyHistory extends GetxController {
  var remedyHistoryDataList = <Data>[].obs;

  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchRemedyData();
  }

  Future<void> fetchRemedyData() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId = prefs.getString('user_id');

      final Map<String, dynamic> queryParams = {'user_id': userId};
      final url = '$apiUrl/list-ramedy';

      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(url, queryParameters: queryParams);
      print(response);

      if (response != null && response.data['status'] == true) {
        final dataList = response.data['data'];
        print("dataList=======$dataList");
        if (dataList != null && dataList is List) {
          List<Data> parsedDataList =
              dataList.map((item) => Data.fromJson(item)).toList();
          remedyHistoryDataList.value = parsedDataList;
        }
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
