import 'package:flutter/material.dart';

import 'appfonts.dart';
import 'appsizes.dart';

class AppStyles {
  AppStyles._();

  static TextStyle get headlineLarge => AppFonts.poppinsBold.copyWith(fontSize: 28, height: 1.2);
  static TextStyle get headlineMedium => AppFonts.poppinsBold.copyWith(fontSize: 22, height: 1.3);
  static TextStyle get headlineSmall => AppFonts.poppinsBold.copyWith(fontSize: 18, height: 1.3);

  static TextStyle get titleLarge => AppFonts.poppinsMedium.copyWith(fontSize: 16, height: 1.4);
  static TextStyle get titleMedium => AppFonts.poppinsMedium.copyWith(fontSize: 14, height: 1.4);
  static TextStyle get titleSmall => AppFonts.poppinsMedium.copyWith(fontSize: 12, height: 1.4);

  static TextStyle get bodyLarge => AppFonts.interRegular.copyWith(fontSize: 16, height: 1.5);
  static TextStyle get bodyMedium => AppFonts.interRegular.copyWith(fontSize: 14, height: 1.5);
  static TextStyle get bodySmall => AppFonts.interRegular.copyWith(fontSize: 12, height: 1.5);

  static TextStyle get labelLarge => AppFonts.interMedium.copyWith(fontSize: 14, height: 1.4);
  static TextStyle get labelMedium => AppFonts.interMedium.copyWith(fontSize: 12, height: 1.4);
  static TextStyle get labelSmall => AppFonts.interMedium.copyWith(fontSize: 10, height: 1.4);

  static EdgeInsets get screenPadding => const EdgeInsets.all(AppSizes.md);
  static EdgeInsets get cardPadding => const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm);
}
