import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int amountIndex = 0;
  late Razorpay razorpay;
  final List amountList = [100, 200, 300, 400, 500, 1000, 2000, 5000, 10000];
  final profileController = Get.find<ProfileList>();
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _amountController =
        TextEditingController(text: amountList[amountIndex].toString());

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      handlerPaymentSuccess(response);
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> createOrderAndOpenCheckout() async {
    int baseAmount =
        (int.tryParse(_amountController.text) ?? amountList[amountIndex]);
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

  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success====");
    String paymentId = response.paymentId ?? 'NA';
    String orderId = response.orderId.toString();
    String signature = response.signature ?? 'NA';
    DateTime paymentTime = DateTime.now();
    String userName =
        profileController.profileDataList.first.name ?? 'Unknown User';

    int selectedAmount =
        int.tryParse(_amountController.text) ?? amountList[amountIndex];
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
            'amount': selectedAmount,
            'date': paymentTime,
            'payment_id': paymentId,
            'status': 'paid'
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        print("API request successful: ${data.data}");
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

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("Payment error: ${response.message}");
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Wallet Recharge".toUpperCase()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(const HomePage());
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: scrWeight(context),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 239, 239, 239),
                        blurRadius: 5.0,
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/wallet-icon.png",
                      width: 80,
                      height: 80,
                    ),
                    Text(
                      "Balance".toUpperCase(),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(
                      () {
                        if (profileController.profileDataList != null &&
                            profileController.profileDataList.isNotEmpty) {
                          String wallet =
                              profileController.profileDataList.first.wallet ??
                                  'NA';
                          String formattedWallet = 'NA';
                          if (wallet != 'NA') {
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
                              fontSize: 30,
                            ),
                          );
                        } else {
                          if (profileController.profileDataList == null) {
                          } else if (profileController
                              .profileDataList.isEmpty) {}
                          return Text(
                            'NA',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "Recharge Wallet",
                     style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
                  ),
                  Text("Choose from the available quick recharge packs",style: GoogleFonts.inter(), ),

                  // const SizedBox(height: 30),
                  // TextField(
                  //  enabled: false,
                  //   controller: _amountController,
                  //   decoration: InputDecoration(
                  //     contentPadding:
                  //         const EdgeInsets.symmetric(horizontal: 20),
                  //     border: InputBorder.none,
                  //     focusedBorder: UnderlineInputBorder(
                  //       borderRadius: BorderRadius.circular(0.0),
                  //     ),
                  //     enabledBorder: UnderlineInputBorder(
                  //       borderRadius: BorderRadius.circular(0.0),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  // ),
                  Gap(3.h),
                  GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.9,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(amountList.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              amountIndex = index;
                              _amountController.text =
                                  amountList[amountIndex].toString();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: amountIndex == index
                                  ? AppColor.primary
                                  : Colors.white,
                              border: Border.all(
                                  width: 2,
                                  color: AppColor.primary.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.only(top: 2),
                            child: Center(
                                child: Text(
                              "₹ ${amountList[index]}",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: amountIndex == index
                                    ? Colors.white
                                    : const Color.fromARGB(255, 42, 42, 42),
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ),
                        );
                      })),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: scrWeight(context) - 40,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    createOrderAndOpenCheckout();
                  },
                  child: const Text("Add To Wallet"),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
