import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/preferences_helper.dart';

class SettingsController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var fontSize = 'medium'.obs;
  var locale = const Locale('vi').obs;

  double get textScale {
    switch (fontSize.value) {
      case 'small':
        return 0.9;
      case 'large':
        return 1.15;
      default:
        return 1.0;
    }
  }

  String get themeLabelKey {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'theme.light';
      case ThemeMode.dark:
        return 'theme.dark';
      case ThemeMode.system:
        return 'theme.system';
    }
  }

  String get fontSizeLabelKey {
    switch (fontSize.value) {
      case 'small':
        return 'font.small';
      case 'large':
        return 'font.large';
      default:
        return 'font.medium';
    }
  }

  String get languageLabelKey {
    switch (locale.value.languageCode) {
      case 'en':
        return 'language.english';
      default:
        return 'language.vietnamese';
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    // THEME
    String theme = await PreferencesHelper.getTheme();
    if (theme == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (theme == 'dark') {


      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }

    // FONT
    fontSize.value = await PreferencesHelper.getFontSize();

    // LANGUAGE
    String lang = await PreferencesHelper.getLanguage();
    locale.value = Locale(lang);
    Get.updateLocale(locale.value);
  }

  void changeTheme(String value) async {
    await PreferencesHelper.setTheme(value);

    if (value == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (value == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
  }

  void changeFontSize(String value) async {
    await PreferencesHelper.setFontSize(value);
    fontSize.value = value;
  }

  void changeLanguage(String value) async {
    await PreferencesHelper.setLanguage(value);
    locale.value = Locale(value);
    Get.updateLocale(locale.value);
  }
}
