import 'package:flutter/material.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/ExploreAstroPage.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/horoscope_controler.dart';
import 'package:foreastro/controler/horoscope_kundali/chart_image_controler.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';

class AriesPage extends StatefulWidget {
  final String zodiac;
  final String image;
  final String title;

  const AriesPage(
      {super.key,
      required this.zodiac,
      required this.image,
      required this.title});

  @override
  State<AriesPage> createState() => _AriesPageState();
}

class _AriesPageState extends State<AriesPage> {
  int dayIndex = 1;
  final List dayList = ['Yesterday', 'Today', 'Tomorrow'];
  final translator = GoogleTranslator();

  final HoroscopeControler controller = Get.put(HoroscopeControler());
  final CartImageControler cartcontroller = Get.put(CartImageControler());

  @override
  void initState() {
    super.initState();
    // cartcontroller.ChartData();
    // var horor = Get.put(HoroscopeControler()).horoscopeData();
    fetchHoroscope();
  }

  void fetchHoroscope() {
    DateTime currentDate = DateTime.now(); 
    print("Current Date: $currentDate"); 

    int offset = dayIndex - 1; 
    DateTime selectedDate = currentDate.add(
        Duration(days: offset)); 
    print(
        "Selected Date: $selectedDate"); 
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate =
        dateFormat.format(selectedDate); 
    controller.translatedText.value = ''; 
    Get.find<HoroscopeControler>().horoscopeData(widget.zodiac, formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Text(
            "Back".toUpperCase(),
          ),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                widget.image,
                height: 100,
              ),
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text(
            //   "${DateFormat('dd MMM').format(DateTime.now())} - ${DateFormat('dd MMM').format(DateTime.now().add(const Duration(days: 7)))}",
            //   style: const TextStyle(
            //     // color: AppColor.primary,
            //     fontSize: 10,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.9,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(dayList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          dayIndex = index;
                          fetchHoroscope();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: dayIndex == index
                                ? AppColor.primary
                                : Colors.white,
                            border: Border.all(
                                width: 2,
                                color: AppColor.primary.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.only(top: 2),
                          child: Center(
                              child: Text(
                            "${dayList[index]}",
                            style: TextStyle(
                              fontSize: 12,
                              color: dayIndex == index
                                  ? Colors.white
                                  : const Color.fromARGB(255, 42, 42, 42),
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ),
                      ),
                    );
                  })),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "हिंदी",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Obx(() {
                          if (controller.horoscopeDataList.value.response ==
                              null) {
                            return const CircularProgressIndicator(); // show loading indicator
                          } else {
                            return Text(
                              controller.horoscopeDataList.value.response
                                      ?.botResponse ??
                                  'NA',
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 15),
                            );
                          }
                        }),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "English",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Obx(() {
                          String originalText = controller.horoscopeDataList
                                  .value.response?.botResponse ??
                              'NA';

                          if (originalText != 'NA' &&
                              originalText.isNotEmpty &&
                              controller.translatedText.isEmpty) {
                            translator
                                .translate(originalText, from: 'hi', to: 'en')
                                .then((translatedText) {
                              setState(() {
                                controller.translatedText.value =
                                    translatedText.text;
                              });
                            }).catchError((e) {});
                          }
                          String displayText =
                              controller.translatedText.isNotEmpty
                                  ? controller.translatedText.value
                                  : originalText;

                          return Text(
                            displayText,
                            style: const TextStyle(fontSize: 15),
                          );
                        }),
                      ),
                      // Obx(() {
                      //   if (cartcontroller.isLoading.value) {
                      //     return CircularProgressIndicator();
                      //   } else if (cartcontroller.svgData.isNotEmpty) {
                      //     return Center(
                      //       child: SvgPicture.string(
                      //         cartcontroller.svgData.value,
                      //         width: 300,
                      //         height: 300,
                      //       ),
                      //     );
                      //   } else {
                      //     return Text('No image available');
                      //   }
                      // }),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       Get.to(SvgImageView());
                      //     },
                      //     child: Text("image")),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.phone,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            navigate.push(routeMe(const ExploreAstroPage()));
          },
        ),
        bottomNavigationBar: const BottamBar(
          index: 0,
        ));
  }
}
