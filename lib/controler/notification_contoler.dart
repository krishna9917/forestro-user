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
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          // Future.delayed(const Duration(seconds: 8), () {
          //   if (Navigator.canPop(context)) {
          //     Navigator.pop(
          //         context); // This ensures the dialog is closed after 30 seconds
          //   }
          // });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            elevation: 10, // Adds shadow for depth
            content: Container(
              padding: const EdgeInsets.all(16.0),
              height: 160, // Adjust height for better spacing
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50, // Slightly wider for better visual balance
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
                            color: AppColor.primary, // "5" in green color
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
                            color: AppColor.primary, // "5" in green color
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
                  // const CircularProgressIndicator(
                  //   color: Colors.orange,
                  //   strokeWidth: 3.0, // Thinner for a sleek look
                  // ),
                ],
              ),
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
}
