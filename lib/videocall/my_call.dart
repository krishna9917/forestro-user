import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/videocall/const.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MyCall extends StatefulWidget {
  const MyCall(
      {super.key,
      required this.callID,
      required this.userid,
      required this.username,
      required this.price,
      required this.totalMinutes});
  final String callID;
  final String userid;
  final String username;
  final String price;
  final double totalMinutes;

  @override
  State<MyCall> createState() => _MyCallState();
}

class _MyCallState extends State<MyCall> {
  late DateTime startTime;
  late DateTime endTime;
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();

    startTime = DateTime.now();

    _remainingSeconds = (widget.totalMinutes * 60).toInt();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        endChatSession();
      }
    });
  }

  void endChatSession() {
    endTime = DateTime.now();
    Duration duration = endTime.difference(startTime);

    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String totaltime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    calculateprice(totaltime);
  }

  Future calculateprice(String totaltime) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'communication_id': widget.callID,
            'astro_per_min_price': widget.price,
            'time': totaltime,
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        // Get.back();
        setState(() {
          Get.find<ProfileList>().fetchProfileData();
        });
      } else {
        showToast("Failed to complete profile. Please try again later.");
      }
    } catch (e) {
      // showToast(tosteError);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: MyConst.appId,
        appSign: MyConst.appSign,
        userID: widget.userid,
        userName: widget.username,
        callID: widget.callID,
        events: ZegoUIKitPrebuiltCallEvents(
          user: ZegoCallUserEvents(
            onEnter: (p) {
              showToast("${p.name} join in call");
            },
          ),
          onCallEnd: (event, defaultAction) {
            endChatSession();
            showToast("Call End");

            // setState(() {
            //   Get.find<ProfileList>().fetchProfileData();
            // });
          },
        ),
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..layout = ZegoLayout.pictureInPicture(
            isSmallViewDraggable: true,
            switchLargeOrSmallViewByClick: true,
          ));
  }
}
