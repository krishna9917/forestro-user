import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foreastro/Components/alertdilogbox.dart';
import 'package:foreastro/Components/enum/enum.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/controler/timecalculating_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:dio/dio.dart' as dio;

class ChatScreen extends StatefulWidget {
  final String id;
  final String userId;
  final String price;
  final String callID;
  final double totalMinutes;

  const ChatScreen(
      {super.key,
      required this.id,
      required this.userId,
      required this.totalMinutes,
      required this.price,
      required this.callID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketController socketController = Get.find<SocketController>();
  late SessionController sessionController;
  late DateTime startTime;
  late DateTime endTime;
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    sessionController = Get.put(SessionController());
    sessionController.newSession(RequestType.Chat);
    startTime = DateTime.now();

    _remainingSeconds = (widget.totalMinutes * 60).toInt();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          endChatSession();
        });
      }
    });
  }

  Future<void> endChatSession() async {
    sessionController.closeSession();
    endTime = DateTime.now();
    Duration duration = endTime.difference(startTime);

    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String totaltime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    await calculateprice(totaltime);

    socketController.closeSession(
      senderId: widget.userId,
      requestType: "chat",
      message: "User Cancel Can",
      data: {"userId": widget.userId},
    );
  }

  @override
  void dispose() {
    if (_remainingSeconds > 0) {
      endChatSession();
    }
    _timer.cancel();
    super.dispose();
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
        await Get.find<ProfileList>().fetchProfileData();
        // Get.back();
      }
    } catch (e) {
      // showToast(tosteError);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fluttertoast.showToast(msg: widget.id);
    return WillPopScope(
      onWillPop: () async {
        showAlertPopup(context,
            title: "Are you Sure",
            text: "Sure you close Chat Session",
            showCancelBtn: true,
            confirmBtnText: "Yes",
            type: QuickAlertType.warning, onConfirmBtnTap: () async {
          Get.offAll(const HomePage());
          await endChatSession();
          // setState(() {
          //   Get.find<ProfileList>().fetchProfileData();
          // });
        });
        return true;
      },
      child: ZIMKitMessageListPage(
        conversationID: widget.id,
        showPickFileButton: false,
        showMoreButton: false,
        theme: ThemeData(),
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
      ),
    );
  }
}
