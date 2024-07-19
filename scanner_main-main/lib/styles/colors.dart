import 'package:flutter/material.dart';

class AppColors {
  final Color primary = const Color(0xFF2B85FF);
  final Color primaryLighter = const Color(0xFF68A7FD);
  final Color mainBlack = const Color(0xFF0A0A0A);
  final Color supportingBlueThin = const Color(0xFFEBF3FF);
  final Color supportingBlack = const Color(0xFF000000);
  final Color supportingBackground = const Color(0xFFF6F7F9);
  final Color supportingGray = const Color(0xFF929292);
  final Color supportingExampleText = const Color(0xFFC4C8D3);
  final Color supportingWhite = const Color(0xFFFFFFFF);
  final Color supportingBackgroundPic = const Color(0xFFEBFFE6);
  final Color supportingBackgroundFile = const Color(0xFFFFFCEA);
  final Color supportingPict = const Color(0xFF239E05);
  final Color supportingFile = const Color(0xFFFFC90F);
  final Color offWhite = const Color(0xFF000000);
  final Color neutralBgLight = const Color(0xFFFCFCFC);
  final Color white = const Color(0xFFFFFFFF);

  final bool isDark = false;

  ThemeData toThemeData() {
    TextTheme txtTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = Colors.black;
    ColorScheme colorScheme = ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: Colors.black,
        secondary: supportingGray,
        onSecondary: Colors.white,
        error: Colors.red.shade400,
        onError: Colors.white,
        surface: white,
        onSurface: Colors.black);

    var t = ThemeData.from(textTheme: txtTheme, colorScheme: colorScheme)
        .copyWith(
        textSelectionTheme: TextSelectionThemeData(cursorColor: primary));

    return t;
  }
}
