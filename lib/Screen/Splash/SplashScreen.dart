import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/commingsoon/commingsoon.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/extensions/build_context.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    Get.find<ProfileList>().fetchProfileData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    Timer.periodic(Duration(seconds: 5), (timer) {
      Get.find<GetAstrologerProfile>().astroData();
    });
    checkTokenAndNavigate();
   
  }

  

  Future<void> checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? is_profile_created = prefs.getString('is_profile_created');
    print("manjulika $is_profile_created");
    if (token != null && token.isNotEmpty) {
      if (is_profile_created == "false") {
        context.goTo(const LoginScreen());
        // context.goTo(HomePage());
      }
      Future.delayed(const Duration(seconds: 3), () {
        DateTime eventDate = DateTime(2024, 10, 3);
        DateTime now = DateTime.now();

        if (now.isAfter(eventDate) || now.isAtSameMomentAs(eventDate)) {
          // If the date has passed or is today, navigate to the home page
          navigate.pushReplacement(routeMe(
              const HomePage())); // Replace with your actual home page widget
        } else {
          context.goTo(ComingSoonAstrologerPage());
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        context.goTo(const LoginScreen());
      });
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
