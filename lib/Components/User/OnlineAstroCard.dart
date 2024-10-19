import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    blocListController = Get.find<GetAstrologerProfile>();
    Get.find<GetAstrologerProfile>().astroData().obs;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Get.find<GetAstrologerProfile>().astroData().obs;
  }

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
                            if (astrologer.rating != null)
                              Row(
                                children: List.generate(
                                  double.parse(astrologer.rating.toString())
                                      .toInt(), // Parse as double and then to integer
                                  (_) => Icon(
                                    Icons.star,
                                    size: 13,
                                    color: AppColor.primary,
                                  ),
                                ),
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
                                    int wallet = walletValue.toInt();

                                    var fcmtoken =
                                        astrologer.notifactionToken ?? 'NA';
                                    var token = fcmtoken.toString();

                                    if (wallet > 0) {
                                      var astroid = astrologer.id;
                                      var coupon = astrologer.callCouponCode;
                                      var coupencode = coupon.toString();
                                      var id = astroid.toString();

                                      SendRequest.sendrequestaudio(
                                          id, token, coupencode);
                                      // Get.back();
                                    } else {
                                      // showToast(
                                      //     "You Have Insufficient balance to start Audio Call");
                                    }
                                    // Get.off(
                                    //     const ExploreAstroPage());
                                  } else {}
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
                                    double walletValue = double.parse(
                                        profileController
                                            .profileDataList.first.wallet);
                                    int wallet = walletValue.toInt();

                                    var fcmtoken =
                                        astrologer.notifactionToken ?? 'NA';
                                    var token = fcmtoken.toString();

                                    if (wallet > 0) {
                                      var astroid = astrologer.id;
                                      var id = astroid.toString();
                                      var coupon = astrologer.chatCouponCode;
                                      var coupencode = coupon.toString();

                                      SendRequest.sendrequestchat(
                                          id, token, coupencode);
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
                                    int wallet = walletValue.toInt();

                                    var fcmtoken =
                                        astrologer.notifactionToken ?? 'NA';
                                    var token = fcmtoken.toString();

                                    if (wallet > 0) {
                                      var astroid = astrologer.id;
                                      var coupon = astrologer.videoCouponCode;
                                      var coupencode = coupon.toString();
                                      var id = astroid.toString();

                                      SendRequest.sendrequestvideo(
                                          id, token, coupencode);
                                      // Get.back();
                                    } else {
                                      // showToast(
                                      //     "You Have Insufficient balance to start Video Call");
                                    }
                                    // Get.off(
                                    //     const ExploreAstroPage());
                                  } else {
                                    // showToast(
                                    //     "Profile data is not available");
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
