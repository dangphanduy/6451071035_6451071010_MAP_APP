import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/models/cart_item_model.dart';
import '/data/models/cart_model.dart';

class CartService {
  CartService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final CartModel _cart = CartModel.empty();

  CartModel get cart => _cart;

  CollectionReference<Map<String, dynamic>> _cartCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  void setLocalItems(List<CartItemModel> items) {
    _cart.items
      ..clear()
      ..addAll(items);
  }

  void clearLocalCart() {
    _cart.items.clear();
  }

  void addToCart(CartItemModel item) {
    final index = _cart.items.indexWhere(
      (e) =>
          e.productId == item.productId &&
          _isSameVariation(e.selectedVariation, item.selectedVariation),
    );

    if (index >= 0) {
      _cart.items[index].quantity += item.quantity;
    } else {
      _cart.items.add(item);
    }
  }

  void removeItem(CartItemModel item) {
    _cart.items.remove(item);
  }

  void increaseQty(CartItemModel item) {
    item.quantity++;
  }

  void decreaseQty(CartItemModel item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cart.items.remove(item);
    }
  }

  Future<List<CartItemModel>> loadCart(String userId) async {
    final snapshot = await _cartCollection(userId).get();
    final items = snapshot.docs
        .map((doc) => CartItemModel.fromJson(doc.data()))
        .toList();
    setLocalItems(items);
    return items;
  }

  Future<void> syncCart(String userId, List<CartItemModel> items) async {
    final collection = _cartCollection(userId);
    final snapshot = await collection.get();
    final nextIds = items.map(_cartDocIdForItem).toSet();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      if (!nextIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    for (final item in items) {
      final docId = _cartDocIdForItem(item);
      batch.set(collection.doc(docId), {
        ...item.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> clearRemoteCart(String userId) async {
    final snapshot = await _cartCollection(userId).get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
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

  String _cartDocIdForItem(CartItemModel item) {
    final normalizedVariation = (item.selectedVariation ?? {}).entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final variationKey = normalizedVariation
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');

    final rawKey = variationKey.isEmpty
        ? item.productId
        : '${item.productId}|$variationKey';
    return Uri.encodeComponent(rawKey);
  }
}
