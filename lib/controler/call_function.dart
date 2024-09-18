import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:foreastro/controler/notification_contoler.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendRequest {
  static String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 + random.nextInt(90000);
    return '$randomNumber';
  }

  static Future sendrequestvideo(
    String? id,
    token,
    coupencode,
  ) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Video";
        String? user_id = prefs.getString('user_id');
        var title = "New  Video Call Request";
        String videocallId = generateRandomOrderId();

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
              'type': 'video',
              'status': 'pending',
              'communication_id': 'video$videocallId',
              'coupon_applied': coupencode,
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Video Call Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  static Future sendrequestchat(String? id, token, coupencode) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Chat";
        String? user_id = prefs.getString('user_id');
        var title = "New  chat Request";
        String chatId = generateRandomOrderId();

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
              'type': 'chat',
              'status': 'pending',
              'communication_id': 'chat$chatId',
              'coupon_applied': coupencode,
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Chat Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  static Future sendrequestaudio(String? id, token, coupencode) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Audio";
        String? user_id = prefs.getString('user_id');

        String audiocallId = generateRandomOrderId();
        var title = "New  Audio Call Request";

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
              'type': 'audio',
              'status': 'pending',
              'communication_id': 'audio$audiocallId',
              'coupon_applied': coupencode,
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Audio Call Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }
}
