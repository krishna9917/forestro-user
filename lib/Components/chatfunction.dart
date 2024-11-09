import 'dart:async';

import 'package:foreastro/controler/timecalculating_controler.dart';
import 'package:get/get.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/Components/enum/enum.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:dio/dio.dart' as dio;

class SessionManager {
  final String userId;
  final String callID;
  final String price;
  late DateTime startTime;
  late DateTime endTime;
  late Timer _timer;
  late int _remainingSeconds;
  final Function onEndSession;
  final SocketController socketController = Get.find<SocketController>();
  final SessionController sessionController = Get.put(SessionController());

  SessionManager({
    required this.userId,
    required this.callID,
    required this.price,
    required double totalMinutes,
    required this.onEndSession,
  }) {
    _remainingSeconds = (totalMinutes * 60).toInt();
    sessionController.newSession(RequestType.Chat);
    startTime = DateTime.now();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        _timer.cancel();
        endSession();
      }
    });
  }

  Future<void> endSession() async {
    sessionController.closeSession();
    endTime = DateTime.now();
    Duration duration = endTime.difference(startTime);

    String totaltime = "${duration.inHours.toString().padLeft(2, '0')}:"
        "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

    await _calculatePrice(totaltime);

    socketController.closeSession(
      senderId: userId,
      requestType: "chat",
      message: "User Cancel Can",
      data: {"userId": userId},
    );

    onEndSession();
  }

  Future<void> _calculatePrice(String totaltime) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData({
          'communication_id': callID,
          'astro_per_min_price': price,
          'time': totaltime,
        }),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        Get.find<ProfileList>().fetchProfileData();
      }
    } catch (e) {
      // Handle error, e.g., show a toast or log error
    }
  }

  void dispose() {
    _timer.cancel();
  }
}
