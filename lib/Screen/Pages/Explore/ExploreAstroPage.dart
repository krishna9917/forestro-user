import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/controler/notification_contoler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:http/http.dart' as http;
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/astrology_detailes.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ExploreAstroPage extends StatefulWidget {
  const ExploreAstroPage({super.key});

  @override
  State<ExploreAstroPage> createState() => _ExploreAstroPageState();
}

class _ExploreAstroPageState extends State<ExploreAstroPage> {
  final GetAstrologerProfile blocListController =
      Get.put(GetAstrologerProfile());
  bool loading = false;

  Future firbasetoken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? user_id = prefs.getString('user_id');
      String? fcmtoken = prefs.getString('fcm_token');

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/send-user-notifaction-token",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'user_id': user_id,
            'notifaction_token': fcmtoken,
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  @override
  void initState() {
    super.initState();
    Get.find<GetAstrologerProfile>().astroData();

    Get.find<ProfileList>().fetchProfileData();
   

    firbasetoken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Astrologers".toUpperCase()),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ExploreAstroView(),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreAstroView extends StatefulWidget {
  const ExploreAstroView({
    super.key,
  });

  @override
  State<ExploreAstroView> createState() => _ExploreAstroViewState();
}

class _ExploreAstroViewState extends State<ExploreAstroView> {
  // late GetAstrologerProfile blocListController;
  final GetAstrologerProfile blocListController =
      Get.find<GetAstrologerProfile>();
  bool isFollowing = false;
  List<String> followedAstrologers = [];
  bool loading = false;
  late IO.Socket socket;

  void sendNotification(dynamic data, String fcmToken) {
    // You can customize the notification payload according to your needs
    var notification = {
      'notification': {
        'title': 'New Deposit',
        'body': 'You received a new deposit: $data',
      },
      'to': fcmToken,
    };
  }

