import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
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
    var wallet = profileController.profileDataList.first.wallet ?? '0';

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
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            elevation: 10, 
            content: Container(
              padding: const EdgeInsets.all(16.0),
              height: 160, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50, 
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "The planets are adjusting their frequencies just for you... ",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "STAY TUNE ",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary, 
                          ),
                        ),
                        TextSpan(
                          text: "your astrologer will ",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "CONNECT WITH YOU ",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary, 
                          ),
                        ),
                        TextSpan(
                          text: "in any moment! ",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                 
                ],
              ),
            ),
          );
        },
      );

      Get.find<SocketController>()
          .sendNewRequest(userId: id, requestType: servicetype, data: {
        "message": "$name Send You video Request",
        "name": name,
        "profile_pic": img,
        "user_wallet": wallet
      });
    } catch (e) {
      // print(e);
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

  static Future<void> sendNotifications(
      String servicetype, String signalId) async {
    final profileController = Get.find<ProfileList>();
    var url = Uri.parse('https://onesignal.com/api/v1/notifications');
    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ZWE1ODgwNDEtZGM5NC00NjRhLWE1YjEtZjg1ZGNmZDdjYjdk',
    };

    var body = jsonEncode({
      'app_id': "689405dc-4610-4a29-8268-4541a0f6299a",
      "target_channel": "push",
      "include_aliases": {
        "external_id": [signalId]
      },
      'contents': {
        'en':
            'New Session Alert: "You have a $servicetype request from ${profileController.profileDataList.first.name ?? 'NA'}. Respond now!'
      },
    });

    print("body=======$body");

    var response = await http.post(url, headers: headers, body: body);
    print("respons==========${response.body}");
    if (response.statusCode == 200) {
      print('Notification sent successfully!');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }
}
