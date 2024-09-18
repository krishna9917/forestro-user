import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/theme/Colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.elevation,
    this.color,
    this.child,
    this.textColor,
    this.padding,
    this.borderRadius = 30,
    this.text = '',
    required this.onPressed,
    this.loading = false,
  });

  final double? height;
  final double? width;
  final double? elevation;
  final Color? color;
  final Color? textColor;
  final String text;
  final void Function() onPressed;
  final Widget? child;
  final double borderRadius;
  final EdgeInsets? padding;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      color: color ?? AppColor.primary,
      height: height,
      minWidth: width ?? 75.w,
      padding: padding ?? EdgeInsets.symmetric(vertical: 1.5.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      onPressed: loading ? () {} : onPressed,
      child: child ??
          (loading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                    strokeCap: StrokeCap.round,
                  ))
              : Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: textColor ?? Colors.white),
                )),
    );
  }
}
