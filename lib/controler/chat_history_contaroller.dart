import 'package:dio/dio.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/chat_history_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistory extends GetxController {
  // Initialize the profile data list
  var chatHistoryDataList = <Data>[].obs;

  // Flag to indicate if the data is loading
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchChatHistoryData();
  }

  Future<void> fetchChatHistoryData() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId = prefs.getString('user_id');

      if (token == null || userId == null) {
        // Handle token or userId being null
        return;
      }

      final Map<String, dynamic> queryParams = {'user_id': userId};
      final url = '$apiUrl/user-chat-log';

      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 201) {
        final responseData = response.data;

        print(responseData);

        if (responseData != null && responseData['status'] == true) {
          final dataList = responseData['data'];
          print("chathistory$dataList");
          if (dataList != null && dataList is List) {
            List<Data> parsedDataList =
                dataList.map((item) => Data.fromJson(item)).toList();
            chatHistoryDataList.value = parsedDataList;
          }
        }
      }
    } catch (e) {
      print("fetch the error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
