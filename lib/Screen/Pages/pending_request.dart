import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/pendingrequest_controller.dart';
import 'package:get/get.dart';

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({super.key});

  @override
  State<PendingRequestScreen> createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen> {
  late PendingRequest pendingRequestController;

  @override
  void initState() {
    super.initState();
    pendingRequestController = Get.find<PendingRequest>();
  }

  Future<void> _refreshRequests() async {
    await pendingRequestController.pendingRequestDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pending Request",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          final requestP =
              pendingRequestController.pendingRequestDataList.toList();

          return RefreshIndicator(
            onRefresh: _refreshRequests,
            child: ListView.builder(
              itemCount: requestP.length,
              itemBuilder: (context, index) {
                final astrologer = requestP[index];
                final nameWords =
                    (astrologer.astroName ?? "Astrologer Name").split(' ');
                final displayName = nameWords.length > 2
                    ? '${nameWords[0]} ${nameWords[1]}'
                    : astrologer.astroName ?? "Astrologer Name";
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: viewImage(
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.orange,
                        ),
                        url: astrologer.astroProfileImage,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.block, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Request Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
