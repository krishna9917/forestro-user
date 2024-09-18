import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingPage extends StatefulWidget {
  final int? austroid;
  const RatingPage({super.key, required this.austroid});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  TextEditingController reviewcomment = TextEditingController();
  bool loading = false;
  String rating = '';
  Future<void> review() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? user_id = prefs.getString('user_id');

      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/give-review",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'user_id': user_id,
            "astrologer_id": widget.austroid.toString(),
            'rating': rating.toString(),
            'comment': reviewcomment.text,
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      // FormData body = FormData.fromMap({

      // });

      // // Make API request
      // ApiRequest apiRequest =
      //     ApiRequest("$apiUrl/give-review", method: ApiMethod.POST, body: body);
      // Response data = await apiRequest.send();

      // Check response status
      if (data.statusCode == 201) {
        // Extract relevant details from the response
        Get.back();
        // navigate.pushReplacement(routeMe(const ExploreAstroPage()));
        showToast("Successful");
      } else {
       
        showToast("Failed to complete profile. Please try again later.");
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        showToast("You have reviewed this profile.");
      } else if (e is FormatException) {
        
      } else {
        
      }
    } catch (e) {
      
     
      showToast("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("wRITE A rEVIEW".toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Rate",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
            Gap(3.h),
            RatingBar(
              alignment: Alignment.center,
              filledIcon: Icons.star,
              size: 55,
              filledColor: AppColor.primary,
              emptyIcon: Icons.star_border,
              onRatingChanged: (value) {
                debugPrint('$value');
                double ab = value;

                rating = ab
                    .toString(); // Pass the rating value to the review function
              },
              initialRating: 0,
              maxRating: 5,
            ),
            Gap(5.h),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Write Your Review",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
            Gap(2.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: reviewcomment,
                decoration: const InputDecoration(),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            Gap(2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        // navigate.push(routeMe(RatingPage()));
                      },
                      child: const Text("Cancel")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        review();
                      },
                      child: const Text("Submit")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
