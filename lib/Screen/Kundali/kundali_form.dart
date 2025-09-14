import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Screen/Kundali/CombinedDetailsView.dart';
import 'package:foreastro/Screen/Kundali/location_page.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/horoscope_kundali/chart_image_controler.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KundaliForm extends StatefulWidget {
  const KundaliForm({super.key});

  @override
  State<KundaliForm> createState() => _KundaliFormState();
}

class _KundaliFormState extends State<KundaliForm>
    with SingleTickerProviderStateMixin {
  final profileData = Get.find<ProfileList>();
  final kundaliController = Get.put(KundaliController());
  final kundaliimg = Get.put(CartImageControler());

  final formKey = GlobalKey<FormState>();
  late TextEditingController addressController;
  late TextEditingController birthtimeController;
  late TextEditingController pujaDateController;
  late TextEditingController latitude;
  late TextEditingController longitude;
  late TextEditingController birth;
  late TextEditingController name;
  late TextEditingController bot;
  String puja = "en";
  String? planet;

  late AnimationController _animationController;
  late Animation<double> _animation;

  final Map<String, String> languageMap = {
    "English": "en",
    "Hindi": "hi",
  };

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    birthtimeController = TextEditingController();
    pujaDateController = TextEditingController();
    latitude = TextEditingController();
    longitude = TextEditingController();
    DateTime? dateOfBirth;
    String dateOfBirthString =
        profileData.profileDataList.first.dateOfBirth ?? '';
    List<String> dateFormats = [
      'dd/MM/yyyy',
      'dd-MM-yyyy',
      'yyyy/MM/dd',
      'yyyy-MM-dd'
    ];

    for (String format in dateFormats) {
      try {
        dateOfBirth = DateFormat(format).parseStrict(dateOfBirthString);
        break;
      } catch (e) {
        print("Date parsing failed for format $format: $e");
      }
    }

    birth = TextEditingController(
      text: dateOfBirth != null
          ? DateFormat('dd/MM/yyyy').format(dateOfBirth)
          : '',
    );

    final birthTimeString =
        profileData.profileDataList.first.birthTime?.toString() ?? '';
    final birthTimeParts = birthTimeString.split(':');
    final hours = birthTimeParts.length > 0 ? birthTimeParts[0] : '';
    final minutesPart = birthTimeParts.length > 1 ? birthTimeParts[1] : '';

    // Remove any 'AM' or 'PM' from the minutes part
    final minutes = minutesPart.replaceAll(RegExp(r'[^\d]'), '');

    // Pad hours and minutes if they are single digits
    final formattedHours = hours.padLeft(2, '0');
    final formattedMinutes = minutes.padLeft(2, '0');

    final formattedBirthTime = '$formattedHours:$formattedMinutes';

    bot = TextEditingController(text: formattedBirthTime);

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
    addressController.dispose();
    birthtimeController.dispose();
    pujaDateController.dispose();
    latitude.dispose();
    longitude.dispose();
    birth.dispose();
    bot.dispose();
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
        final coordinates = await fetchCoordinates(addressController.text);
        final lat = coordinates['lat'] ?? 0;
        final lon = coordinates['lng'] ?? 0;

        final dob = birth.text;
        final tob = bot.text;
        final lang = puja;
        // final pla = planet ?? 'Jupiter';

        kundaliController.fetchPlanetData(dob, tob, lat, lon, lang);
        kundaliController.AssedentData(dob, tob, lat, lon, lang);
        kundaliController.PersonalCharacteristicsData(dob, tob, lat, lon, lang);
        kundaliController.KpHouseData(dob, tob, lat, lon, lang);
        kundaliController.KpHousePlannet(dob, tob, lat, lon, lang);
        kundaliController.BinnashtakvargaData(dob, tob, lat, lon, lang);
        kundaliController.Vimsotridasa(dob, tob, lat, lon, lang);
        kundaliimg.ChartData(dob, tob, lat, lon, lang);
        kundaliimg.ChartDatas(dob, tob, lat, lon, lang);
        kundaliimg.KpChartData(dob, tob, lat, lon, lang);

        Get.to(() => CombinedDetailsView(
            dob: dob,
            tob: tob,
            place: addressController.text,
            lati: lat,
            long: lon,
            lang: lang));
      } catch (e) {
        print('Error fetching coordinates: $e');
      }
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
                "assets/icons/task-5.png",
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
              child: Text("Kundali",
                  style: GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.w700)),
            ),
             Center(
              child: Padding(
                padding: EdgeInsets.all(4.0),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(
                    title: "Place of Birth",
                    child: TextFormField(
                      onTap: () async {
                        final selectedAddress = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const GoogleMapSearchPlacesApi(),
                          ),
                        );
                        if (selectedAddress != null) {
                          setState(() {
                            addressController.text = selectedAddress;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Search Location",
                      ),
                      readOnly: true,
                      controller: addressController,
                      validator: (inp) {
                        if (inp!.isEmpty) {
                          return "Enter your address";
                        }
                        return null;
                      },
                    ),
                  ),
                  const Gap(10),
                  TitleWidget(
                    title: "Date-Of-Birth",
                    child: TextFormField(
                      controller: birth,
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
                                birth.text = formattedDate;
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
                  const Gap(10),
                  TitleWidget(
                    title: "Time of Birth",
                    child: TextFormField(
                      controller: bot,
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
                                bot.text = formattedTime;
                              });
                            }
                          },
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  // Gap(3.h),

                  // InputBox(
                  //   title: "Date Of Birth",
                  //   controller: birth,
                  //   // readOnly: true,
                  //   hintText: birth.toString(),
                  //   validator: (inp) {
                  //     if (inp!.isEmpty) {
                  //       return "Enter Your DOB";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // InputBox(
                  //   title: "Birth Time",
                  //   controller: bot,
                  //   readOnly: true,
                  //   hintText: bot.toString(),
                  //   validator: (inp) {
                  //     if (inp!.isEmpty) {
                  //       return "Enter Your Birth Time";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  Gap(2.h),
                   Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
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
                  Gap(2.h),
                  Gap(2.h),
                  SizedBox(
                    width: scrWeight(context),
                    height: 52,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      child:  Text(
                        "Submit",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
