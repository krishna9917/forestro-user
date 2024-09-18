import 'package:flutter/material.dart';
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
              return const Center(child: CircularProgressIndicator());
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
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3 / 2, // 2:2 ratio
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          var a = controller.blocDataList[index].id;

                          String id = a.toString();
                          navigate.push(routeMe(BlocDetailes(
                            id: id,
                          )));
                        },
                        child: Container(
                          // margin: const EdgeInsets.all(8.0),
                          width: 310,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  controller.blocDataList[index].image ?? 'NA',
                                  width: double.infinity,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                controller.blocDataList[index].title ?? 'NA',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
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
