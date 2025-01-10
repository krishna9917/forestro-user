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
              final nameWords =
                  (astrologer.name ?? "Astrologer Name").split(' ');
              final displayName = nameWords.length > 2
                  ? '${nameWords[0]} ${nameWords[1]}'
                  : astrologer.name ?? "Astrologer Name";
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
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Available now ",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              TextSpan(
                                text:
                                    "\u20B9${astrologer.chatChargesPerMin ?? 0}/min",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      if (profileController.profileDataList.isNotEmpty) {
                        var chatperminatastro = astrologer.chatChargesPerMin;

                        double walletValue = double.parse(
                            profileController.profileDataList.first.wallet);
                        double chatChargesPerMin =
                            double.parse(chatperminatastro) ?? 0;

                        if (chatChargesPerMin > 0) {
                          var totalMinutes = walletValue / chatChargesPerMin;

                          var fcmToken = astrologer.notifactionToken ?? 'NA';
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

                            print(
                                "You need a minimum balance for 2 minutes of chat.");
                          }
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
