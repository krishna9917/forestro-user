import 'package:flutter/material.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/innerpage/youtub_play.dart';
import 'package:foreastro/controler/celebrity_controler.dart';
import 'package:foreastro/core/function/navigation.dart';
import 'package:get/get.dart';

class Celebinsights extends StatefulWidget {
  const Celebinsights({super.key});

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
        //        centerTitle: false,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 0.0), // remove default padding
        //   child: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       // handle back button press
        //     },
        //   ),
        // ),
        title: Text("Celeb insights".toUpperCase(), textAlign: TextAlign.left),
      ),
      body: GetBuilder<CelibrityList>(
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return RefreshIndicator(
                onRefresh: _refreshData,
                child: Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      controller.celibrityDataList.length,
                      (index) {
                        final celebrity = controller.celibrityDataList[index];
                        var videoUrl = celebrity.video.toString();
                       

                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: InkWell(
                                  onTap: () {
                                    if (videoUrl != null) {
                                      navigate.push(routeMe(VideoPlay(
                                        videoUrl: videoUrl,
                                      )));
                                    } else {
                                     
                                    }
                                  },
                                  child: Image.network(
                                    celebrity.thumbnail ??
                                        'https://via.placeholder.com/550x140.png?text=No+Image',
                                    width: 550,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  celebrity.title ?? 'NA',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
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
                  ),
                ),
              );
            }
          });
        },
      ),
    );
  }
}
