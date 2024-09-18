import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:shimmer/shimmer.dart';

Widget viewImage(
    {double height = 60,
    String? url,
    String? name,
    double width = 60,
    BoxDecoration? boxDecoration,
    TextStyle? textStyle,
    double radius = 100}) {
  return Container(
    decoration: boxDecoration ??
        BoxDecoration(
          color: const Color.fromARGB(255, 223, 219, 198),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 2,
            color: AppColor.primary,
          ),
        ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Builder(builder: (context) {
        if (url == null) {
          return Container(
            height: height,
            width: width,
            decoration: boxDecoration ??
                BoxDecoration(
                  color: const Color.fromARGB(255, 223, 219, 198),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    width: 1,
                    color: AppColor.primary,
                  ),
                ),
            child: Center(
              child: Image.asset(
                'assets/default_profile_pic.png',
                width: 70,
                height: 70,
                fit: BoxFit.fill,
              ),
            ),
          );
        }
        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => viewShimmer(
            height: height,
            width: width,
            boxDecoration: boxDecoration,
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/default_profile_pic.png',
            width: 55,
            height: 55,
            fit: BoxFit.fill,
          ),
        );
      }),
    ),
  );
}

Widget viewShimmer(
    {double height = 100,
    double width = 100,
    BoxDecoration? boxDecoration,
    double radius = 0}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 255, 255, 255),
        highlightColor: const Color.fromARGB(255, 233, 233, 233),
        child: Container(
          width: width,
          height: height,
          decoration: boxDecoration ??
              const BoxDecoration(
                color: Colors.white,
              ),
        ),
      ),
    ),
  );
}
