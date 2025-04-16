import 'package:flutter/material.dart';

const colors = <Color>[
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.lightBlueAccent,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0});

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: colors[selectedColor],
    useMaterial3: true,
  );
}