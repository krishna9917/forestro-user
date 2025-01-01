import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/listoftermination_model.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ClientSays extends GetxController {
  final _clientsaysDataList = Rx<List<Data>>([]);
  List<Data> get clientsaysDataList => _clientsaysDataList.value;
  final _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await clientsaysData();
  }

  Future<void> clientsaysData() async {
    try {
      _isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = '$apiUrl/list-testimonial';

      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData != null && responseData['status'] == true) {
          final dataList = responseData['data'];
          if (dataList != null && dataList is List) {
            List<Data> parsedDataList =
                dataList.map((item) => Data.fromJson(item)).toList();
            _clientsaysDataList.value = parsedDataList;

            // print(_ clientsaysDataList);
          }
        }
      }
    } catch (e) {
      print("featchthe error $e");
    } finally {
      _isLoading.value = false;
    }
  }
}
