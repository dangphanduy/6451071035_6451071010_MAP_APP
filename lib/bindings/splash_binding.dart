import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}