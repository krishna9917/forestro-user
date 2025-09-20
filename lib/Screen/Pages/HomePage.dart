import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/Drawer/AppDrawer.dart';
import 'package:foreastro/Components/HomeTitleBar.dart';
import 'package:foreastro/Components/TaskTabs.dart';
import 'package:foreastro/Components/User/LiveProfileView.dart';
import 'package:foreastro/Components/User/OnlineAstroCard.dart';
import 'package:foreastro/Components/Widgts/BottamBar.dart';
import 'package:foreastro/Components/recharge_popup.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Auth/SetupProfile.dart';
import 'package:foreastro/Screen/Pages/Explore/ExploreAstroPage.dart';
import 'package:foreastro/Screen/Pages/Explore/bloc_detailes.dart';
import 'package:foreastro/Screen/Pages/Explore/search_astro.dart';
import 'package:foreastro/Screen/Pages/NotificationsPage.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Screen/Pages/innerpage/bloc_viewall.dart';
import 'package:foreastro/Screen/Pages/innerpage/celeb_insights.dart';
import 'package:foreastro/Screen/Pages/innerpage/our_client_says.dart';
import 'package:foreastro/Screen/Pages/innerpage/youtub_play.dart';
import 'package:foreastro/Screen/Pages/pending_request.dart';
import 'package:foreastro/Screen/Pages/service_page.dart';
import 'package:foreastro/Screen/Profile/profilepage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/baner_controler.dart';
import 'package:foreastro/controler/bloc_controler.dart';
import 'package:foreastro/controler/celebrity_controler.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/listof_termination_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/listaustro_model.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Razorpay razorpay;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bannerController = Get.put(BannerList());
  final BlocList blocListController = Get.put(BlocList());
  final SocketController socketController = Get.put(SocketController());
  bool? isOnline;
  final TextEditingController _searchController = TextEditingController();

  RxList<Data> _astrologers = RxList<Data>();
  final profileController = Get.find<ProfileList>();

  List<Map<String, dynamic>> rechargeData = [];

  Future<void> createOrderAndOpenCheckout() async {
    final profileController = Get.find<ProfileList>();
    int baseAmount = 1;
    double gst = baseAmount * 0.18;
    int totalAmount = (baseAmount + gst).toInt() * 100;
    String breakdownMessage =
        "Base Amount: ₹$baseAmount\nGST (18%): ₹${gst.toStringAsFixed(2)}\nTotal Amount: ₹${(baseAmount + gst).toStringAsFixed(2)}";
    showToast(breakdownMessage);
    String userphone = profileController.profileDataList.first.phone ?? 'NA';
    String useremail = profileController.profileDataList.first.email ?? 'NA';
    print("userphone=================================$userphone,$useremail");
    var orderResponse = await http.post(
      Uri.parse("https://api.razorpay.com/v1/orders"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Basic ${base64Encode(utf8.encode("rzp_live_CJkLJpz9BeaRDw:hvVS8uUKkURE9rsneO8GGhX4"))}",
      },
      body: jsonEncode({
        "amount": totalAmount,
        "currency": "INR",
        "payment_capture": 1,
      }),
    );

    if (orderResponse.statusCode == 200) {
      var orderData = jsonDecode(orderResponse.body);
      var orderId = orderData['id'];
      print("ordrr=============$orderId");

      var options = {
        "key": "rzp_live_CJkLJpz9BeaRDw",
        "amount": totalAmount,
        "name": "For Astro App",
        "description": "Payment for the some random product",
        "order_id": orderId,
        "prefill": {"contact": "$userphone", "email": "$useremail"},
        "external": {
          "wallets": ["paytm"],
          "upi": {
            "payeeName": "Payee Name",
            "payeeVpa": "9886975566@okbizaxis",
          },
        },
        "theme": {
          "color": "#${AppColor.primary.value.toRadixString(16).substring(2)}"
        }
      };

      try {
        razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
    } else {
      print("Error creating order: ${orderResponse.body}");
    }
  }

  Future<void> follow() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? user_id = prefs.getString('user_id');

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/user-wallet-history",
        method: ApiMethod.POST,
        body: packFormData(
          {
            "user_id": user_id,
          },
        ),
      );
      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        rechargeData = List<Map<String, dynamic>>.from(data.data['data']);
        if (rechargeData.isEmpty) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  insetPadding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.transparent,
                  content: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/popup_bg_img.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                children: [
                                  Text(
                                    "Recharge now of",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Rs. 9",
                                    style: GoogleFonts.inter(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "and instantly get",
                                    style: GoogleFonts.inter(fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Rs. 100 in Your Wallet",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    onPressed: () {
                                      createOrderAndOpenCheckout();
                                    },
                                    child: Text(
                                      "Recharge Now",
                                      style: GoogleFonts.inter(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -40,
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/gift.png", // Your gift image
                              height: 80,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        }
      } else {
        // Failed API request
        print("API request failed with status code: ${data.statusCode}");
        showToast("Failed to complete profile. Please try again later.");
      }
    } on dio.DioError catch (e) {
      // Handle DioError
      print("DioError: ${e.message}");
      showToast("Failed to complete profile. Please try again later.");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      showToast("An unexpected error occurred. Please try again later.");
    } finally {}
  }

  @override
  void initState() {
    fetchAndInitProfile();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            (PaymentSuccessResponse response) {
          handlerPaymentSuccess(response);
        });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    Get.find<ProfileList>().fetchProfileData();
    Get.put(BannerList()).fetchProfileData();
    Get.put(BlocList()).blocData();
    Get.put(CelibrityList()).celibrityData();
    Get.put(ClientSays()).clientsaysData();
    Get.put(GetAstrologerProfile()).astroData();
    follow();
    socketController.initSocketConnection();
    calculatePrice();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("Payment error: ${response.message}");
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success====");
    String paymentId = response.paymentId ?? 'NA';
    String orderId = response.orderId.toString();
    String signature = response.signature ?? 'NA';
    DateTime paymentTime = DateTime.now();
    String userName =
        profileController.profileDataList.first.name ?? 'Unknown User';

    int selectedAmount = 9;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    storePaymentDetails(paymentId, orderId, signature, paymentTime, userName,
        selectedAmount, userId!);
  }

  Future<void> storePaymentDetails(
      String paymentId,
      String orderId,
      String signature,
      DateTime paymentTime,
      String userName,
      int selectedAmount,
      String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? user_id = prefs.getString('user_id');

      print(user_id);

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/wallet-payment",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'user_id': user_id,
            'name': userName,
            'order_id': orderId,
            'amount': 100,
            'is_bonus': true,
            'date': paymentTime,
            'payment_id': paymentId,
            'status': 'paid'
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.
      statusCode == 201) {
        Get.back();
        showToast("Wallet Recharge successfull");
      } else {
        print("API request failed with status code: ${data.statusCode}");
      }
      print("manjulika${data}");
    } catch (e) {
      // showToast(tosteError);
    }
    setState(() {
      Get.find<ProfileList>().fetchProfileData();
    });
  }


  void _onSearchChanged() {
    if (_searchController.text.length >= 3) {
      _filterAstrologers(_searchController.text);
    } else {
      _astrologers.clear();
    }
  }

  Future<void> calculatePrice() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionData = prefs.getString('active_call');

      if (sessionData == null) {
        print("No session data found");
        return;
      }
      Map<String, dynamic> sessionMap = jsonDecode(sessionData);
      String callId = sessionMap['call_id'] ?? "";
      String astroPerMinPrice = sessionMap['astro_per_min_price'] ?? "";
      String totalTime = sessionMap['totaltime'] ?? "";
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/communication-charges",
        method: ApiMethod.POST,
        body: packFormData({
          'communication_id': callId,
          'astro_per_min_price': astroPerMinPrice,
          'time': totalTime,
        }),
      );
      dio.Response data = await apiRequest.send();
      print("API Response: $data");

      if (data.statusCode == 201) {
        await prefs.remove('active_call');
        print("Cleared active_call from storage");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchAndInitProfile() async {
    await chatzegocloud();
    await Get.find<ProfileList>().fetchProfileData();
  }

  Future<void> chatzegocloud() async {
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

    print("name=======$name $user_id $profile  --   $user_id-user");
    try {
      await ZIMKit().connectUser(
        id: "$user_id-user",
        name: name,
        avatarUrl: profile,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _filterAstrologers(String query) async {
    final List<Data> astrologers =
        Get.find<GetAstrologerProfile>().astroDataList;
    final List<Data> filteredAstrologers = astrologers
        .where((astrologer) =>
            astrologer.name?.toLowerCase().contains(query.toUpperCase()) ??
            false)
        .toList();
    _astrologers.clear();
    _astrologers.addAll(filteredAstrologers);
  }

  String extractVideoId(String url) {
    RegExp regExp = RegExp(
        r"(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Iterable<RegExpMatch> matches = regExp.allMatches(url);
    if (matches.isNotEmpty) {
      return matches.first.group(1)!;
    }
    return '';
  }

  @override
  void dispose() {
    razorpay.clear();
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(
        width: 1,
        color: Color.fromARGB(255, 226, 226, 226),
      ),
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
          // bottomSheet: const InteractiveBottomSheet(
          //   options: InteractiveBottomSheetOptions(),
          //   child: PendingRequestScreen(),
          // ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: AppColor.bgcolor,
          extendBody: true,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: AppColor.bgcolor,
            leading: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 8.0),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/nav.svg",
                    height: 20,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    // navigate.push(routeMe( SetupProfileScreen(phone: '', userId: null,)));
                    navigate.push(routeMe(const SearchPage()));
                  },
                  icon: Icon(
                    Icons.search,
                    color: AppColor.primary,
                    size: 30,
                  )),
              GestureDetector(
                onTap: () {
                  navigate.push(routeMe(const WalletPage()));
                },
                child: Container(
                  width: 95,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Obx(
                      () {
                        if (profileController.profileDataList != null &&
                            profileController.profileDataList.isNotEmpty) {
                          String wallet =
                              profileController.profileDataList.first.wallet ??
                                  '0';
                          String formattedWallet = '0';
                          if (wallet != '0') {
                            try {
                              formattedWallet =
                                  double.parse(wallet).toStringAsFixed(2);
                            } catch (e) {
                              print("Error parsing wallet value: $e");
                            }
                          }

                          return Text(
                            "₹ $formattedWallet",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          );
                        } else {
                          if (profileController.profileDataList == null) {
                          } else if (profileController
                              .profileDataList.isEmpty) {}
                          return Text(
                            '0',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w500),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  navigate.push(routeMe(const NotificationPage()));
                },
                child: Badge(
                  backgroundColor: AppColor.primary,
                  label: Text(
                    "0",
                    style: GoogleFonts.inter(fontSize: 10),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/notic.svg",
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return _astrologers.isEmpty
                        ? const Center(child: Text(''))
                        : ListView.builder(
                            itemCount: _astrologers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_astrologers[index].name ?? 'NA'),
                              );
                            },
                          );
                  },
                ),

                Obx(
                  () {
                    if (bannerController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final bannerList = bannerController.dataList;
                      if (bannerList.isNotEmpty) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 175.0,
                            viewportFraction: 0.9,
                            autoPlay: true,
                          ),
                          items: bannerList.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const Center(
                            child: Text('No banners available'));
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Top Astrologers".toUpperCase(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                          "500+ Best Astrologers from India for Online Consultation")
                    ],
                  ),
                ),
                const HomeTitleBar(
                  title: "Live Video CAll",
                ),
                const SizedBox(height: 15),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      LiveProfileView(),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 20.0, vertical: 10),
                      //   child: Text(
                      //     "pending reques".toUpperCase(),
                      //     style: const GoogleFonts.inter(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PendingRequestScreen(),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                HomeTitleBar(
                  title: "Astrologer",
                  onClick: () {
                    navigate.push(routeMe(const ExploreAstroPage()));
                  },
                ),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OnlineAstroCard(),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       SizedBox(width: 10),
                //       Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: PendingRequestScreen(),
                //       ),
                //       SizedBox(width: 10),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 20),
                TaskTabs(),
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                // Client Says //
/////////////////////////////////////////////////////////////////////////////////////////////////////////
                // const SizedBox(height: 20),
                HomeTitleBar(
                  title: "What our client Says",
                  desc: "Discover what our stargazers have to say",
                  onClick: () {
                    navigate.push(routeMe(const OurClientSays()));
                  },
                ),
                GetBuilder<ClientSays>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.17,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              controller.clientsaysDataList.length,
                              (index) {
                                final data =
                                    controller.clientsaysDataList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            AppColor.primary.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: data.image != null
                                                  ? Image.network(
                                                      data.image!,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.error);
                                                      },
                                                    )
                                                  : const Icon(Icons.person,
                                                      size: 50),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.name ?? 'NA',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  if (data.rating != null)
                                                    Row(
                                                      children: List.generate(
                                                        double.parse(controller
                                                                .clientsaysDataList[
                                                                    index]
                                                                .rating
                                                                .toString())
                                                            .toInt(),
                                                        (_) => Icon(
                                                          Icons.star,
                                                          color:
                                                              AppColor.primary,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Builder(
                                            builder: (context) {
                                              final comment =
                                                  data.comment ?? 'NA';

                                              final words = comment.split(' ');
                                              final chunkedText = List.generate(
                                                (words.length / 7).ceil(),
                                                (index) => words
                                                    .skip(index * 7)
                                                    .take(7)
                                                    .join(' '),
                                              ).join('\n');

                                              return Text(
                                                chunkedText,
                                                maxLines: null,
                                                overflow: TextOverflow.visible,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
                HomeTitleBar(
                  title: "Latest blogs",
                  desc: "Stay in the cosmic loop and explore our blogs!",
                  onClick: () {
                    navigate.push(routeMe(const BlocViewAll()));
                  },
                ),

                GetBuilder<BlocList>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading) {
                        // Show shimmer effect while loading
                        return SizedBox(
                          height: 210,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5, // Number of shimmer placeholders
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 190,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        // Show actual data once loaded
                        return SizedBox(
                          height: 210,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.blocDataList.length,
                            itemBuilder: (context, index) {
                              final blocData = controller.blocDataList[index];
                              final String id = blocData.id?.toString() ?? '';
                              final String imageUrl = blocData.image ?? '';
                              final String title = blocData.title ?? 'NA';

                              return GestureDetector(
                                onTap: () {
                                  navigate.push(routeMe(BlocDetailes(id: id)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 190,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl.isNotEmpty
                                              ? imageUrl
                                              : 'https://via.placeholder.com/450x140.png?text=No+Image',
                                          width: 450,
                                          height: 140,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
                ),

                HomeTitleBar(
                  title: "Celeb Insights",
                  desc: "Celebrities Share Their Astrological Insights",
                  onClick: () {
                    navigate.push(routeMe(const Celebinsights()));
                  },
                ),

                // GetBuilder<CelibrityList>(
                //   builder: (controller) {
                //     return Obx(() {
                //       if (controller.isLoading) {
                //         return const Center(child: CircularProgressIndicator());
                //       } else {
                //         return Container(
                //           height: 200,
                //           child: ListView(
                //             scrollDirection: Axis.horizontal,
                //             children: List.generate(
                //               controller.celibrityDataList.length,
                //               (index) {
                //                 final celebrity =
                //                     controller.celibrityDataList[index];
                //                 var videoUrl = celebrity.video.toString();
                //                 print("videoUrl====$videoUrl");

                //                 return Container(
                //                   margin: const EdgeInsets.all(8.0),
                //                   width: 210,
                //                   child: Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       // const SizedBox(height: 8),
                //                       ClipRRect(
                //                         borderRadius: BorderRadius.circular(25),
                //                         child: InkWell(
                //                           onTap: () {
                //                             if (videoUrl != null) {
                //                               navigate.push(routeMe(VideoPlay(
                //                                 videoUrl: videoUrl,
                //                               )));
                //                             } else {
                //                               print(
                //                                   'Video ID is null, cannot play video.');
                //                             }
                //                           },
                //                           child: Image.network(
                //                             celebrity.thumbnail ??
                //                                 'https://via.placeholder.com/550x140.png?text=No+Image',
                //                             width: 550,
                //                             height: 140,
                //                             fit: BoxFit.cover,
                //                           ),
                //                         ),
                //                       ),
                //                       // const SizedBox(height: 8),
                //                       Flexible(
                //                         child: Padding(
                //                           padding: const EdgeInsets.all(8.0),
                //                           child: Text(
                //                             celebrity.title ?? 'NA',
                //                             maxLines: 2,
                //                             overflow: TextOverflow.ellipsis,
                //                             style: const GoogleFonts.inter(
                //                               fontSize: 14,
                //                               fontWeight: FontWeight.w400,
                //                             ),
                //                             textAlign: TextAlign.center,
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 );
                //               },
                //             ),
                //           ),
                //         );
                //       }
                //     });
                //   },
                // ),

                GetBuilder<CelibrityList>(
                  init: CelibrityList(),
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading) {
                        // Show shimmer loading effect while data is loading
                        return SizedBox(
                          height: 200,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5, // Number of shimmer placeholders
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 210,
                                  height: 140,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        // Display the data once it's loaded
                        return Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.celibrityDataList.length,
                            itemBuilder: (context, index) {
                              final celebrity =
                                  controller.celibrityDataList[index];
                              var videoUrl = celebrity.video?.toString() ?? '';
                              print("videoUrl====$videoUrl");

                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 210,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: InkWell(
                                        onTap: () {
                                          if (videoUrl.isNotEmpty) {
                                            // Navigate to video player screen
                                            Get.to(() =>
                                                VideoPlay(videoUrl: videoUrl));
                                          } else {
                                            print(
                                                'Video URL is null, cannot play video.');
                                          }
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: celebrity.thumbnail ??
                                              'https://via.placeholder.com/550x140.png?text=No+Image',
                                          width: 550,
                                          height: 140,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          celebrity.title ?? 'NA',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
          drawer: const AppDrawer(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.phone,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              navigate.push(routeMe(const ExploreAstroPage()));
            },
          ),
          bottomNavigationBar: const BottamBar(
            index: 0,
          )),
    );
  }
}

class BottamBar extends StatelessWidget {
  final int index;
  const BottamBar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: StylishBottomBar(
        // elevation: 0,
        option: AnimatedBarOptions(),
        items: [
          activeBottamBar(
            activeImage: "home-active.svg",
            inactiveImage: "home.svg",
            activeIndex: 0,
            index: index,
            title: "Home",
          ),
          activeBottamBar(
            activeImage: "chat-active.svg",
            inactiveImage: "chat.svg",
            activeIndex: 1,
            index: index,
            title: "Chat",
            alineRight: true,
          ),
          activeBottamBar(
            activeImage: "wallet-active.svg",
            inactiveImage: "wallet.svg",
            activeIndex: 1,
            index: index,
            title: "Wallet",
            alineLeft: true,
          ),
          activeBottamBar(
            activeImage: "profile-active.svg",
            inactiveImage: "profile.svg",
            activeIndex: 1,
            index: index,
            title: "Profile",
          )
        ],
        fabLocation: StylishBarFabLocation.center,
        hasNotch: true,
        notchStyle: NotchStyle.circle,
        currentIndex: index,
        onTap: (index) {
          switch (index) {
            case 1:
              navigate.push(routeMe(const ServicesPage()));
              break;
            case 2:
              navigate.push(routeMe(const WalletPage()));
              break;
            case 3:
              navigate.push(routeMe(const ProfilePage()));
              break;
            default:
          }
        },
      ),
    );
  }
}
