import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/settings_controller.dart';

class AppTextStyle {
  static double get scale {
    final controller = Get.find<SettingsController>();

    switch (controller.fontSize.value) {
      case 'small':
        return 0.9;
      case 'large':
        return 1.15;
      default:
        return 1.0;
    }
  }

  static TextStyle get title => TextStyle(
        fontSize: 22 * scale,
        fontWeight: FontWeight.bold,
        color: Get.theme.colorScheme.onSurface,
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 14 * scale,
        color: Get.theme.colorScheme.onSurface.withOpacity(0.65),
      );

  static TextStyle get whiteTitle => TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get whiteSubtitle => TextStyle(
        fontSize: 14 * scale,
        color: Colors.white70,
      );
}
