import 'package:flutter/material.dart';

class AppColor extends Color {
  AppColor(super.value);

  static const backgroudColor = Color(0xFFE7D7BE);
  static const textColor = Color(0xFF9C8761);
  static const objectColor = Color(0xFFE8E4D7);
  static const subColor = Color(0xFFC3B6A3);
  static const swatchColor = Color(0xFF6C584C);

  // 인덱스가 클수록 어두운 색
  static const List<Color> colorList = [
    Color(0xFFE8E4D7),
    Color(0xFFE7D7BE),
    Color(0xFFC3B6A3),
    Color(0xFF9C8761),
    Color(0xFF6C584C),
  ];
}
