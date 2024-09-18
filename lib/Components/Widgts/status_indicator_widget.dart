import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';

import 'package:gap/gap.dart';

class StatusIndicatorWidget extends StatelessWidget {
  final bool? value;
  final void Function(bool?)? onChanged;

  const StatusIndicatorWidget({super.key, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: EdgeInsets.zero,
      backgroundColor: AppColor.peach,
      visualDensity: const VisualDensity(vertical: -1, horizontal: -4),
      shape: const StadiumBorder(
        side: BorderSide(
          color: AppColor.peach,
        ),
      ),
      label: DropdownButtonHideUnderline(
        child: DropdownButton<bool>(
          isDense: true,
          isExpanded: false,
          value: value,
          alignment: Alignment.centerLeft,
          iconSize: 3.h,
          items: List.generate(
            2,
            (index) => DropdownMenuItem<bool>(
              value: index == 0,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: index == 0 ? Colors.green : Colors.grey,
                  ),
                  Gap(2.w),
                  Text(
                    index == 0 ? "online" : "offline",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: index == 0 ? AppColor.primary : Colors.grey,
                          fontSize: 12.dp,
                        ),
                  ),
                ],
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
