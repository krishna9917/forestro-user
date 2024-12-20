import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/videocall/const.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:just_audio/just_audio.dart';
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
  bool _isLoading = false;
  bool _isBeeping = false;
  Color countdownColor = Colors.white;
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

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
        if (_timer.isActive) {
          _timer.cancel();
        }
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
    setState(() {
      _isLoading = true;
    });

    endTime = DateTime.now();
    Duration duration = endTime.difference(startTime);

    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String totaltime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    try {
      await calculateprice(totaltime);

      Get.offAll(const WalletPage());
    } catch (e) {
      // showToast("Something went wrong. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    // await calculateprice(totaltime);
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
      } else {
        showToast("Failed to complete profile. Please try again later.");
      }
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ZegoUIKitPrebuiltCall(
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
            onCallEnd: (event, defaultAction) async {
              Get.offAll(const HomePage());
              await endChatSession();
            },
          ),
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            ..layout = ZegoLayout.pictureInPicture(
              isSmallViewDraggable: true,
              switchLargeOrSmallViewByClick: true,
            ),
        ),
        // Countdown Timer Positioned on the Right Corner
        Positioned(
          top: 30,
          left: 10,
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

        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
