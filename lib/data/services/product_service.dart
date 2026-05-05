import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getPopularProducts() async {
    final snapshot = await _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .get();

    final products = await _mapProducts(snapshot);
    products.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
    return products.take(6).toList();
  }

  Future<List<ProductModel>> getAllActiveProducts() async {
    final snapshot = await _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('isDeleted', isEqualTo: false)
        .get();

    final products = await _mapProducts(snapshot);
    products.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
    return products;
  }

  Future<List<ProductModel>> getAllPopularProducts({
    String sortBy = "name",
  }) async {
    final snapshot = await _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .get();

    final products = await _mapProducts(snapshot);

    if (sortBy == "low_price") {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "high_price") {
      products.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == "newest") {
      products.sort((a, b) {
        final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });
    } else if (sortBy == "best_selling") {
      products.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
    } else {
      products.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    }

    return products;
  }

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
  }) async {
    final snapshot = await _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('categoryIds', arrayContains: categoryId)
        .get();

    final products = await _mapProducts(snapshot);
    products.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
    return products;
  }

  Future<List<ProductModel>> getProductsByBrand({
    required String brandId,
  }) async {
    final snapshot = await _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('brandId', isEqualTo: brandId)
        .get();

    final products = await _mapProducts(snapshot);
    products.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
    return products;
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _db.collection('products').doc(productId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    String? brandName;
    final brandId = data['brandId']?.toString();

    if (brandId != null && brandId.isNotEmpty) {
      final brandDoc = await _db.collection('brands').doc(brandId).get();
      brandName = brandDoc.data()?['name']?.toString();
    }

    return ProductModel.fromSnapshot(doc, brandName);
  }

  Future<List<ProductModel>> _mapProducts(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    final products = <ProductModel>[];
    final seenKeys = <String>{};
    final brandCache = <String, String?>{};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final productKey = _productKeyFromData(data, doc.id);
      if (!seenKeys.add(productKey)) {
        continue;
      }

      final brandId = data['brandId']?.toString();
      String? brandName;

      if (brandId != null && brandId.isNotEmpty) {
        if (brandCache.containsKey(brandId)) {
          brandName = brandCache[brandId];
        } else {
          final brandDoc = await _db.collection('brands').doc(brandId).get();
          brandName = brandDoc.data()?['name']?.toString();
          brandCache[brandId] = brandName;
        }
      }

      products.add(ProductModel.fromSnapshot(doc, brandName));
    }

    return products;
  }

  String _productKeyFromData(Map<String, dynamic> data, String fallbackId) {
    final lowerTitle = data['lowerTitle']?.toString().trim();
    if (lowerTitle != null && lowerTitle.isNotEmpty) {
      return lowerTitle.toLowerCase();
    }

    final title = data['title']?.toString().trim();
    if (title != null && title.isNotEmpty) {
      return title.toLowerCase();
    }

    return fallbackId;
  }
}
