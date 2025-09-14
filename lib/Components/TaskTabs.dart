import 'package:flutter/material.dart';
import 'package:foreastro/Components/Horerscope/horerscope_page.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Kundali/Kundalimilan/kundalimilan_form.dart';
import 'package:foreastro/Screen/Kundali/kundali_form.dart';
import 'package:foreastro/Screen/Pages/Explore/ExploreAstroPage.dart';
import 'package:foreastro/Screen/Pages/Explore/online_puja.dart';
import 'package:foreastro/core/function/navigation.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTabs extends StatelessWidget {
  TaskTabs({
    super.key,
  });

  final List tasks = [
    {
      "image": "assets/icons/task-1.png",
      "title": "Talk to Astrologer",
      "onTap": () {
        navigate.push(routeMe(const ExploreAstroPage()));
      }
    },
    {
      "image": "assets/icons/task-2.png",
      "title": "Chat with Astrologer",
      "onTap": () {
        navigate.push(routeMe(const ExploreAstroPage()));
      }
    },
    {
      "image": "assets/icons/task-3.png",
      "title": "Online Pooja ",
      "onTap": () {
        navigate.push(routeMe(const OnlinePuja()));
      }
    },
    {
      "image": "assets/icons/task-4.png",
      "title": "Kundali Milan",
      "onTap": () {
        navigate.push(routeMe(const KundaliMilanForm()));
      }
    },
    {
      "image": "assets/icons/task-5.png",
      "title": "Free Kundali",
      "onTap": () {
        navigate.push(routeMe(const KundaliForm()));
      }
    },
    {
      "image": "assets/icons/task-6.png",
      "title": "Daily Horoscope",
      "onTap": () {
        navigate.push(routeMe(const HorerscopePage()));
        // Horoscope();
      }
    }
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
              onTap: tasks[index]['onTap'],
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
                        width: 43,
                        height: 43,
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
                            fontSize: 10,
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
