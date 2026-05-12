import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // HEADINGS
  static TextStyle heading = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle headingLarge = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // SUB HEADINGS
  static TextStyle subHeading = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // BODY
  static TextStyle body = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // CAPTION
  static TextStyle caption = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // BUTTON
  static TextStyle button = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // PRICE
  static TextStyle price = const TextStyle(
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}