import 'package:flutter/material.dart';
import 'package:foreastro/Components/Widgts/colors.dart';

class BGGradientWidget extends StatelessWidget {
  const BGGradientWidget({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.bgTopMargin,
    this.useBG = true,
  });

  final Widget child;
  final double? height;
  final double? width;
  final double? bgTopMargin;
  final bool useBG;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// BACKGROUND
        Stack(
          children: [
            Container(
              height: height ?? MediaQuery.of(context).size.height,
              width: width ?? MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.secondary,
                    Colors.white,
                    Colors.white,
                    Colors.white,
                  ],
                  stops: [0, 0.3, 0.3, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// Background
            // Visibility(
            //   visible: useBG,
            //   child: Container(
            //     margin: EdgeInsets.only(top: bgTopMargin ?? 0.0),
            //     decoration: const BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage(Assets.bgAstroPng),
            //         fit: BoxFit.fitWidth,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),

        /// Child Widget
        child,
      ],
    );
  }
}
