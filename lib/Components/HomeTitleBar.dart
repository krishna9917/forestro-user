import 'package:flutter/material.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTitleBar extends StatelessWidget {
  final String title;
  final String? desc;

  final void Function()? onClick;

  const HomeTitleBar({
    super.key,
    required this.title,
    this.onClick,
    this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style:  GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Builder(builder: (context) {
                if (desc == null) {
                  return const SizedBox();
                }
                return SizedBox(
                    width: scrWeight(context) - 140,
                    child: Text(
                      "$desc",
                      style:  GoogleFonts.inter(fontSize: 12),
                    ));
              }),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50)),
            child: GestureDetector(
              onTap: onClick,
              child: Text(
                "View All",
                style: GoogleFonts.inter(color: AppColor.primary),
              ),
            ),
          )
        ],
      ),
    );
  }
}
