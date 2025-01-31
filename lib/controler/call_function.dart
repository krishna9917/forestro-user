import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/controler/notification_contoler.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/theme/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendRequest {
  static String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 + random.nextInt(90000);
    return '$randomNumber';
  }

  static Future sendrequestvideo(
      String? id, String token, String coupencode, String signalId) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Video";
        String? user_id = prefs.getString('user_id');
        var title = "New Video Call Request";
        String videocallId = generateRandomOrderId();

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData({
            'user_id': user_id,
            'astro_id': id,
            'type': 'video',
            'status': 'pending',
            'communication_id': 'video$videocallId',
            'coupon_applied': coupencode,
          }),
        );

        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Video Call Request sent");
          NotificationService.sendNotification(token, title, id, servicetype);
          NotificationService.sendNotifications(servicetype, signalId);
        } else if (data.statusCode == 203) {
          final message = data.data['message'];
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColor.primary,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      }
    } catch (e) {
      // showToast("Error: ${e.toString()}");
    }
  }

  static Future sendrequestchat(
      String? id, String token, String coupencode, String signalId) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Chat";
        String? user_id = prefs.getString('user_id');
        var title = "New Chat Request";
        String chatId = generateRandomOrderId();
        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData({
            'user_id': user_id,
            'astro_id': id,
            'type': 'chat',
            'status': 'pending',
            'communication_id': 'chat$chatId',
            'coupon_applied': coupencode,
          }),
        );

        dio.Response data = await apiRequest.send();

        print("manjulika========${data.data['status']}");

        if (data.statusCode == 201) {
          showToast("Chat Request sent");
          NotificationService.sendNotification(token, title, id, servicetype);
          NotificationService.sendNotifications(servicetype, signalId);
        } else if (data.statusCode == 203) {
          final message = data.data['message'];
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColor.primary,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {}
      }
    } catch (e) {
      // showToast("Error: ${e.toString()}");
    }
  }

  static Future sendrequestaudio(
      String? id, String token, String coupencode, String signalId) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Audio";
        String? user_id = prefs.getString('user_id');
        var title = "New Audio Call Request";
        String audiocallId = generateRandomOrderId();

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData({
            'user_id': user_id,
            'astro_id': id,
            'type': 'audio',
            'status': 'pending',
            'communication_id': 'audio$audiocallId',
            'coupon_applied': coupencode,
          }),
        );

        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Audio Call Request sent");
          NotificationService.sendNotification(token, title, id, servicetype);
          NotificationService.sendNotifications(servicetype, signalId);
        } else if (data.statusCode == 203) {
          final message = data.data['message'];
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColor.primary,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      // showToast("Error: ${e.toString()}");
    }
  }
}
