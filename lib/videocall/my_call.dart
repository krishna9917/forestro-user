import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Screen/internetConnection/internet_connection_screen.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/videocall/const.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:foreastro/constants/zego_keys.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

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

class MyCallController extends GetxController {
  final String callID;
  final String userid;
  final String username;
  final String price;
  final double totalMinutes;

  MyCallController({
    required this.callID,
    required this.userid,
    required this.username,
    required this.price,
    required this.totalMinutes,
  });

  final SocketController socketController = Get.find<SocketController>();

  late DateTime startTime;
  late DateTime endTime;

  final RxInt remainingSeconds = 0.obs;
  final RxBool isLoading = true.obs;
  final Rx<Color> countdownColor = Colors.white.obs;

  bool _isBeeping = false;
  bool _timerStarted = false;

  Timer? _timer;
  Timer? _loadingSafetyTimer;
  final AudioPlayer _beepPlayer = AudioPlayer();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    startTime = DateTime.now();
    remainingSeconds.value = (totalMinutes * 60).toInt();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first == ConnectivityResult.none) {
        socketController.closeSession(
          senderId: userid,
          requestType: "video",
          message: "User Cancel Can",
          data: {
            "userId": userid,
            'communication_id': callID,
          },
        );
        endChatSession();
        Get.offAll(const NoInternetPage());
      }
    });

    // Safety: ensure loading overlay is dismissed if events are delayed on some devices
    _loadingSafetyTimer = Timer(const Duration(seconds: 8), () {
      if (isLoading.value) {
        isLoading.value = false;
      }
    });
  }

  void hideLoading() {
    if (isLoading.value) {
      isLoading.value = false;
    }
  }

  void startCountdownIfNeeded() {
    if (_timerStarted) return;
    _timerStarted = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = remainingSeconds.value;
      if (current > 60) {
        remainingSeconds.value = current - 1;
        if (remainingSeconds.value <= 120 && !_isBeeping) {
          countdownColor.value = Colors.red;
          _isBeeping = true;
          playBeepSound();
        }
      } else if (current == 60) {
        _timer?.cancel();
        _timerStarted = false;
        endChatSession();
      }
    });
  }

  Future<void> playBeepSound() async {
    try {
      await _beepPlayer.setAsset('assets/bg/beep.mp3');
      for (int i = 0; i < 3; i++) {
        await _beepPlayer.play();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print('Audio play error: $e');
    }
  }

  Future<void> endChatSession() async {
    endTime = DateTime.now();
    Duration duration = endTime.difference(startTime);

    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String totaltime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    await SharedPreferences.getInstance().then((prefs) {
      String sessionData = jsonEncode({
        'call_id': callID,
        'astro_per_min_price': price,
        'totaltime': totaltime,
      });
      prefs.setString('active_call', sessionData).then((_) {
        String? storedSession = prefs.getString('active_call');
        print("Stored Session: $storedSession");
      });
    });
    await _calculatePrice(totaltime);
  }

  Future _calculatePrice(String totaltime) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'communication_id': callID,
            'astro_per_min_price': price,
            'time': totaltime,
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        await prefs.remove('active_call');
        await Get.find<ProfileList>().fetchProfileData();
        Get.offAll(const WalletPage());
      } else {
        // no-op
      }
    } catch (e) {}
  }

  @override
  void onClose() {
    _timer?.cancel();
    _loadingSafetyTimer?.cancel();
    _beepPlayer.dispose();
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}

class _MyCallState extends State<MyCall> {
  late final MyCallController callController;

  @override
  void initState() {
    super.initState();
    callController = Get.put(
      MyCallController(
        callID: widget.callID,
        userid: widget.userid,
        username: widget.username,
        price: widget.price,
        totalMinutes: widget.totalMinutes,
      ),
      tag: widget.callID,
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    Get.delete<MyCallController>(tag: widget.callID);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure no white flash; keep a dark background behind video
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ZegoUIKitPrebuiltCall(
            appID: ZegoKeys.appID,
            appSign: ZegoKeys.appSign,
            userID: widget.userid,
            userName: widget.username.split(' ').first,
            callID: widget.callID,
            events: ZegoUIKitPrebuiltCallEvents(
              onError: (e) {
                print("astro error{$e}");
              },
              room: ZegoCallRoomEvents(onTokenExpired: (e) {
                print("astro error{$e}");
              }, onStateChanged: (e) {
                print("astro error{$e}");
                callController.hideLoading();
                callController.startCountdownIfNeeded();
              }),
              user: ZegoCallUserEvents(
                onEnter: (p) {
                  showToast("${p.name} join in call");
                  callController.hideLoading();
                  callController.startCountdownIfNeeded();
                },
              ),
              onCallEnd: (event, defaultAction) async {
                // Stop countdown immediately on call end
                await callController.endChatSession();
                // Get.offAll(const HomePage());

                // socketController.closeSession(
                //   senderId: widget.userid,
                //   requestType: "chat",
                //   message: "User Cancel Can",
                //   data: {
                //     "userId": widget.userid,
                //     'communication_id': widget.callID,
                //   },
                // );
              },
            ),
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..layout = ZegoLayout.pictureInPicture(
                isSmallViewDraggable: true,
                switchLargeOrSmallViewByClick: true,
              ),
          ),
          // Countdown badge - show only after loading overlay is hidden
          Obx(() => callController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.4),
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text(
                            "Please wait, we are connecting...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          Obx(() => callController.isLoading.value
              ? const SizedBox.shrink()
              : Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.all(20),
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
                          Obx(() => Text(
                                formatTime(callController.remainingSeconds.value),
                                style: GoogleFonts.inter(
                                  color: callController.countdownColor.value,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
