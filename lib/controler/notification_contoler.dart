import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<void> sendNotification(
      String token, String title, String id, String servicetype) async {
    final profileController = Get.find<ProfileList>();
    var name = profileController.profileDataList.first.name;
    var img = profileController.profileDataList.first.profileImg ?? '';

    print("token==========$token");

    try {
      await http.post(
        Uri.parse('http://143.244.130.192:4000/notify'),
        body: jsonEncode({
          "token": token,
          "notification": {
            "title": title,
            "body": "",
          },
          "data": {}
        }),
      );

      Fluttertoast.showToast(
        msg: "Notification sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Get.find<SocketController>().sendNewRequest(
          userId: id,
          requestType: servicetype,
          data: {
            "message": "$name Send You video Request",
            "name": name,
            "profile_pic": img
          });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Failed to send notification.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
