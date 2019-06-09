import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    accentColor: Colors.redAccent,
    buttonColor: Colors.deepOrange);

final ThemeData _iosTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    accentColor: Colors.deepOrangeAccent,
    buttonColor: Colors.deepOrange);

ThemeData getAdaptiveTheme(context) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? _iosTheme
      : _androidTheme;
}
