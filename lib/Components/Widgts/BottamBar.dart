import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';


BottomBarItem activeBottamBar(
    {required int index,
    required int activeIndex,
    required String title,
    bool alineRight = false,
    bool alineLeft = false,
    required String activeImage,
    required String inactiveImage}) {
  return BottomBarItem(
    icon: Padding(
      padding: alineRight
          ? EdgeInsets.only(top: 3, right: 20)
          : alineLeft
              ? EdgeInsets.only(top: 3, left: 20)
              : EdgeInsets.only(top: 3, right: 0),
      child: SvgPicture.asset(
        "assets/icons/bottambar/$inactiveImage",
        width: 25,
        height: 25,
      ),
    ),
    title: Padding(
      padding: alineRight
          ? EdgeInsets.only(top: 3, right: 20)
          : alineLeft
              ? EdgeInsets.only(top: 3, left: 20)
              : EdgeInsets.only(top: 3, right: 0),
      child: Text(
        "$title",
        style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: index == activeIndex
                ? AppColor.primary
                : const Color.fromARGB(255, 144, 134, 134)),
      ),
    ),
    backgroundColor: Colors.red,
    selectedIcon: Padding(
      padding: alineRight
          ? EdgeInsets.only(top: 3, right: 20)
          : alineLeft
              ? EdgeInsets.only(top: 3, left: 20)
              : EdgeInsets.only(top: 3, right: 0),
      child: SvgPicture.asset(
        "assets/icons/bottambar/$activeImage",
        width: 25,
        height: 25,
      ),
    ),
  );
}
