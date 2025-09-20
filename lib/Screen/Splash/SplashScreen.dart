import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Screen/Auth/LoginScreen.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/controler/baner_controler.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/pendingrequest_controller.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  bool _isInternetChecked = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isShowingNoInternetPopup = false;
  String _version = '';
  String _buildNumber = '';
  bool _isAppInitialized = false;
  OverlayEntry? _overlayEntry; // Use Overlay instead of Dialog

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Load package info first, then check internet
    _loadPackageInfo().then((_) {
      _checkInternetAndInitialize();
    });
  }

  Future<void> _loadPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
      await version();
      print("build version number =======>>>>>>>>>>>>$_version $_buildNumber");
    } catch (e) {
      print("Error loading package info: $e");
    }
  }

  Future<void> _checkInternetAndInitialize() async {
    print("Checking internet connection...");

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      print("Connectivity result: $connectivityResult");

      if (connectivityResult.contains(ConnectivityResult.none)) {
        print("No internet - showing popup");
        _showNoInternetPopup();
        return;
      }

      print("Internet available - proceeding with initialization");
      _isInternetChecked = true;
      _setupConnectivityListener();
      await _initializeAppComponents();
    } catch (e) {
      print("Error checking connectivity: $e");
      _showNoInternetPopup();
    }
  }

  void _showNoInternetPopup() {
    if (_isShowingNoInternetPopup || _isAppInitialized) return;

    print("Showing no internet popup using Overlay");

    // Remove existing overlay if any
    _hideNoInternetPopup();

    _overlayEntry = OverlayEntry(
      builder: (context) => NoInternetPopup(
        onRetry: _retryConnection,
        onClose: _hideNoInternetPopup,
      ),
    );

    // Insert overlay at the top level
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isShowingNoInternetPopup = true;
    });
  }

  void _hideNoInternetPopup() {
    print("Hiding no internet popup");

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    if (mounted) {
      setState(() {
        _isShowingNoInternetPopup = false;
      });
    }
  }

  Future<void> _retryConnection() async {
    print("Retrying connection...");

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (!connectivityResult.contains(ConnectivityResult.none)) {
        print("Connection successful - closing popup");
        _hideNoInternetPopup();
        _isInternetChecked = true;
        _setupConnectivityListener();
        await _initializeAppComponents();
      } else {
        print("Connection failed - keeping popup open");
        showToast("Still no internet connection");
      }
    } catch (e) {
      print("Error in retry: $e");
      showToast("Connection check failed");
    }
  }

  void _setupConnectivityListener() {
    // Cancel existing subscription
    _connectivitySubscription?.cancel();

    print("Setting up connectivity listener");

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      print("Connectivity changed: $results");

      if (results.contains(ConnectivityResult.none)) {
        // No internet
        if (!_isShowingNoInternetPopup && !_isAppInitialized) {
          print("No internet detected - showing popup");
          _showNoInternetPopup();
        }
        if (!_isAppInitialized) {
          showToast("Check Your Internet Connection");
        }
      } else {
        // Internet restored
        if (_isShowingNoInternetPopup && !_isAppInitialized) {
          print("Internet restored - closing popup");
          _hideNoInternetPopup();
        }
      }
    });
  }

  Future<void> _initializeAppComponents() async {
    if (_isAppInitialized) return;

    try {
      print("Initializing app components...");

      // Initialize controllers
      await Future.wait([
        Get.put(BannerList()).fetchProfileData(),
        Get.find<ProfileList>().fetchProfileData(),
      ]);

      // Start periodic updates
      Timer.periodic(const Duration(seconds: 30), (timer) async {
        if (!_isAppInitialized) return;
        try {
          await Future.wait([
            Get.put(GetAstrologerProfile()).astroData(),
            Get.put(PendingRequest()).pendingRequestData(),
          ]);
        } catch (e) {
          print("Error in periodic update: $e");
        }
      });

      await checkTokenAndNavigate();
      setState(() {
        _isAppInitialized = true;
      });
    } catch (e) {
      print("Error initializing app components: $e");
      // Even if initialization fails, try to navigate
      await checkTokenAndNavigate();
    }
  }

  Future<void> version() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user_id = prefs.getString('user_id');

      if (user_id == null) return;

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/user-version-update",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'user_id': user_id,
            "version": "$_version $_buildNumber",
          },
        ),
      );
      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        print("Version update successful");
      }
    } catch (e) {
      print("Error updating version: $e");
    }
  }

  Future<void> chatzegocloud() async {
    try {
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

      print("Connecting to Zego: $name $user_id $profile");

      await ZIMKit().connectUser(
        id: "$user_id-user",
        name: name,
        avatarUrl: profile,
      );
    } catch (e) {
      print("Error connecting to Zego: $e");
    }
  }

  Future<void> requestPermissions() async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();
    } catch (e) {
      print("Error requesting permissions: $e");
    }
  }

  Future<void> checkTokenAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final isProfileCreated = prefs.getString('is_profile_created');

      if (token == null || token.isEmpty) {
        print("No token found - clearing data and going to login");
        await prefs.clear();
        await _deleteCacheDir();
        await _deleteAppDir();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Get.offAll(() => const LoginScreen());
          }
        });
        return;
      }

      if (isProfileCreated == null || isProfileCreated == "false") {
        print("Profile not created - clearing data and going to login");
        await prefs.clear();
        await _deleteCacheDir();
        await _deleteAppDir();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Get.offAll(() => const LoginScreen());
          }
        });
        return;
      }

      print("Token valid - navigating to home");
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Get.offAll(() => const HomePage());
        }
      });
    } catch (e) {
      print("Error in checkTokenAndNavigate: $e");
      // Fallback to login
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Get.offAll(() => const LoginScreen());
        }
      });
    }
  }

  Future<void> _deleteCacheDir() async {
    try {
      var tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (e) {
      print("Error deleting cache: $e");
    }
  }

  Future<void> _deleteAppDir() async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      if (appDocDir.existsSync()) {
        appDocDir.deleteSync(recursive: true);
      }
    } catch (e) {
      print("Error deleting app dir: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _connectivitySubscription?.cancel();
    _hideNoInternetPopup(); // Clean up overlay
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
                    const SizedBox(height: 60),
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

class NoInternetPopup extends StatefulWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const NoInternetPopup({
    super.key,
    this.onRetry,
    this.onClose,
  });

  @override
  State<NoInternetPopup> createState() => _NoInternetPopupState();
}

class _NoInternetPopupState extends State<NoInternetPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isClosed = false; // Prevent multiple close calls

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (_isClosed) return;
    _isClosed = true;

    _animationController.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(_slideAnimation),
            child: Container(
              width: 90.w,
              constraints: BoxConstraints(maxHeight: 50.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.wifi_off,
                          color: Colors.red.shade600,
                          size: 24.sp,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            "No Internet Connection",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _handleClose,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.close,
                            size: 20.sp,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.signal_wifi_off,
                            size: 48.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "You're offline",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              "Please check your internet connection and try again.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Buttons
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: widget.onRetry,
                      icon: Icon(Icons.refresh, size: 16.sp),
                      label: Text(
                        "Retry Connection",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
