import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/controler/ramedy_controler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RemedyScreen extends StatefulWidget {
  const RemedyScreen({super.key});

  @override
  State<RemedyScreen> createState() => _RemedyScreenState();
}

class _RemedyScreenState extends State<RemedyScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(RemedyHistory()).fetchRemedyData();
  }

  @override
  Widget build(BuildContext context) {
    var remedylist = Get.put(RemedyHistory());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Remedy List".toUpperCase(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() {
          if (remedylist.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (remedylist.remedyHistoryDataList.isEmpty) {
            return const Center(child: Text('No remedy history available.'));
          } else {
            return ListView.builder(
              itemCount: remedylist.remedyHistoryDataList.length,
              itemBuilder: (BuildContext context, int index) {
                var remedy = remedylist.remedyHistoryDataList[index];

                return Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      viewImage(
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.orange,
                        ),
                        url: remedy.astroImg,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // const Spacer(),
                      Text(
                        remedy.astrologerName ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Show remedy description in an AlertDialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Remedy Description'),
                                content: Text(
                                  remedy.description ??
                                      'No description available',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("View Remedy"),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
