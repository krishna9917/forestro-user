import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDown<T> extends StatelessWidget {
  final T? value;
  final List<T> itemList;
  final void Function(T?)? onChanged;
  final String hintText;
  final TextStyle? hintTextStyle;
  final Color color;
  final EdgeInsets? padding;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool isDense;
  final bool isExpanded;
  final AlignmentGeometry alignment;

  const CustomDropDown({
    super.key,
    required this.value,
    required this.itemList,
    this.onChanged,
    this.boxShadow,
    this.padding,
    this.borderRadius = 100.0,
    this.color = Colors.white,
    this.hintText = "Select",
    this.hintTextStyle,
    this.alignment = Alignment.centerLeft,
    this.isDense = true,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ??
            [
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                blurStyle: BlurStyle.outer,
              ),
            ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isDense: true,
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          alignment: alignment,
          hint: Text(hintText, style: GoogleFonts.inter()),
          items: itemList.map<DropdownMenuItem<T>>((value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text("$value",style:GoogleFonts.inter()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
