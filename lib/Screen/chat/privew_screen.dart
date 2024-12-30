import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/model/profile_model.dart';
import 'package:photo_view/photo_view.dart';

class PreviewScreen extends StatelessWidget {
  final Certifications certification;
  final bool isImage;
  const PreviewScreen(
      {super.key, required this.certification, this.isImage = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Builder(
                builder: (context) {
                  String ext =
                      certification.certificate.toString().toLowerCase();
                  List<String> imageFile = [
                    'jpg',
                    'jpeg',
                    'png',
                    'webp',
                    'gif'
                  ];
                  if (imageFile.contains(ext) || isImage) {
                    return PhotoView(
                      loadingBuilder: (context, event) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                          strokeCap: StrokeCap.round,
                        );
                      },
                      imageProvider:
                          NetworkImage(certification.certificate.toString()),
                    );
                  }
                  if (ext == "pdf") {
                    return const PDF(
                      swipeHorizontal: true,
                      nightMode: false,
                    ).cachedFromUrl(
                      certification.certificate.toString(),
                      placeholder: (progress) =>
                          Center(child: Text('$progress %')),
                      errorWidget: (error) => Center(
                        child: Text(
                          error.toString(),
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.fileText,
                        size: 150,
                        color: AppColor.primary,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          certification.certificate.toString() +
                              certification.certificate.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                  onPressed: () {
                    // navigateme.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
