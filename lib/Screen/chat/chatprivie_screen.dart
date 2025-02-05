import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Screen/chat/privew_screen.dart';
import 'package:foreastro/model/profile_model.dart';
import 'package:foreastro/theme/AppTheme.dart';
import 'package:get/get.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class PreviewChatScreen extends StatelessWidget {
  final String astroId;
  const PreviewChatScreen({
    super.key,
    required this.astroId,
  });

  void initState() {
    ZIMKit().init(
        appID: 2007373594,
        appSign:
            '387754e51af7af0caf777a6a742a2d7bcfdf3ea1599131e1ff6cf5d1826649ae');
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    void playAudio(String url) async {
      await player.play(UrlSource(url));
    }

    // print(id);
    return Theme(
      data: appTheme.copyWith(),
      child: ZIMKitMessageListPage(
        // showOnly: true,
        showPickMediaButton: false,
        showMoreButton: false,
        showPickFileButton: false,
        messageInputKeyboardType: TextInputType.none,
        inputBackgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),

        // messageListBackgroundBuilder: (context, defaultWidget) {
        //   return Image.asset(
        //     AssetsPath.chatBgSvg,
        //     width: context.windowWidth,
        //     height: context.windowHeight,
        //     fit: BoxFit.cover,
        //   );
        // },
        appBarBuilder: (context, defaultAppBar) {
          return AppBar(
            title: defaultAppBar.title,
          );
        },
        onMessageItemPressed: (context, message, defaultAction) {
          if (message.type == ZIMMessageType.image) {
            Get.to(
              PreviewScreen(
                isImage: true,
                certification: Certifications(
                  certificate: message.imageContent!.fileDownloadUrl,
                  certificateId: DateTime.now().microsecondsSinceEpoch,
                  fileSize: message.imageContent!.fileSize.toString(),
                ),
              ),
            );
          } else if (message.type == ZIMMessageType.audio) {
            print(
                "Playing audio from URL: ${message.audioContent!.fileDownloadUrl}");
            playAudio(message.audioContent!.fileDownloadUrl);
          }
        },
        onMessageSent: (e) {
          print(e);
        },
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
        showRecordButton: false,
        conversationID: "${astroId}-astro",
        conversationType: ZIMConversationType.peer,
      ),
    );
  }
}
