import 'package:flutter/material.dart';
import 'package:foreastro/Components/TaskTabs.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Services Page".toUpperCase(),
        ),
      ),
      body: Center(
        child: TaskTabs(),
      ),
    );
  }
}
