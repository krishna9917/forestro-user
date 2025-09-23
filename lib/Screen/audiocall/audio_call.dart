import 'package:flutter/material.dart';
import 'package:foreastro/controler/audio_call_controller.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:foreastro/constants/zego_keys.dart';

import '../../Utils/Quick.dart';

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
  late AudioCallController _audioCallController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    // Check if controller already exists and reset it if needed
    if (Get.isRegistered<AudioCallController>()) {
      _audioCallController = Get.find<AudioCallController>();
      // Only reset if call is already ended
      if (_audioCallController.isCallEnded) {
        _audioCallController.resetController();
      }
    } else {
      _audioCallController = Get.put(AudioCallController());
    }
    
    // Only initialize if not already initialized
    if (!_audioCallController.isInitialized) {
      _audioCallController.initializeCall(
        callID: widget.callID,
        userid: widget.userid,
        username: widget.username,
        price: widget.price,
        totalMinutes: widget.totalMinutes,
      );
    }
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      print("AudioCall disposing...");
      _isDisposed = true;

      // Clean up the call properly
      try {
        if (_audioCallController.isCallActive &&
            !_audioCallController.isCallEnded) {
          _audioCallController.handleZegoHangup();
        }
      } catch (e) {
        print('Error during dispose: $e');
      }

      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Safety check to ensure controller is initialized
      try {
        // If call is ended or disconnecting, show proper UI
        if (_audioCallController.isCallEnded ||
            _audioCallController.isDisconnecting) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  _audioCallController.isDisconnecting
                      ? "Ending call..."
                      : "Call ended",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SafeArea(
        top: true,
        child: Stack(
          children: [
            ZegoUIKitPrebuiltCall(
              key: ValueKey('audio_call_${widget.callID}'),
              appID: ZegoKeys.appID,
              appSign: ZegoKeys.appSign,
              userID: widget.userid,
              userName: widget.username.split(' ').first,
              callID: widget.callID,
              events: ZegoUIKitPrebuiltCallEvents(
                onCallEnd: (event, defaultAction) async {
                  if (_audioCallController.isCallEnded ||
                      _audioCallController.isDisconnecting) {
                    print(
                        "Call already ended or disconnecting, skipping onCallEnd");
                    return;
                  }

                  print("Call ended: ${event.toString()}");
                  // Handle our custom disconnection logic first
                  _audioCallController.handleZegoHangup();

                  // Execute the default action after a small delay to prevent conflicts
                  Future.delayed(const Duration(milliseconds: 100), () {
                    try {
                      defaultAction();
                    } catch (e) {
                      print('Error executing default action: $e');
                    }
                  });
                },
                onError: (error) {
                  print("Zego error: $error");
                  // Handle error gracefully
                  _audioCallController.handleCallError(error.toString());
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
            // Countdown timer - using GetBuilder instead of nested Obx
            _buildCountdownTimer(),
            Center(child: Image.asset("assets/call_logo.jpg")),
            // Loading indicator - using GetBuilder instead of nested Obx
            _buildLoadingIndicator(),
          ],
        ),
      );
      } catch (e) {
        // If controller is not initialized, show loading screen
        print('Controller not initialized yet: $e');
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      }
    });
  }

  Widget _buildCountdownTimer() {
    return GetBuilder<AudioCallController>(
      builder: (controller) => Positioned(
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
                controller.formatTime(controller.remainingSeconds),
                style: GoogleFonts.inter(
                  color: controller.countdownColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return GetBuilder<AudioCallController>(
      builder: (controller) => controller.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox.shrink(),
    );
  }
}
