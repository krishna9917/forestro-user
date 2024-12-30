import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Screen/chat/chatprivie_screen.dart';
import 'package:foreastro/controler/chat_history_contaroller.dart';
import 'package:foreastro/model/chat_history_model.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(ChatHistory()).fetchChatHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    var chathistory = Get.put(ChatHistory());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat History".toUpperCase(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() {
          if (chathistory.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (chathistory.chatHistoryDataList.isEmpty) {
            return const Center(child: Text('No chat history available.'));
          } else {
            return ListView.builder(
              itemCount: chathistory.chatHistoryDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ChatListCard(
                      chatData: chathistory.chatHistoryDataList[index]),
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
  final Data chatData;

  const ChatListCard({
    required this.chatData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(" chatData.profilePic==================${chatData.profilePic}");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          viewImage(
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.orange,
            ),
            url: chatData.profilePic,
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatData.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${chatData.date ?? ''} | ${chatData.time ?? ''}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Duration: ${chatData.communicationTime ?? '0'} min",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Amount: ₹${chatData.totalAmount ?? '0'}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                (chatData.status ?? '').toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: (chatData.status?.toLowerCase() == 'accept')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  var chathistro = chatData.astroId.toString();
                  Get.to(() => PreviewChatScreen(astroId: chathistro));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "View History",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
