import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartImageControler extends GetxController {
  var isLoading = false.obs;
  var svgData = ''.obs;
  var kpData = ''.obs;
  var divisionchartData = ''.obs;
  var divisionchartDatas = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // await ChartData();
  }

  Future<void> ChartData(
      String dob, String tob, double lat, double lon, String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': '5.5',
        'div': 'D1',
        'color': '%23ff3366',
        'style': 'north',
        'font_size': '12',
        'font_style': 'roboto',
        'colorful_planets': '0',
        'size': '300',
        'stroke': '2',
        'format': 'base64',
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': 'en',
      };
      final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        svgData.value = response.data;
      }
    } catch (e) {
      print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> DivisionalChartData(
      {required String dob,
      required String tob,
      required double lat,
      required double lon,
      required String lang,
      required String div}) async {
    try {
      isLoading.value = true;
      // divisionchartData.value = '';
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': '5.5',
        'div': div,
        'color': '%23ff3366',
        'style': 'north',
        'font_size': '12',
        'font_style': 'roboto',
        'colorful_planets': '1',
        'size': '300',
        'stroke': '2',
        'format': 'base64',
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      print("quriparametterrr============$queryParams");
      final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        divisionchartData.value = response.data;
      }
    } catch (e) {
      print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> DivisionalChartDatas(
      {required String dob,
      required String tob,
      required double lat,
      required double lon,
      required String lang,
      required String div}) async {
    try {
      // isLoading.value = true;
      // divisionchartData.value = '';
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': '5.5',
        'div': div,
        'color': '%23ff3366',
        'style': 'south',
        'font_size': '12',
        'font_style': 'roboto',
        'colorful_planets': '1',
        'size': '300',
        'stroke': '2',
        'format': 'base64',
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      print("quriparametterrr============$queryParams");
      final url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        divisionchartDatas.value = response.data;
      }
    } catch (e) {
      print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> KpChartData(
      String dob, String tob, double lat, double lon, String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': '5.5',
        'div': 'kp_chalit',
        'color': '%23ff3366',
        'style': 'north',
        'font_size': '12',
        'font_style': 'roboto',
        'colorful_planets': '0',
        'size': '300',
        'stroke': '2',
        'format': 'base64',
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': 'en',
      };
      const url = 'https://api.vedicastroapi.com/v3-json/horoscope/chart-image';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        kpData.value = response.data;
        print("svagimage");
      }
    } catch (e) {
      print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
