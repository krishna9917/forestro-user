import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  /// get device [height] information
  double get height => MediaQuery.of(this).size.height;

  /// get device [width] information
  double get width => MediaQuery.of(this).size.width;

  /// get [screenPadding]
  EdgeInsets get screenPadding => MediaQuery.of(this).padding;

  /// get current [colorScheme] data
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// get current [textTheme] data
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// get [devicePixelRatio]
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// check [isPortraitMode]
  bool get isPortraitMode =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// check [isLandscapeMode]
  bool get isLandscapeMode =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// get device themeMode or [brightness]
  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  /// Push Page
  Future<void> go(Widget page) async {
    Navigator.push(this, MaterialPageRoute(builder: (context) => page));
  }

  /// Push Replacement
  Future<void> goTo(Widget page) async {
    Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => page));
  }
}
