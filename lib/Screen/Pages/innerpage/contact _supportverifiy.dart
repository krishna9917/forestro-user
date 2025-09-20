import 'package:flutter/material.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactVerifiction extends StatefulWidget {
  const ContactVerifiction({super.key});

  @override
  State<ContactVerifiction> createState() => _ContactVerifictionState();
}

class _ContactVerifictionState extends State<ContactVerifiction> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 10), () {
    //   Get.offAll(HomePage());
    // });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                Image.asset(
                  "assets/spiner.png",
                  width: scrWeight(context) + 3000,
                  fit: BoxFit.fill,
                ),
                Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100, right: 50),
                        child: Image.asset(
                          "assets/check-mark.png",
                          width: 200,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                       Text("Your Request Has Been Submitted!",
                          style: GoogleFonts.inter(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Thank you for reaching out to us! \nWe have received your support request and our \nteam  already on it",

                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
