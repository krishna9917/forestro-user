import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double blurRadius;
  final bool disableBorder;
  final AlignmentGeometry alignment;

  const ShadowContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.disableBorder = false,
    this.blurRadius = 5,
    this.alignment = Alignment.center,
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      alignment: alignment,
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: !disableBorder
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: const Offset(0, 0),
                  blurRadius: blurRadius,
                )
              ],
            )
          : null,
      child: child,
    );
  }
}
