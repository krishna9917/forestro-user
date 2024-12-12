import 'package:dio/dio.dart';
import 'package:foreastro/model/kundali/Binnashtakvarga_Model.dart';
import 'package:foreastro/model/kundali/Personal_Characteristics_Model.dart';
import 'package:foreastro/model/kundali/assedent_model.dart';
import 'package:foreastro/model/kundali/kp_housemodel.dart';
import 'package:foreastro/model/kundali/matchkundali/northkundali_model.dart';
import 'package:foreastro/model/kundali/matchkundali/southkundali_model.dart';
import 'package:foreastro/model/kundali/plannet_model.dart';
import 'package:foreastro/model/kundali/vimshotri_model.dart';
import 'package:get/get.dart';

class KundaliController extends GetxController {
  var planetDataList = Rx<PlanetModel?>(null);
  var assedentDataList = AsedentReportModel().obs;
  var personalcharacteristics = Personal_Characteristics_Model().obs;
  var binnashtakvarga = Binnashtakvarga_Model().obs;
  var vimsotridasadatalist = Vimsotridasa_Model().obs;
  var northmatching = NorthModel().obs;
  var southmatching = SouthKundaliModel().obs;
  var kphousemodel = KpHouseModel().obs;
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> fetchPlanetData(
      String dob, String tob, double lat, double lon, String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/horoscope/planet-details';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          planetDataList.value = PlanetModel.fromJson(responseData);
          print("planetDataList.value===========${planetDataList.value}");
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> AssedentData(
      String dob, String tob, double lat, double lon, String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/horoscope/ascendant-report';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          assedentDataList.value = AsedentReportModel.fromJson(responseData);
          print(assedentDataList.value);
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> PersonalCharacteristicsData(
      String dob, String tob, double lat, double lon, String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/horoscope/personal-characteristics';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          personalcharacteristics.value =
              Personal_Characteristics_Model.fromJson(responseData);
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> KpHouseData(
      String dob, String tob, double lat, double lon, String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/extended-horoscope/kp-houses';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          kphousemodel.value = KpHouseModel.fromJson(responseData);
        } else {}
      } else {}
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> BinnashtakvargaData(
    String dob,
    String tob,
    double lat,
    double lon,
    String lang,
  ) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
        'planet': "Jupiter",
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/horoscope/binnashtakvarga';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          binnashtakvarga.value = Binnashtakvarga_Model.fromJson(responseData);
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> Vimsotridasa(
    String dob,
    String tob,
    double lat,
    double lon,
    String lang, {
    String? md,
    String? ad,
    String? pd,
    String? sd,
  }) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'dob': dob,
        'tob': tob,
        'lat': lat,
        'lon': lon,
        'tz': 5.5,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      if (md != null) queryParams['md'] = md;
      if (ad != null) queryParams['ad'] = ad;
      if (pd != null) queryParams['pd'] = pd;
      if (sd != null) queryParams['sd'] = sd;
      const url =
          'https://api.vedicastroapi.com/v3-json/dashas/specific-sub-dasha';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;
        print("responseData===============>>>>>>>>>>>>>$responseData");

        if (responseData != null) {
          vimsotridasadatalist.value =
              Vimsotridasa_Model.fromJson(responseData);
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> KundalimilanNorthData(
      String dobBoy,
      String tobBoy,
      double latBoy,
      double lonBoy,
      String dobGirl,
      String tobGirl,
      double latGirl,
      double lonGirl,
      String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'boy_dob': dobBoy,
        'boy_tob': tobBoy,
        'boy_tz': 5.5,
        'boy_lat': latBoy,
        'boy_lon': lonBoy,
        'girl_dob': dobGirl,
        'girl_tob': tobGirl,
        'girl_tz': '5.5',
        'girl_lat': latGirl,
        'girl_lon': lonGirl,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/matching/ashtakoot-with-astro-details';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);
      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          northmatching.value = NorthModel.fromJson(responseData);
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> KundalimilanSouthData(
      String dobBoy,
      String tobBoy,
      double latBoy,
      double lonBoy,
      String dobGirl,
      String tobGirl,
      double latGirl,
      double lonGirl,
      String lang) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> queryParams = {
        'boy_dob': dobBoy,
        'boy_tob': tobBoy,
        'boy_tz': 5.5,
        'boy_lat': latBoy,
        'boy_lon': lonBoy,
        'girl_dob': dobGirl,
        'girl_tob': tobGirl,
        'girl_tz': '5.5',
        'girl_lat': latGirl,
        'girl_lon': lonGirl,
        'api_key': 'c9783a2d-98e9-5735-81e7-7c093ee21104',
        'lang': lang,
      };
      const url =
          'https://api.vedicastroapi.com/v3-json/matching/dashakoot-with-astro-details';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null) {
          southmatching.value = SouthKundaliModel.fromJson(responseData);
          // print(northmatching.value);
        } else {}
      } else {}
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
