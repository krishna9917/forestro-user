import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/Components/Widgts/custambutton.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Auth/SetupProfile.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/LocalStorage/UseLocalstorage.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  String phone;

  OtpScreen({
    super.key,
    required this.phone,
    int? resendToken,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';
  bool loading = false;
  bool resendLoading = false;

  void _confirmOTP() async {
    try {
      setState(() {
        loading = true;
      });

      await verifyProfile();
    } catch (e) {
      setState(() {
        loading = false;
      });
      // showToast(e.toString());
    }
  }

  Future verifyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');

    try {
      ApiRequest apiRequest = ApiRequest('$apiUrl/user-login-verify-otp',
          method: ApiMethod.POST,
          body: packFormData({"user_id": user_id, "otp": otp}));
      Response res = await apiRequest.send<Map>();
      SharedPreferences localStorage = await LocalStorage.init();

      if (res.data['status'] == true) {
        bool isProfileCreated = res.data['data']['is_profile_created'] ?? false;

        localStorage.setString(
            "is_profile_created", isProfileCreated.toString());

        if (isProfileCreated) {
          localStorage.setString("token", res.data['data']['token']);
          navigate.pushReplacement(routeMe(const HomePage()));
        } else {
          localStorage.setString("token", res.data['data']['token']);
          // Navigate to SetupProfileScreen
          navigate.push(routeMe(SetupProfileScreen(
            phone: widget.phone,
            userId: res.data['user_id'],
          )));
        }
      }
      // else {
      //   showToast("Invalid OTP!");
      // }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showToast("Invalid OTP!");
    }
  }

  Future resendOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');
    try {
      ApiRequest apiRequest = ApiRequest('$apiUrl/user-resend-otp',
          method: ApiMethod.POST,
          body: packFormData({
            "user_id": user_id,
          }));
      Response res = await apiRequest.send<Map>();

      if (res.data['status'] == true) {
        Fluttertoast.showToast(
            msg: "Resend OTP sent successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // showToast(tosteError);
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showToast(tosteError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/bg/auth.png",
          width: scrWeight(context),
          height: scrHeight(context),
          fit: BoxFit.cover,
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          navigate.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: scrWeight(context) - 80,
                        child: const ListTile(
                          title: Text(
                            "Verify Your OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text("Enter Your OTP Send On Your Mobile"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// OTP Input Fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(20.0),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        activeColor: AppColor.primary,
                        selectedColor: AppColor.primary,
                        inactiveColor: AppColor.primary,
                      ),
                      cursorColor: AppColor.primary,
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      onCompleted: (String verificationCode) {
                        setState(() {
                          otp = verificationCode;
                        });
                        // _confirmOTP();
                      },
                      onChanged: (value) {
                        // Handle changes if necessary
                      },
                      beforeTextPaste: (text) {
                        return true; // Allow pasting of the OTP
                      },
                    ),
                  ),

                  Gap(5.h),

                  /// Confirm Button
                  CustomButton(
                    text: 'OTP Confirm',
                    loading: loading,
                    onPressed: () => _confirmOTP(),
                  ),

                  const SizedBox(height: 50),
                  const Spacer(),
                  TextButton(
                    onPressed: resendLoading ? null : resendOtp,
                    child: Text(
                      resendLoading ? "Resending Otp..." : "Resend OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: resendLoading
                            ? AppColor.primary.withOpacity(0.7)
                            : AppColor.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
