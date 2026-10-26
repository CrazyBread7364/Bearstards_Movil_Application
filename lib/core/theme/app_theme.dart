import 'package:flutter/material.dart';

abstract final class Palette {
  static const ink = Color(0xff1b1636);
  static const muted = Color(0xff665d73);
  static const night = Color(0xff171344);
  static const paper = Color(0xfffffaf0);
  static const cream = Color(0xfffff0cc);
  static const yellow = Color(0xffffd440);
  static const pink = Color(0xffff67a7);
  static const cyan = Color(0xff55dce4);
  static const blue = Color(0xff43bdff);
  static const mint = Color(0xff5cdeb4);
  static const lavender = Color(0xffc9a4f5);
  static const orange = Color(0xffed9148);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Vera',
    scaffoldBackgroundColor: Palette.night,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.night,
      primary: Palette.ink,
      surface: Palette.paper,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        height: 1.12,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
        letterSpacing: -.9,
      ),
      headlineSmall: TextStyle(
        fontSize: 23,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
        letterSpacing: -.6,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
        letterSpacing: -.4,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
      ),
      bodyMedium: TextStyle(fontSize: 13, height: 1.5, color: Palette.ink),
      bodySmall: TextStyle(fontSize: 11, height: 1.4, color: Palette.muted),
      labelSmall: TextStyle(
        fontSize: 10,
        height: 1.2,
        letterSpacing: 1,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
      ),
    ),
    iconTheme: const IconThemeData(color: Palette.ink),
  );
}
