import 'package:flutter/material.dart';
import 'package:foreastro/Components/Horerscope/horerscope.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/ExploreAstroPage.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:google_fonts/google_fonts.dart';

class HorerscopePage extends StatefulWidget {
  const HorerscopePage({super.key});

  @override
  State<HorerscopePage> createState() => _HorerscopePageState();
}

class _HorerscopePageState extends State<HorerscopePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Text(
            "Horoscope".toUpperCase(),
            style: GoogleFonts.inter(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Horoscope(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.phone,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            navigate.push(routeMe(const ExploreAstroPage()));
          },
        ),
        bottomNavigationBar: const BottamBar(
          index: 0,
        ));
  }
}
