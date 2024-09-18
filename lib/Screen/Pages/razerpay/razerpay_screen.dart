import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RzerpayScreen extends StatefulWidget {
  @override
  _RzerpayScreenState createState() => _RzerpayScreenState();
}

class _RzerpayScreenState extends State<RzerpayScreen> {
  late Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
   
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    String upiId = "9886975566@okbizaxis";
    int amount = (double.parse(textEditingController.text) * 100).toInt();
    var options = {
      "key": "rzp_test_RfIDXZliMd9np8",
      "amount": amount,
      "name": "Sample App",
      "description": "Payment for the some random product",
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"],
        "upi": {
          "payeeName": "Payee Name",
          "payeeVpa": upiId,
        },
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
   
  }

  void handlerErrorFailure() {
   
  }

  void handlerExternalWallet() {
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Razor Pay Tutorial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(hintText: "amount to pay"),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              child: const Text(
                "Donate Now",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                openCheckout();
              },
            )
          ],
        ),
      ),
    );
  }
}
