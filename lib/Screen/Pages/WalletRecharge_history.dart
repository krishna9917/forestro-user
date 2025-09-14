import 'dart:async'; // Add this import for StreamController
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletRechargeHistory extends StatefulWidget {
  const WalletRechargeHistory({super.key});

  @override
  State<WalletRechargeHistory> createState() => _WalletRechargeHistoryState();
}

class _WalletRechargeHistoryState extends State<WalletRechargeHistory> {
  bool loading = false;
  List<Map<String, dynamic>> rechargeData = [];
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>();

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
        _streamController.add(rechargeData); // Add data to the stream
      } else {
        // Failed API request
        print("API request failed with status code: ${data.statusCode}");
        showToast("Failed to complete profile. Please try again later.");
      }
    } on DioError catch (e) {
      // Handle DioError
      print("DioError: ${e.message}");
      showToast("Failed to complete profile. Please try again later.");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      showToast("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    follow();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Recharge History".toUpperCase()),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: scrWeight(context),
                      height: 220,
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
                            width: 70,
                            height: 70,
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
                                  profileController
                                      .profileDataList!.isNotEmpty) {
                                String wallet = profileController
                                        .profileDataList!.first.wallet ??
                                    'NA';

                                if (wallet != 'NA') {
                                  double walletAmount =
                                      double.tryParse(wallet) ?? 0.0;
                                  wallet = walletAmount.toStringAsFixed(2);
                                }

                                return Text(
                                  "₹$wallet",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                );
                              } else {
                                if (profileController.profileDataList == null) {
                                  print("Profile data list is null");
                                } else if (profileController
                                    .profileDataList!.isEmpty) {
                                  print("Profile data list is empty");
                                }
                                return  Text(
                                  '₹00.00',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                );
                              }
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                navigate.push(routeMe(WalletPage()));
                              },
                              child: const Text("Recharge"))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _streamController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("An error occurred"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text("No recharge history found"));
                        } else {
                          final rechargeData = snapshot.data!;
                          return ListView.builder(
                            itemCount: rechargeData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                      "Wallet Recharge!",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy HH:mm:ss').format(
                                          DateTime.parse(rechargeData[index]
                                                  ['date'] ??
                                              "")),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:  GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                        "Transaction ID ${rechargeData[index]['payment_id'] ?? ""}"),
                                  ],
                                ),
                                subtitle: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "₹${rechargeData[index]['amount'] ?? ""}",
                                    style:  GoogleFonts.inter(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
