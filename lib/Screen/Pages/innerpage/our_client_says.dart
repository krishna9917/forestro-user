import 'package:flutter/material.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/listof_termination_controler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OurClientSays extends StatefulWidget {
  const OurClientSays({super.key});

  @override
  State<OurClientSays> createState() => _OurClientSaysState();
}

class _OurClientSaysState extends State<OurClientSays> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client Says".toUpperCase()),
      ),
      body: GetBuilder<ClientSays>(
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: controller.clientsaysDataList.length,
                itemBuilder: (context, index) {
                  final data = controller.clientsaysDataList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: AppColor.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: data.image != null
                                    ? Image.network(
                                        data.image!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      )
                                    : const Icon(Icons.person, size: 50),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.name ?? 'NA',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (data.rating != null)
                                      Row(
                                        children: List.generate(
                                          double.parse(data.rating.toString())
                                              .toInt(), // Parse as double and then to integer
                                          (_) => const Icon(
                                            Icons.star,
                                            color: AppColor.primary,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              data.comment ?? 'NA',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:  GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          });
        },
      ),
    );
  }
}
