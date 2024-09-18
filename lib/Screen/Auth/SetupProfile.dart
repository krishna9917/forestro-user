import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/Utils/validate.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/core/function/pickimage.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> zodiacSigns = [
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces'
];

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
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController city = TextEditingController();
  final _birthtimeController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber? phoneNumber = const PhoneNumber(isoCode: IsoCode.IN, nsn: "");
  String? gender;
  String? state;
  String? sign;
  // String city = "";
  File? _pickedImage;

  @override
  void initState() {
    _phoneController.text = widget.phone;
    // certificationFiles = [];

    if (widget.email != null) {
      email.text = widget.email!;
    }
    if (widget.name != null) {
      name.text = widget.name!;
    }

    super.initState();
  }

  void onSumbit() async {
    if (_formKey.currentState!.validate()) {
      if (gender == null) {
        showToast("Select Your Gender");
      } else if (sign == null) {
        showToast("Select Your Zodiac Sign");
      } else {
        makeNewAccount();
      }
    }
  }

  Future<void> makeNewAccount() async {
    try {
      // Check if profile image is selected
      if (_pickedImage != null && _pickedImage!.path.isNotEmpty) {
        // Upload profile image
        MultipartFile image =
            await addFormFile(_pickedImage!.path, filename: _pickedImage!.path);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? user_id = prefs.getString('user_id');

        // Construct FormData
        FormData body = FormData.fromMap({
          'name': name.text,
          'email': email.text,
          'mobile_number': _phoneController.text,
          'gender': gender,
          'sign': sign,
          'date_of_birth': _birthDateController.text,
          'birth_time': _birthtimeController.text,
          'city': city.text[0].toUpperCase() + city.text.substring(1),
          'state': state,
          "user_id": user_id,
          "profile_image": image,
        });

        ApiRequest apiRequest = ApiRequest("$apiUrl/user-create-profile",
            method: ApiMethod.POST, body: body);
        Response data = await apiRequest.send();
        if (data.statusCode == 201) {
          navigate.push(routeMe(HomePage()));
          showToast("Successful Profile Created");
        } else {}
      } else {
        showToast("Profile pic not uploded");
      }
    } on DioException catch (e) {
      if (widget.email != null) {
        showToast(
            "This mobile number is already registered. Please try a different mobile number. ");
      } else {
        showToast(
            "This email ID is already registered. Please try a different email ID.");
      }

      // showToast(e.message.toString());
    } catch (e) {
      showToast("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await pickImage();

      if (result == null) return;

      setState(() {
        _pickedImage = result.first;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeSighup() async {
    navigate.popUntil((route) => route.isFirst);
    navigate.pushReplacement(routeMe(HomePage()));
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
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
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        "Complete your Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    Gap(3.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                child: _pickedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.file(
                                          _pickedImage!,
                                          fit: BoxFit.cover,
                                          width: 180,
                                          height: 180,
                                        ),
                                      )
                                    : Image.asset(Assets.defaultProfilePic),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFDEDEDE),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    Assets.iconEditPencil,
                                    height: 2.5.h,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputBox(
                              title: "Name",
                              controller: name,
                              readOnly: widget.name != null,
                              validator: (inp) {
                                if (inp!.isEmpty) {
                                  return "Enter Your Name";
                                }
                                return null;
                              },
                            ),
                            InputBox(
                              controller: email,
                              title: "Email",
                              readOnly: widget.email != null,
                              validator: (inp) {
                                if (inp!.isEmpty) {
                                  return "Enter Your Email ID";
                                } else if (!validateEmail(inp)) {
                                  return "Enter Valid Email ID";
                                }
                                return null;
                              },
                            ),
                            widget.phone.isNotEmpty
                                ? TitleWidget(
                                    title: "Phone No",
                                    padding: EdgeInsets.only(left: 3.w),
                                    child: IntlPhoneField(
                                      controller: _phoneController,
                                      showCountryFlag: false,
                                      disableLengthCheck: true,
                                      readOnly: true,
                                      validator: (_) => validatePhoneNumber(
                                          _phoneController.text),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                          // hintStyle: hintTextStyle,
                                          ),
                                      initialCountryCode: 'IN',
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (phone) {},
                                    ),
                                  )
                                : TitleWidget(
                                    title: "Phone No",
                                    padding: EdgeInsets.only(left: 3.w),
                                    child: IntlPhoneField(
                                      controller: _phoneController,
                                      showCountryFlag: false,
                                      disableLengthCheck: true,
                                      // readOnly: true,
                                      validator: (_) => validatePhoneNumber(
                                          _phoneController.text),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                          // hintStyle: hintTextStyle,
                                          ),
                                      initialCountryCode: 'IN',
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (phone) {},
                                    ),
                                  ),

                            // InputBox(
                            //   controller: email,
                            //   title: "Email",
                            //   validator: (inp) {
                            //     if (inp!.isEmpty) {
                            //       return "Enter Your Email ID";
                            //     } else if (!validateEmail(inp)) {
                            //       return "Enter Valid Email ID";
                            //     }
                            //     return null;
                            //   },
                            // ),

                            // /// Phone
                            // TitleWidget(
                            //   title: "Phone No",
                            //   padding: EdgeInsets.only(left: 3.w),
                            //   child: IntlPhoneField(
                            //     controller: _phoneController,
                            //     showCountryFlag: false,
                            //     disableLengthCheck: true,
                            //     // readOnly: true,
                            //     validator: (_) =>
                            //         Validator.phoneNum(_phoneController.text),
                            //     textAlignVertical: TextAlignVertical.center,
                            //     decoration: const InputDecoration(
                            //         // hintStyle: hintTextStyle,
                            //         ),
                            //     initialCountryCode: 'IN',
                            //     inputFormatters: [
                            //       LengthLimitingTextInputFormatter(10),
                            //     ],
                            //     onChanged: (phone) {},
                            //   ),
                            // ),
                            Gap(3.h),
                            Theme(
                              data: ThemeData(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: scrWeight(context) / 2 - 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Text(
                                              "Gender",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: SelectBox(
                                              list: const [
                                                "Male",
                                                "Female",
                                                "Others"
                                              ],
                                              onChanged: (e) {
                                                setState(() {
                                                  gender = e;
                                                });
                                              },
                                              hint: "Select Gender",
                                              initialItem: gender,
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                      width: scrWeight(context) / 2 - 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Text(
                                              "Zodiac Sign",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: SelectBox(
                                              list: zodiacSigns,
                                              onChanged: (e) {
                                                setState(() {
                                                  sign = e;
                                                });
                                              },
                                              initialItem: sign,
                                              hint: "Select Sign",
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Gap(3.h),
                            Theme(
                              data: ThemeData(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Text(
                                              "State",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: SelectBox(
                                              list: const [
                                                "Andhra Pradesh",
                                                "Arunachal Pradesh",
                                                "Assam",
                                                "Bihar",
                                                "Chhattisgarh",
                                                "Goa",
                                                "Gujarat",
                                                "Haryana",
                                                "Himachal Pradesh",
                                                "Jharkhand",
                                                "Karnataka",
                                                "Kerala",
                                                "Madhya Pradesh",
                                                "Maharashtra",
                                                "Manipur",
                                                "Meghalaya",
                                                "Mizoram",
                                                "Nagaland",
                                                "Odisha",
                                                "Punjab",
                                                "Rajasthan",
                                                "Sikkim",
                                                "Tamil Nadu",
                                                "Telangana",
                                                "Tripura",
                                                "Uttar Pradesh",
                                                "Uttarakhand",
                                                "West Bengal",
                                                "Andaman and Nicobar Islands",
                                                "Chandigarh",
                                                "Dadra and Nagar Haveli",
                                                "Daman and Diu",
                                                "Delhi",
                                                "Lakshadweep",
                                                "Puducherry",
                                              ],
                                              onChanged: (e) {
                                                setState(() {
                                                  state = e;
                                                });
                                              },
                                              hint: "Select State",
                                              initialItem: state,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Gap(3.h),
                            InputBox(
                              title: "City",
                              controller: city,
                              validator: (inp) {
                                if (inp!.isEmpty) {
                                  return "Enter Your City";
                                }
                                return null;
                              },
                            ),
                            // TitleWidget(
                            //   title: "City",
                            //   child: TextFormField(
                            //     controller: city,
                            //     autovalidateMode:
                            //         AutovalidateMode.onUserInteraction,
                            //     validator: (inp) {
                            //       if (inp!.isEmpty) {
                            //         return "Enter Your City";
                            //       }
                            //       return null;
                            //     },
                            //     decoration: const InputDecoration(
                            //       hintText: "Enter Your City",
                            //       // hintStyle: hintTextStyle,
                            //     ),
                            //   ),
                            // ),

                            TitleWidget(
                              title: "Enter Birth Time",
                              child: TextFormField(
                                controller: _birthtimeController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                // validator: (_) => Validator.onlyNum(
                                //     _endtimeController.text, "End_Time_Slot"),
                                decoration: InputDecoration(
                                  hintText: "Enter Birth Time",
                                  // prefix: const Text("Rs. "),
                                  hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                  suffixIcon: IconButton(
                                      icon: const Icon(Icons.access_time),
                                      onPressed: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          String formattedTime =
                                              pickedTime.format(context);
                                          setState(() {
                                            _birthtimeController.text =
                                                formattedTime;
                                          });
                                        }
                                      }),
                                ),
                                readOnly: true,
                              ),
                            ),
                            Gap(3.h),
                            TitleWidget(
                              title: "Enter Date-Of-Birth",
                              child: TextFormField(
                                controller: _birthDateController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onTap: () async {
                                  // Show date picker when the text field is tapped
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(
                                        1900), // Adjust as per your requirement
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"; // Format the picked date as needed
                                    setState(() {
                                      // Update the controller or state with the selected date
                                      _birthDateController.text = formattedDate;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  hintText: "Enter Date-Of-Birth",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                  suffixIcon: Icon(Icons
                                      .calendar_today), // Change the icon to represent date picking
                                ),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: scrWeight(context),
                              height: 52,
                              child: ElevatedButton(
                                  onPressed: loading ? null : onSumbit,
                                  child: Builder(builder: (context) {
                                    if (loading) {
                                      return const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                          strokeCap: StrokeCap.round,
                                        ),
                                      );
                                    }
                                    return const Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    );
                                  })),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
