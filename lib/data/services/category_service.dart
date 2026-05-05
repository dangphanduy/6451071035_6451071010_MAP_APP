import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await _db
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .get();

    final categories = snapshot.docs
        .map((doc) => CategoryModel.fromSnapshot(doc))
        .toList();

    categories.sort((a, b) {
      final priorityCompare = a.priority.compareTo(b.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final seenNames = <String>{};
    return categories.where((category) {
      final key = category.name.trim().toLowerCase();
      return seenNames.add(key);
    }).toList();
  }
}
