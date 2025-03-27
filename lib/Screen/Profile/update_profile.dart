import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/Profile/profilepage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/Utils/validate.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/core/function/pickimage.dart';
import 'package:foreastro/core/validation/validation.dart';
import 'package:foreastro/model/profile_model.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
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

class UpdateProfileScreen extends StatefulWidget {
  final Data? profileData;

  const UpdateProfileScreen({Key? key, required this.profileData})
      : super(key: key);
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
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
    super.initState();
    // Initialize controllers with default values
    name.text = widget.profileData?.name ?? '';
    email.text = widget.profileData?.email ?? '';
    city.text = widget.profileData?.city ?? '';
    _birthtimeController.text = widget.profileData?.birthTime ?? '';
    _birthDateController.text = widget.profileData?.dateOfBirth ?? '';
    gender = widget.profileData?.gender;
    state = widget.profileData?.state;
    sign = widget.profileData?.sign;
  }

  void onSumbit() async {
    makeNewAccount();
    // if (_formKey.currentState!.validate()) {
    //   if (gender == null) {
    //     showToast("Select Your Gender");
    //   } else if (sign == null) {
    //     showToast("Select Your Zodiac Sign");
    //   } else {

    //   }
    // }
  }

  Future<void> makeNewAccount() async {
    try {
      setState(() {
        loading = true;
      });

      // Check if profile image is selected
      dio.MultipartFile? image;
      if (_pickedImage != null) {
        image =
            await addFormFile(_pickedImage!.path, filename: _pickedImage!.path);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user_id = prefs.getString('user_id');

      // Use existing values if fields are empty
      String finalName =
          name.text.isNotEmpty ? name.text : widget.profileData?.name ?? '';
      String finalEmail =
          email.text.isNotEmpty ? email.text : widget.profileData?.email ?? '';
      String finalCity =
          city.text.isNotEmpty ? city.text : widget.profileData?.city ?? '';
      String finalBirthTime = _birthtimeController.text.isNotEmpty
          ? _birthtimeController.text
          : widget.profileData?.birthTime ?? '';
      String finalBirthDate = _birthDateController.text.isNotEmpty
          ? _birthDateController.text
          : widget.profileData?.dateOfBirth ?? '';
      String? finalGender = gender ?? widget.profileData?.gender;
      String? finalState = state ?? widget.profileData?.state;
      String? finalSign = sign ?? widget.profileData?.sign;

      // Construct FormData
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/user-profile-update",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'name': finalName,
            'email': finalEmail,
            'gender': finalGender,
            'sign': finalSign,
            'date_of_birth': finalBirthDate,
            'birth_time': finalBirthTime,
            'city': finalCity[0].toUpperCase() + city.text.substring(1),
            'state': finalState,
            "user_id": user_id,
            if (image != null) "profile_image": image,
          },
        ),
      );
      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        setState(() {
          final Data? profileData;
          Get.find<ProfileList>().fetchProfileData();
        });
        Get.off(() => const ProfilePage());
        // navigate.pus(routeMe(const ProfilePage()));
        showToast("Profile Updated Successfully");
        print("API request successful: ${data.data}");
      } else {
        print("API request failed with status code: ${data.statusCode}");
        showToast("Failed to update profile. Please try again later.");
      }
    } on DioError catch (e) {
      // Handle DioError
      print("DioError: ${e.message}");
      showToast("Failed to update profile. Please try again later.");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
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
      print("hhhhhhhhhh${_pickedImage}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeSighup() async {
    // TODO: Here Handel All data
    navigate.popUntil((route) => route.isFirst);
    navigate.pushReplacement(routeMe(HomePage()));
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
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 30),
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
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Image.file(
                                            _pickedImage!,
                                            fit: BoxFit.cover,
                                            width: 180,
                                            height: 180,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: SizedBox(
                                            width: 95,
                                            height: 95,
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .profileData!.profileImg,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )),
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
                              hintText: widget.profileData!.name,
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
                              hintText: widget.profileData!.email,
                              // validator: (inp) {
                              //   if (inp!.isEmpty) {
                              //     return "Enter Your Email ID";
                              //   } else if (!validateEmail(inp)) {
                              //     return "Enter Valid Email ID";
                              //   }
                              //   return null;
                              // },
                            ),

                            /// Phone
                            // TitleWidget(
                            //   title: "Phone No",
                            //   padding: EdgeInsets.only(left: 3.w),
                            //   child: IntlPhoneField(
                            //     controller: _phoneController,
                            //     showCountryFlag: false,
                            //     keyboardType: TextInputType.number,
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
                            // Gap(3.h),
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
                                              hint: widget.profileData!.gender,
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
                                              hint: widget.profileData!.sign,
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
                                              hint: widget.profileData!.state,
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
                              hintText: widget.profileData!.city,
                              // validator: (inp) {
                              //   if (inp!.isEmpty) {
                              //     return "Enter Your City";
                              //   }
                              //   return null;
                              // },
                            ),

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
                                  hintText: widget.profileData!.birthTime,
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
                                decoration: InputDecoration(
                                  hintText: widget.profileData!.dateOfBirth,
                                  hintStyle: const TextStyle(
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
