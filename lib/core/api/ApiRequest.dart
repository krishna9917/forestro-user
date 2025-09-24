import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:foreastro/core/LocalStorage/UseLocalstorage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';

Logger logger = Logger();
String apiUrl = "https://foreastro.technovaedge.in/api";
// String apiUrl = "https://foreastro.com/api";
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
  final Dio dio = Dio()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
    );
  final bool ignoreUnauthorized;

  ApiRequest(this.url, {this.method, this.body, this.ignoreUnauthorized = false});

  dynamic _freshBody() {
    if (body is FormData) {
      final FormData original = body as FormData;
      final FormData copy = FormData();
      copy.fields.addAll(List<MapEntry<String, String>>.from(original.fields));
      copy.files.addAll(List<MapEntry<String, MultipartFile>>.from(original.files));
      return copy;
    }
    return body;
  }

  Future<Response> send<T>() async {
    logger.i(url, time: DateTime.now(), error: body is FormData ? '[FormData]' : body);
    try {
      // Short-circuit when offline to avoid useless network hits
      final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        throw const SocketException('No Internet connection');
      }

      SharedPreferences sharedPreferences = await LocalStorage.init();
      print("'Bearer ${sharedPreferences.getString("token")}'");
      Response data = await dio.request<T>(
        url,
        data: _freshBody(),
        options: Options(method: method ?? ApiMethod.GET, headers: {
          'Authorization': 'Bearer ${sharedPreferences.getString("token")}'
        }),
      );
      logger.f(data.data,
          time: DateTime.now(), error: "This Is Response, Method : $method");
      // Removed global auto-logout on JSON payloads; let callers handle messages
      return data;
    } on DioException catch (e) {
      logger.e(e.response?.data, error: e.error, stackTrace: e.stackTrace);
      final bool isHostLookupError =
          e.error is SocketException ||
              (e.message?.toLowerCase().contains('failed host lookup') ?? false);
      if (isHostLookupError && url.contains("foreastro.technovaedge.in")) {
        final String alternateUrl =
            url.replaceFirst("foreastro.technovaedge.in", "foreastro.com");
        try {
          SharedPreferences sharedPreferences = await LocalStorage.init();
          Response data = await dio.request<T>(
            alternateUrl,
            data: _freshBody(),
            options: Options(method: method ?? ApiMethod.GET, headers: {
              'Authorization': 'Bearer ${sharedPreferences.getString("token")}'
            }),
          );
          logger.f(data.data,
              time: DateTime.now(),
              error: "RETRY Response, Method : $method");
          apiUrl = apiUrl.replaceFirst(
              "https://foreastro.technovaedge.in", "https://foreastro.com");
          // Removed auto-logout logic in retry branch as well
          return data;
        } on DioException catch (retryError) {
          logger.e(retryError.response?.data,
              error: retryError.error, stackTrace: retryError.stackTrace);
          rethrow;
        }
      }
      // Removed global auto-logout on HTTP 401; let UI handle it
      rethrow;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}

Future<void> _forceLogoutUser() async {
  try {
    SharedPreferences prefs = await LocalStorage.init();
    await prefs.clear();
  } catch (_) {}
  try {
    navigate.popUntil((route) => route.isFirst);
  } catch (_) {}
  try {
    navigate.pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  } catch (_) {}
}
