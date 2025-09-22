import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/pendingrequest_controller.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/model/pendingrequest_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_fonts/google_fonts.dart';

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
    // Ensure the controller is initialized before trying to find it
    try {
      pendingRequestController = Get.find<PendingRequest>();
    } catch (e) {
      // If controller is not found, create it
      pendingRequestController = Get.put(PendingRequest());
    }
  }

  Future requestCancel(String? id) async {
    try {
      if (id != null) {
        // Find the item to remove
        Data? itemToRemove;
        int? itemIndex;
        for (int i = 0; i < pendingRequestController.pendingRequestDataList.length; i++) {
          if (pendingRequestController.pendingRequestDataList[i].id.toString() == id) {
            itemToRemove = pendingRequestController.pendingRequestDataList[i];
            itemIndex = i;
            break;
          }
        }

        // Remove item immediately from UI for better UX
        if (itemToRemove != null && itemIndex != null) {
          pendingRequestController.pendingRequestDataList.removeAt(itemIndex);
        }

        ApiRequest apiRequest = ApiRequest(
          "$apiUrl/user-pending-request-cancel",
          method: ApiMethod.POST,
          body: packFormData(
            {'id': id},
          ),
        );
        dio.Response data = await apiRequest.send();

        if (data.statusCode == 200 && data.data != null) {
          // Check if the response indicates success
          if (data.data['status'] == true) {
            showToast("Request Cancel successful.");
          } else {
            // If API call failed, restore the item
            if (itemToRemove != null && itemIndex != null) {
              pendingRequestController.pendingRequestDataList.insert(itemIndex, itemToRemove);
            }
            showToast("Failed to cancel request. Please try again.");
          }
        } else {
          // If API call failed, restore the item
          if (itemToRemove != null && itemIndex != null) {
            pendingRequestController.pendingRequestDataList.insert(itemIndex, itemToRemove);
          }
          showToast("Failed to cancel request. Please try again.");
        }
      }
    } catch (e) {
      // If API call failed, restore the item
      if (id != null) {
        await pendingRequestController.pendingRequestData();
        showToast("Failed to cancel request. Please try again.");
      }
    }
  }

  Future<void> _refreshRequests() async {
    await pendingRequestController.pendingRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(() {
        final requestP =
            pendingRequestController.pendingRequestDataList.toList();

        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (requestP.isNotEmpty)
              Text(
                "pending request".toUpperCase(),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: requestP.map((astrologer) {
                  final nameWords =
                      (astrologer.astroName ?? "Astrologer Name").split(' ');
                  final displayName = nameWords.length > 2
                      ? '${nameWords[0]} ${nameWords[1]}'
                      : astrologer.astroName ?? "Astrologer Name";
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Container(
                        width: 280,
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
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              int? ab = astrologer.id;
                              var id = ab.toString();
                              requestCancel(id);
                            },
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.block,
                                      color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    "Cancel",
                                    style: GoogleFonts.inter(
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
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
