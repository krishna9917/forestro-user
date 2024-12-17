import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/chat_history_contaroller.dart';
import 'package:foreastro/model/chat_history_model.dart';
import 'package:get/get.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

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

  Future<void> _fetchChatHistory(BuildContext context) async {
    try {
      String conversationID = "chat45900"; // Replace with valid conversation ID
      ZIMConversationType conversationType = ZIMConversationType.peer;

      ZIMMessageQueryConfig config = ZIMMessageQueryConfig()
        ..count = 50; // Adjust count as needed

      ZIMMessageQueriedResult result =
          await ZIM.getInstance()!.queryHistoryMessage(
                conversationID,
                conversationType,
                config,
              );

      if (result.messageList.isNotEmpty) {
        Get.to(() => ZegoChatHistoryScreen(messages: result.messageList));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No chat history available.")),
        );
      }
    } catch (error) {
      print("Error fetching chat history: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch chat history: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _fetchChatHistory(context);
      },
      // onTap: () {

      //   () => _fetchChatHistory(context);
      // },
      child: Column(
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
              Column(
                children: [
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
                  Text(
                    "Duration: ${chatData.communicationTime ?? ''} min",
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "Amount: ₹${chatData.totalAmount ?? ''}",
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
      ),
    );
  }
}

class ZegoChatHistoryScreen extends StatelessWidget {
  final List<ZIMMessage> messages;

  const ZegoChatHistoryScreen({required this.messages, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: messages.isEmpty
          ? const Center(child: Text('No chat history available.'))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.senderUserID ?? ''),
                  // subtitle: Text(message.content ?? ''),
                  trailing: Text(message.timestamp.toString()),
                );
              },
            ),
    );
  }
}
