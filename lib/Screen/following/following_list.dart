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
    setState(() {
      loading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user_id = prefs.getString('user_id');
      FormData body = FormData.fromMap({'user_id': user_id});

      ApiRequest apiRequest = ApiRequest("$apiUrl/my-following",
          method: ApiMethod.POST, body: body);
      Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        setState(() {
          followingData = List<Map<String, dynamic>>.from(data.data['data']);
        });
      } else {
        showToast("Failed to retrieve following list. Please try again.");
      }
    } on DioException {
      showToast("Failed to retrieve following list. Please try again.");
    } catch (e) {
      showToast("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> unfollow(String ab) async {
    setState(() {
      loading = true;
    });

    try {
      FormData body = FormData.fromMap({'follower_id': ab});

      ApiRequest apiRequest =
          ApiRequest("$apiUrl/unfollow", method: ApiMethod.POST, body: body);
      Response data = await apiRequest.send();

      if (data.statusCode == 201) {
        follow(); // Refresh list after unfollowing
        showToast("Unfollowed Successfully");
      } else {
        showToast("Failed to unfollow. Please try again.");
      }
    } on DioException {
      showToast("Failed to unfollow. Please try again.");
    } catch (e) {
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
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 102, 0),
              ),
            )
          : followingData.isEmpty
              ? Center(
                  child: Text(
                    "You are not following anyastrologers.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemCount: followingData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                followingData[index]['profile_img'] ?? ""),
                          ),
                          title: Text(
                            followingData[index]['astrologier_name'] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            followingData[index]['specialization'] ?? "",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              int? id = followingData[index]['id'] ?? "";
                              var ab = id.toString();
                              unfollow(ab);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 255, 102, 0)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                              ),
                            ),
                            child: const Text(
                              "Unfollow",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
