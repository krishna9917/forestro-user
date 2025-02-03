import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/Splash/SplashScreen.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/videocall/const.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class AudioCall extends StatefulWidget {
  const AudioCall(
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
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  final SocketController socketController = Get.find<SocketController>();
  late DateTime startTime;
  late DateTime endTime;
  late Timer _timer;
  late int _remainingSeconds;
  bool isLoading = false;
  bool _isLoading = false;
  bool _isBeeping = false;
  Color countdownColor = Colors.white;
  AudioPlayer player = AudioPlayer();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    _remainingSeconds = (widget.totalMinutes * 60).toInt();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first == ConnectivityResult.none) {
        print("No internet connection detected. Ending call...");
        endChatSession();
        Get.offAll(const SplashScreen());
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 60) {
        setState(() {
          _remainingSeconds--;
          if (_remainingSeconds == 120 && !_isBeeping) {
            countdownColor =
                (_remainingSeconds <= 120) ? Colors.red : Colors.white;
            playBeepSound();
          }
        });
      } else if (_remainingSeconds == 60) {
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
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print('Audio play error: $e');
    }
  }

  Future<void> endChatSession() async {
    showToast("Ending session...");
    setState(() {
      isLoading = true;
    });

    endTime = DateTime.now();
    Duration duration = endTime.difference(startTime);

    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String totaltime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    await SharedPreferences.getInstance().then((prefs) {
      // Store the session
      String sessionData = jsonEncode({
        'call_id': widget.callID,
        'astro_per_min_price': widget.price,
        'totaltime': totaltime,
      });
      prefs.setString('active_call', sessionData).then((_) {
        // Retrieve and print the stored session
        String? storedSession = prefs.getString('active_call');
        print("Stored Session: $storedSession");
      });
    });

    await calculateprice(totaltime);
  }

  Future calculateprice(String totaltime) async {
    final prefs = await SharedPreferences.getInstance();

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
      print("datatttttttttt$data");
      if (data.statusCode == 201) {
        print("Data sent successfully");

        await Get.find<ProfileList>().fetchProfileData();
        setState(() {
          isLoading = false;
        });
        await prefs.remove('active_call');
        print("Cleared active_call from storage");
        Get.offAll(const HomePage());
      }
    } catch (e) {
      print(e);
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
    _connectivitySubscription?.cancel();

    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Stack(
        children: [
          ZegoUIKitPrebuiltCall(
            appID: MyConst.appId,
            appSign: MyConst.appSign,
            userID: widget.userid,
            userName: widget.username,
            callID: widget.callID,
            events: ZegoUIKitPrebuiltCallEvents(
              onCallEnd: (event, defaultAction) async {
                await endChatSession();
                Get.offAll(const HomePage());
              },
              onError: (error) {
                print("Error: $error");
              },
              user: ZegoCallUserEvents(
                onEnter: (user) {
                  showToast("${user.name} joined the call");
                },
                onLeave: (user) {
                  print("${user.name} left the call");
                },
              ),
            ),
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
          ),
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
          Center(child: Image.asset("assets/call_logo.jpg")),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
