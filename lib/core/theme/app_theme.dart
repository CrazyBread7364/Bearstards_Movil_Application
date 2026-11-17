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

/// Display titles use Lilita One; reading text and labels use Fredoka.
abstract final class AppFonts {
  static const display = 'LilitaOne';
  static const body = 'Fredoka';
}

/// Fredoka is a variable font: the weight is set on its `wght` axis.
TextStyle _body(
  double size, {
  required Color color,
  int weight = 400,
  double height = 1.4,
  double letterSpacing = 0,
}) => TextStyle(
  fontFamily: AppFonts.body,
  fontSize: size,
  height: height,
  color: color,
  letterSpacing: letterSpacing,
  fontWeight: FontWeight.values[(weight ~/ 100) - 1],
  fontVariations: [FontVariation('wght', weight.toDouble())],
);

TextStyle _display(double size, {double height = 1.1}) => TextStyle(
  fontFamily: AppFonts.display,
  fontSize: size,
  height: height,
  color: Palette.ink,
  letterSpacing: .2,
  fontWeight: FontWeight.w400,
);

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.body,
    scaffoldBackgroundColor: Palette.night,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.night,
      primary: Palette.ink,
      surface: Palette.paper,
    ),
    textTheme: TextTheme(
      headlineLarge: _display(32),
      headlineSmall: _display(26),
      titleLarge: _display(21, height: 1.15),
      titleMedium: _body(16, color: Palette.ink, weight: 600, height: 1.25),
      bodyMedium: _body(14.5, color: Palette.ink, height: 1.5),
      bodySmall: _body(12.5, color: Palette.muted),
      labelSmall: _body(
        11,
        color: Palette.ink,
        weight: 700,
        height: 1.2,
        letterSpacing: 1,
      ),
    ),
    iconTheme: const IconThemeData(color: Palette.ink),
  );
}
