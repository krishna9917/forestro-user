import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:get/get.dart';

class ChatSupport extends StatelessWidget {
  const ChatSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();
    return SafeArea(
      child: Scaffold(
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/668cfb2ec3fb85929e3d20bb/1i2bbabtl',
          placeholder: const Center(
            child: CircularProgressIndicator(),
          ),
          visitor: TawkVisitor(
            name: profileController.profileDataList.first.name ?? '',
            email: profileController.profileDataList.first.email ?? '',
          ),
        ),
      ),
    );
  }
}
