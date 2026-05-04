import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

abstract class AppText {
  static TextStyle display(double size) => GoogleFonts.outfit(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle label(double size, {Color? color}) =>
      GoogleFonts.outfit(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.ink,
        letterSpacing: 0.2,
      );

  static TextStyle body(double size, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.subtle,
        height: 1.5,
      );
}

class AppTheme {
  static ThemeData buildTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        primary: AppColors.accent,
        secondary: AppColors.ink,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.rule, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.rule, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
            color: AppColors.muted,
            fontWeight: FontWeight.w400,
            fontSize: 14),
      ),
    );
  }
}
