import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:dio/dio.dart' as dio;
import 'package:foreastro/core/api/ApiRequest.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool isLoading = true;

  Future<void> blocdetailes() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        "$apiUrl/blog-details",
        method: ApiMethod.POST,
        body: packFormData(
          {'blog_id': widget.id},
        ),
      );
      dio.Response data = await apiRequest.send();
      if (data.statusCode == 201) {
        setState(() {
          imageUrl = data.data['data']['image'];
          title = data.data['data']['title'];
          description = data.data['data']['description'];
          isLoading = false;
        });
      } else {
        showToast("Failed to complete profile. Please try again later.");
      }
    } catch (e) {
      showToast(tosteError);
      setState(() {
        isLoading = false;
      });
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
        title: Text("Blog Detail".toUpperCase()),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.23,
                    ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title!,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HtmlWidget(description!),
                    ),
                ],
              ),
            ),
    );
  }
}
