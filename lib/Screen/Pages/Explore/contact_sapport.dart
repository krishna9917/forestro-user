import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Screen/Pages/innerpage/contact%20_supportverifiy.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:foreastro/core/validation/validation.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  Future contactsupport() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/contact-us",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'name': name.text,
            'email': email.text,
            'phone': phoneController.text,
            'descreption': discriptionController.text,
            'type': 'user'
          },
        ),
      );
      dio.Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        Get.off(const ContactVerifiction());
      } else {
        showToast("Failed to complete profile. Please try again later.");
      }
    } catch (e) {
      showToast(tosteError);
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customer Support".toUpperCase(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  InputBox(
                    title: "Name",
                    controller: name,
                    hintText: "Enter Name ",
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
                    hintText: "Enter here Email",
                  ),
                  TitleWidget(
                    title: "Phone No",
                    padding: EdgeInsets.only(left: 3.w),
                    child: IntlPhoneField(
                      controller: phoneController,
                      showCountryFlag: false,
                      keyboardType: TextInputType.number,
                      disableLengthCheck: true,
                      validator: (_) =>
                          Validator.phoneNum(phoneController.text),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(),
                      initialCountryCode: 'IN',
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (phone) {},
                    ),
                  ),
                  Gap(3.h),
                  InputBox(
                    controller: discriptionController,
                    title: "Please Write Your Issue",
                    hintText: "Write here...",
                  ),
                  Gap(2.h),
                  SizedBox(
                    width: scrWeight(context),
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          contactsupport();
                        }
                      },
                      child: Text(
                        "Submit",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
