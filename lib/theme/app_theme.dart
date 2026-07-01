import 'package:flutter/material.dart';

import 'appcolors.dart';
import 'appfonts.dart';
import 'appsizes.dart';
import 'appstyles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: AppFonts.inter,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: Brightness.light,
          surface: AppColors.surfaceLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.pink,
          foregroundColor: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.greyLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide.none,
          ),
          contentPadding: AppStyles.cardPadding,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: AppColors.greyLight,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: AppFonts.inter,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: Brightness.dark,
          surface: AppColors.surfaceDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.pink,
          foregroundColor: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.greyDark.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide.none,
          ),
          contentPadding: AppStyles.cardPadding,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: AppColors.greyDark,
        ),
      );
}
