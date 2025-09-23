import 'package:flutter/material.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:foreastro/constants/zego_keys.dart';

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  const LivePage({Key? key, required this.liveID, this.isHost = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileList>();
    dynamic user_id = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.userId
        : '';

    String name = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.name
        : '';

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: ZegoKeys.liveAppID,
        appSign: ZegoKeys.liveAppSign,
        userID: user_id.toString(),
        userName: name.toString().split(' ').first,
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
