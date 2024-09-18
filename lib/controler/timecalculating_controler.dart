import 'dart:async';
import 'package:foreastro/Components/enum/enum.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  DateTime? _startTime;
  DateTime? _endTime;
  var _sec = 0.obs;
  var _sessionType = RequestType.None.obs;
  Timer? _timer;

  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;
  int get sec => _sec.value;
  RequestType get sessionType => _sessionType.value;

  void newSession(RequestType type) {
    clearSession();
    _sessionType.value = type;
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _sec.value = _sec.value + 1;
    });
   
  }

  void closeSession() {
    _endTime = DateTime.now();
    _timer?.cancel();
  }

  void clearSession() {
    closeSession();
    _sec.value = 0;
    _endTime = null;
    _startTime = null;
    _timer = null;
    _sessionType.value = RequestType.None;
  }
}
