import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/cart_controller.dart';
import 'package:map_app_6451071035_6451071010/data/services/login_auth_service.dart';
import 'package:map_app_6451071035_6451071010/data/models/user_model.dart';
import 'package:map_app_6451071035_6451071010/controllers/wishlist_controller.dart';
import 'notification_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  UserModel? currentUser;
  Future<void> login(String email, String password) async {
    UserModel user = await _authService.loginWithEmailPassword(
      email,
      password,
    );
    currentUser = user;
    update();
    await Get.find<NotificationController>().bindToUser(user);
    await Get.find<CartController>().bindToUser();
    await Get.find<WishlistController>().bindToUser();
    Get.back(result: true);
  }
  Future<void> logout() async {
    await _authService.logout();
    Get.find<CartController>().clearLocalCart();
    Get.find<WishlistController>().clearLocalWishlist();
    currentUser = null;
    await Get.find<NotificationController>().bindToUser(null);
    update();
  }
}
