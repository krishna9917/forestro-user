import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/bloc_detailes.dart';
import 'package:foreastro/controler/bloc_controler.dart';
import 'package:foreastro/core/function/navigation.dart';
import 'package:get/get.dart';

class BlocViewAll extends StatefulWidget {
  const BlocViewAll({super.key});

  @override
  State<BlocViewAll> createState() => _BlocViewAllState();
}

class _BlocViewAllState extends State<BlocViewAll> {
  Future<void> _refreshData() async {
    await Get.find<BlocList>().blocData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Latest blogs".toUpperCase(),
          textAlign: TextAlign.left,
        ),
      ),
      body: GetBuilder<BlocList>(
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading) {
              // Shimmer effect while loading
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GridView.builder(
                    itemCount: 6, // Placeholder count for shimmer
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshData,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.blocDataList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      final blocData = controller.blocDataList[index];
                      final String id = blocData.id?.toString() ?? '';
                      final String imageUrl = blocData.image ?? '';
                      final String title = blocData.title ?? 'NA';

                      return GestureDetector(
                        onTap: () {
                          navigate.push(routeMe(BlocDetailes(id: id)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl.isNotEmpty
                                      ? imageUrl
                                      : 'https://via.placeholder.com/450x140.png?text=No+Image',
                                  width: double.infinity,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
