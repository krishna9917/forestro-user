import 'package:dio/dio.dart';
import 'package:foreastro/core/LocalStorage/UseLocalstorage.dart';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Logger logger = Logger();
String apiUrl = "https://foreastro.com/api";
const String tosteError = "Something Went Wrong!";

class ApiMethod {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PUT = "PUT";
  static const String PATCH = "PATCH";
  static const String DELETE = "DELETE";
}

FormData packFormData(data) {
  return FormData.fromMap(data);
}

Future<MultipartFile> addFormFile(String file, {String? filename}) async {
  return await MultipartFile.fromFile(file, filename: filename);
}

class ApiRequest {
  final String url;
  String? method;
  var body;
  final Dio dio = Dio();

  ApiRequest(this.url, {this.method, this.body});

  Future<Response> send<T>() async {
    logger.i(
      url,
      time: DateTime.now(),
      error: [body.fields, body.files],
    );
    try {
      SharedPreferences sharedPreferences = await LocalStorage.init();
      Response data = await dio.request<T>(
        url,
        data: body,
        options: Options(method: method ?? ApiMethod.GET, headers: {
          'Authorization': 'Bearer ${sharedPreferences.getString("token")}'
        }),
      );
      logger.f(data.data,
          time: DateTime.now(), error: "This Is Response, Method : $method");
      return data;
    } on DioException catch (e) {
      logger.e(e.response?.data, error: e.error, stackTrace: e.stackTrace);
      rethrow;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
