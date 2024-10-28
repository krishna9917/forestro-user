import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/Widgts/bg_gradient_widget.dart';
import 'package:foreastro/Components/Widgts/custambutton.dart';
import 'package:foreastro/Components/fairebase/initFirebase.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Auth/OtpScreen.dart';
import 'package:foreastro/Screen/Auth/SetupProfile.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/commingsoon/commingsoon.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/core/LocalStorage/UseLocalstorage.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const greetingTitle = "Welcome to Fore Astro";
const buttonText = 'OTP Verification';
const googleText = 'Continue with Google';
const facebookText = 'Continue with Facebook';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PhoneNumber? phoneNumber;
  bool loading = false;
  bool _isLoading = false;

  String _dialCode = '91';
  String _phoneNum = '';

  String? email = '';
  String? fbemail = '';
  String? token = '';
  String? fbtoken = '';

  // void onSkip() {
  //   navigate.push(routeMe(const HomePage()));
  // }

  Future<void> onClick() async {
    if (_phoneNum.length != 10) {
      showToast("Enter a 10-digit Mobile Number");
    } else {
      await Sendotp();
    }
  }

  // ignore: non_constant_identifier_names
  Future Sendotp() async {
    try {
      ApiRequest apiRequest = ApiRequest('$apiUrl/user-login',
          method: ApiMethod.POST,
          body: packFormData({
            "phone": _phoneNum,
          }));
      Response res = await apiRequest.send<Map>();
      SharedPreferences localStorage = await LocalStorage.init();

      if (res.data['status'] == true) {
        int? userId = res.data['user_id'];
        if (userId != null) {
          localStorage.setString("user_id", userId.toString());
        } else {
          showToast("Error: 'user_id' is null");
        }

        navigate.push(routeMe(OtpScreen(
          phone: _phoneNum,
        )));
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
      // showToast(tosteError);
    }
  }

  Future verifyOTP() async {
    setState(() {
      loading = true;
    });

    try {
      String formattedPhoneNumber = '+$_dialCode$_phoneNum';
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            loading = false;
          });
          showToast(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            loading = false;
          });
          navigate.push(routeMe(OtpScreen(
            resendToken: resendToken,
            phone: _phoneNum,
          )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        loading = false;
      });

      showToast(e.toString());
    }
  }

  Future<void> _googleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        showToast("Google sign-in was canceled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      
      if (googleUser.email != null && googleAuth.accessToken != null) {
        email = googleUser.email!;
        token = googleAuth.accessToken!;
        String name =
            googleUser.displayName ?? "User"; 

        await verifyProfilee(email!, name);
      } else {
        showToast("Login failed. Missing email or access token.");
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      showToast("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _facebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        await FirebaseAuth.instance.signInWithCredential(credential);
        final userData = await FacebookAuth.instance.getUserData();

        fbemail = userData['email'];
        email = fbemail;
        fbtoken = userData['id'];
        verifyProfileefb(email!);
        // debugPrint('Email: $email');
        // debugPrint('id: $id');
        // navigate.push(routeMe(HomePage()));
      } else {
        showToast(result.message!);
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> verifyProfilee(String email, String name) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        '$apiUrl/login-with-google',
        method: ApiMethod.POST,
        body: packFormData({
          "email": email,
          "token": token, // Ensure token is valid here
        }),
      );
      Response res = await apiRequest.send<Map>();

      SharedPreferences localStorage = await LocalStorage.init();

      if (res.data['status'] == true) {
        String? resToken = res.data['token'];
        if (resToken != null) {
          localStorage.setString("token", resToken);
        } else {
          showToast("Error: 'token' in response is null");
          return;
        }

        int? userId = res.data['user_id'];
        if (userId != null) {
          localStorage.setString("user_id", userId.toString());
        } else {
          showToast("Error: 'user_id' is null");
          return;
        }

        if (res.data['is_profile_created'] == true) {
          navigate.pushReplacement(routeMe(const HomePage()));
        } else {
          navigate.push(routeMe(SetupProfileScreen(
            phone: _phoneNum ?? '',
            userId: userId,
            email: email,
            name: name,
          )));
        }
      }
    } catch (e) {
      showToast("An error occurred: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future verifyProfileefb(String email) async {
    try {
      ApiRequest apiRequest = ApiRequest('$apiUrl/login-with-facebook',
          method: ApiMethod.POST,
          body: packFormData({
            "email": fbemail,
            "token": fbtoken,
          }));
      Response res = await apiRequest.send<Map>();

      SharedPreferences localStorage = await LocalStorage.init();

      if (res.data['status'] == true) {
        localStorage.setString("token", res.data['token']);
        int? userId = res.data['user_id'];
        if (userId != null) {
          localStorage.setString("user_id", userId.toString());
        } else {
          showToast("Error: 'user_id' is null");
          return;
        }

        if (res.data['is_profile_created'] == true) {
          navigate.push(routeMe(const HomePage()));
        } else {
          navigate.push(routeMe(SetupProfileScreen(
            phone: _phoneNum,
            userId: userId,
            email: email,
          )));
        }
      } else {
        // showToast("Something went wrong, please try again.");
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      // showToast(tosteError);
    }
  }

  void _termsAndCondition() async {
    final Uri url = Uri.parse('https://foreastro.com/terms-of-use');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _privacyPolicy() async {
    final Uri url = Uri.parse('https://foreastro.com/user-privacy-policy');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final termsAndPrivacyTextStyle = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(color: Colors.black45, fontWeight: FontWeight.w500);

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,

        /// App Bar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
        ),
        body: BGGradientWidget(
            bgTopMargin: 15.h,
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Gap(8.h),

              /// LOGO
              Image.asset(Assets.logoAstroPng, height: 20.h),

              Gap(3.h),

              /// Greeting Text
              Text(
                greetingTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              Gap(5.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone No",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Gap(1.h),
                        const SizedBox(height: 10),
                        IntlPhoneField(
                          keyboardType: TextInputType.phone,
                          showCountryFlag: false,
                          disableLengthCheck: true,
                          onCountryChanged: (country) {
                            setState(() => _dialCode = country.dialCode);
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            hintText: '',
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            setState(() => _phoneNum = phone.number);
                          },
                        )
                      ],
                    ),

                    Gap(3.h),

                    /// Submit Button
                    CustomButton(
                      loading: loading,
                      color: AppColor.primary,
                      onPressed: onClick,
                      text: buttonText,
                    ),

                    Gap(5.h),

                    /// Or SignUp with
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 7.w, right: 2.w),
                            child: const Divider(
                              height: 1,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        Text(
                          "Or Sign Up With",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 7.w, left: 2.w),
                            child: const Divider(
                              height: 1,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Gap(5.h),

                    /// Google Sign In
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : CustomButton(
                              onPressed: _googleSignIn,
                              color: Theme.of(context).secondaryHeaderColor,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.logoGoogleSvg,
                                    height: 3.h,
                                  ),
                                  Gap(5.w),
                                  const Text(googleText),
                                ],
                              ),
                            ),
                    ),

                    // Gap(2.h),

                    /// Google Sign Up
                    // CustomButton(
                    //   onPressed: _facebookSignIn,
                    //   color: Theme.of(context).secondaryHeaderColor,
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       SvgPicture.asset(
                    //         Assets.logoFacebookSvg,
                    //         height: 3.h,
                    //       ),
                    //       Gap(5.w),
                    //       const Text(facebookText),
                    //     ],
                    //   ),
                    // ),
                    Gap(5.h),

                    /// Terms and Conditions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By Proceeding, I agree to ',
                          style: termsAndPrivacyTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: termsAndPrivacyTextStyle.copyWith(
                                color: AppColor.primary,
                                decorationColor: AppColor.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _termsAndCondition,
                            ),
                            TextSpan(
                              text: ' & ',
                              style: termsAndPrivacyTextStyle,
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: termsAndPrivacyTextStyle.copyWith(
                                color: AppColor.primary,
                                decorationColor: AppColor.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _privacyPolicy,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(5.h),
                  ],
                ),
              ),
            ]))));
  }
}
