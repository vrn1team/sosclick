import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    accentColor: Colors.deepPurpleAccent,
    buttonColor: Colors.deepPurple);

final ThemeData _iosTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    accentColor: Colors.deepPurpleAccent,
    buttonColor: Colors.deepPurple);

ThemeData getAdaptiveTheme(context) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? _iosTheme
      : _androidTheme;
}
