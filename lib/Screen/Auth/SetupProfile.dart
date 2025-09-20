import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Screen/Kundali/location_page.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/commingsoon/commingsoon.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/extensions/build_context.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/Widgts/title_widget.dart';
import '../../Helper/InAppKeys.dart';
import '../../Utils/Quick.dart' show showToast, scrWeight, scrHeight;
import '../../core/function/navigation.dart' show routeMe;
import '../../Components/CustomWheelDatePicker.dart';
import '../../Components/CustomWheelTimePicker.dart';

class SetupProfileScreen extends StatefulWidget {
  String phone;
  var userId;
  final String? email;
  final String? name;

  SetupProfileScreen(
      {super.key,
      required this.phone,
      required this.userId,
      this.email,
      this.name});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;
  String? selectedValue;
  final nameController = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  String selectedGender = '';
  String selectedState = '';
  String selectedCity = '';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  ExpectAddressLatLog? locationData;

  Future<void> makeNewAccount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user_id = prefs.getString('user_id');
      FormData body = FormData.fromMap({
        'name': nameController.text,
        'gender': selectedGender,
        'date_of_birth':
            "${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year}",
        'birth_time': "${selectedTime?.hour}:${selectedTime?.minute}",
        'city': city.text[0].toUpperCase() + city.text.substring(1),
        'state': state.text,
        "user_id": user_id,
        // "pin_code": pin.text
      });

      ApiRequest apiRequest = ApiRequest("$apiUrl/user-create-profile",
          method: ApiMethod.POST, body: body);
      Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        DateTime eventDate = DateTime(2024, 10, 3);
        DateTime now = DateTime.now();

