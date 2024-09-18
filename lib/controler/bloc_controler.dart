import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/block_model.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BlocList extends GetxController {
  final _blocDataList = Rx<List<Data>>([]);
  List<Data> get blocDataList => _blocDataList.value;
  final _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await blocData();
  }

  Future<void> blocData() async {
    try {
      _isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = '$apiUrl/blogs';

      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        url,
      );

      if (response.statusCode == 201) {
        final responseData = response.data;

        print(responseData);

        if (responseData != null && responseData['status'] == true) {
          final dataList = responseData['data'];
          print(dataList);
          if (dataList != null && dataList is List) {
            List<Data> parsedDataList =
                dataList.map((item) => Data.fromJson(item)).toList();
            _blocDataList.value = parsedDataList;

            print(_blocDataList);
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
