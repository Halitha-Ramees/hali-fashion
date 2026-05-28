import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get logo => GoogleFonts.raleway(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 3.0,
  );

  static TextStyle get screenHeading => GoogleFonts.raleway(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle get sectionTitle => GoogleFonts.raleway(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyText => GoogleFonts.raleway(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle get mutedText => GoogleFonts.raleway(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get price => GoogleFonts.raleway(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle get buttonLabel => GoogleFonts.raleway(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: 1.2,
  );

  static TextStyle get buttonLabelOutline => GoogleFonts.raleway(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 1.2,
  );

  static TextStyle get caption => GoogleFonts.raleway(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get navLabel => GoogleFonts.raleway(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}
