import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static Future<IO.Socket> initSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IO.Socket socket = IO.io('http://143.244.130.192:4000/', {
      'transports': ['websocket'],
      'extraHeaders': {
        'userId': prefs.getString("user_id").toString(),
        'type': 'user',
        'token': prefs.getString("token").toString(),
      }
    });

    socket.onConnect((data) => {print("connect")});
    socket.onDisconnect((data) => {print("diconnect")});
    socket.on(
      "error",
      (data) => Logger().e(
        data,
        error: "Socket Error",
        time: DateTime.now(),
        stackTrace: StackTrace.empty,
      ),
    );
    socket.onError(
      (data) => Logger().e(
        data,
        error: "Socket Error",
        time: DateTime.now(),
        stackTrace: StackTrace.empty,
      ),
    );
    return socket;
  }
}
