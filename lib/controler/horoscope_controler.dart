import 'package:dio/dio.dart';
import 'package:foreastro/model/horoscope_model.dart';
import 'package:get/get.dart';

class HoroscopeControler extends GetxController {
  var horoscopeDataList = HoroscopeModel().obs;
  var isLoading = false.obs;
  RxString translatedText = RxString('');
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> horoscopeData(String zodiac, String date) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'zodiac': zodiac,
        'date': date,
        'show_same': true,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': 'hi',
        // 'split': true,
        'type': 'big'
      };
      const url = 'https://api.vedicastroapi.com/v3-json/prediction/daily-sun';

      final Dio dio = Dio();

      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          horoscopeDataList.value = HoroscopeModel.fromJson(responseData);
          // print(horoscopeDataList.value);
        } else {}
      } else {}
    } catch (e) {
      // print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
