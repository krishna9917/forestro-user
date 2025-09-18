import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

var outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(50),
  borderSide: BorderSide(width: 1, color: AppColor.primary),
);

ThemeData appTheme = ThemeData(
    fontFamily: "assets/fonts/Inter_18pt-Regular.ttf",
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.bgcolor,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) {
        return const Icon(
          FontAwesomeIcons.arrowLeft,
          size: 23,
        );
      },
    ),
    appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColor.bgcolor,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(AppColor.primary),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide.none,
          ),
        ),
        textStyle:  WidgetStatePropertyAll(
          GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedErrorBorder: outlineInputBorder,
      errorBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColor.primary,
        selectionColor: AppColor.bgcolor,
        selectionHandleColor: AppColor.primary //thereby
        ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(TextStyle(color: AppColor.primary)),
        foregroundColor: WidgetStatePropertyAll(AppColor.primary),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      elevation: 0.0,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: AppColor.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    ));
