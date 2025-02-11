import 'dart:async';
import 'package:dio/dio.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/listaustro_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAstrologerProfile extends GetxController {
  final _austroDataList = Rx<List<Data>>([]);
  List<Data> get astroDataList => _austroDataList.value.obs;

  final _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await astroData();
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

      print("jjjjjjjjjj======${response.statusCode}");
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
     

      print("featchthe error Astrology Data======> $e");
    } finally {
      _isLoading.value = false;
    }
  }
}
