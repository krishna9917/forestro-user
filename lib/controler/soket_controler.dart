import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';
import 'package:foreastro/Screen/Splash/SplashScreen.dart';
import 'package:foreastro/Screen/audiocall/audio_call.dart';
import 'package:foreastro/Screen/chat/ChatScreen.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/baner_controler.dart';
import 'package:foreastro/controler/celebrity_controler.dart';
import 'package:foreastro/controler/listof_termination_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/soket_services.dart';
import 'package:foreastro/videocall/my_call.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  final _socket = Rxn<IO.Socket>();
  IO.Socket? get socket => _socket.value;
  bool? get socketConnected => _socket.value?.connected;

  var liveAstrologers = <Map<String, dynamic>>[].obs;
  Map? _workdata;
  bool _iAmWorkScreen = false;
  bool get iAmWorkScreen => _iAmWorkScreen;
  Map? get workdata => _workdata;

  Future<IO.Socket?> initSocketConnection() async {
    _socket.value = await SocketService.initSocket();
    addSocketListeners();
    update();
    return _socket.value;
  }

  void addSocketListeners() {
    socket?.on('request', (data) {});
    socket?.on("wettingDecline", (data) {
      Fluttertoast.showToast(msg: "Request Cancel");
      Get.back();
    });

    socket?.on('accepted', (data) {
      print(data);
      try {
        var profileimage = data['data']['astroData']['profile_img'] ??
            "https://cdn-icons-png.flaticon.com/512/149/149071.png";
        var name = data['data']['astroData']['name'];
        print("hhh==============>>>>>");
        Get.dialog(
          AlertDialog(
            contentPadding:
                const EdgeInsets.all(20), // Add padding for better appearance
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileimage),
                  radius: 30,
                ),
                const SizedBox(height: 16),
                Text(
                  "Are you sure you want to start ${data['requestType'] == 'audio' || data['requestType'] == 'video' ? 'a ${data['requestType']} call' : 'a ${data['requestType']}'} with this astrologer, $name?",
                  style: const TextStyle(
                    fontSize: 14, // Updated font size for better readability
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.only(bottom: 10),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
                onPressed: () {
                  Fluttertoast.showToast(msg: "Processing");
                  socket?.emit('startSession', {
                    'userId': data['userId'],
                    'userType': data['userType'],
                    'requestType': data['requestType'],
                    'data': data,
                  });
                  Get.back();
                  // Get.off(const ExploreAstroPage());
                },
                child: const Text("Yes"),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
                onPressed: () {
                  socket?.emit('decline', {
                    'userId': data['userId'],
                    'userType': data['userType'],
                    'requestType': data['requestType'],
                    'data': data,
                  });
                  Get.back();
                  // Get.off(const ExploreAstroPage());
                },
                child: const Text("No"),
              ),
            ],
          ),
        );
      } catch (e) {
        print(e);
      }
    });

    socket?.on('openSession', (data) {
      if (data['requestType'] == 'chat') {
        final profileController = Get.find<ProfileList>();
        var wallet = profileController.profileDataList.first.wallet ?? 'NA';
        var price = data['data']['astroData']['chat_charges_per_min'];
        double walletAmount = double.tryParse(wallet) ?? 0;
        double pricePerMin = double.tryParse(price.toString()) ?? 0;
        if (walletAmount > 0 && pricePerMin > 0) {
          var totalMinutes = walletAmount / pricePerMin;
          Get.off(ChatScreen(
            id: data['userId'] + "-astro",
            userId: data['userId'],
            callID: data['data']['communication_id'].toString(),
            price: price,
            totalMinutes: totalMinutes,
          ));
        }
      } else if (data['requestType'] == 'video') {
        final profileController = Get.find<ProfileList>();
        var wallet = profileController.profileDataList.first.wallet ?? 'NA';

        var price = data['data']['astroData']['video_charges_per_min'];
        print("price=========$price");

        double walletAmount = double.tryParse(wallet) ?? 0;
        double pricePerMin = double.tryParse(price.toString()) ?? 0;

        // Calculate total minutes
        if (walletAmount > 0 && pricePerMin > 0) {
          var totalMinutes = walletAmount / pricePerMin;
          Get.off(
            MyCall(
              userid: data['userId'].toString(),
              username: data['data']['name'].toString(),
              callID: data['data']['communication_id'].toString(),
              price: price,
              totalMinutes: totalMinutes,
            ),
          );
        }
      } else if (data['requestType'] == 'audio') {
        final profileController = Get.find<ProfileList>();
        var wallet = profileController.profileDataList.first.wallet ?? 'NA';
        var price = data['data']['astroData']['call_charges_per_min'];
        double walletAmount = double.tryParse(wallet) ?? 0;
        double pricePerMin = double.tryParse(price.toString()) ?? 0;

        // Calculate total minutes
        if (walletAmount > 0 && pricePerMin > 0) {
          var totalMinutes = walletAmount / pricePerMin;
          Get.off(
            AudioCall(
              userid: data['userId'].toString(),
              username: data['data']['name'].toString(),
              callID: data['data']['communication_id'].toString(),
              price: price,
              totalMinutes: totalMinutes,
            ),
          );
        }
      } else {
        _iAmWorkScreen = false;
      }
      // Fluttertoast.showToast(
      //   msg: "accepted ${data['requestType']} successfully!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
    });

    socket?.on('rejected', (data) {
      Fluttertoast.showToast(
          msg: "Your ${data['requestType']} is reject from astrologer");
    });

    socket?.on('busy', (data) {
      showToast("User busy");
    });

    socket?.on("userOffline", (data) {
      showToast("userOffline");
    });

    socket?.on("closeSession", (data) {
      onWorkEnd();
      Get.back();

      // Get.offAll(const ExploreAstroPage());
    });

    socket?.on('liveFeeds', (data) {
      liveAstrologers.assignAll(List<Map<String, dynamic>>.from(data));
    });
  }

  void sendNewRequest(
      {required String userId, required String requestType, required data}) {
    socket?.emit('newRequest', {
      'userId': userId,
      'userType': 'astro',
      'requestType': requestType,
      'data': data
    });
  }

  void closeSession({
    required String senderId,
    required String requestType,
    required String message,
    required Map data,
  }) {
    socket?.emit('endSession', {
      'userId': senderId,
      'userType': 'astro',
      'requestType': requestType,
      'data': data,
      'message': message,
    });
    if (data['requestType'] == "chat") {
      Get.back();
    }
    Get.back();
  }

  void onWorkEnd() {
    _iAmWorkScreen = false;
    _workdata = null;
    update();
  }

  Future<void> logoutUser() async {
    socket?.disconnect();
    socket?.destroy();
    socket?.dispose();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // showToast('Logout successfully!');

    await GoogleSignIn().signOut();
    // final profileController = Get.find<ProfileList>();
    // final bannerController = Get.put(BannerList());
    // final celebrity = Get.put(CelibrityList());
    // final clientsays = Get.put(ClientSays());
    // bannerController.dataList.clear();
    // profileController.profileDataList.clear();
    // clientsays.clientsaysDataList.clear();
    // celebrity.celibrityDataList.clear();
    Get.offAll(() => const LoginScreen());
    showToast('Logout successfully!');
  }
}
