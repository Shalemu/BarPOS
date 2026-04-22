import 'package:barpos/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


/// A reusable input decoration for all text fields in the app.
/// Supports dynamic suffix icons, error messages, and smooth focus visuals.
InputDecoration inputDecoration(
  String label,
  IconData icon, {
  Widget? suffix,
  String? hintText,
  String? errorText,
  bool isDense = false,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    errorText: errorText,
    prefixIcon: Icon(
      icon,
      color: AppColors.primary,
    ),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    isDense: isDense,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),

    
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),

    // 🟦 Focused border
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
    ),

    
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.red.shade500, width: 1.8),
    ),

    // 📝 Label, hint & error styles
    labelStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: TextStyle(
      color: Colors.grey.shade400,
      fontSize: 15,
    ),
    errorStyle: const TextStyle(
      fontSize: 13,
      color: Colors.redAccent,
      fontWeight: FontWeight.w500,
    ),


    floatingLabelBehavior: FloatingLabelBehavior.auto,
  );
}
