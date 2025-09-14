import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatPopUpOptions extends StatefulWidget {
  const ChatPopUpOptions({super.key});

  @override
  State<ChatPopUpOptions> createState() => _ChatPopUpOptionsState();
}

class _ChatPopUpOptionsState extends State<ChatPopUpOptions> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'New Chat',
            child:  ListTile(
              leading: const Icon(CupertinoIcons.chat_bubble_2_fill),
              title: Text(
                'Create New Chat',style: GoogleFonts.inter(),
                maxLines: 1,
              ),
            ),
            onTap: () {
              ZIMKit().showDefaultNewPeerChatDialog(context);
            },
          ),
        ];
      },
    );
  }
}
