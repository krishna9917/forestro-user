import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Components/alertdilogbox.dart';
import 'package:foreastro/Components/enum/enum.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Screen/internetConnection/internet_connection_screen.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/controler/timecalculating_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:dio/dio.dart' as dio;

class ChatScreen extends StatefulWidget {
  final String id;
  final String userId;
  final String price;
  final String callID;
  final double totalMinutes;

  const ChatScreen({
    super.key,
    required this.id,
    required this.userId,
    required this.totalMinutes,
    required this.price,
    required this.callID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final SocketController socketController = Get.put(SocketController());
  final SessionController sessionController = Get.put(SessionController());
  late DateTime startTime;
  late DateTime endTime;
  late Timer _timer;
  int _remainingSeconds = 0;
  bool isSessionEnded = false;
  bool _isBeeping = false;
  Color countdownColor = Colors.white;
  final AudioPlayer player = AudioPlayer();
  bool _isAppActive = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final profileController = Get.find<ProfileList>();
  bool _zimReady = false;

  @override
  void initState() {
    super.initState();
    chatzegocloud();
    sessionController.newSession(RequestType.Chat);
    startTime = DateTime.now();
    // Enforce only full, divisible minutes already calculated upstream
    _remainingSeconds = (widget.totalMinutes.floor() * 60).toInt();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first == ConnectivityResult.none) {
        print("No internet connection detected. Ending call...");
        endChatSession();
        Get.offAll(const NoInternetPage());
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
      } else if (_remainingSeconds == 60 && !isSessionEnded) {
        endChatSession();
        _timer.cancel();
      }
    });
  }

  Future<void> chatzegocloud() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) return;
    try {
      if (ZIMKit().currentUser != null) {
        try {
          await ZIMKit().disconnectUser();
        } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 200));
      }
      await ZIMKit().connectUser(
        id: "$userId-user",
        name: "User",
      );
    } catch (e) {
      // keep showing loader; ZIM will retry; avoid crash
      return;
    }
    if (mounted) {
      setState(() {
        _zimReady = true;
      });
    }
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
    if (isSessionEnded) return;
    isSessionEnded = true;

    sessionController.closeSession();
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

    await calculatePrice(totaltime);

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

  Future<void> calculatePrice(String totaltime) async {
    final prefs = await SharedPreferences.getInstance();
    print(totaltime);
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
      print("dataprice===========$data");
      if (data.statusCode == 201) {
        // socketController.closeSession(
        //   senderId: widget.userId,
        //   requestType: "chat",
        //   message: "User Cancel Can",
        //   data: {
        //     "userId": widget.userId,
        //     'communication_id': widget.callID,
        //   },
        // );
        await prefs.remove('active_call');
        await Get.find<ProfileList>().fetchProfileData();
      }
    } catch (e) {
      print('Error calculating price: $e');
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (ZIMKit().currentUser != null) {
      ZIMKit().disconnectUser();
    }
    if (!isSessionEnded) {
      endChatSession();
    }
    player.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (!isSessionEnded) {
        endChatSession();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_zimReady) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(
                "Please wait, we are connecting...",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        showAlertPopup(
          context,
          title: "Are you Sure",
          text: "Sure you close Chat Session",
          showCancelBtn: true,
          confirmBtnText: "Yes",
          type: QuickAlertType.warning,
          onConfirmBtnTap: () async {
            endChatSession();
            setState(() {
              isSessionEnded = true;
            });
            Get.offAll(const WalletPage());
          },
        );
        return false;
      },
      child: Stack(
        children: [
          ZIMKitMessageListPage(
              conversationType: ZIMConversationType.peer,
              conversationID: widget.id,
              showPickFileButton: false,
              showMoreButton: false,
              theme: ThemeData(),
              inputDecoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 10),
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
                      style: GoogleFonts.inter(
                        color: countdownColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
