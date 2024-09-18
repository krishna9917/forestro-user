import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final String subTitle;

  const TitleWidget({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.black54, fontWeight: FontWeight.w400),
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
