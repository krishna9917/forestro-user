import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool disableShadowContainer;
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? hintText; // Add a hintText property

  const TitleWidget({
    super.key,
    required this.title,
    required this.child,
    this.disableShadowContainer = false,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.borderRadius = 30.0,
    this.hintText, // Add hintText to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Text(
            title,
            style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        if (hintText != null) // Conditionally show hintText if it's not null
          Padding(
            padding: EdgeInsets.only(left: 5.w, top: 0.5.h),
            child: Text(
              hintText!,
              style: GoogleFonts.inter(
                    color: Colors.grey,
                  ),
            ),
          ),
        Gap(1.h),
        child,
      ],
    );
  }
}
