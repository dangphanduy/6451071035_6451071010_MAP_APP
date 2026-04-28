import 'package:flutter/material.dart';
import 'package:map_app_6451071035_6451071010/views/onboarding/onboarding_screen.dart';
import '../views/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String forgetPassword = '/forget-password';
  static const String resetEmailSent = '/reset-email-sent';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String registerSuccess = '/register-success';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String publisher = '/publisher';
  static const String updateAccount = '/update-account';

  static const String changeName = '/change-name';
  static const String changeUsername = '/change-username';
  static const String changePassword = '/change-password';
  static const String changeEmail = '/change-email';
  static const String changePhoneNumber = '/change-phonenumber';
  static const String changeGender = '/change-gender';
  static const String changeDateofBirth = '/change-datebirth';
  static const String cartOverview = '/cart-overview';
  static const String orderOverview = '/order-overview';
  static const String myOrderview = '/my-order';
  static const String myShippingAddressview = '/my_shipping_address';
  static const String myBankAccountview = '/my_bank_account';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
  };
}