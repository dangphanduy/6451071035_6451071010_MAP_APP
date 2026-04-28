import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingController());
  }
}