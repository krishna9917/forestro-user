import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/payment_controller.dart';
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
  final List amountList = [100, 200, 300, 400, 500, 1000, 2000, 5000, 10000];
  final profileController = Get.find<ProfileList>();
  final PaymentController paymentController = Get.put(PaymentController());
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _amountController =
        TextEditingController(text: amountList[amountIndex].toString());

    // Set initial amount in payment controller
    paymentController.setSelectedAmount(amountList[amountIndex]);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void initiatePayment() {
    int selectedAmount =
        int.tryParse(_amountController.text) ?? amountList[amountIndex];
    paymentController.setSelectedAmount(selectedAmount);
    paymentController.createOrderAndOpenCheckout();
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
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w500),
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
                  Text(
                    "Choose from the available quick recharge packs",
                    style: GoogleFonts.inter(),
                  ),

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
                            // Update payment controller with selected amount
                            paymentController
                                .setSelectedAmount(amountList[amountIndex]);
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
                child: Obx(() => ElevatedButton(
                      onPressed: paymentController.isPaymentLoading ||
                              paymentController.isProcessingPayment
                          ? null
                          : () {
                              initiatePayment();
                            },
                      child: paymentController.isPaymentLoading ||
                              paymentController.isProcessingPayment
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(paymentController.isProcessingPayment
                              ? "Processing..."
                              : "Add To Wallet"),
                    )),
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
