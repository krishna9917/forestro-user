import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foreastro/Screen/Splash/SplashScreen.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool isConnected = false;
  bool isChecking = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    checkConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (!mounted) return;
      if (!results.contains(ConnectivityResult.none)) {
        // Internet restored; go back to splash to resume normal flow
        Get.offAll(() => const SplashScreen());
      }
    });
  }

  Future<void> checkConnection() async {
    setState(() {
      isChecking = true;
    });
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    final bool hasInternet = !results.contains(ConnectivityResult.none);
    if (hasInternet) {
      setState(() {
        isConnected = true;
        isChecking = false;
      });
      Get.offAll(() => const SplashScreen());
    } else {
      setState(() {
        isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isChecking
            ? CircularProgressIndicator(
                color: AppColor.primary,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.signal_wifi_off,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Internet Connection",
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please check your network settings.",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: checkConnection,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: AppColor.primary,
                    ),
                    child: Text(
                      "Retry",
                      style:
                          GoogleFonts.inter(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
