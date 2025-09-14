import 'package:flutter/material.dart';
import 'package:foreastro/Components/Horerscope/innerpage/aries_page.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Horoscope extends StatelessWidget {
  Horoscope({
    super.key,
  });

  final List tasks = [
    {
      "image": "assets/icons/h1.png",
      "title": "Aries",
    },
    {
      "image": "assets/icons/h2.png",
      "title": "Tauras",
    },
    {
      "image": "assets/icons/h3.png",
      "title": "Gemini",
    },
    {
      "image": "assets/icons/h4.png",
      "title": "Cancer",
    },
    {
      "image": "assets/icons/h5.png",
      "title": "Leo",
    },
    {
      "image": "assets/icons/h6.png",
      "title": "Virgo",
    },
    {
      "image": "assets/icons/h7.png",
      "title": "Libra",
    },
    {
      "image": "assets/icons/h8.png",
      "title": "Scorpio",
    },
    {
      "image": "assets/icons/h9.png",
      "title": "Sagittarius",
    },
    {
      "image": "assets/icons/h10.png",
      "title": "Capricorn",
    },
    {
      "image": "assets/icons/h11.png",
      "title": "Aquarius",
    },
    {
      "image": "assets/icons/h12.png",
      "title": "Pisces",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: List.generate(
          tasks.length,
          (index) {
            return GestureDetector(
              onTap: () {
                navigate.push(
                  routeMe(
                    AriesPage(
                      zodiac: (index + 1).toString(),
                      image: tasks[index]['image'],
                      title: tasks[index]['title'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 255, 249, 244),
                        Color.fromARGB(255, 255, 231, 215)
                      ]),
                  border: Border.all(
                    color: AppColor.primary.withOpacity(0.4),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        tasks[index]['image'],
                        width: 60,
                        height: 60,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          tasks[index]['title'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:  GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
