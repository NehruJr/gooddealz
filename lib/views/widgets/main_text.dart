import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';

class MainText extends StatelessWidget {
  const MainText(
    this.text, {
    super.key,
    this.color = AppColors.yBlackColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontStyle,
     List<Shadow>? shadows,
  });
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  // final

  /// this is style for title for all app with size=16 and fontWeight=700
  const MainText.heading(
    this.text, {
    super.key,
    this.color,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontStyle,
  });

  /// this is style for title for all app with size=14, color=grey and fontWeight=400
  const MainText.subHeading(
    this.text, {
    super.key,
    this.color = AppColors.yGreyColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontStyle,
  });

  /// this is style for title for all app with size=14,color=white and fontWeight=700
  const MainText.txtButton(
    this.text, {
    super.key,
    this.color = AppColors.yWhiteColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        decoration: decoration,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
      ),
    );
  }
}
