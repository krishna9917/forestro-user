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
import 'package:foreastro/controler/pendingrequest_controller.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/controler/timecalculating_controler.dart';
import 'package:foreastro/firebase_options.dart';
import 'package:foreastro/theme/AppTheme.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notification();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {}
  });
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken);
  }
  print(fcmToken);
  initOneSignal();
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

  await Future.delayed(const Duration(seconds: 1));
  _handleGetExternalId();
}

void _handleGetExternalId() async {
  var externalId = await OneSignal.User.getExternalId();
  print('External ID: $externalId');
  if (externalId != null) {
    print('IDSIGNAL: $externalId');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('externalId', externalId ?? '');
  }
}

void _handleLogin() {
  String? _externalUserId = "your_custom_external_id";
  print("Setting external user ID ");
  if (_externalUserId == null) return;
  OneSignal.login(_externalUserId);
  OneSignal.User.addAlias("fb_id", "1341524");
  print('External ID: $_externalUserId');
}

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
          Get.lazyPut<PendingRequest>(() => PendingRequest());
        }),
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkForUpdate(context);
          });
          return child!;
        },
        // home: HomePage(),
      );
    });
  }

  Future<void> _checkForUpdate(BuildContext context) async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
    }
  }
}