  Future folllow(String? id) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String? user_id = prefs.getString('user_id');

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/follow",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
            },
          ),
        );
        dio.Response data = await apiRequest.send();

        if (data.statusCode == 201) {
          setState(() {
            Get.find<GetAstrologerProfile>().astroData();
            final astrologerIndex = blocListController.astroDataList
                .indexWhere((astrologer) => astrologer.id.toString() == id);
            if (astrologerIndex != -1) {
              blocListController.astroDataList[astrologerIndex].followStatus =
                  "1";
            }
          });
          showToast("Follow successful.");
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 +
        random.nextInt(
            90000); // Generates a random number between 10000 and 99999
    return '$randomNumber';
  }

  Future sendrequestchat(String? id, token, coupencode) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Chat";
        String? user_id = prefs.getString('user_id');
        var title = "New  chat Request";
        String chatId = generateRandomOrderId();

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
              'type': 'chat',
              'status': 'pending',
              'communication_id': 'chat$chatId',
              'coupon_applied': coupencode,
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Chat Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  Future sendrequestvideo(
    String? id,
    token,
    coupencode,
  ) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Video";
        String? user_id = prefs.getString('user_id');
        var title = "New  Video Call Request";
        String videocallId = generateRandomOrderId();

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
              'type': 'video',
              'status': 'pending',
              'communication_id': 'video$videocallId',
              'coupon_applied': coupencode,
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Video Call Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  Future sendrequestaudio(String? id, token, coupencode) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var servicetype = "Audio";
        String? user_id = prefs.getString('user_id');

        String audiocallId = generateRandomOrderId();
        var title = "New  Audio Call Request";

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/send-communication-request",
          method: ApiMethod.POST,
          body: packFormData(
            {
              'user_id': user_id,
              'astro_id': id,
              'type': 'audio',
              'status': 'pending',
              'communication_id': 'audio$audiocallId',
              'coupon_applied': coupencode,
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Audio Call Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {
          showToast("Failed to complete profile. Please try again later.");
        }
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
  }

  @override
  void initState() {
    super.initState();
    blocListController.astroData();
    Get.find<GetAstrologerProfile>().astroData();
    _startOnlineStatusCheck();
  }

  void _startOnlineStatusCheck() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await blocListController.astroData();
      setState(() {});
    });
  }

  Future<void> _refresh() async {
    await blocListController.astroData();
    setState(() {});
  }

  String addLineBreaks(String text, int wordLimit) {
    StringBuffer buffer = StringBuffer();
    int wordCount = 0;

    List<String> words = text.split(' '); // Split the text into words

    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);

      if (i < words.length - 1) {
        // Don't add space after the last word
        buffer.write(' ');
      }

      wordCount++;

      if (wordCount % wordLimit == 0 && i != words.length - 1) {
        buffer.write('\n'); // Add a newline after every `wordLimit` words
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();

    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: blocListController.astroDataList.map((astrologer) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  navigate.push(
                      routeMe(AustrologyDetailes(astrologer: astrologer)));
                },
                child: Container(
                  width: scrWeight(context),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: AppColor.primary.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // LiveProfileView(
                          //   type: profileType.Online,
                          // ),

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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ));
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ],
                          ),

                          Column(children: [
                            const SizedBox(height: 5),
                            Text(
                              addLineBreaks(astrologer.name ?? '', 1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              addLineBreaks(astrologer.specialization ?? '', 2),
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.black.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            )
                          ]),
                          // const SizedBox(height: 5),
                          Row(
                            children: [
                              // SizedBox(width: 5),
                              Text(astrologer.rating != null ? '' : ''),
                              if (astrologer.rating != null)
                                Row(
                                  children: List.generate(
                                    double.parse(astrologer.rating.toString())
                                        .toInt(), // Parse as double and then to integer
                                    (_) => Icon(
                                      Icons.star,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (astrologer.followStatus == "0")
                            TextButton(
                              onPressed: () {
                                int? ab = astrologer.id;
                                var id = ab.toString();
                                folllow(id);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color.fromARGB(255, 255, 102, 0)),
                                padding:
                                    WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 25,
                                  ),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 255, 102, 0),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Follow",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          InfoTask(
                                            image: "exp.svg",
                                            label: "Exp :",
                                            desc: Text(
                                                "${astrologer.experience}"),
                                          ),
                                          const SizedBox(width: 15),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                      InfoTask(
                                        image: "lang.svg",
                                        label: "Language :",
                                        desc: Text(
                                            astrologer.languaage?.join(', ') ??
                                                ""),
                                      ),
                                      InfoTask(
                                        image: "call.svg",
                                        label: "Audio :",
                                        desc: (astrologer.callDiscountStatus ??
                                                false)
                                            ? RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "₹ ${astrologer.beforeCallChargesPerMin}/minute",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ₹ ${astrologer.callChargesPerMin}/minute",
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text(
                                                "₹ ${astrologer.callChargesPerMin}/minute"),
                                      ),
                                      InfoTask(
                                        image: "video.svg",
                                        label: "Video :",
                                        desc: (astrologer.videoDiscountStatus ??
                                                false)
                                            ? RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "₹ ${astrologer.beforVideoChargesPerMin}/mminute",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ₹ ${astrologer.videoChargesPerMin}/minute",
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text(
                                                "₹ ${astrologer.videoChargesPerMin}/minute"),
                                      ),
                                      InfoTask(
                                        image: "chat.svg",
                                        label: "Chat :",
                                        desc: (astrologer.chatDiscountStatus ??
                                                false)
                                            ? RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "₹ ${astrologer.beforeChatDiscountPrice}/minute",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ₹ ${astrologer.chatChargesPerMin}/minute",
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text(
                                                "₹ ${astrologer.chatChargesPerMin}/minute"),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          ActionBtn(
                                            title: "Start Call",
                                            image: "call-now.svg",
                                            onTap: () {
                                              Get.dialog(
                                                AlertDialog(
                                                  title: const Center(
                                                    child: Text(
                                                      'Do you want to send call request?',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (profileController
                                                                .profileDataList
                                                                .isNotEmpty) {
                                                              double
                                                                  walletValue =
                                                                  double.parse(
                                                                      profileController
                                                                          .profileDataList
                                                                          .first
                                                                          .wallet);
                                                              int wallet =
                                                                  walletValue
                                                                      .toInt();

                                                              var fcmtoken =
                                                                  astrologer
                                                                          .notifactionToken ??
                                                                      'NA';
                                                              var token = fcmtoken
                                                                  .toString();

                                                              if (wallet > 0) {
                                                                var astroid =
                                                                    astrologer
                                                                        .id;
                                                                var coupon =
                                                                    astrologer
                                                                        .videoCouponCode;
                                                                var coupencode =
                                                                    coupon
                                                                        .toString();
                                                                var id = astroid
                                                                    .toString();

                                                                sendrequestvideo(
                                                                    id,
                                                                    token,
                                                                    coupencode);
                                                                Get.back();
                                                              } else {
                                                                showToast(
                                                                    "You Have Insufficient balance to start Video Call");
                                                              }
                                                              Get.off(
                                                                  const ExploreAstroPage());
                                                            } else {
                                                              showToast(
                                                                  "Profile data is not available");
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Video Call",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (profileController
                                                                .profileDataList
                                                                .isNotEmpty) {
                                                              double
                                                                  walletValue =
                                                                  double.parse(
                                                                      profileController
                                                                          .profileDataList
                                                                          .first
                                                                          .wallet);
                                                              int wallet =
                                                                  walletValue
                                                                      .toInt();

                                                              var fcmtoken =
                                                                  astrologer
                                                                          .notifactionToken ??
                                                                      'NA';
                                                              var token = fcmtoken
                                                                  .toString();

                                                              if (wallet > 0) {
                                                                var astroid =
                                                                    astrologer
                                                                        .id;
                                                                var coupon =
                                                                    astrologer
                                                                        .callCouponCode;
                                                                var coupencode =
                                                                    coupon
                                                                        .toString();
                                                                var id = astroid
                                                                    .toString();

                                                                sendrequestaudio(
                                                                    id,
                                                                    token,
                                                                    coupencode);
                                                                Get.back();
                                                              } else {
                                                                showToast(
                                                                    "You Have Insufficient balance to start Audio Call");
                                                              }
                                                              Get.off(
                                                                  const ExploreAstroPage());
                                                            } else {
                                                              showToast(
                                                                  "Profile data is not available");
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Audio Call",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 7),
                                          ActionBtn(
                                            title: "Start Chat",
                                            image: "chat-now.svg",
                                            onTap: () {
                                              if (profileController
                                                  .profileDataList.isNotEmpty) {
                                                double walletValue =
                                                    double.parse(
                                                        profileController
                                                            .profileDataList
                                                            .first
                                                            .wallet);
                                                int wallet =
                                                    walletValue.toInt();

                                                var fcmtoken = astrologer
                                                        .notifactionToken ??
                                                    'NA';
                                                var token = fcmtoken.toString();

                                                if (wallet > 0) {
                                                  var astroid = astrologer.id;
                                                  var id = astroid.toString();
                                                  var coupon =
                                                      astrologer.chatCouponCode;
                                                  var coupencode =
                                                      coupon.toString();

                                                  sendrequestchat(
                                                      id, token, coupencode);
                                                } else {
                                                  showToast(
                                                      "You Have Insufficient balance to start chat");
                                                }
                                              } else {
                                                showToast(
                                                    "Profile data is not available");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ActionBtn extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;

  const ActionBtn({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: scrWeight(context) / 2 - 90,
        height: 37,
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1, color: AppColor.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              "assets/icons/tiny/$image",
              width: 20,
              height: 20,
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class InfoTask extends StatelessWidget {
  final String image;
  final String label;
  final Widget desc;

  const InfoTask({
    super.key,
    required this.image,
    required this.label,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/tiny/$image",
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 5),
          desc,
          // Text.rich(
          //   TextSpan(
          //       text: '$label ',
          //       style: const TextStyle(fontSize: 12),
          //       children: <InlineSpan>[
          //         TextSpan(
          //           text: desc.replaceAllMapped(
          //               new RegExp(r'(?:[^,]*,){3}[^,]*(?=,|$)'),
          //               (match) => '${match.group(0)}\n'),
          //           style: const TextStyle(fontWeight: FontWeight.w400),
          //           // style: const TextStyle(fontWeight: FontWeight.w500),
          //         )
          //       ]),
          //   overflow: TextOverflow.ellipsis,
          //   maxLines: 2,
          // ),
        ],
      ),
    );
  }
}
