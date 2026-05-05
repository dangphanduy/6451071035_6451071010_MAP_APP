import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/login_controller.dart';
import 'package:map_app_6451071035_6451071010/data/models/cart_item_model.dart';

import '../data/services/cart_service.dart';

class CartController extends GetxController {
  final CartService _service = CartService();
  final AuthController _authController = Get.find<AuthController>();

  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  String? get uid => _authController.currentUser?.id;

  void _refreshFromService() {
    cartItems.assignAll(List<CartItemModel>.from(_service.cart.items));
  }

  Future<void> bindToUser() async {
    final userId = uid;
    if (userId == null) {
      clearLocalCart();
      return;
    }

    final guestItems = List<CartItemModel>.from(_service.cart.items);
    await _service.loadCart(userId);

    for (final item in guestItems) {
      _service.addToCart(item);
    }

    await _service.syncCart(userId, _service.cart.items);
    _refreshFromService();
  }

  Future<void> loadCart() async {
    final userId = uid;
    if (userId == null) {
      clearLocalCart();
      return;
    }

    await _service.loadCart(userId);
    _refreshFromService();
  }

  Future<void> addToCart(CartItemModel item) async {
    _service.addToCart(item);
    _refreshFromService();
    await _syncRemoteIfNeeded();
    Get.snackbar("Success", "Added to cart");
  }

  Future<void> removeItem(CartItemModel item) async {
    _service.removeItem(item);
    _refreshFromService();
    await _syncRemoteIfNeeded();
  }

  Future<void> increaseQty(CartItemModel item) async {
    _service.increaseQty(item);
    _refreshFromService();
    await _syncRemoteIfNeeded();
  }

  Future<void> decreaseQty(CartItemModel item) async {
    _service.decreaseQty(item);
    _refreshFromService();
    await _syncRemoteIfNeeded();
  }

  Future<void> clearCart() async {
    final userId = uid;
    _service.clearLocalCart();
    _refreshFromService();

    if (userId != null) {
      await _service.clearRemoteCart(userId);
    }
  }

  void clearLocalCart() {
    _service.clearLocalCart();
    _refreshFromService();
  }

  Future<void> _syncRemoteIfNeeded() async {
    final userId = uid;
    if (userId == null) return;
    await _service.syncCart(userId, _service.cart.items);
  }

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.finalPrice * item.quantity,
    );
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  bool isInCart(String productId, Map<String, String>? variation) {
    return cartItems.any(
      (item) =>
          item.productId == productId &&
          _isSameVariation(item.selectedVariation, variation),
    );
  }

  bool _isSameVariation(Map<String, String>? a, Map<String, String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  bool isProductInCart(String productId, Map<String, String>? variation) {
    return cartItems.any((item) => item.productId == productId);
  }
}
