import 'package:flutter/material.dart';
import 'package:foreastro/controler/horoscope_kundali/chart_image_controler.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartImageControler controller = Get.put(CartImageControler());

    return Scaffold(
      appBar: AppBar(
        title: Text('SVG Image'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.svgData.isNotEmpty) {
          return Center(
            child: SvgPicture.string(
              controller.svgData.value,
              width: 300,
              height: 300,
            ),
          );
        } else {
          return Center(child: Text('No SVG data available'));
        }
      }),
    );
  }
}
