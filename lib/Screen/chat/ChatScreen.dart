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
import 'package:just_audio/just_audio.dart';
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
  bool isSessionEnded = false;
  bool _isLoading = false;
  bool _isBeeping = false;
  Color countdownColor = Colors.white;
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    sessionController = Get.put(SessionController());
    sessionController.newSession(RequestType.Chat);
    startTime = DateTime.now();

    _remainingSeconds = (widget.totalMinutes * 60).toInt();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
          if (_remainingSeconds == 120 && !_isBeeping) {
            // startBeeping();
            countdownColor =
                (_remainingSeconds <= 120) ? Colors.red : Colors.white;
            playBeepSound();
          }
        });
      } else {
        _timer.cancel();
        setState(() {
          endChatSession();
        });
      }
    });
  }

  Future<void> playBeepSound() async {
    try {
      await player.setAsset('assets/bg/beep.mp3');
      for (int i = 0; i < 3; i++) {
        await player.play();
        await Future.delayed(Duration(milliseconds: 500));
      }
    } catch (e) {
      print('Audio play error: $e');
    }
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
      data: {
        "userId": widget.userId,
        'communication_id': widget.callID,
      },
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_remainingSeconds > 0 && !isSessionEnded) {
      endChatSession();
    }
    _audioPlayer.dispose();
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
          setState(() {
            isSessionEnded = true;
          });
          Get.offAll(const HomePage());
          await endChatSession();
          // setState(() {
          //   Get.find<ProfileList>().fetchProfileData();
          // });
        });
        return true;
      },
      child: Stack(
        children: [
          ZIMKitMessageListPage(
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
          Positioned(
            top: 35,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 125, 122, 122),
                    Color.fromARGB(151, 234, 231, 227)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatTime(_remainingSeconds),
                    style: TextStyle(
                      color: countdownColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
