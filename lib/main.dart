import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Splash/SplashScreen.dart';
import 'package:foreastro/controler/bloc_controler.dart';
import 'package:foreastro/controler/call_histrory_controller.dart';
import 'package:foreastro/controler/celebrity_controler.dart';
import 'package:foreastro/controler/chat_history_contaroller.dart';
import 'package:foreastro/controler/horoscope_controler.dart';
import 'package:foreastro/controler/horoscope_kundali/chart_image_controler.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/listof_termination_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/signal_notification.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/controler/timecalculating_controler.dart';
import 'package:foreastro/firebase_options.dart';
import 'package:foreastro/theme/AppTheme.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main(List<String> args) async {
  /////////////////////////// chat function /////////////////////////////
  await ZIMKit().init(
      appID: 2007373594,
      appSign:
          '387754e51af7af0caf777a6a742a2d7bcfdf3ea1599131e1ff6cf5d1826649ae');
  ////////////////////////// Vedio Call //////////////////////////////////
  SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notification();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {}
  });
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    await prefs.setString('fcm_token', fcmToken);
  }
  print(fcmToken);

  initOneSignal();
  // OneSignal.Debug.setLogLevel(OSLogLevel.debug);
  // OneSignal.initialize("689405dc-4610-4a29-8268-4541a0f6299a");
  // OneSignal.Notifications.requestPermission(true);
  runApp(const InitApp());
}

Future<void> initOneSignal() async {
   String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 + random.nextInt(90000);
    return '$randomNumber';
  }

  String externalIdg = generateRandomOrderId();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("689405dc-4610-4a29-8268-4541a0f6299a");
  OneSignal.Notifications.requestPermission(true);
  var externalId = externalIdg;
  OneSignal.login(externalId);

  await Future.delayed(Duration(seconds: 1));
  _handleGetExternalId();
  // _handleLogin();
}

// void _handleGetExternalId() async {
//   // final status = await OneSignal.shared.getDeviceState();
//   var externalId = await OneSignal.User.getOnesignalId();
//   print('External ID: $externalId');
//   // final playerId = status?.userId;
//   // if (playerId != null) {
//   //   print('ID: $playerId');
//   // } else {
//   //   print('User ID is null; OneSignal may not be initialized yet.');
//   // }
// }
void _handleGetExternalId() async {
  var externalId = await OneSignal.User.getExternalId();
  print('External ID: $externalId');
  if (externalId != null) {
    print('IDSIGNAL: $externalId');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('externalId', externalId ?? '');
    await NotificationRepo.sendsignal();
  }
}

void _handleLogin() {
  String? _externalUserId = "your_custom_external_id";
  print("Setting external user ID");
  if (_externalUserId == null) return;
  OneSignal.login(_externalUserId);
  OneSignal.User.addAlias("fb_id", "1341524");
  print('External ID: $_externalUserId');
}

// void _handleGetOnesignalId() async {
//   OneSignal.User.pushSubscription.addObserver((state) {
//     print("========abcd=======");
//     print(OneSignal.User.pushSubscription.optedIn);
//     print(OneSignal.User.pushSubscription.id);
//     print(OneSignal.User.pushSubscription.token);
//     print(state.current.jsonRepresentation());
//   });
//   var onesignalId = await OneSignal.User.pushSubscription.id;
//   print('OneSignal ID: $onesignalId');
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('onesignal_id', onesignalId ?? '');
// }

Future<void> Notification() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(builder: (context, orientation, screenSize) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
        initialBinding: BindingsBuilder(() {
          Get.lazyPut<ProfileList>(() => ProfileList());
          Get.lazyPut<BlocList>(() => BlocList());
          Get.lazyPut<GetAstrologerProfile>(() => GetAstrologerProfile());
          Get.lazyPut<SocketController>(() => SocketController());
          Get.lazyPut<CelibrityList>(() => CelibrityList());
          Get.lazyPut<SessionController>(() => SessionController());
          Get.lazyPut<ClientSays>(() => ClientSays());
          Get.lazyPut<ChatHistory>(() => ChatHistory());
          Get.lazyPut<CallHistory>(() => CallHistory());
          Get.lazyPut<HoroscopeControler>(() => HoroscopeControler());
          Get.lazyPut<CartImageControler>(() => CartImageControler());
          Get.lazyPut<KundaliController>(() => KundaliController());
        }),
        // home: HomePage(),
      );
    });
  }
}
