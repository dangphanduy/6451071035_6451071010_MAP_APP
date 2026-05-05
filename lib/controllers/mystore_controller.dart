import 'package:get/get.dart';
import '../data/models/brand_model.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/services/mystore_service.dart';

class MyStoreController extends GetxController {
  final MyStoreService _service = MyStoreService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var featuredBrands = <BrandModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var categoryBrands = <BrandModel>[].obs;
  var products = <ProductModel>[].obs;

  var selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      featuredBrands.value = await _service.getFeaturedBrands();
      categories.value = await _service.getCategories();

      if (categories.isNotEmpty) {
        await selectCategory(0);
      } else {
        categoryBrands.clear();
        products.clear();
      }
    } catch (e) {
      errorMessage.value = 'Không tải được dữ liệu cửa hàng.';
      categoryBrands.clear();
      products.clear();
      print("Error loading my store: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCategory(int index) async {
    if (index < 0 || index >= categories.length) {
      return;
    }

    selectedCategoryIndex.value = index;

    final categoryId = categories[index].id;

    final brandIds = await _service.getBrandIdsByCategory(categoryId);

    if (brandIds.isEmpty) {
      categoryBrands.clear();
    } else {
      categoryBrands.value = featuredBrands
          .where((brand) => brandIds.contains(brand.id))
          .toList();
    }

    products.value = await _service.getProductsByCategoryAndBrands(
      categoryId,
      brandIds,
    );
  }
}
