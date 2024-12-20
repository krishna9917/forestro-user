import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/call_function.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:get/get.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late GetAstrologerProfile blocListController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    blocListController = Get.find<GetAstrologerProfile>();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Online Astrologers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          final onlineAstrologers = blocListController.astroDataList
              .where((astrologer) => astrologer.isOnline == true)
              .toList();

          if (onlineAstrologers.isEmpty) {
            return Center(
              child: Text(
                "No astrologers are online.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.builder(
            itemCount: onlineAstrologers.length,
            itemBuilder: (context, index) {
              final astrologer = onlineAstrologers[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: viewImage(
                      boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.orange,
                      ),
                      url: astrologer.profileImg,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(
                    astrologer.name ?? "Astrologer Name",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    "Available for chat",
                    style: TextStyle(color: Colors.green),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      if (profileController.profileDataList.isNotEmpty) {
                        double walletValue = double.parse(
                            profileController.profileDataList.first.wallet);
                        int wallet = walletValue.toInt();

                        var fcmtoken = astrologer.notifactionToken ?? 'NA';
                        var token = fcmtoken.toString();

                        if (wallet > 0) {
                          var astroid = astrologer.id;
                          var id = astroid.toString();
                          var coupon = astrologer.chatCouponCode;
                          var coupencode = coupon.toString();
                          var signal = astrologer.signalId;
                          var signalId = signal.toString();

                          SendRequest.sendrequestchat(
                              id, token, coupencode, signalId);
                        } else {
                          // showToast(
                          //     "You Have Insufficient balance to start chat");
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/tiny/chat.svg",
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Chat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
