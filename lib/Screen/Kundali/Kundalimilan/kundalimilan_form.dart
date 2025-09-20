import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Screen/Auth/SetupProfile.dart';
import 'package:foreastro/Screen/Kundali/Kundalimilan/kundalimilan_page.dart';
import 'package:foreastro/Screen/Kundali/location_page.dart';
import 'package:foreastro/controler/horoscope_kundali/chart_image_controler.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KundaliMilanForm extends StatefulWidget {
  const KundaliMilanForm({super.key});

  @override
  State<KundaliMilanForm> createState() => _KundaliMilanFormState();
}

class _KundaliMilanFormState extends State<KundaliMilanForm>
    with SingleTickerProviderStateMixin {
  final profileData = Get.find<ProfileList>();
  final kundaliController = Get.put(KundaliController());
  final kundaliimg = Get.put(CartImageControler());

  final formKey = GlobalKey<FormState>();
  late TextEditingController addressControllerBoy;
  late TextEditingController birthtimeControllerBoy;
  late TextEditingController addressControllerGirl;
  late TextEditingController birthtimeControllerGirl;
  late TextEditingController pujaDateController;
  late TextEditingController latitudeBoy;
  late TextEditingController longitudeBoy;
  late TextEditingController latitudeGirl;
  late TextEditingController longitudeGirl;
  late TextEditingController birthBoy;
  late TextEditingController birthGirl;
  late TextEditingController botBoy;
  late TextEditingController botGirl;
  String puja = "en";

  late AnimationController _animationController;
  late Animation<double> _animation;

  final Map<String, String> languageMap = {
    "English": "en",
    "Hindi": "hi",
  };

  @override
  void initState() {
    super.initState();
    addressControllerBoy = TextEditingController();
    birthtimeControllerBoy = TextEditingController();
    addressControllerGirl = TextEditingController();
    birthtimeControllerGirl = TextEditingController();
    pujaDateController = TextEditingController();
    latitudeBoy = TextEditingController();
    longitudeBoy = TextEditingController();
    latitudeGirl = TextEditingController();
    longitudeGirl = TextEditingController();
    birthBoy = TextEditingController();
    birthGirl = TextEditingController();
    botBoy = TextEditingController();
    botGirl = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    addressControllerBoy.dispose();
    birthtimeControllerBoy.dispose();
    addressControllerGirl.dispose();
    birthtimeControllerGirl.dispose();
    pujaDateController.dispose();
    latitudeBoy.dispose();
    longitudeBoy.dispose();
    latitudeGirl.dispose();
    longitudeGirl.dispose();
    birthBoy.dispose();
    birthGirl.dispose();
    botBoy.dispose();
    botGirl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, double>> fetchCoordinates(String address) async {
    const apiKey = 'AIzaSyBXwHH1AuqJEY9yoxCPD_e04t9hEiYM9SQ';
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['results'][0]['geometry']['location'];
      return {
        'lat': location['lat'],
        'lng': location['lng'],
      };
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  void submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        final coordinatesBoy =
            await fetchCoordinates(addressControllerBoy.text);
        final latBoy = coordinatesBoy['lat'] ?? 0;
        final lonBoy = coordinatesBoy['lng'] ?? 0;

        final dobBoy = birthBoy.text;

        final tobBoy = birthtimeControllerBoy.text;

        final coordinatesGirl =
            await fetchCoordinates(addressControllerGirl.text);
        final latGirl = coordinatesGirl['lat'] ?? 0;
        final lonGirl = coordinatesGirl['lng'] ?? 0;

        final dobGirl = birthGirl.text;

        final tobGirl =
            birthtimeControllerGirl.text; // Use birthtimeControllerGirl

        final lang = puja ?? 'en';

        kundaliController.KundalimilanNorthData(dobBoy, tobBoy, latBoy, lonBoy,
            dobGirl, tobGirl, latGirl, lonGirl, lang);
        kundaliController.KundalimilanSouthData(dobBoy, tobBoy, latBoy, lonBoy,
            dobGirl, tobGirl, latGirl, lonGirl, lang);

        Get.to(() => KundaliMilan());
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            AnimatedBuilder(
              animation: _animation,
              child: Image.asset(
                "assets/icons/task-4.png",
                height: 70,
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + _animation.value * 0.2,
                  child: child,
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text("Kundali Milan",
                  style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " Welcome \nPlease provide some details",
                  style: GoogleFonts.inter(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.w, right: 2.w),
                          child: const Divider(
                            height: 1,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Text(
                        "Boy",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 7.w, left: 2.w),
                          child: const Divider(
                            height: 1,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CompleteProfileInputBox(
                    title: "Boy Birth Of Place",
                    textEditingController: addressControllerBoy,
                    readOnly: true,
                    prefixIcon: const Icon(Icons.location_on_rounded),
                    onTap: () {
                      Get.to(GoogleMapSearchPlacesApi(
                        onSelect: (e) {
                          setState(() {
                            addressControllerBoy.text = e.address;
                          });
                        },
                      ));
                    },
                  ),
                  // TitleWidget(
                  //   title: "Boy Birth Of Place",
                  //   child: TextFormField(
                  //     onTap: () async {
                  //       final selectedAddress = await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) =>
                  //               const GoogleMapSearchPlacesApi(),
                  //         ),
                  //       );
                  //       if (selectedAddress != null) {
                  //         setState(() {
                  //           addressControllerBoy.text = selectedAddress;
                  //         });
                  //       }
                  //     },
                  //     readOnly: true,
                  //     controller: addressControllerBoy,
                  //     validator: (inp) {
                  //       if (inp!.isEmpty) {
                  //         return "Enter your address";
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  const Gap(10),
                  TitleWidget(
                    title: "Boy Birth Time",
                    child: TextFormField(
                      controller: birthtimeControllerBoy,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Birth Time",
                        hintStyle: GoogleFonts.inter(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              int hour = pickedTime.hourOfPeriod == 0
                                  ? 12
                                  : pickedTime
                                      .hourOfPeriod; // Convert hour to 12-hour format
                              String formattedTime =
                                  "${hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                              setState(() {
                                birthtimeControllerBoy.text = formattedTime;
                              });
                            }
                          },
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Gap(3.h),
                  TitleWidget(
                    title: "Boy Date-Of-Birth",
                    child: TextFormField(
                      controller: birthBoy,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "Enter DOB",
                        suffixIcon: IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                              setState(() {
                                birthBoy.text = formattedDate;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                        hintStyle: GoogleFonts.inter(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.w, right: 2.w),
                          child: const Divider(
                            height: 1,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Text(
                        "Girl",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 7.w, left: 2.w),
                          child: const Divider(
                            height: 1,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CompleteProfileInputBox(
                    title: "Boy Birth Of Place",
                    textEditingController: addressControllerGirl,
                    readOnly: true,
                    prefixIcon: const Icon(Icons.location_on_rounded),
                    onTap: () {
                      Get.to(GoogleMapSearchPlacesApi(
                        onSelect: (e) {
                          setState(() {
                            addressControllerGirl.text = e.address;
                          });
                        },
                      ));
                    },
                  ),
                  // TitleWidget(
                  //   title: "Girl Birth Of Place",
                  //   child: TextFormField(
                  //     onTap: () async {
                  //       final selectedAddress = await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) =>
                  //               const GoogleMapSearchPlacesApi(),
                  //         ),
                  //       );
                  //       if (selectedAddress != null) {
                  //         setState(() {
                  //           addressControllerGirl.text = selectedAddress;
                  //         });
                  //       }
                  //     },
                  //     readOnly: true,
                  //     controller: addressControllerGirl,
                  //     validator: (inp) {
                  //       if (inp!.isEmpty) {
                  //         return "Enter your address";
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  const Gap(10),
                  TitleWidget(
                    title: "Girl Birth Time",
                    child: TextFormField(
                      controller: birthtimeControllerGirl,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Birth Time",
                        hintStyle: GoogleFonts.inter(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              int hour = pickedTime.hourOfPeriod == 0
                                  ? 12
                                  : pickedTime
                                      .hourOfPeriod; // Convert hour to 12-hour format
                              String formattedTime =
                                  "${hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                              setState(() {
                                birthtimeControllerGirl.text = formattedTime;
                              });
                            }
                          },
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Gap(3.h),
                  TitleWidget(
                    title: "Girl Date-Of-Birth",
                    child: TextFormField(
                      controller: birthGirl,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "Enter DOB",
                        suffixIcon: IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                              setState(() {
                                birthGirl.text = formattedDate;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                        hintStyle: GoogleFonts.inter(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Gap(2.h),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                "Language",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
              child: SelectBox(
                list: languageMap.keys.toList(),
                onChanged: (e) {
                  setState(() {
                    puja = languageMap[e]!;
                  });
                },
                hint: "Select",
                initialItem: languageMap.keys.firstWhere(
                    (key) => languageMap[key] == puja,
                    orElse: () => "Select"),
              ),
            ),
            Gap(3.h),
            ElevatedButton(
              onPressed: submitForm,
              child: Text("Submit", style: GoogleFonts.inter()),
            ),
          ],
        ),
      ),
    );
  }
}
