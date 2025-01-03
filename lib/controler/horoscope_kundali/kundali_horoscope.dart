import 'package:dio/dio.dart';
import 'package:foreastro/model/kundali/Binnashtakvarga_Model.dart';
import 'package:foreastro/model/kundali/Personal_Characteristics_Model.dart';
import 'package:foreastro/model/kundali/assedent_model.dart';
import 'package:foreastro/model/kundali/kp_housemodel.dart';
import 'package:foreastro/model/kundali/kp_planet_model.dart';
import 'package:foreastro/model/kundali/matchkundali/northkundali_model.dart';
import 'package:foreastro/model/kundali/matchkundali/southkundali_model.dart';
import 'package:foreastro/model/kundali/plannet_model.dart';
import 'package:foreastro/model/kundali/sub_dasha/anterdasha_model.dart';
import 'package:foreastro/model/kundali/sub_dasha/paryantardasha_model.dart';
import 'package:foreastro/model/kundali/sub_dasha/pranadasha_model.dart';

import 'package:foreastro/model/kundali/sub_dasha/shookshamadasha_model.dart';
import 'package:foreastro/model/kundali/vimshotri_model.dart';
import 'package:get/get.dart';

class KundaliController extends GetxController {
  var isLoading = true.obs;
  var selectedMahadasha = "".obs;
  var currentDetail = 'mahadasha'.obs;
  var selectedAntardasha = Rxn<String>();
  var planetDataList = Rx<PlanetModel?>(null);
  var assedentDataList = AsedentReportModel().obs;
  var personalcharacteristics = Personal_Characteristics_Model().obs;
  var binnashtakvarga = Binnashtakvarga_Model().obs;
  var vimsotridasadatalist = Vimsotridasa_Model().obs;
  var antardashadatalist = Antardasha_Model().obs;
  var paryantardashadatalist = Paryantardasha_Model().obs;
  var shookshamadashadatalist = Shookshamadasha_Model().obs;
  var pranadashadatalist = Pranadasha_Model().obs;
  var northmatching = NorthModel().obs;
  var southmatching = SouthKundaliModel().obs;
  var kphousemodel = KpHouseModel().obs;
  var kphouseplanetmodel = Kp_Planet_Model().obs;

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

  Future<void> KpHousePlannet(
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
          'https://api.vedicastroapi.com/v3-json/extended-horoscope/kp-planets';

      final Dio dio = Dio();
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;
        print("plannetkp========================>>>>>>>${responseData}");

        if (responseData != null && responseData['status'] == 200) {
          kphouseplanetmodel.value = Kp_Planet_Model.fromJson(responseData);
          print("Parsed kp house planet model: ${kphouseplanetmodel.value}");
        } else {
          print("Unexpected response structure: $responseData");
        }
      } else {
        print("API error: ${response.statusCode}, ${response.statusMessage}");
      }
    } catch (e) {
      print("eeeeeeeeee=======$e");
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
    String? mahadashaName,
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
      print(queryParams);
      if (mahadashaName != null) queryParams['md'] = mahadashaName;
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
        // antardashadatalist.value = Antardasha_Model.fromJson(responseData);
        if (responseData != null) {
          // shookshamadashadatalist.value =Shookshamadasha_Model.fromJson(responseData);
          if (mahadashaName != null && ad != null && pd != null && sd != null) {
            print("Mahadasha, AD, and PD sd available.");
            pranadashadatalist.value = Pranadasha_Model.fromJson(responseData);
            // pranadashadatalist.value = Pranadasha_Model.fromJson(responseData);
          } else if (mahadashaName != null && ad != null && pd != null) {
            print("Mahadasha, AD, and PD available.");
            shookshamadashadatalist.value =
                Shookshamadasha_Model.fromJson(responseData);
          } else if (mahadashaName != null && ad != null) {
            print("Both Mahadasha and AD available.");
            paryantardashadatalist.value =
                Paryantardasha_Model.fromJson(responseData);
          }
          // If only `mahadashaName` is present
          else if (mahadashaName != null) {
            print(mahadashaName);
            antardashadatalist.value = Antardasha_Model.fromJson(responseData);
          }
          // Default to `vimsotridasadatalist`
          else {
            vimsotridasadatalist.value =
                Vimsotridasa_Model.fromJson(responseData);
          }
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
