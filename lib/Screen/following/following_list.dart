import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  bool loading = false;
  List<Map<String, dynamic>> followingData = [];
  Future<void> follow() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? user_id = prefs.getString('user_id');
      FormData body = FormData.fromMap({
        'user_id': user_id,
      });

      // Make API request
      ApiRequest apiRequest = ApiRequest("$apiUrl/my-following",
          method: ApiMethod.POST, body: body);
      Response data = await apiRequest.send();

      // Check response status
      if (data.statusCode == 201) {
        // Extract relevant details from the response

        setState(() {
          followingData = List<Map<String, dynamic>>.from(data.data['data']);
        });

        // showToast("Successful");
      } else {
        showToast("Failed to complete profile. Please try again later.");
      }
    } on DioException {
     
      showToast("Failed to complete profile. Please try again later.");
    } catch (e) {
      showToast("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> unfollw(String ab) async {
    try {
      FormData body = FormData.fromMap({
        'follower_id': ab,
      });

      // Make API request
      ApiRequest apiRequest =
          ApiRequest("$apiUrl/unfollow", method: ApiMethod.POST, body: body);
      Response data = await apiRequest.send();

      // Check response status
      if (data.statusCode == 201) {
        // Extract relevant details from the response

        setState(() {
          follow();
        });

        showToast("Unfollow Successful");
      } else {
        // Failed API request

        showToast("Failed to complete profile. Please try again later.");
      }
    } on DioException {
      // Handle DioError
    
      showToast("Failed to complete profile. Please try again later.");
    } catch (e) {
      // Handle other exceptions
     
      showToast("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {

    super.initState();
    follow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Following".toUpperCase()),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : ListView.builder(
              itemCount: followingData
                  .length, // Assuming followingData is a List containing the API response
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(followingData[index]
                            ['profile_img'] ??
                        ""), // Use network image for profile image
                  ),
                  title: Row(
                    children: [
                      Text(
                        followingData[index]['astrologier_name'] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          int? id = followingData[index]['id'] ?? "";
                          var ab = id.toString();
                         
                          unfollw(ab);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(
                                  255, 255, 102, 0)), // Change color as needed
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 15), // Adjust padding as needed
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 255, 102,
                                    0), // Specify border color here
                                width: 2, // Specify border width here
                              ), // Adjust border radius as needed
                            ),
                          ),
                        ),
                        child: const Text(
                          "Unfollow",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // Change text color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(followingData[index]['specialization'] ?? ""),
                  // You can add more widgets here to display additional information
                );
              },
            ),
    );
  }
}
