import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/login_controller.dart';

class WishlistManager {
  static final WishlistManager _instance = WishlistManager._internal();

  factory WishlistManager() {
    return _instance;
  }

  WishlistManager._internal();

  // Map<userId, List<Product>>
  final Map<String, List<Map<String, dynamic>>> _userWishlists = {};



   List<Map<String, dynamic>> get items {
    final AuthController authController = Get.find<AuthController>();

    final user = authController.currentUser;

    if (user == null) {
      return [];
    }

    final userId = user.id ?? user.email;

    if (_userWishlists[userId] == null) {
      _userWishlists[userId] = [];
    }

    return _userWishlists[userId]!;
  }

  bool isFavorite(String id) {
    final currentItems = items;

    return currentItems.any((element) => element['id'] == id);
  }

  void toggle(Map<String, dynamic> product) {
    final AuthController authController = Get.find<AuthController>();

    final user = authController.currentUser;

    if (user == null) {
      return;
    }

    final userId = user.id ?? user.email;

    if (_userWishlists[userId] == null) {
      _userWishlists[userId] = [];
    }

    final List<Map<String, dynamic>> userItems = _userWishlists[userId]!;

    final index = userItems.indexWhere(
      (element) => element['id'] == product['id'],
    );

    if (index >= 0) {
      userItems.removeAt(index);
    } else {
      userItems.add(product);
    }
  }
}
