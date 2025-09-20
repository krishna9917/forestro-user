import 'package:flutter/material.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/innerpage/youtub_play.dart';
import 'package:foreastro/controler/celebrity_controler.dart';
import 'package:foreastro/core/function/navigation.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Celebinsights extends StatefulWidget {
  const Celebinsights({Key? key}) : super(key: key);

  @override
  State<Celebinsights> createState() => _CelebinsightsState();
}

class _CelebinsightsState extends State<Celebinsights> {
  Future<void> _refreshData() async {
    await Get.find<CelibrityList>().celibrityData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Celeb insights".toUpperCase(), textAlign: TextAlign.left),
      ),
      body: GetBuilder<CelibrityList>(
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading) {
              // Shimmer effect during loading
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 5, // Number of shimmer placeholders
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      height: 140,
                      color: Colors.white,
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                  itemCount: controller.celibrityDataList.length,
                  itemBuilder: (context, index) {
                    final celebrity = controller.celibrityDataList[index];
                    var videoUrl = celebrity.video?.toString() ?? '';
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 190,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: InkWell(
                              onTap: () {
                                if (videoUrl.isNotEmpty) {
                                  navigate.push(routeMe(VideoPlay(
                                    videoUrl: videoUrl,
                                  )));
                                } else {
                                  print(
                                      'Video URL is null, cannot play video.');
                                }
                              },
                              child: CachedNetworkImage(
                                imageUrl: celebrity.thumbnail ??
                                    'https://via.placeholder.com/550x140.png?text=No+Image',
                                width: 550,
                                height: 170,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              celebrity.title ?? 'NA',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          });
        },
      ),
    );
  }
}
