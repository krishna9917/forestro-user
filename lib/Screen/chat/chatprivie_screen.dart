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
            showDialog(
              context: context,
              builder: (context) => AudioPlayerDialog(
                audioUrl: message.audioContent!.fileDownloadUrl,
              ),
            );
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

class AudioPlayerDialog extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerDialog({super.key, required this.audioUrl});

  @override
  _AudioPlayerDialogState createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _playerState = state);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    await _audioPlayer.setSource(UrlSource(widget.audioUrl));
  }

  void _playPause() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _stop() async {
    await _audioPlayer.stop();
  }

  void _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: const Text('Audio Player'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(_playerState == PlayerState.playing
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: _playPause,
                iconSize: 40,
              ),
              Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                onChanged: (value) => _seek(Duration(seconds: value.toInt())),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position)),
              Text(_formatDuration(_duration - _position)),
            ],
          ),
        ],
      ),
      // actions: [
      //   TextButton(
      //     child: const Text('Close'),
      //     onPressed: () {
      //       _stop();
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
    );
  }
}
