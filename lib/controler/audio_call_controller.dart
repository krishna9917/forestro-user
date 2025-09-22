import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import '../core/api/ApiRequest.dart';
import '../controler/profile_controler.dart';
import '../controler/soket_controler.dart';
import '../Utils/Quick.dart';
import '../Screen/Pages/WalletPage.dart';
import '../Screen/internetConnection/internet_connection_screen.dart';

class AudioCallController extends GetxController {
  // Observable variables
  final RxInt _remainingSeconds = 0.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isDisconnecting = false.obs;
  final RxBool _isBeeping = false.obs;
  final Rx<Color> _countdownColor = Colors.white.obs;
  final RxBool _isCallActive = true.obs;
  final RxBool _isCallEnded = false.obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isNavigating = false.obs;

  // Private variables
  late DateTime _startTime;
  late DateTime _endTime;
  Timer? _timer;
  Timer? _callTimeoutTimer;
  AudioPlayer? _player;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Call parameters
  late String _callID;
  late String _userid;
  late String _username;
  late String _price;
  late double _totalMinutes;

  // Getters
  int get remainingSeconds => _remainingSeconds.value;

  bool get isLoading => _isLoading.value;

  bool get isDisconnecting => _isDisconnecting.value;

  bool get isBeeping => _isBeeping.value;

  Color get countdownColor => _countdownColor.value;

  bool get isCallActive => _isCallActive.value;

  bool get isCallEnded => _isCallEnded.value;

  bool get isInitialized => _isInitialized.value;

  bool get isNavigating => _isNavigating.value;

  // Initialize call parameters
  void initializeCall({
    required String callID,
    required String userid,
    required String username,
    required String price,
    required double totalMinutes,
  }) {
    // Prevent multiple initialization
    if (_isInitialized.value && !_isCallEnded.value) {
      print("Audio call already initialized and active, skipping...");
      return;
    }

    print("Initializing audio call...");
    print("Call ID: $callID, User ID: $userid, Total Minutes: $totalMinutes");

    _callID = callID;
    _userid = userid;
    _username = username;
    _price = price;
    _totalMinutes = totalMinutes;

    _startTime = DateTime.now();
    _remainingSeconds.value = (totalMinutes * 60).toInt();
    _isCallActive.value = true;
    _isCallEnded.value = false;
    _isDisconnecting.value = false;
    _isInitialized.value = true;

    _initializeAudioPlayer();
    _startCountdownTimer();
    _setupConnectivityListener();
    _startCallTimeoutTimer();

    print("Audio call initialized successfully");
  }

  void _initializeAudioPlayer() {
    _player = AudioPlayer();
  }

  void _startCallTimeoutTimer() {
    // Set a maximum call duration timeout (e.g., 2 hours)
    _callTimeoutTimer?.cancel();
    _callTimeoutTimer = Timer(const Duration(hours: 2), () {
      if (_isCallActive.value && !_isCallEnded.value) {
        print("Call timeout reached, ending call...");
        handleZegoHangup();
      }
    });
  }

