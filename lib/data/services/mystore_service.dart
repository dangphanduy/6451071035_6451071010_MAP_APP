import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class MyStoreService {
  final _db = FirebaseFirestore.instance;

  /// 1. Featured Brands
  Future<List<BrandModel>> getFeaturedBrands() async {
    final snapshot = await _db.collection('brands').get();

    return snapshot.docs
        .map((e) => BrandModel.fromSnapshot(e))
        .where((brand) => brand.isActive && brand.isFeatured)
        .toList();
  }

  /// 2. Categories
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _db.collection('categories').get();
    final categories = snapshot.docs
        .map((e) => CategoryModel.fromSnapshot(e))
        .where((category) => category.isActive)
        .toList();

    categories.sort((a, b) => a.priority.compareTo(b.priority));
    return categories;
  }

  /// 3. Brand by Category (N-N table)
  Future<List<String>> getBrandIdsByCategory(String categoryId) async {
    final snapshot = await _db
        .collection('brand_categories')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    final brandIds = snapshot.docs
        .map((e) => e['brandId']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    if (brandIds.isNotEmpty) {
      return brandIds;
    }

    final productSnapshot = await _db
        .collection('products')
        .where('categoryIds', arrayContains: categoryId)
        .get();

    return productSnapshot.docs
        .map((doc) => doc.data()['brandId']?.toString())
        .whereType<String>()
        .where((brandId) => brandId.trim().isNotEmpty)
        .toSet()
        .toList();
  }

  /// 4. Products by category + brand list
  Future<List<ProductModel>> getProductsByCategoryAndBrands(
    String categoryId,
    List<String> brandIds,
  ) async {
    final snapshot = await _db
        .collection('products')
        .where('categoryIds', arrayContains: categoryId)
        .get();
    final allowedBrandIds = brandIds.toSet();

    return snapshot.docs
        .where((doc) {
          final data = doc.data();
          final brandId = data['brandId']?.toString();
          final isActive = data['isActive'] != false;
          final isDeleted = data['isDeleted'] == true;

          if (!isActive || isDeleted) {
            return false;
          }

          if (allowedBrandIds.isEmpty) {
            return true;
          }

          return brandId != null && allowedBrandIds.contains(brandId);
        })
        .map((e) => ProductModel.fromSnapshot(e, null))
        .toList();
  }
}
