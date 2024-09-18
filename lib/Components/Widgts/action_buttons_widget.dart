import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Components/Widgts/custambutton.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onSave,
    this.onCancel,
    this.hideSecondaryButton = false,
    this.color = Colors.white,
    this.primaryButtonText = "Save",
    this.secondaryButtonText = "Cancel",
    this.primaryButtonWidth,
    this.secondaryButtonWidth,
  });

  final String primaryButtonText;
  final String secondaryButtonText;
  final double? primaryButtonWidth;
  final double? secondaryButtonWidth;
  final void Function() onSave;
  final void Function()? onCancel;
  final Color color;
  final bool hideSecondaryButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      constraints: const BoxConstraints(maxHeight: kBottomNavigationBarHeight),
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: hideSecondaryButton
            ? MainAxisAlignment.center
            : MainAxisAlignment.end,
        children: [
          !hideSecondaryButton
              ? CustomButton(
                  height: 5.h,
                  elevation: 0.0,
                  padding: EdgeInsets.zero,
                  width: secondaryButtonWidth ?? 30.w,
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  color: Colors.transparent,
                  text: secondaryButtonText,
                  textColor: AppColor.primary,
                )
              : const SizedBox.shrink(),
          CustomButton(
            height: 5.h,
            padding: EdgeInsets.zero,
            width: primaryButtonWidth ?? 30.w,
            onPressed: onSave,
            text: primaryButtonText,
          ),
        ],
      ),
    );
  }
}
