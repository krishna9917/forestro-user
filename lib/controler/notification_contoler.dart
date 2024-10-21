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

      // Show bottom sheet after the toast
      showModalBottomSheet(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please wait for some time while Astrologer is responding.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                // const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ],
            ),
          );
        },
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
