import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
NavigatorState? navigateMe = navigatorKey.currentState;

MaterialPageRoute routeMe(Widget screen) {
  return MaterialPageRoute(
    builder: (context) => screen,
  );
}
