import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Screen/Pages/HomePage.dart';
import 'dart:async';
import 'package:foreastro/Utils/Quick.dart';

class ComingSoonAstrologerPage extends StatefulWidget {
  @override
  _ComingSoonAstrologerPageState createState() =>
      _ComingSoonAstrologerPageState();
}

class _ComingSoonAstrologerPageState extends State<ComingSoonAstrologerPage>
    with SingleTickerProviderStateMixin {
  DateTime eventDate = DateTime(2024, 9, 27);
  late AnimationController _controller; // Animation Controller
  List<String> astrologerImages = [
    'assets/pandit.png',
    'assets/pandit.png',
    'assets/pandit.png',
    // Add more images as needed
  ];
  late Timer _timer; // Timer variable
  int daysLeft = 0;
  int hoursLeft = 0;
  int minutesLeft = 0;
  int secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final difference = eventDate.difference(now);

    if (difference.isNegative) {
      _timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      setState(() {
        daysLeft = difference.inDays;
        hoursLeft = difference.inHours % 24;
        minutesLeft = difference.inMinutes % 60;
        secondsLeft = difference.inSeconds % 60;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String astrologerImage =
        astrologerImages[DateTime.now().day % astrologerImages.length];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 0.9 * 2.14,
                        child: Image.asset(
                          "assets/spiner.png",
                          width: scrWeight(context) + 3000,
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                              child: Image.asset("assets/astro.png",
                                  height: 30.h))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Coming Soon...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeBox(daysLeft, 'Days'),
                  const SizedBox(width: 8),
                  _buildTimeBox(hoursLeft, 'Hours'),
                  const SizedBox(width: 8),
                  _buildTimeBox(minutesLeft, 'Minutes'),
                  const SizedBox(width: 8),
                  _buildTimeBox(secondsLeft, 'Seconds'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTimeBox(int timeValue, String label) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          '$timeValue',
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    ),
  );
}
