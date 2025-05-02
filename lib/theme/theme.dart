import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightMode = ThemeData(
  textTheme: GoogleFonts.actorTextTheme(),
  colorScheme: const ColorScheme(
    tertiary: Color.fromARGB(255, 0, 0, 0),
    brightness: Brightness.light,
    primary:  Color.fromARGB(255, 185, 208, 241),
    onPrimary:  Color.fromARGB(255, 0, 0, 0),
    secondary:  Color.fromARGB(255, 123, 165, 228),
    onSecondary:  Color.fromARGB(255, 252, 109, 209),
    surface:  Color.fromARGB(255, 255, 255, 255),
    onSurface:  Color.fromARGB(255, 0, 0, 0),
    onPrimaryContainer:  Color.fromARGB(255, 82, 139, 224),
    secondaryContainer:  Color.fromARGB(255, 0, 0, 0),
    onSecondaryContainer:  Color.fromARGB(255, 255, 255, 255),
    error:  Color.fromARGB(255, 243, 130, 111),
    onError: Colors.black,
  ),
);

final darkMode = ThemeData(
  textTheme: GoogleFonts.actorTextTheme(),
  colorScheme: const ColorScheme(
    tertiary: Color.fromARGB(255, 118, 207, 235),
    brightness: Brightness.light,
    primary:  Color.fromARGB(255, 25, 44, 70),
    onPrimary:  Color.fromRGBO(12, 43, 58, 1),
    secondary:  Color.fromARGB(255, 224, 79, 79),
    onSecondary:  Color.fromARGB(255, 247, 163, 228),
    surface:  Color.fromARGB(255, 0, 0, 0),
    onSurface:  Color.fromARGB(255, 179, 207, 243),
    onPrimaryContainer:  Color.fromARGB(255, 12, 12, 49),
    secondaryContainer:  Color.fromARGB(255, 11, 255, 231),
    onSecondaryContainer:  Color.fromARGB(255, 0, 0, 0),
    error:  Color.fromARGB(255, 243, 130, 111),
    onError: Colors.black,
  ),
);