        if (now.isAfter(eventDate) || now.isAtSameMomentAs(eventDate)) {
          navigate.pushReplacement(routeMe(const HomePage()));
        } else {
          context.goTo(ComingSoonAstrologerPage());
        }
        showToast("Successful Profile Created");
      } else {}
    } on DioException catch (e) {
      if (widget.email != null) {
        showToast(
            "This mobile number is already registered. Please try a different mobile number. ");
      } else {
        showToast(
            "This email ID is already registered. Please try a different email ID.");
      }
    } catch (e) {
      showToast("An unexpected error occurred. Please try again later.");
    } finally {}
  }

  // Future<void> getStateCity() async {
  //   try {
  //     final dio = Dio();
  //     final url = "https://api.postalpincode.in/pincode/${pin.text}";
  //
  //     final response = await dio.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final res =
  //           response.data is String ? jsonDecode(response.data) : response.data;
  //
  //       if (res is List && res.isNotEmpty) {
  //         final postOffices = res[0]["PostOffice"] as List?;
  //
  //         if (postOffices != null && postOffices.isNotEmpty) {
  //           final first = postOffices.first as Map<String, dynamic>;
  //
  //           final stateValue = first["State"] ?? "";
  //           final blockValue = first["Block"] ?? "";
  //
  //           setState(() {
  //             state.text = stateValue;
  //             city.text = blockValue;
  //           });
  //         } else {
  //           setState(() {
  //             state.text = "";
  //             city.text = "";
  //           });
  //
  //           showToast("No post office details found for this pin code.");
  //         }
  //       } else {
  //         showToast("Invalid response format from API.");
  //       }
  //     } else {
  //       setState(() {
  //         state.text = "";
  //         city.text = "";
  //       });
  //       showToast("Server error: ${response.statusCode}");
  //     }
  //   } on DioException catch (e) {
  //     print("❌ Dio error: ${e.message}");
  //     showToast("This pin code is not valid. Please try a different pin code.");
  //   } catch (e) {
  //     print("❌ Unexpected error: $e");
  //     showToast("An unexpected error occurred. Please try again later.");
  //   }
  // }

  void nextPage() {
    if (currentPage == 0) {
      if (nameController.text.isEmpty || selectedGender.isEmpty) {
        Fluttertoast.showToast(msg: "Please fill the required field");
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    } else if (currentPage == 1) {
      if (selectedDate == null || selectedTime == null) {
        Fluttertoast.showToast(msg: "Please fill the required field");
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  void previousPage() {
    if (currentPage >= 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void submitForm() {
    if (state.text.isEmpty || city.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill the required field");
    } else {
      makeNewAccount();
    }
  }

  Widget buildProgressBar() {
    double progress = (currentPage + 1) / 3;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LinearProgressIndicator(
            value: progress,
            color: AppColor.primary,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Text("${currentPage + 1}/3",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ✅ Custom Date Picker using GetX
  void _showCustomDatePicker() async {
    final date = await showCustomWheelDatePicker(
      context: context,
      initialDate: selectedDate,
      title: "Select Date of Birth",
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  // ✅ Custom Time Picker using GetX
  void _showCustomTimePicker() async {
    final time = await showCustomWheelTimePicker(
      context: context,
      initialTime: selectedTime,
      title: "Select Birth Time",
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/bg/auth.png",
          width: scrWeight(context),
          height: scrHeight(context),
          fit: BoxFit.cover,
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentPage != 0
                      ? InkWell(
                          onTap: () {
                            previousPage();
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.arrow_back_ios)),
                        )
                      : const SizedBox(height: 25, width: 25),
                  Text("Complete your Profile",
                      style: GoogleFonts.inter(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25, width: 25),
                ],
              ),
              const SizedBox(height: 50),
              buildProgressBar(),
              const SizedBox(height: 50),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  // prevent swipe
                  onPageChanged: (index) => setState(() => currentPage = index),
                  children: [
                    // ------------------ PAGE 1 ------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputBox(
                            title: "Name",
                            controller: nameController,
                            hintText: "Daksh Prasad",
                            validator: (inp) {
                              if (inp!.isEmpty) {
                                return "Enter Your Name";
                              }
                              return null;
                            },
                          ),
                          Theme(
                            data: ThemeData(
                              inputDecorationTheme: const InputDecorationTheme(
                                contentPadding: EdgeInsets.all(0),
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                            child: SizedBox(
                                width: scrWeight(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 5),
                                      child: Text("Gender",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: SelectBox(
                                        list: const ["Male", "Female", "Other"],
                                        onChanged: (e) {
                                          setState(() {
                                            selectedGender = e;
                                          });
                                        },
                                        // hint: widget.profileData!.gender,
                                        initialItem: selectedGender.isEmpty
                                            ? null
                                            : selectedGender,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text("Next", style: GoogleFonts.inter()),
                          )
                        ],
                      ),
                    ),

                    // ------------------ PAGE 2 ------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(
                            title: "Date of Birth",
                            child: TextFormField(
                              // controller: TextEditingController(text: "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: _showCustomDatePicker,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(164, 255, 255, 255),
                                filled: true,
                                hintStyle: GoogleFonts.inter(
                                    color: Color(0xffA4A4A4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 233, 233, 233),
                                  ),
                                ),
                                hintText: selectedDate == null
                                    ? "Date of Birth"
                                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                suffixIcon: Icon(Icons
                                    .calendar_today), // Change the icon to represent date picking
                              ),
                              readOnly: true,
                            ),
                          ),
                          // Text(" Date of Birth",
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14, fontWeight: FontWeight.w600)),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   readOnly: true,
                          //   decoration: InputDecoration(
                          //     hintText: selectedDate == null
                          //         ? "Date of Birth"
                          //         : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          //     suffixIcon: const Icon(Icons.calendar_today),
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1.5),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   onTap: _showCustomDatePicker,
                          // ),
                          const SizedBox(height: 16),
                          TitleWidget(
                            title: "Birth Time",
                            child: TextFormField(
                              // controller: _birthtimeController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              onTap: _showCustomTimePicker,
                              // validator: (_) => Validator.onlyNum(
                              //     _endtimeController.text, "End_Time_Slot"),
                              decoration: InputDecoration(
                                hintText: selectedTime == null
                                    ? "Birth Time"
                                    : selectedTime!.format(context),
                                // prefix: const Text("Rs. "),
                                fillColor: Color.fromARGB(164, 255, 255, 255),
                                filled: true,
                                hintStyle: GoogleFonts.inter(
                                    color: Color(0xffA4A4A4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 233, 233, 233),
                                  ),
                                ),
                                suffixIcon: const Icon(Icons.access_time),
                              ),
                              readOnly: true,
                            ),
                          ),
                          // Text(" Birth Time",
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14, fontWeight: FontWeight.w600)),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   readOnly: true,
                          //   decoration: InputDecoration(
                          //     hintText: selectedTime == null
                          //         ? "Birth Time"
                          //         : selectedTime!.format(context),
                          //     suffixIcon: const Icon(Icons.access_time),
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1.5),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   onTap: _showCustomTimePicker,
                          // ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text("Next", style: GoogleFonts.inter()),
                          )
                        ],
                      ),
                    ),

                    // ------------------ PAGE 3 ------------------
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CompleteProfileInputBox(
                            title: "Enter Birth Place",
                            textEditingController: TextEditingController(
                                text: "${city.text}, ${state.text}"),
                            readOnly: true,
                            hintText: "Search with city name",
                            prefixIcon: const Icon(Icons.location_on_rounded),
                            onTap: () {
                              Get.to(GoogleMapSearchPlacesApi(
                                onSelect: (e) {
                                  setState(() {
                                    if (e.city?.isEmpty ??
                                        false || (e.state?.isEmpty ?? false)) {
                                      showToast("Please search with city name");
                                    } else {
                                      city.text = e.city ?? "";
                                      state.text = e.state ?? "";
                                      locationData = e;
                                    }
                                  });
                                },
                              ));
                            },
                          ),
                          // Text(" Pin Code",
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14, fontWeight: FontWeight.w600)),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   inputFormatters: [
                          //     LengthLimitingTextInputFormatter(6),
                          //     FilteringTextInputFormatter.digitsOnly
                          //   ],
                          //   controller: pin,
                          //   decoration: InputDecoration(
                          //     hintText: "Enter PinCode",
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1.5),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   onChanged: ((value) {
                          //     if (value.isNotEmpty && value.length > 5) {
                          //       getStateCity();
                          //     }
                          //   }),
                          // ),
                          // Text(" Birth State",
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14, fontWeight: FontWeight.w600)),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   enabled: false,
                          //   controller: state,
                          //   decoration: InputDecoration(
                          //     hintText: "Birth State",
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1.5),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 16),
                          // Text(" Birth City",
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14, fontWeight: FontWeight.w600)),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   enabled: false,
                          //   controller: city,
                          //   decoration: InputDecoration(
                          //     hintText: "Birth City",
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 1.5),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text("Submit"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CompleteProfileInputBox extends StatelessWidget {
  String title;
  TextEditingController? textEditingController;
  int maxLines;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  int? maxLength;
  bool readOnly;
  Widget? prefixIcon;
  Function()? onTap;
  Widget? suffixIcon;
  bool obscureText;
  bool autofocus;
  bool? enable;
  Function(String)? onChanged;
  String? hintText;
  List<TextInputFormatter>? inputFormatter;

  CompleteProfileInputBox(
      {super.key,
      this.keyboardType,
      this.textEditingController,
      required this.title,
      this.validator,
      this.readOnly = false,
      this.onTap,
      this.maxLines = 1,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus = false,
      this.obscureText = false,
      this.maxLength,
      this.enable,
      this.inputFormatter,
      this.onChanged,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Color(0xFF353333),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          onChanged: onChanged,
          inputFormatters: inputFormatter,
          enabled: enable ?? true,
          controller: textEditingController,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                width: 2,
                color: Color(0xFFECE7E4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CompleteProfileSelectBox extends StatelessWidget {
  String title;
  List<String> list;
  String? hintText;
  dynamic Function(String?)? onChanged;

  CompleteProfileSelectBox({
    super.key,
    required this.list,
    this.hintText,
    required this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Color(0xFF353333),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Theme(
          data: ThemeData.light(
            useMaterial3: true,
          ),
          child: CustomDropdown<String>(
            hintText: hintText,
            items: list,
            initialItem: list.first,
            onChanged: onChanged,
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(50),
              closedBorder: Border.all(
                color: const Color(0xFFECE7E4),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
