import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/Screen/livestriming/live_striming.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum ProfileType { Online, Live, Default }

class LiveProfileView extends StatelessWidget {
  final ProfileType type;
  final bool showTitle;

  const LiveProfileView(
      {Key? key, this.type = ProfileType.Live, this.showTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketController = Get.find<SocketController>();
    // Removed the clear() call here

    return Obx(() {
      final liveAstrologers = socketController.liveAstrologers;
      if (liveAstrologers.isEmpty) {
        return  Center(
          child: Text(
            "No astrologers are live",
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }

      return Row(
        children: liveAstrologers.map((astrologer) {
          return GestureDetector(
            onTap: () {
              var liveIdastro = astrologer['liveId'] ?? 'NA';
              Get.to(LivePage(
                liveID: liveIdastro,
              ));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 85,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: type == ProfileType.Default
                                    ? Colors.grey
                                    : Colors.red),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: viewImage(
                            boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.orange,
                            ),
                            url: astrologer['profile'],
                          ),
                        ),
                        if (type == ProfileType.Online)
                          Positioned(
                            right: 10,
                            top: 0,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          )
                        else if (type == ProfileType.Live)
                          Positioned(
                            right: 0,
                            top: 2,
                            child: Container(
                              height: 15,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child:  Center(
                                child: Text(
                                  "⦿ Live",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (showTitle)
                      Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            astrologer['name'] ?? 'NA',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style:  GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            astrologer['data']['specialization'] ?? 'NA',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
