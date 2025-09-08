import 'package:dio/dio.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/profile_model.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileList extends GetxController {
  final _profileDataList = Rx<List<Data>>([]);

  List<Data> get profileDataList => _profileDataList.value.obs;
  final _isLoading = RxBool(false);

  bool get isLoading => _isLoading.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      _isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? user_id = prefs.getString('user_id');
      final Map<String, dynamic> queryParams = {'user_id': user_id};

      final url = '$apiUrl/user-profile';

      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(url, queryParameters: queryParams);
      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData != null) {
          final data = responseData['data'];
          if (data != null) {
            _profileDataList.value = [Data.fromJson(data)];
            print(_profileDataList.value);
          }
        }
      }
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await GoogleSignIn().signOut();
      Get.offAll(() => const LoginScreen());
      showToast("Plese Login");
      print("featchthe error Bloc list $e");
      print(e);
    } finally {
      _isLoading.value = false;
    }
  }
}
