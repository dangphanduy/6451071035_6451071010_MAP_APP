import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';

class BrandService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get featured brands (isFeatured == true && isActive == true)
  Future<List<BrandModel>> getAllFeaturedBrands() async {
    final snapshot = await _db
        .collection('brands')
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .get();

    return snapshot.docs.map((d) => BrandModel.fromSnapshot(d)).toList();
  }

  /// Get all active brands
  Future<List<BrandModel>> getAllBrands() async {
    final snapshot = await _db
        .collection('brands')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((d) => BrandModel.fromSnapshot(d)).toList();
  }

  /// Get single brand by id
  Future<BrandModel?> getBrandById(String id) async {
    final doc = await _db.collection('brands').doc(id).get();
    if (!doc.exists) return null;
    return BrandModel.fromSnapshot(doc);
  }
}
