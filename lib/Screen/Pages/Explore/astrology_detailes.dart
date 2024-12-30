import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/ExploreAstroPage.dart';
import 'package:foreastro/Screen/Pages/Explore/rating_page.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/call_function.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/notification_contoler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/listaustro_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AustrologyDetailes extends StatefulWidget {
  final Data? astrologer;

  const AustrologyDetailes({super.key, required this.astrologer});

  @override
  _AustrologyDetailesState createState() => _AustrologyDetailesState();
}

class _AustrologyDetailesState extends State<AustrologyDetailes> {
  bool loading = false;
  String astroDetailsText = '';
  final GetAstrologerProfile blocListController =
      Get.put(GetAstrologerProfile());
  List<Review> reviews = [];
  String image = '';

  @override
  initState() {
    super.initState();
    Get.find<GetAstrologerProfile>().astroData();

    Get.find<ProfileList>().fetchProfileData();
    review();
  }

  Future<void> review() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/astrologer-details",
        method: ApiMethod.POST,
        body: packFormData(
          {
            "astro_id": widget.astrologer?.id.toString(),
          },
        ),
      );
      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        var responseData = jsonDecode(data.toString());

        if (responseData.containsKey('data')) {
          var dataObj = responseData['data'];

          String description = dataObj.containsKey('description')
              ? dataObj['description']
              : "No description available";

          setState(() {
            astroDetailsText = description;
          });

          reviews = (dataObj['reviews'] as List)
              .map((review) => Review.fromJson(review))
              .toList();
        }
      } else {}
    } on DioException {
    } catch (e) {
    } finally {
      // setState(() {
      //   loading = false;
      // });
    }
  }

  String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 +
        random.nextInt(
            90000); // Generates a random number between 10000 and 99999
    return '$randomNumber';
  }

  Future sendrequestchat(String? id, token) async {
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
            },
          ),
        );
        dio.Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          showToast("Chat Request send");
          NotificationService.sendNotification(token, title, id, servicetype);
        } else {}
      } else {}
    } catch (e) {
      showToast(tosteError);
    }
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

  Future sendrequestvideo(String? id, token) async {
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

  Future sendrequestaudio(String? id, token) async {
    try {
      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var title = "New  Audio Call Request";
        var servicetype = "Audio";
        String? user_id = prefs.getString('user_id');

        String audiocallId = generateRandomOrderId();

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
      // showToast(tosteError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Astrologer Detail ".toUpperCase()),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          review();
        },
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: widget.astrologer?.isOnline == true
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
                                    url: widget.astrologer?.profileImg),
                              ),
                            ),
                            Builder(builder: (context) {
                              if (widget.astrologer?.isOnline == true) {
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
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                addLineBreaks(
                                    widget.astrologer?.name ?? 'No Name', 3),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                addLineBreaks(
                                    widget.astrologer?.specialization ?? '', 2),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Spacer(),
                              // const SizedBox(height: 10),
                              if (widget.astrologer?.rating != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: List.generate(
                                      double.parse(widget.astrologer!.rating
                                              .toString())
                                          .toInt(),
                                      (_) => const Icon(
                                        Icons.star,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              // const SizedBox(height: 10),
                              if (widget.astrologer!.followStatus == "0")
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        int? ab = widget.astrologer!.id;
                                        var id = ab.toString();
                                        folllow(id);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 255, 102, 0)),
                                        padding: WidgetStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 25,
                                          ),
                                        ),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 102, 0),
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
                                  ),
                                ),
                            ]),
                        const SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     const SizedBox(width: 5),
                        //     if (widget.astrologer?.rating != null)
                        //       Row(
                        //         children: List.generate(
                        //           double.parse(
                        //                   widget.astrologer!.rating.toString())
                        //               .toInt(), // Parse as double and then to integer
                        //           (_) => const Icon(
                        //             Icons.star,
                        //             color: AppColor.primary,
                        //           ),
                        //         ),
                        //       ),
                        //   ],
                        // ),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoTask(
                                    image: "exp.svg",
                                    label: "Exp :",
                                    desc: Text(
                                        "${widget.astrologer?.experience}"),
                                  ),
                                  InfoTask(
                                    image: "lang.svg",
                                    label: "Language :",
                                    desc:
                                        Text("${widget.astrologer?.languaage}"),
                                  ),
                                  InfoTask(
                                    image: "call.svg",
                                    label: "Audio :",
                                    desc: (widget.astrologer
                                                ?.videoDiscountStatus ??
                                            false)
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "₹ ${widget.astrologer?.beforeCallChargesPerMin}/minute ",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ₹ ${widget.astrologer?.callChargesPerMin}/minute",
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(
                                            "₹ ${widget.astrologer?.callChargesPerMin}/minute"),
                                  ),
                                  InfoTask(
                                    image: "video.svg",
                                    label: "Video :",
                                    desc: (widget.astrologer
                                                ?.videoDiscountStatus ??
                                            false)
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "₹ ${widget.astrologer?.beforVideoChargesPerMin}/minute",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ₹ ${widget.astrologer?.videoChargesPerMin}/minute",
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(
                                            "₹ ${widget.astrologer?.videoChargesPerMin}/minute"),
                                  ),
                                  InfoTask(
                                    image: "chat.svg",
                                    label: "Chat :",
                                    desc: (widget.astrologer
                                                ?.chatDiscountStatus ??
                                            false)
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "₹ ${widget.astrologer?.beforeChatDiscountPrice}/minute",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ₹ ${widget.astrologer?.chatChargesPerMin}/minute",
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(
                                            "₹ ${widget.astrologer?.chatChargesPerMin}/minute"),
                                  ),
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
                                                  'Do you want to send call request ?',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
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
                                                            double walletValue =
                                                                double.parse(
                                                                    profileController
                                                                        .profileDataList
                                                                        .first
                                                                        .wallet);
                                                            double
                                                                videoChargesPerMin =
                                                                double.parse(widget
                                                                        .astrologer!
                                                                        .videoChargesPerMin) ??
                                                                    0;

                                                            if (videoChargesPerMin >
                                                                0) {
                                                              var totalMinutes =
                                                                  walletValue /
                                                                      videoChargesPerMin;
                                                              if (totalMinutes >=
                                                                  2) {
                                                                var astroid = widget
                                                                    .astrologer!
                                                                    .id;
                                                                var coupon = widget
                                                                    .astrologer!
                                                                    .videoCouponCode;
                                                                var coupencode =
                                                                    coupon
                                                                        .toString();
                                                                var id = astroid
                                                                    .toString();
                                                                var signal = widget
                                                                    .astrologer!
                                                                    .signalId;
                                                                var signalId =
                                                                    signal
                                                                        .toString();

                                                                SendRequest.sendrequestvideo(
                                                                    id,
                                                                    widget.astrologer!
                                                                            .notifactionToken ??
                                                                        'NA',
                                                                    coupencode,
                                                                    signalId);

                                                                Get.back();
                                                              } else {
                                                                Get.snackbar(
                                                                  "Your balance is only $walletValue",
                                                                  "You need a minimum balance for 2 minutes of video call.",
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                            "Video Call")),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          if (profileController
                                                              .profileDataList
                                                              .isNotEmpty) {
                                                            double walletValue =
                                                                double.parse(
                                                                    profileController
                                                                        .profileDataList
                                                                        .first
                                                                        .wallet);
                                                            double
                                                                audioChargesPerMin =
                                                                double.parse(widget
                                                                        .astrologer!
                                                                        .callChargesPerMin) ??
                                                                    0;

                                                            if (audioChargesPerMin >
                                                                0) {
                                                              var totalMinutes =
                                                                  walletValue /
                                                                      audioChargesPerMin;
                                                              if (totalMinutes >=
                                                                  2) {
                                                                var astroid = widget
                                                                    .astrologer!
                                                                    .id;
                                                                var coupon = widget
                                                                    .astrologer!
                                                                    .callCouponCode;
                                                                var coupencode =
                                                                    coupon
                                                                        .toString();
                                                                var id = astroid
                                                                    .toString();
                                                                var signal = widget
                                                                    .astrologer!
                                                                    .signalId;
                                                                var signalId =
                                                                    signal
                                                                        .toString();

                                                                SendRequest.sendrequestaudio(
                                                                    id,
                                                                    widget.astrologer!
                                                                            .notifactionToken ??
                                                                        'NA',
                                                                    coupencode,
                                                                    signalId);

                                                                Get.back();
                                                              } else {
                                                                Get.snackbar(
                                                                  "Your balance is only $walletValue",
                                                                  "You need a minimum balance for 2 minutes of audio call.",
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                            "Audio Call")),
                                                  ],
                                                ),
                                                // const Spacer(),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      ActionBtn(
                                        title: "Start Chat",
                                        image: "chat-now.svg",
                                        onTap: () {
                                          if (profileController
                                              .profileDataList.isNotEmpty) {
                                            double walletValue = double.parse(
                                                profileController
                                                    .profileDataList
                                                    .first
                                                    .wallet);
                                            double chatChargesPerMin =
                                                double.parse(widget.astrologer!
                                                        .chatChargesPerMin) ??
                                                    0;

                                            if (chatChargesPerMin > 0) {
                                              var totalMinutes = walletValue /
                                                  chatChargesPerMin;
                                              if (totalMinutes >= 2) {
                                                var astroid =
                                                    widget.astrologer!.id;
                                                var id = astroid.toString();
                                                var coupon = widget
                                                    .astrologer!.chatCouponCode;
                                                var coupencode =
                                                    coupon.toString();
                                                var signal =
                                                    widget.astrologer!.signalId;
                                                var signalId =
                                                    signal.toString();

                                                SendRequest.sendrequestchat(
                                                    id,
                                                    widget.astrologer!
                                                            .notifactionToken ??
                                                        'NA',
                                                    coupencode,
                                                    signalId);
                                              } else {
                                                Get.snackbar(
                                                  "Your balance is only $walletValue",
                                                  "You need a minimum balance for 2 minutes of chat.",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                  duration: const Duration(
                                                      seconds: 3),
                                                );
                                              }
                                            }
                                          }
                                          // showToast("Chate Request Sent");
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("About ${widget.astrologer?.name}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800)),
                      Text(
                        astroDetailsText,
                      ),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(10, 50))),
                  onPressed: () {
                    navigate.push(
                        routeMe(RatingPage(austroid: widget.astrologer?.id)));
                  },
                  child: const Text("Write a review")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  for (var review in reviews)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: AppColor.primary.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  review.userImgUrl,
                                  width: 50, // Adjust width as needed
                                  height: 50, // Adjust height as needed
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.fill,
                                    ); // Widget to display if image fails to load
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const CircularProgressIndicator(); // Placeholder widget while loading
                                  },
                                ),
                              ),
                              // viewImage(
                              //   boxDecoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(100),
                              //     color: Colors.orange,
                              //   ),
                              //   url: review.userImgUrl,
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review.userName ?? 'NA'),
                                    // Text(review.rating != null ? '' : 'NA'),
                                    if (review.rating != null)
                                      Row(
                                        children: List.generate(
                                          double.parse(review.rating)
                                              .toInt(), // Parse as double and then to integer
                                          (_) => const Icon(
                                            Icons.star,
                                            color: AppColor.primary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(review.postDate != null
                                  ? DateFormat('yyyy-MM-dd HH:mm')
                                      .format(DateTime.parse(review.postDate))
                                  : 'NA'),
                            ],
                          ),
                          Text(review.comment ?? 'NA'),
                        ],
                      ),
                    ),
                  if (reviews.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: AppColor.primary.withOpacity(0.4),
                        ),
                      ),
                      child: const Text('No reviews available'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Review {
  final dynamic userName;
  final dynamic userImgUrl;
  final dynamic rating;
  final dynamic comment;
  final dynamic postDate;

  Review({
    required this.userName,
    required this.userImgUrl,
    required this.rating,
    required this.comment,
    required this.postDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['user_name']?.toString() ?? 'Anonymous',
      userImgUrl: json['user_img']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '0',
      comment: json['comment']?.toString() ?? 'No comment',
      postDate: json['post_date']?.toString() ?? '',
    );
  }
}
