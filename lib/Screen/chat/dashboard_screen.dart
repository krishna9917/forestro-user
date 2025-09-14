import 'package:flutter/material.dart';
import 'package:foreastro/Screen/chat/chat_options.dart';
import 'package:foreastro/Screen/chat/config.dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class DashBoardScreen extends StatefulWidget {
  final String userId;

  const DashBoardScreen({super.key, required this.userId});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff0155FE),
        elevation: 0,
        title:  Text('Chat and Groups',style: GoogleFonts.inter()),
        actions: const [ChatPopUpOptions()],
      ),
      body: Column(
        children: [
          _upperSection(),
          _chatAndGroupsVisibleSection(),
        ],
      ),
    );
  }

  _upperSection() {
    return InkWell(
      onTap: () {
        copyText(widget.userId);
        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(content: Text('Copied',style: GoogleFonts.inter())));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          'User Id: ${widget.userId}',
          style:  GoogleFonts.inter(fontSize: 16),
        ),
      ),
    );
  }

  _chatAndGroupsVisibleSection() {
    return Expanded(child: ZIMKitConversationListView(
      onPressed: (context, conversation, defaultAction) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ZIMKitMessageListPage(
                    conversationID: conversation.id,
                    conversationType: conversation.type)));
      },
    ));
  }
}
