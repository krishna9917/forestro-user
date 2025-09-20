import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Screen/chat/chatprivie_screen.dart';
import 'package:foreastro/controler/chat_history_contaroller.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/model/chat_history_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final profileController = Get.find<ProfileList>();

  @override
  void initState() {
    super.initState();
    chatzegocloud();
    Get.put(ChatHistory()).fetchChatHistoryData();
  }

  Future<void> chatzegocloud() async {
    await ZIMKit().init(
        appID: 1432355811,
        appSign:
            'fb0256f502da88184adb163037bd05d7d26bf3ac029ca9d38d4a071f3f52bdfd');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');

    if (user_id == null) {
      print('User ID not found in SharedPreferences');
      return;
    }

    String profile = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.profileImg
        : '';

    String name = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.name
        : '';

    if (name.isEmpty) {
      print("Name not found");
      return;
    }

    print("name=======$name $user_id $profile  --   $user_id-user");

    await ZIMKit().connectUser(
      id: "$user_id-user",
      name: name,
      avatarUrl: profile,
    );
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
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.primary,
              ),
            );
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
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${chatData.date ?? ''} | ${chatData.time ?? ''}",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Duration: ${chatData.communicationTime ?? '0'} min",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Amount: ₹${chatData.totalAmount ?? '0'}",
                  style: GoogleFonts.inter(
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
                style: GoogleFonts.inter(
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
                  ZIMKit().init(
                      appID: 2007373594,
                      appSign:
                          '387754e51af7af0caf777a6a742a2d7bcfdf3ea1599131e1ff6cf5d1826649ae');
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
                child: Text(
                  "View History",
                  style: GoogleFonts.inter(
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
