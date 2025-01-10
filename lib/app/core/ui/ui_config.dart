
import 'package:flutter/material.dart';

class UiConfig {
  
  UiConfig._();

  static String get title => "Cuida Pet";

  static ThemeData get theme => ThemeData(
    primaryColor: const Color.fromARGB(255, 186, 6, 202),
    primaryColorDark: const Color.fromARGB(255, 101, 2, 110),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 186, 6, 202),
      elevation: 0.0,
    ),
  );
}