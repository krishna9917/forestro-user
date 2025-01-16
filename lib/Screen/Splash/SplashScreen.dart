import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/controler/baner_controler.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final profileController = Get.find<ProfileList>();

  @override
  void initState() {
    super.initState();
    Get.put(BannerList()).fetchProfileData();
    // Get.find<BannerList>().fetchProfileData();
    chatzegocloud();
    Get.find<ProfileList>().fetchProfileData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      Get.find<GetAstrologerProfile>().astroData();
    });

    checkTokenAndNavigate();
    requestPermissions();
  }

  Future<void> chatzegocloud() async {
    await ZIMKit().init(
        appID: 2007373594,
        appSign:
            '387754e51af7af0caf777a6a742a2d7bcfdf3ea1599131e1ff6cf5d1826649ae');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');

    if (user_id == null) {
      print('User ID not found in SharedPreferences');
      return;
    }

    String profile = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.profileImg
        : '';

    String name = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.name
        : '';

    if (name.isEmpty) {
      print("Name not found");
      return;
    }

    print("name=======$name $user_id $profile  --   $user_id-user");

    await ZIMKit().connectUser(
      id: "$user_id-user",
      name: name,
      avatarUrl: profile,
    );
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  Future<void> checkTokenAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve stored values
    final token = prefs.getString('token');
    final isProfileCreated = prefs.getString('is_profile_created');

    print("Token: $token");
    print("Is Profile Created: $isProfileCreated");

    if (token == null || token.isEmpty) {
      await prefs.clear();
      await _deleteCacheDir();
      await _deleteAppDir();

      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => const LoginScreen());
      });
      return;
    }

    // Check if profile is created
    if (isProfileCreated == null || isProfileCreated == "false") {
      await prefs.clear();
      await _deleteCacheDir();
      await _deleteAppDir();
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => const LoginScreen());
      });
      return;
    }

    // Navigate to HomePage if everything is valid
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const HomePage());
    });
  }

  Future<void> _deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              SpinAstro(controller: _controller),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Image.asset(Assets.logoAstroPng, height: 30.h),
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      child: const Text("Powered by Fore Astro"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpinAstro extends StatelessWidget {
  const SpinAstro({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2.0 * 3.14,
            child: Image.asset(
              "assets/spiner.png",
              width: scrWeight(context) + 3000,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
