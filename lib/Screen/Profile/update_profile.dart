import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Kundali/location_page.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Screen/Profile/profilepage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/Utils/assets.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/core/function/pickimage.dart';
import 'package:foreastro/model/profile_model.dart';
import 'package:foreastro/package/phoneinput/src/number_parser/models/iso_code.dart';
import 'package:foreastro/package/phoneinput/src/number_parser/models/phone_number.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  TextEditingController city=TextEditingController();
  TextEditingController state=TextEditingController();
  // TextEditingController pin=TextEditingController();
  final _birthtimeController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber? phoneNumber = const PhoneNumber(isoCode: IsoCode.IN, nsn: "");
  String? gender;

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
    state.text = widget.profileData?.state;
    sign = widget.profileData?.sign;
    // pin.text = widget.profileData?.pinCode??"" ;


    print("gender is $gender" );
  }

  // Future<void> getStateCity() async {
  //   try {
  //     final dio = Dio();
  //     final url = "https://api.postalpincode.in/pincode/${pin.text}";
  //
  //
  //     final response = await dio.get(url);
  //
  //
  //     if (response.statusCode == 200) {
  //       final res = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data;
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
  //
  //
  //           setState(() {
  //             state.text = stateValue;
  //             city.text = blockValue;
  //
  //           });
  //         } else {
  //           setState(() {
  //             state.text = "";
  //             city.text = "";
  //
  //           });
  //
  //           showToast("No post office details found for this pin code.");
  //         }
  //       } else {
  //
  //         showToast("Invalid response format from API.");
  //       }
  //     } else {
  //       print("❌ Server error: ${response.statusCode}");
  //       setState(() {
  //         state.text = "";
  //         city.text = "";
  //
  //       });
  //       showToast("Server error: ${response.statusCode}");
  //     }
  //   } on DioException catch (e) {
  //     print("❌ Dio error: ${e.message}");
  //     showToast("This pin code is not valid. Please try a different pin code.");
  //   } catch (e) {
  //
  //     print("❌ Unexpected error: $e");
  //     showToast("An unexpected error occurred. Please try again later.");
  //   }
  // }

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
      String? finalState = state.text.isNotEmpty ? state.text : widget.profileData?.state ?? '';
      // String? finalPin = pin.text.isNotEmpty ? pin.text : widget.profileData?.pinCode ?? '';
      String? finalSign = sign ?? widget.profileData?.sign;

      // if(pin.text.length<6){
      //   showToast("Enter Valid PinCode");
      //   setState(() {
      //     loading = false;
      //   });
      //   return;
      // }
      if(finalState!.isEmpty || finalCity.isEmpty){
        showToast("Enter Valid PinCode");
        setState(() {
          loading = false;
        });
        return;
      }

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
            // "pin_code": finalPin,
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
                     Center(
                      child: Text(
                        "Complete your Profile",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold, fontSize: 25),),
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
                                           Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Text(
                                              "Gender",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: SelectBox(
                                              list: const [
                                                "Male",
                                                "Female",
                                                "Other"
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
                                           Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Text(
                                              "Zodiac Sign",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold
                                              )


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
                            const SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("    Pin Code",style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),),
                                const SizedBox(height: 10,),
                                // TextFormField(
                                //   inputFormatters: [
                                //     LengthLimitingTextInputFormatter(6),
                                //     FilteringTextInputFormatter.digitsOnly
                                //   ],
                                //   controller: pin,
                                //   decoration: InputDecoration(
                                //
                                //     hintText: "Enter PinCode",
                                //     enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                //       borderRadius: BorderRadius.circular(30),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
                                //       borderRadius: BorderRadius.circular(30),
                                //     ),
                                //   ),
                                //   onChanged: ((value) {
                                //     if (value.isNotEmpty && value.length > 5) {
                                //       getStateCity();
                                //     }
                                //   }),
                                // ),
                                const SizedBox(height: 16),
                                Text("    Birth State",style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),),
                                const SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: (){
                                    Get.to(GoogleMapSearchPlacesApi(
                                      onSelect: (e) {
                                        setState(() {
                                          if(e.city?.isEmpty??false || (e.state?.isEmpty??false)){
                                            showToast("Please search with city name");
                                          }else{
                                            city.text = e.city??"";
                                            state.text = e.state??"";
                                          }
                                        });
                                      },
                                    ));
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    controller: TextEditingController(text: "${city.text}, ${state.text}"),
                                    decoration: InputDecoration(
                                      hintText: "Search with city name",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 16),
                                // Text("    Birth City",style: GoogleFonts.inter(
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w500
                                // ),),
                                // const SizedBox(height: 10,),
                                // TextFormField(
                                //
                                //   enabled: false,
                                //   controller: city,
                                //   decoration: InputDecoration(
                                //     hintText: "Birth City",
                                //     enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                //       borderRadius: BorderRadius.circular(30),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
                                //       borderRadius: BorderRadius.circular(30),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 10,),


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
                                  hintStyle: GoogleFonts.inter(
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
                                  hintStyle: GoogleFonts.inter(
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
                                    return  Text(
                                      "Submit",
                                        style:GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        )

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
