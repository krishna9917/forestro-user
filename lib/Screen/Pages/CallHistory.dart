import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/call_histrory_controller.dart';
import 'package:foreastro/model/call_history_model.dart';
import 'package:get/get.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(CallHistory()).fetchCallHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    var callhistory = Get.put(CallHistory());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Call History".toUpperCase(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() {
          if (callhistory.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (callhistory.CallHistoryDataList.isEmpty) {
            return const Center(child: Text('No call history available.'));
          } else {
            return ListView.builder(
              itemCount: callhistory.CallHistoryDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ChatListCard(
                      callData: callhistory.CallHistoryDataList[index]),
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class ChatListCard extends StatelessWidget {
  final Data callData;

  const ChatListCard({
    required this.callData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            viewImage(
              boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.orange,
              ),
              url: callData.profilePic,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        callData.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            callData.date ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            callData.time ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                  height: 30,
                  callData.type == 'audio'
                      ? "assets/audio.png"
                      : "assets/videocall.png"),
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  (callData.status ?? '').toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: (callData.status?.toLowerCase() == 'accept')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  "CallDuration: ${callData.callDuration ?? ''}",
                  style:
                      const TextStyle(fontSize: 8, fontWeight: FontWeight.w900),
                ),
                Text(
                  "Charges: ${callData.totalAmount ?? ''}",
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
