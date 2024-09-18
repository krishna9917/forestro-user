import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
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
    return Column(
      children: [
        Row(
          children: [
            viewImage(
              boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.orange,
              ),
              url: chatData.profilePic,
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
                        chatData.name ?? '',
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
                            chatData.date ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chatData.time ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            Text(
              (chatData.status ?? '').toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: (chatData.status?.toLowerCase() == 'accept')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
