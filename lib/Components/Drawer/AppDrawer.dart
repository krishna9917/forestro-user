import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/CallHistory.dart';
import 'package:foreastro/Screen/Pages/ChatHistory.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Screen/Pages/WalletRecharge_history.dart';
import 'package:foreastro/Screen/Pages/remedy_screen.dart';
import 'package:foreastro/Screen/Profile/profilepage.dart';
import 'package:foreastro/Screen/following/following_list.dart';
import 'package:foreastro/Screen/twkt/twkt.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("Before clear: ${prefs.getKeys()}");
      String? userId = prefs.getString('user_id');

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/user-logout",
        method: ApiMethod.POST,
        body: packFormData({'user_id': userId}),
      );

      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        Get.put(SocketController()).logoutUser();
        // showToast('Logout successfully!');

        // await GoogleSignIn().signOut();
        // // navigate.pushAndRemoveUntil(
        // //     routeMe(const LoginScreen()), (Route<dynamic> route) => false);

        // // Get.off(() => LoginScreen());
        // await prefs.clear();
        // final profileController = Get.find<ProfileList>();
        // profileController.profileDataList.clear();

        // Get.off(() => const LoginScreen());

        // if (Platform.isAndroid || Platform.isIOS) {
        //   SystemNavigator.pop(); // Close the app
        // }
        // print("After clear: ${prefs.getKeys()}");
      }
    } catch (e) {
      print("Logout Error: $e");
      showToast("An error occurred during logout.");
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }


  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();
    return Container(
      width: scrWeight(context) - 50,
      child: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Image.asset(Assets.logoAstroPng, height: 20.h),
                  const SizedBox(height: 40),
                  Container(
                    height: 130,
                    width: scrWeight(context) - 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 223, 223, 223),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(children: [
                        Row(
                          children: [
                            ClipOval(
                              child: profileController
                                          .profileDataList.first.profileImg !=
                                      null
                                  ? File(profileController.profileDataList.first
                                              .profileImg!)
                                          .existsSync()
                                      ? Image.file(
                                          File(profileController.profileDataList
                                              .first.profileImg!),
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.fill,
                                        )
                                      : CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          imageUrl: profileController
                                              .profileDataList
                                              .first
                                              .profileImg!,
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.fill,
                                        )
                                  : Image.asset(
                                      'assets/default_profile.png',
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: scrWeight(context) / 2 - 20,
                                  child: Text(
                                    capitalize(profileController.profileDataList.first.name ?? 'NA'),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),

                                //  Text(
                                //  profileController
                                //             .profileDataList.first. ??
                                //         'NA',
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.w400,
                                //     color: Color.fromARGB(255, 122, 122, 122),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // GestureDetector(
                            //   onTap: changeProfileDetails,
                            //   child: Container(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 10, vertical: 5),
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(50),
                            //         color: AppColor.primary.withOpacity(0.2)),
                            //     child: Row(
                            //       children: [
                            //         Icon(
                            //           FontAwesomeIcons.edit,
                            //           size: 15,
                            //           color: AppColor.primary,
                            //         ),
                            //         const SizedBox(width: 8),
                            //         Text(
                            //           "Edit Profile",
                            //           style: TextStyle(
                            //             color: AppColor.primary,
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 12,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Container(
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/navwallet.svg",
                                    width: 25,
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Balance",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Color.fromARGB(
                                                  255, 81, 81, 81)),
                                        ),
                                        Obx(
                                          () {
                                            if (profileController
                                                .profileDataList.isNotEmpty) {
                                              String wallet = profileController
                                                      .profileDataList
                                                      .first
                                                      .wallet ??
                                                  'NA';

                                              // Check if wallet is a number and format it to two decimal places
                                              String formattedWallet = 'NA';
                                              if (wallet != 'NA') {
                                                try {
                                                  formattedWallet =
                                                      double.parse(wallet)
                                                          .toStringAsFixed(2);
                                                } catch (e) {
                                                  print(
                                                      "Error parsing wallet value: $e");
                                                }
                                              }

                                              return Text(
                                                "₹ $formattedWallet",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              );
                                            } else {
                                              if (profileController
                                                  .profileDataList.isEmpty) {
                                                print(
                                                    "Profile data list is empty");
                                              }
                                              return Text(
                                                'NA',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 40),
                  DrawerTiles(
                    image: "assets/icons/user.svg",
                    title: "My Profile",
                    onTap: () {
                      navigate.push(routeMe(const ProfilePage()));
                    },
                  ),
                  DrawerTiles(
                    image: "assets/icons/g.svg",
                    title: "Following",
                    onTap: () {
                      navigate.push(routeMe(const FollowingList()));
                    },
                  ),
                  DrawerTiles(
                    image: "assets/icons/wallet.svg",
                    title: "My Recharge History",
                    onTap: () {
                      navigate.push(routeMe(const WalletRechargeHistory()));
                    },
                  ),

                  DrawerTiles(
                    image: "assets/icons/chat.svg",
                    title: "Chat History",
                    onTap: () {
                      navigate.push(routeMe(const ChatScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: "assets/icons/call.svg",
                    title: "Call History",
                    onTap: () {
                      navigate.push(routeMe(const CallHistoryScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: "assets/icons/remedy.svg",
                    title: "Remedy",
                    onTap: () {
                      navigate.push(routeMe(const RemedyScreen()));
                    },
                  ),
                  DrawerTiles(
                    image: "assets/icons/mywallet.svg",
                    title: "My Wallet",
                    onTap: () {
                      navigate.push(routeMe(WalletPage()));
                    },
                  ),
                  // DrawerTiles(
                  //   image: "assets/icons/contact.svg",
                  //   title: "Customer Support",
                  //   onTap: () {
                  //     navigate.push(routeMe(const ContactSupport()));
                  //   },
                  // ),
                  DrawerTiles(
                    image: "assets/icons/chats.svg",
                    title: "Chat Support",
                    onTap: () {
                      navigate.push(routeMe(const ChatSupport()));
                    },
                  ),
                  // DrawerTiles(
                  //   image: "assets/icons/setting.svg",
                  //   title: "Settings",
                  // ),
                  DrawerTiles(
                    image: "assets/icons/logout.svg",
                    title: "Log Out",
                    onTap: () async {
                      logout();
                    },
                  ),

                  const SizedBox(height: 20),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final version = snapshot.data!.version;
                        final buildNumber = snapshot.data!.buildNumber;
                        return Text(
                          "Version: $version ($buildNumber)",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        );
                      } else {
                        return const Text(
                          "Version: N/A",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        );
                      }
                    },
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

class DrawerTiles extends StatelessWidget {
  final String image;
  final String title;
  void Function()? onTap;
  DrawerTiles({
    super.key,
    this.onTap,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromARGB(66, 255, 185, 142),
        ),
        child: Center(
          child: SvgPicture.asset(
            image,
            height: 18,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
