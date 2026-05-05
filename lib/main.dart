import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/cart_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/category_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/notification_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/order_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/product_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/settings_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/wishlist_controller.dart';
import 'package:map_app_6451071035_6451071010/data/services/seed_data_service.dart';
import 'package:map_app_6451071035_6451071010/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'controllers/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final seedVersion = prefs.getInt('seed_data_version') ?? 0;
  final hasRequiredSeedData = await SeedDataService.hasRequiredSeedData();

  if (seedVersion < SeedDataService.currentSeedVersion ||
      !hasRequiredSeedData) {
    final didSeed = await SeedDataService.seedPhoneData();

    if (didSeed) {
      await prefs.setInt(
        'seed_data_version',
        SeedDataService.currentSeedVersion,
      );
      await prefs.setBool('is_data_seeded', true);
    } else {
      await prefs.remove('seed_data_version');
      await prefs.setBool('is_data_seeded', false);
    }
  }

  Get.put(AuthController());
  Get.put(NotificationController());
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(ProductController());
  Get.put(WishlistController());
  Get.put(CategoryController());
  Get.put(SettingsController());

  runApp(MyApp());
}
