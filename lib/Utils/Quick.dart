import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double scrHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double scrWeight(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

MaterialPageRoute routeMe(Widget Screen) {
  return MaterialPageRoute(
    builder: (context) => Screen,
  );
}

void showToast(
  String msg, {
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastGravity? gravity,
  int timeInSecForIosWeb = 1,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}
