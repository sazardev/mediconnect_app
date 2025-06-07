import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
    textTheme: textTheme,
  );
}

final textTheme = GoogleFonts.outfitTextTheme();
