import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

@immutable
class AppStyle {
  AppStyle({Size? screenSize}) {
    if (screenSize == null) {
      scale = 1;
      return;
    }

    final shortestSide = screenSize.shortestSide;
    const tabletXl = 1000;
    const tabletLg = 800;
    const tabletSm = 600;
    const phoneLg = 400;

    if (shortestSide > tabletXl) {
      scale = 1.25;
    } else if (shortestSide > tabletLg) {
      scale = 1.15;
    } else if (shortestSide > tabletSm) {
      scale = 1;
    } else if (shortestSide > phoneLg) {
      scale = .9;
    } else {
      scale = .85;
    }
    debugPrint('screenSize=$screenSize, scale=$scale');
  }

  late final double scale;

  final AppColors colors = AppColors();

  late final _Text text = _Text(scale);
}

@immutable
class _Text {
  _Text(this._scale);

  final double _scale;

  final Map<String, TextStyle> _titleFonts = {
    'en': GoogleFonts.inter(),
  };

  final Map<String, TextStyle> _contentFonts = {
    'en': GoogleFonts.inter(),
  };

  TextStyle _getFontForLocale(Map<String, TextStyle> fonts) {
    if (false) {
      // return fonts.entries.firstWhere((x) => x.key == $strings.localeName, orElse: () => fonts.entries.first).value;
    } else {
      return fonts.entries.first.value;
    }
  }

  TextStyle get titleFont => _getFontForLocale(_titleFonts);

  TextStyle get contentFont => _getFontForLocale(_contentFonts);

  //font style

  late final TextStyle headingExtraLargeBold =
      _createFont(titleFont, sizePx: 32, heightPx: 42, weight: FontWeight.w700);
  late final TextStyle headingMediumBold =
  _createFont(titleFont, sizePx: 24, heightPx: 31, weight: FontWeight.w700);
  late final TextStyle headingSmallBold =
  _createFont(titleFont, sizePx: 20, heightPx: 26, weight: FontWeight.w700);
  late final TextStyle headingSmallRegular =
  _createFont(titleFont, sizePx: 20, heightPx: 26, weight: FontWeight.w400);
  late final TextStyle bodyTextLargeRegular =
      _createFont(titleFont, sizePx: 16, heightPx: 26, weight: FontWeight.w400);
  late final TextStyle bodyTextLargeMedium =
  _createFont(titleFont, sizePx: 16, heightPx: 26, weight: FontWeight.w500);
  late final TextStyle bodyTextLargeBold =
      _createFont(titleFont, sizePx: 16, heightPx: 26, weight: FontWeight.w700);
  late final TextStyle bodyTextExtraLargeBold =
      _createFont(titleFont, sizePx: 24, heightPx: 31, weight: FontWeight.w700);
  late final TextStyle bodyTextSmall =
      _createFont(titleFont, sizePx: 16, heightPx: 26, weight: FontWeight.w500);
  late final TextStyle bodyTextSmallRegular =
  _createFont(titleFont, sizePx: 12, heightPx: 20, weight: FontWeight.w400);
  late final TextStyle bodyTextMedium =
  _createFont(titleFont, sizePx: 14, heightPx: 20, weight: FontWeight.w400);
  late final TextStyle labelBold =
  _createFont(titleFont, sizePx: 10, heightPx: 18, weight: FontWeight.bold);
  late final TextStyle body = _createFont(contentFont, sizePx: 14, heightPx: 23);

  TextStyle _createFont(TextStyle style,
      {required double sizePx,
      double? heightPx,
      double? spacingPc,
      FontWeight? weight}) {
    sizePx *= _scale;
    if (heightPx != null) {
      heightPx *= _scale;
    }
    return style.copyWith(
        fontSize: sizePx,
        height: heightPx != null ? (heightPx / sizePx) : style.height,
        letterSpacing:
            spacingPc != null ? sizePx * spacingPc * 0.01 : style.letterSpacing,
        fontWeight: weight);
  }
}
