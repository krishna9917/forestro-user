import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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

  void openCheckout() {
    int amount =
        (int.tryParse(_amountController.text) ?? amountList[amountIndex]) * 100;

    var options = {
      "key": "rzp_live_KxN6rq5K8JKbi6",
      "amount": amount,
      "name": "For Astro App",
      "description": "Payment for the some random product",
      "prefill": {
        "contact": "+91 8879381057",
        "email": "anuragtiwari1172000@gmail.com"
      },
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
  }

  String generateRandomOrderId() {
    var random = Random();
    int randomNumber = 10000 +
        random.nextInt(
            90000); // Generates a random number between 10000 and 99999
    return 'Astro@$randomNumber';
  }

  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success");
    String paymentId = response.paymentId ?? 'NA';
    String orderId = generateRandomOrderId();
    String signature = response.signature ?? 'NA';
    DateTime paymentTime = DateTime.now();
    String userName =
        profileController.profileDataList.first.name ?? 'Unknown User';

    int selectedAmount =
        int.tryParse(_amountController.text) ?? amountList[amountIndex];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    // String userId = profileController.profileDataList?.first.userId ?? 'NA';

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
    // Implement your logic to store these details in your preferred storage.
    // For example, you can store them in a local database or send them to a server.
    print("Payment ID: $paymentId");
    print("Order ID: $orderId");
    print("Signature: $signature");
    print("Payment Time: $paymentTime");
    print("User Name: $userName");
    print("Selected Amount: ₹$selectedAmount");
    print("User ID: $userId");

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
      showToast(tosteError);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Wallet Recharge".toUpperCase()),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () {
                      if (profileController.profileDataList != null &&
                          profileController.profileDataList.isNotEmpty) {
                        // Assuming wallet is a number or a string that can be parsed to a number
                        String wallet =
                            profileController.profileDataList.first.wallet ??
                                'NA';

                        // Check if wallet is a number and format it to two decimal places
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        );
                      } else {
                        if (profileController.profileDataList == null) {
                        } else if (profileController.profileDataList.isEmpty) {}
                        return Text(
                          'NA',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Recharge Wallet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text("Choose from the available quick recharge packs"),
                const SizedBox(height: 30),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Gap(3.h),
                GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.9,
                    physics: const NeverScrollableScrollPhysics(),
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
                            style: TextStyle(
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
                  openCheckout();
                },
                child: const Text("Add To Wallet"),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
