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
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MyCall extends StatefulWidget {
  const MyCall({
    super.key,
    required this.callID,
    required this.userid,
    required this.username,
    required this.price,
    required this.totalMinutes,
    this.isAstrologer = false, // <-- pass true if this widget represents the astrologer
  });

  final String callID;
  final String userid;
  final String username;
  final String price;
  final double totalMinutes;
  final bool isAstrologer;

  @override
  State<MyCall> createState() => _MyCallState();
}

class _MyCallState extends State<MyCall> {
  final SocketController socketController = Get.find<SocketController>();

  late DateTime startTime;
  late DateTime endTime;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isLoading = false;
  bool _isBeeping = false;
  Color countdownColor = Colors.white;

  // single audio player (used for beep)
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    startTime = DateTime.now();
    _remainingSeconds = (widget.totalMinutes * 60).toInt();

    // Connectivity listener: only once, in initState
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
          // when there's no connectivity (no active networks)
          if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
            debugPrint("No internet connection detected. Ending call...");
            if (widget.isAstrologer) {
              socketController.closeSession(
                senderId: widget.userid,
                requestType: "video",
                message: "No Internet",
                data: {
                  "userId": widget.userid,
                  "communication_id": widget.callID,
                },
              );
            }
            endChatSession();
            if (mounted) {
              Get.offAll(const NoInternetPage());
            }
          }
        });


    // Timer: counts down to 0 properly
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          // Start beeping when 120 seconds left (2 minutes)
          if (_remainingSeconds <= 120 && !_isBeeping) {
            _isBeeping = true;
            countdownColor = Colors.red;
            // fire-and-forget beep (we await inside but don't block UI)
            playBeepSound();
          }
        });
      } else {
        // time's up
        timer.cancel();
        setState(() {
          // call end session (it handles preferences and API)
          endChatSession();
        });
      }
    });
  }

  /// Play a short beep sound up to 3 times.
  /// Note: small, defensive implementation — retries setAsset only once.
  Future<void> playBeepSound() async {
    try {
      await _player.setAsset('assets/bg/beep.mp3');
      // play beep 3 times with short gap; ensure each play seeks to start
      for (int i = 0; i < 3; i++) {
        if (!mounted) return;
        await _player.seek(Duration.zero);
        await _player.play();
        // wait a short time; if beep is longer, this simply waits
        await Future.delayed(const Duration(milliseconds: 600));
      }
    } catch (e) {
      debugPrint('Audio play error: $e');
    }
  }

  Future<void> endChatSession() async {
    // guard: avoid multiple calls
    if (!mounted) {
      // still want to compute price even if not mounted? we'll still run
    }

    // set endTime and compute elapsed
    endTime = DateTime.now();
    final Duration duration = endTime.difference(startTime);

    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    final String totaltime = "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    try {
      final prefs = await SharedPreferences.getInstance();
      final String sessionData = jsonEncode({
        'call_id': widget.callID,
        'astro_per_min_price': widget.price,
        'totaltime': totaltime,
      });
      await prefs.setString('active_call', sessionData);
      debugPrint("Stored Session: $sessionData");
    } catch (e) {
      debugPrint("Failed to store active_call: $e");
    }

    await calculateprice(totaltime);
  }

  Future<void> calculateprice(String totaltime) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isLoading = true);

    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData({
          'communication_id': widget.callID,
          'astro_per_min_price': widget.price,
          'time': totaltime,
        }),
      );

      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        // success: remove stored active_call and refresh profile
        await prefs.remove('active_call');
        await Get.find<ProfileList>().fetchProfileData();
        if (mounted) {
          Get.offAll(const WalletPage());
        }
      } else {
        debugPrint(
            "Failed to complete compute price: ${data.statusCode} ${data.data}");
        // optional: showToast("Failed to complete profile. Please try again later.");
      }
    } catch (e) {
      debugPrint("calculateprice error: $e");
      // optional: showToast("Network error while calculating price.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _connectivitySubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
                showToast("${p.name} joined the call");
              },
              onLeave: (p) {
                showToast("${p.name} left the call");

                // If only one user left in room -> end session
                try {
                  if (ZegoUIKit().getAllUsers().length <= 1) {
                    endChatSession();
                  }
                } catch (e) {
                  debugPrint("Error checking users on leave: $e");
                }
              },
            ),
            onCallEnd: (event, defaultAction) async {
              // If astrologer hung up -> destroy session (caller should pass isAstrologer)
              if (widget.isAstrologer &&
                  event.reason == ZegoCallEndReason.localHangUp) {
                await endChatSession();
              } else {
                // default behavior for other cases
                defaultAction();
              }
            },
          ),
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            ..layout = ZegoLayout.pictureInPicture(
              isSmallViewDraggable: true,
              switchLargeOrSmallViewByClick: true,
            )

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
                    fontSize: 20,
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
