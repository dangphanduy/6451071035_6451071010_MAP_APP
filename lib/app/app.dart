import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/app/app_translations.dart';
import 'package:map_app_6451071035_6451071010/controllers/settings_controller.dart';
import '../routes/app_routes.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SettingsController settingsController =
      Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Flutter E-Commerce',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: settingsController.locale.value,
        fallbackLocale: const Locale('vi'),
        supportedLocales: const [
          Locale('vi'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: settingsController.themeMode.value,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9FC),
          canvasColor: Colors.white,
          cardColor: Colors.white,
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0F1720),
          canvasColor: const Color(0xFF17202A),
          cardColor: const Color(0xFF1E293B),
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF17202A),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF17202A),
            selectedItemColor: Colors.lightBlueAccent,
            unselectedItemColor: Colors.white70,
          ),
        ),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(settingsController.textScale),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      );
    });
  }
}