  void _startCountdownTimer() {
    _timer?.cancel(); // Cancel any existing timer

    print("Starting countdown timer with ${_remainingSeconds.value} seconds");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 60) {
        _remainingSeconds.value--;
        print("Countdown: ${_remainingSeconds.value} seconds remaining");

        // Update UI for countdown timer
        update();

        // Change color and play beep when 2 minutes remaining
        if (_remainingSeconds.value == 120 && !_isBeeping.value) {
          _countdownColor.value = Colors.red;
          _playBeepSound();
          update(); // Update UI for color change
        }
      } else if (_remainingSeconds.value == 60) {
        print("Call time limit reached, ending call...");
        _timer?.cancel();
        _endCallSession();
      }
    });
  }

  Future<void> _playBeepSound() async {
    if (_player == null) return;

    try {
      _isBeeping.value = true;
      update(); // Update UI for beeping state
      await _player!.setAsset('assets/bg/beep.mp3');

      for (int i = 0; i < 3; i++) {
        await _player!.play();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print('Audio play error: $e');
    } finally {
      _isBeeping.value = false;
      update(); // Update UI for beeping state
    }
  }

  // Immediate disconnection method
  Future<void> disconnectCall() async {
    if (_isDisconnecting.value || _isCallEnded.value)
      return; // Prevent multiple calls

    print("Disconnecting call...");
    _isDisconnecting.value = true;
    _isCallActive.value = false;
    _isCallEnded.value = true;

    // Cancel timer immediately
    _timer?.cancel();

    // Close socket connection immediately
    try {
      final socketController = Get.find<SocketController>();
      socketController.closeSession(
        senderId: _userid,
        requestType: "audio",
        message: "User Disconnected",
        data: {
          "userId": _userid,
          'communication_id': _callID,
        },
      );
    } catch (e) {
      print('Error closing socket: $e');
    }

    // End session in background
    _endCallSession();
  }

  // Force immediate disconnection (for button press)
  void forceDisconnect() {
    if (_isDisconnecting.value || _isCallEnded.value)
      return; // Prevent multiple calls

    print("Force disconnecting call...");
    _isDisconnecting.value = true;
    _isCallActive.value = false;
    _isCallEnded.value = true;
    _timer?.cancel();

    // Close socket immediately
    try {
      final socketController = Get.find<SocketController>();
      socketController.closeSession(
        senderId: _userid,
        requestType: "audio",
        message: "User Force Disconnected",
        data: {
          "userId": _userid,
          'communication_id': _callID,
        },
      );
    } catch (e) {
      print('Error force closing socket: $e');
    }

    // Navigate immediately
    _navigateToWallet();
  }

  // Handle Zego call hangup
  void handleZegoHangup() {
    if (_isDisconnecting.value || _isCallEnded.value) {
      print("Call already disconnecting or ended, skipping hangup...");
      return; // Prevent multiple calls
    }

    print("Handling Zego hangup...");
    _isDisconnecting.value = true;
    _isCallActive.value = false;
    _isCallEnded.value = true;
    _timer?.cancel();
    _callTimeoutTimer?.cancel();

    // Close socket with a small delay to prevent conflicts
    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        final socketController = Get.find<SocketController>();
        socketController.closeSession(
          senderId: _userid,
          requestType: "audio",
          message: "User Hung Up",
          data: {
            "userId": _userid,
            'communication_id': _callID,
          },
        );
        print("Socket closed successfully");
      } catch (e) {
        print('Error closing socket on hangup: $e');
      }
    });

    // End the session first, then navigate
    _endCallSessionAndNavigate();
  }

  // End session and navigate properly
  Future<void> _endCallSessionAndNavigate() async {
    print("Ending call session and navigating...");

    try {
      _endTime = DateTime.now();
      Duration duration = _endTime.difference(_startTime);

      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;

      String totaltime = "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";

      print("Call duration: $totaltime");

      // Store session data
      await _storeSessionData(totaltime);

      // Calculate price and navigate
      await _calculatePriceAndNavigate(totaltime);
    } catch (e) {
      print('Error ending session: $e');
      // Navigate even if there's an error
      _navigateToWallet();
    }
  }

  // Helper method to navigate to wallet page
  void _navigateToWallet() {
    if (_isNavigating.value) {
      print("Navigation already in progress, skipping...");
      return;
    }

    if (_isDisconnecting.value && _isCallEnded.value) {
      _isNavigating.value = true;
      print("Navigating to WalletPage...");
      // Use a small delay to ensure UI updates are processed
      Future.delayed(const Duration(milliseconds: 200), () {
        try {
          Get.offAll(() => const WalletPage());
        } catch (e) {
          print('Navigation error: $e');
        }
      });
    }
  }

  Future<void> _endCallSession() async {
    if (!_isCallActive.value || _isCallEnded.value)
      return; // Prevent multiple calls

    _isCallActive.value = false;
    _isCallEnded.value = true;
    _isLoading.value = true;
    update(); // Update UI for loading state

    try {
      _endTime = DateTime.now();
      Duration duration = _endTime.difference(_startTime);

      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;

      String totaltime = "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";

      print("Call duration: $totaltime");

      // Store session data
      await _storeSessionData(totaltime);

      // Calculate price
      await _calculatePrice(totaltime);
    } catch (e) {
      print('Error ending session: $e');
    } finally {
      _isLoading.value = false;
      update(); // Update UI for loading state
    }
  }

  Future<void> _storeSessionData(String totaltime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String sessionData = jsonEncode({
        'call_id': _callID,
        'astro_per_min_price': _price,
        'totaltime': totaltime,
      });
      await prefs.setString('active_call', sessionData);
      print("Stored Session: $sessionData");
    } catch (e) {
      print('Error storing session: $e');
    }
  }

  Future<void> _calculatePrice(String totaltime) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Parse call duration for logging
      Duration callDuration = _endTime.difference(_startTime);
      int totalSeconds = callDuration.inSeconds;

      print("Call duration: $totalSeconds seconds, Total time: $totaltime");

      // Always call the API with actual call time - let server handle charging logic
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData({
          'communication_id': _callID,
          'astro_per_min_price': _price,
          'time': totaltime,
          'call_duration_seconds': totalSeconds.toString(),
          // Add actual seconds for server-side processing
        }),
      );

      dio.Response data = await apiRequest.send();
      print("Price calculation response: $data");

      if (data.statusCode == 201) {
        print("Communication charges API called successfully");
        await Get.find<ProfileList>().fetchProfileData();
        await prefs.remove('active_call');
        print("Cleared active_call from storage");

        // Navigate to wallet page
        _navigateToWallet();
      } else {
        print("API call failed with status: ${data.statusCode}");
        // Still navigate even if API fails
        _navigateToWallet();
      }
    } catch (e) {
      print('Error calculating price: $e');
      // Navigate even if there's an error
      _navigateToWallet();
    }
  }

  // Calculate price and navigate with proper session ending
  Future<void> _calculatePriceAndNavigate(String totaltime) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Parse call duration for logging
      Duration callDuration = _endTime.difference(_startTime);
      int totalSeconds = callDuration.inSeconds;

      print("Call duration: $totalSeconds seconds, Total time: $totaltime");

      // Always call the API with actual call time - let server handle charging logic
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData({
          'communication_id': _callID,
          'astro_per_min_price': _price,
          'time': totaltime,
          'call_duration_seconds': totalSeconds.toString(),
          // Add actual seconds for server-side processing
        }),
      );

      dio.Response data = await apiRequest.send();
      print("Price calculation response: $data");

      if (data.statusCode == 201) {
        print("Communication charges API called successfully");
        await Get.find<ProfileList>().fetchProfileData();
        await prefs.remove('active_call');
        print("Cleared active_call from storage");
      } else {
        print("API call failed with status: ${data.statusCode}");
      }
    } catch (e) {
      print('Error calculating price: $e');
    } finally {
      // Always navigate after price calculation (success or failure)
      _navigateToWallet();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first == ConnectivityResult.none) {
        print("No internet connection detected. Ending call...");
        _handleNoInternet();
      }
    });
  }

  void _handleNoInternet() {
    if (_isCallEnded.value) return; // Prevent multiple calls

    print("No internet connection detected, ending call...");
    _isCallActive.value = false;
    _isCallEnded.value = true;
    _timer?.cancel();
    _callTimeoutTimer?.cancel();

    try {
      final socketController = Get.find<SocketController>();
      socketController.closeSession(
        senderId: _userid,
        requestType: "audio",
        message: "User Cancel Can",
        data: {
          "userId": _userid,
          'communication_id': _callID,
        },
      );
    } catch (e) {
      print('Error handling no internet: $e');
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      Get.offAll(const NoInternetPage());
    });
  }

  // Handle call errors gracefully
  void handleCallError(String error) {
    if (_isCallEnded.value || _isDisconnecting.value) return;

    print("Call error occurred: $error");
    _isCallActive.value = false;
    _isCallEnded.value = true;
    _timer?.cancel();
    _callTimeoutTimer?.cancel();

    try {
      final socketController = Get.find<SocketController>();
      socketController.closeSession(
        senderId: _userid,
        requestType: "audio",
        message: "Call Error: $error",
        data: {
          "userId": _userid,
          'communication_id': _callID,
        },
      );
    } catch (e) {
      print('Error handling call error: $e');
    }

    // Show error message and navigate
    showToast("Call error: $error");
    _navigateToWallet();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Reset controller state for reuse
  void resetController() {
    print("Resetting audio call controller...");
    _timer?.cancel();
    _callTimeoutTimer?.cancel();
    _connectivitySubscription?.cancel();
    _player?.dispose();

    // Use a microtask to avoid setState during build
    Future.microtask(() {
      _remainingSeconds.value = 0;
      _isLoading.value = false;
      _isDisconnecting.value = false;
      _isBeeping.value = false;
      _countdownColor.value = Colors.white;
      _isCallActive.value = true;
      _isCallEnded.value = false;
      _isInitialized.value = false;
      _isNavigating.value = false;
    });

    _timer = null;
    _callTimeoutTimer = null;
    _player = null;
    _connectivitySubscription = null;
  }

  @override
  void onClose() {
    print("AudioCallController onClose called");
    _timer?.cancel();
    _callTimeoutTimer?.cancel();
    _connectivitySubscription?.cancel();
    _player?.dispose();
    super.onClose();
  }
}
