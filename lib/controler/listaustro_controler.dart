import 'dart:async';

import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/listaustro_model.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GetAstrologerProfile extends GetxController {
  // Initialize the profile data list
  final _austroDataList = Rx<List<Data>>([]);

  // Getter for the profile data list
  List<Data> get astroDataList => _austroDataList.value.obs;

  // Flag to indicate if the data is loading
  final _isLoading = RxBool(false);

  // Getter for the loading flag
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await astroData();
    await astroData();

    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   astroData();
    // });
  }

  Future<void> astroData() async {
    try {
      _isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = '$apiUrl/list-astrologer';

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
            _austroDataList.value = parsedDataList;

           
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
