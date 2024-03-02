import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextDecoration? decoration;

  const CustomText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}
