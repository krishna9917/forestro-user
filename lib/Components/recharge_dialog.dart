import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controler/payment_controller.dart';
import '../theme/Colors.dart';

class RechargeDialog extends StatelessWidget {
  final int? customAmount;
  final String? customTitle;
  final String? customDescription;

  const RechargeDialog({
    Key? key,
    this.customAmount,
    this.customTitle,
    this.customDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.put(PaymentController());

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/popup_bg_img.png"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          customTitle ?? "Recharge now of",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rs. ${customAmount ?? paymentController.selectedAmount}",
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          customDescription ?? "and instantly get",
                          style: GoogleFonts.inter(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          children: [
                            Text(
                              "Rs. ${paymentController.selectedAmount} ",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "in Your Wallet",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: paymentController
                                            .isPaymentLoading ||
                                        paymentController.isProcessingPayment
                                    ? Colors.grey
                                    : Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                              onPressed: paymentController.isPaymentLoading ||
                                      paymentController.isProcessingPayment
                                  ? null
                                  : () {
                                      paymentController
                                          .createOrderAndOpenCheckout(
                                              customAmount: customAmount);
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
                                  : Text(
                                      paymentController.isProcessingPayment
                                          ? "Processing..."
                                          : "Recharge Now",
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                            )),
                        Obx(
                          () => paymentController.errorMessage.isNotEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      paymentController.errorMessage,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 30,
            child: GestureDetector(
              onTap: () {
                paymentController.resetPaymentState();
                Get.back();
              },
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
          Positioned(
            top: -20,
            child: Stack(
              children: [
                Image.asset(
                  "assets/gift.png",
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
