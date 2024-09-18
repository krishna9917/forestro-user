import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:dio/dio.dart' as dio;
import 'package:foreastro/core/api/ApiRequest.dart';

class BlocDetailes extends StatefulWidget {
  final String id;
  const BlocDetailes({super.key, required this.id});

  @override
  State<BlocDetailes> createState() => _BlocDetailesState();
}

class _BlocDetailesState extends State<BlocDetailes> {
  String? imageUrl;
  String? title;
  String? description;

  Future<void> blocdetailes() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/blog-details",
        method: ApiMethod.POST,
        body: packFormData(
          {
            'blog_id': widget.id,
          },
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        setState(() {
          imageUrl = data.data['data']['image'];
          title = data.data['data']['title'];
          description = data.data['data']['description'];
        });
      } else {
        showToast("Failed to complete profile. Please try again later.");
      }
    } catch (e) {
      showToast(tosteError);
    }
  }

  @override
  void initState() {
    super.initState();
    blocdetailes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Block Detail".toUpperCase()),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.23,
                      ),
                    ),
                  ),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlWidget(
                      description!,
                    ),
                  ),
                // Spacer(),
              ],
            ),
          ),
          // Spacer(),
          // Positioned(
          //   bottom: 16.0,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: FloatingActionButton(
          //       child: const Text(
          //         "Call ",
          //         style: TextStyle(
          //           fontSize: 15,
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       onPressed: () {
          //         navigate.push(routeMe(const ExploreAstroPage()));
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
