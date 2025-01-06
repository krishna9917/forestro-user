import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/astrology_detailes.dart';

import 'package:foreastro/controler/call_function.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/function/navigation.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:get/get.dart';

class OnlineAstroCard extends StatefulWidget {
  const OnlineAstroCard({
    super.key,
  });

  @override
  State<OnlineAstroCard> createState() => _OnlineAstroCardState();
}

class _OnlineAstroCardState extends State<OnlineAstroCard> {
  late GetAstrologerProfile blocListController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    blocListController = Get.find<GetAstrologerProfile>();
    // timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
    //   setState(() {
    //     // Trigger an update every second
    //     blocListController.astroData().obs;
    //   });
    // });
    // Get.find<GetAstrologerProfile>().astroData().obs;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Get.find<GetAstrologerProfile>().astroData().obs;
  // }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: blocListController.astroDataList.map((astrologer) {
            return GestureDetector(
              onTap: () {
                navigate
                    .push(routeMe(AustrologyDetailes(astrologer: astrologer)));
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 220,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColor.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: astrologer.isOnline == true
                                        ? Colors.green
                                        : Colors.red),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: viewImage(
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.orange,
                                  ),
                                  url: astrologer.profileImg),
                            ),
                            Builder(builder: (context) {
                              if (astrologer.isOnline == true) {
                                return Positioned(
                                    right: 10,
                                    top: 0,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ));
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          astrologer.name ?? 'No Name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        Text(
                          astrologer.specialization ?? '',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(astrologer?.rating.toString() ?? ''),
                            // const SizedBox(width: 5),
                            // Container(
                            //   width: 1,
                            //   height: 10,
                            //   color: Colors.black,
                            // ),
                            // const SizedBox(width: 5),
                            if (astrologer.rating != null &&
                                astrologer.rating != 0)
                              Row(
                                children: [
                                  Text(
                                    astrologer.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.star,
                                    size: 13,
                                    color: AppColor.primary,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (profileController
                                      .profileDataList.isNotEmpty) {
                                    double walletValue = double.parse(
                                        profileController
                                            .profileDataList.first.wallet);
                                    double callChargesPerMin = double.parse(
                                            astrologer.callChargesPerMin) ??
                                        0;

                                    if (callChargesPerMin > 0) {
                                      var totalMinutes =
                                          walletValue / callChargesPerMin;

                                      var fcmToken =
                                          astrologer.notifactionToken ?? 'NA';
                                      var token = fcmToken.toString();

                                      if (totalMinutes >= 2) {
                                        var astroId = astrologer.id;
                                        var coupon = astrologer.callCouponCode;
                                        var couponCode = coupon.toString();
                                        var id = astroId.toString();
                                        var signal = astrologer.signalId;
                                        var signalId = signal.toString();

                                        SendRequest.sendrequestaudio(
                                            id, token, couponCode, signalId);
                                      } else {
                                        Get.snackbar(
                                          "Your balance is only $walletValue",
                                          "You need a minimum balance for 2 minutes of an audio call.",
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/tiny/call-now.svg",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (profileController
                                      .profileDataList.isNotEmpty) {
                                    var chatperminatastro =
                                        astrologer.chatChargesPerMin;

                                    double walletValue = double.parse(
                                        profileController
                                            .profileDataList.first.wallet);
                                    double chatChargesPerMin =
                                        double.parse(chatperminatastro) ?? 0;

                                    if (chatChargesPerMin > 0) {
                                      // Calculate total minutes that can be covered by the wallet
                                      var totalMinutes =
                                          walletValue / chatChargesPerMin;

                                      var fcmToken =
                                          astrologer.notifactionToken ?? 'NA';
                                      var token = fcmToken.toString();

                                      if (totalMinutes >= 2) {
                                        var astroId = astrologer.id;
                                        var id = astroId.toString();
                                        var coupon = astrologer.chatCouponCode;
                                        var couponCode = coupon.toString();
                                        var signal = astrologer.signalId;
                                        var signalId = signal.toString();

                                        SendRequest.sendrequestchat(
                                            id, token, couponCode, signalId);
                                      } else {
                                        Get.snackbar(
                                          "Your balance is only $walletValue",
                                          "You need a minimum balance for 2 minutes of chat.",
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                        );
                                        // Fluttertoast.showToast(
                                        //   msg:
                                        //       "You need a minimum balance for 2 minutes of chat.",
                                        //   toastLength: Toast.LENGTH_SHORT,
                                        //   gravity: ToastGravity.BOTTOM,
                                        //   timeInSecForIosWeb: 1,
                                        //   backgroundColor: AppColor.primary,
                                        //   textColor: Colors.white,
                                        //   fontSize: 16.0,
                                        // );
                                        // Show error: Insufficient balance for at least 2 minutes of chat
                                        print(
                                            "You need a minimum balance for 2 minutes of chat.");
                                        // showToast(
                                        //     "You need a minimum balance for 2 minutes of chat.");
                                      }
                                    } else {
                                      // showToast(
                                      //     "You Have Insufficient balance to start chat");
                                    }
                                  } else {
                                    // showToast(
                                    //     "Profile data is not available");
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/tiny/chat-now.svg",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (profileController
                                      .profileDataList.isNotEmpty) {
                                    double walletValue = double.parse(
                                        profileController
                                            .profileDataList.first.wallet);
                                    double videoChargesPerMin = double.parse(
                                            astrologer.videoChargesPerMin) ??
                                        0;

                                    if (videoChargesPerMin > 0) {
                                      // Calculate total minutes that can be covered by the wallet
                                      var totalMinutes =
                                          walletValue / videoChargesPerMin;

                                      var fcmToken =
                                          astrologer.notifactionToken ?? 'NA';
                                      var token = fcmToken.toString();

                                      if (totalMinutes >= 2) {
                                        var astroId = astrologer.id;
                                        var coupon = astrologer.videoCouponCode;
                                        var couponCode = coupon.toString();
                                        var id = astroId.toString();
                                        var signal = astrologer.signalId;
                                        var signalId = signal.toString();

                                        SendRequest.sendrequestvideo(
                                            id, token, couponCode, signalId);
                                        // Get.back(); // Optional navigation logic
                                      } else {
                                        // Show error using Get.snackbar
                                        Get.snackbar(
                                          "Your balance is only $walletValue",
                                          "You need a minimum balance for 2 minutes of video call.",
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: SvgPicture.asset(
                                  color: AppColor.primary,
                                  "assets/icons/tiny/video.svg",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            );
          }).toList(),
        ));
  }
}
