import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/commingsoon/commingsoon.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/extensions/build_context.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helper/InAppKeys.dart';
import '../../Utils/Quick.dart' show showToast;
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
  final cityController = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pin = TextEditingController();
  String selectedGender = '';
  String selectedState = '';
  String selectedCity = '';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
        "pin_code": pin.text
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

  Future<void> getStateCity() async {
    try {
      final dio = Dio();
      final url = "https://api.postalpincode.in/pincode/${pin.text}";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final res =
            response.data is String ? jsonDecode(response.data) : response.data;

        if (res is List && res.isNotEmpty) {
          final postOffices = res[0]["PostOffice"] as List?;

          if (postOffices != null && postOffices.isNotEmpty) {
            final first = postOffices.first as Map<String, dynamic>;

            final stateValue = first["State"] ?? "";
            final blockValue = first["Block"] ?? "";

            setState(() {
              state.text = stateValue;
              city.text = blockValue;
            });
          } else {
            setState(() {
              state.text = "";
              city.text = "";
            });

            showToast("No post office details found for this pin code.");
          }
        } else {
          showToast("Invalid response format from API.");
        }
      } else {
        setState(() {
          state.text = "";
          city.text = "";
        });
        showToast("Server error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio error: ${e.message}");
      showToast("This pin code is not valid. Please try a different pin code.");
    } catch (e) {
      print("❌ Unexpected error: $e");
      showToast("An unexpected error occurred. Please try again later.");
    }
  }

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
    if (state.text.isEmpty || city.text.isEmpty || pin.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill the required field");
    } else if (pin.text.length < 6) {
      Fluttertoast.showToast(msg: "Please Enter Valid Pin Code");
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
            color: Colors.orange,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Text("${currentPage + 1}/3",
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                const Text("Complete your Profile",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox()
              ],
            ),
            const SizedBox(height: 50),
            buildProgressBar(),
            const SizedBox(height: 50),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // prevent swipe
                onPageChanged: (index) => setState(() => currentPage = index),
                children: [
                  // ------------------ PAGE 1 ------------------
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" Name",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nameController,
                          maxLength: 50,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Name",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(" Gender",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedGender.isEmpty ? null : selectedGender,
                          items: ['Male', 'Female', 'Other'].map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedGender = val!),
                          decoration: InputDecoration(
                            hintText: "Select",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text("Next", style: GoogleFonts.inter()),
                        )
                      ],
                    ),
                  ),

                  // ------------------ PAGE 2 ------------------
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" Date of Birth",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: selectedDate == null
                                ? "Date of Birth"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            suffixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onTap: _showCustomDatePicker,
                        ),
                        const SizedBox(height: 16),
                        Text(" Birth Time",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: selectedTime == null
                                ? "Birth Time"
                                : selectedTime!.format(context),
                            suffixIcon: const Icon(Icons.access_time),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onTap: _showCustomTimePicker,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
                        Text(" Pin Code",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: pin,
                          decoration: InputDecoration(
                            hintText: "Enter PinCode",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onChanged: ((value) {
                            if (value.isNotEmpty && value.length > 5) {
                              getStateCity();
                            }
                          }),
                        ),
                        Text(" Birth State",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: false,
                          controller: state,
                          decoration: InputDecoration(
                            hintText: "Birth State",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(" Birth City",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          enabled: false,
                          controller: city,
                          decoration: InputDecoration(
                            hintText: "Birth City",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
    );
  }
}
