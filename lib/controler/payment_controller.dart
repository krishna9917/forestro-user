import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import '../core/api/ApiRequest.dart';
import '../controler/profile_controler.dart';
import '../Utils/Quick.dart';

class PaymentController extends GetxController {
  late Razorpay _razorpay;
  final ProfileList _profileController = Get.find<ProfileList>();

  // Observable variables
  final RxBool _isPaymentLoading = false.obs;
  final RxBool _isProcessingPayment = false.obs;
  final RxString _paymentStatus = ''.obs;
  final RxString _errorMessage = ''.obs;

  // Payment details
  final RxInt _selectedAmount = 100.obs;
  final RxString _orderId = ''.obs;
  final RxString _paymentId = ''.obs;

  //
  late bool isBonus = false;

  // Getters
  bool get isPaymentLoading => _isPaymentLoading.value;

  bool get isProcessingPayment => _isProcessingPayment.value;

  String get paymentStatus => _paymentStatus.value;

  String get errorMessage => _errorMessage.value;

  int get selectedAmount => _selectedAmount.value;

  String get orderId => _orderId.value;

  String get paymentId => _paymentId.value;

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void setSelectedAmount(int amount) {
    _selectedAmount.value = amount;
  }

  Future<void> createOrderAndOpenCheckout({int? customAmount}) async {
    try {
      _isPaymentLoading.value = true;
      _errorMessage.value = '';

      isBonus = (customAmount ?? 0) <= 9;

      int baseAmount = customAmount ?? _selectedAmount.value;
      double gst = baseAmount * 0.18;
      int totalAmount = (baseAmount + gst).toInt() * 100;

      // Show breakdown message
      String breakdownMessage =
          "Base Amount: ₹$baseAmount\nGST (18%): ₹${gst.toStringAsFixed(2)}\nTotal Amount: ₹${(baseAmount + gst).toStringAsFixed(2)}";
      showToast(breakdownMessage);

      // Get user details
      String userPhone = _profileController.profileDataList.first.phone ?? 'NA';
      String userEmail = _profileController.profileDataList.first.email ?? 'NA';

      // Create order
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
        _orderId.value = orderData['id'];

        // Open Razorpay checkout
        var options = {
          "key": "rzp_live_CJkLJpz9BeaRDw",
          "amount": totalAmount,
          "name": "For Astro App",
          "description": "Wallet Recharge",
          "order_id": _orderId.value,
          "prefill": {"contact": userPhone, "email": userEmail},
          "external": {
            "wallets": ["paytm"],
            "upi": {
              "payeeName": "Payee Name",
              "payeeVpa": "9886975566@okbizaxis",
            },
          },
          "theme": {
            "color": "#FF6B35" // You can customize this color
          }
        };

        _razorpay.open(options);
      } else {
        _errorMessage.value = "Failed to create order: ${orderResponse.body}";
        showToast(_errorMessage.value);
      }
    } catch (e) {
      _errorMessage.value = "Error creating order: $e";
      showToast(_errorMessage.value);
    } finally {
      _isPaymentLoading.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      _isProcessingPayment.value = true;
      _paymentId.value = response.paymentId ?? '';
      _paymentStatus.value = 'success';

      // Get payment details
      String orderId = response.orderId.toString();
      String signature = response.signature ?? '';
      DateTime paymentTime = DateTime.now();
      String userName =
          _profileController.profileDataList.first.name ?? 'Unknown User';

      // Store payment details
      await _storePaymentDetails(
        _paymentId.value,
        orderId,
        signature,
        paymentTime,
        userName,
        _selectedAmount.value,
      );

      // Close any open dialogs and show success message
      Get.back(); // This will close the recharge dialog
      showToast(
          "Wallet Recharge Successful! ₹${_selectedAmount.value} added to your wallet.");

      // Refresh profile data to update wallet balance
      _profileController.fetchProfileData();
    } catch (e) {
      _errorMessage.value = "Error processing payment: $e";
      showToast(_errorMessage.value);
    } finally {
      _isProcessingPayment.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _paymentStatus.value = 'failed';
    _errorMessage.value = response.message ?? 'Payment failed';
    showToast("Payment Failed: ${response.message}");
    _isProcessingPayment.value = false;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showToast("External wallet selected: ${response.walletName}");
  }

  Future<void> _storePaymentDetails(
    String paymentId,
    String orderId,
    String signature,
    DateTime paymentTime,
    String userName,
    int selectedAmount,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId == null) {
        throw Exception("User ID not found");
      }

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/wallet-payment",
        method: ApiMethod.POST,
        body: packFormData({
          'user_id': userId,
          'name': userName,
          'order_id': orderId,
          'amount': selectedAmount,
          'is_bonus': isBonus,
          'date': paymentTime.toIso8601String(),
          'payment_id': paymentId,
          'status': 'paid'
        }),
      );

      dio.Response response = await apiRequest.send();

      if (response.statusCode == 201) {
        print("Payment details stored successfully");
      } else {
        print("Failed to store payment details: ${response.statusCode}");
        throw Exception("Failed to store payment details");
      }
    } catch (e) {
      print("Error storing payment details: $e");
      rethrow;
    }
  }

  void resetPaymentState() {
    _paymentStatus.value = '';
    _errorMessage.value = '';
    _orderId.value = '';
    _paymentId.value = '';
    _isPaymentLoading.value = false;
    _isProcessingPayment.value = false;
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
