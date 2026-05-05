import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDataService {
  static final _db = FirebaseFirestore.instance;
  static const int currentSeedVersion = 3;
  static const List<String> _categoryNames = [
    'Điện thoại',
    'Phụ kiện',
    'Tablet',
  ];
  static const List<String> _brandNames = [
    'Apple',
    'Samsung',
    'Xiaomi',
    'Oppo',
    'Google',
    'OnePlus',
  ];
  static const List<String> _productTitles = [
    'iPhone 15 Pro Max',
    'Samsung Galaxy S24 Ultra',
    'Xiaomi 14 Ultra',
    'OPPO Find X7 Ultra',
    'iPhone 15',
    'Google Pixel 8 Pro',
    'OnePlus 12',
    'Samsung Galaxy A55',
    'iPhone 14',
  ];

  static Future<bool> seedPhoneData() async {
    try {
      print("Seeding store data...");
      await _addCategories();
      await _addBrands();
      await _addPhoneProducts();
      final hasSeedData = await hasRequiredSeedData();
      print(hasSeedData ? "Seed complete" : "Seed incomplete");
      return hasSeedData;
    } catch (e) {
      print("Seed failed: $e");
      return false;
    }
  }

  static Future<bool> hasRequiredSeedData() async {
    try {
      final categorySnapshot = await _db
          .collection('categories')
          .where('name', whereIn: _categoryNames)
          .get();
      final brandSnapshot = await _db
          .collection('brands')
          .where('name', whereIn: _brandNames)
          .get();
      final productSnapshot = await _db
          .collection('products')
          .where('title', whereIn: _productTitles)
          .get();

      final categoryCount = categorySnapshot.docs
          .map((doc) => doc.data()['name']?.toString())
          .whereType<String>()
          .toSet()
          .length;
      final brandCount = brandSnapshot.docs
          .map((doc) => doc.data()['name']?.toString())
          .whereType<String>()
          .toSet()
          .length;
      final productCount = productSnapshot.docs
          .map((doc) => doc.data()['title']?.toString())
          .whereType<String>()
          .toSet()
          .length;

      return categoryCount == _categoryNames.length &&
          brandCount == _brandNames.length &&
          productCount == _productTitles.length;
    } catch (e) {
      print("Seed validation failed: $e");
      return false;
    }
  }

  static Future<void> _addCategories() async {
    final now = Timestamp.now();
    final categories = [
      {
        'name': 'Điện thoại',
        'imageURL': 'assets/images/icons/phone.png',
        'isActive': true,
        'isFeatured': true,
        'priority': 1,
        'numberOfProducts': 10,
        'viewCount': 0,
        'createdBy': 'admin',
        'updatedBy': 'admin',
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Phụ kiện',
        'imageURL': 'assets/images/icons/headphones.png',
        'isActive': true,
        'isFeatured': true,
        'priority': 2,
        'numberOfProducts': 4,
        'viewCount': 0,
        'createdBy': 'admin',
        'updatedBy': 'admin',
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Tablet',
        'imageURL': 'assets/images/icons/tablet.png',
        'isActive': true,
        'isFeatured': false,
        'priority': 3,
        'numberOfProducts': 3,
        'viewCount': 0,
        'createdBy': 'admin',
        'updatedBy': 'admin',
        'createdAt': now,
        'updatedAt': now,
      },
    ];

    for (final category in categories) {
      await _upsertByField(
        collection: 'categories',
        field: 'name',
        value: category['name'] as String,
        data: category,
      );
    }
  }

  static Future<void> _addBrands() async {
    final brands = [
      {
        'name': 'Apple',
        'imageURL': 'assets/images/brands/apple.png',
        'isFeatured': true,
        'isActive': true,
        'productsCount': 3,
      },
      {
        'name': 'Samsung',
        'imageURL': 'assets/images/brands/samsung.png',
        'isFeatured': true,
        'isActive': true,
        'productsCount': 2,
      },
      {
        'name': 'Xiaomi',
        'imageURL': 'assets/images/brands/xiaomi.png',
        'isFeatured': true,
        'isActive': true,
        'productsCount': 2,
      },
      {
        'name': 'Oppo',
        'imageURL': 'assets/images/brands/oppo.png',
        'isFeatured': true,
        'isActive': true,
        'productsCount': 1,
      },
      {
        'name': 'Google',
        'imageURL': 'assets/images/brands/google.png',
        'isFeatured': true,
        'isActive': true,
        'productsCount': 1,
      },
      {
        'name': 'OnePlus',
        'imageURL': 'assets/images/brands/one-plus.png',
        'isFeatured': true,
        'isActive': true,
        'productsCount': 1,
      },
    ];

    for (final brand in brands) {
      await _upsertByField(
        collection: 'brands',
        field: 'name',
        value: brand['name'] as String,
        data: brand,
      );
    }
  }

  static Future<void> _addPhoneProducts() async {
    final phoneCategory = await _getCategoryId('Điện thoại');
    if (phoneCategory == null) {
      return;
    }

    final products = [
      {
        'title': 'iPhone 17 Pro Max',
        'lowerTitle': 'iphone 17 pro max',
        'description':
            'Flagship Apple với khung titanium, camera zoom 5x và hiệu năng mạnh cho nhu cầu cao cấp.',
        'price': 37500000,
        'salePrice': 37900000,
        'thumbnail': 'assets/images/smartphones/thumb_ip17_promax.jpg',
        'images': [
          'assets/images/smartphones/ip17_promax_cam.jpg',
          'assets/images/smartphones/ip17_promax_xanh.jpg',
          'assets/images/smartphones/ip17_promax_bac.jpg',
        ],
        'brandId': await _getBrandId('Apple'),
        'categoryIds': [phoneCategory],
        'tags': ['flagship', 'ios', 'camera'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Cam vũ trụ', 'Xanh Đậm', 'Bạc']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['256GB', '512GB', '1TB']
          }
        ],
        'stock': 120,
        'sku': 'IPHONE17PM-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.8,
        'ratingCount': 1250,
        'reviewsCount': 245,
        'fiveStarCount': 1100,
        'fourStarCount': 120,
        'threeStarCount': 20,
        'twoStarCount': 5,
        'oneStarCount': 5,
        'soldQuantity': 42,
        'views': 5600,
        'likes': 890,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Samsung Galaxy S24 Ultra',
        'lowerTitle': 'samsung galaxy s24 ultra',
        'description':
            'Mẫu flagship nổi bật với bút S Pen, camera 200MP và màn hình lớn cho công việc lẫn giải trí.',
        'price': 20000000,
        'salePrice': 29000000,
        'thumbnail': 'assets/images/smartphones/thumb_samsung_s24_ultra.jpg',
        'images': [
          'assets/images/banners/banner_2.jpg',
          'assets/images/banners/banner_3.jpg',
        ],
        'brandId': await _getBrandId('Samsung'),
        'categoryIds': [phoneCategory],
        'tags': ['flagship', 'camera', 'android'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Titanium Black', 'Titanium Gray', 'Titanium Violet']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['256GB', '512GB']
          }
        ],
        'stock': 95,
        'sku': 'SGS24ULTRA-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.7,
        'ratingCount': 980,
        'reviewsCount': 210,
        'fiveStarCount': 850,
        'fourStarCount': 110,
        'threeStarCount': 15,
        'twoStarCount': 3,
        'oneStarCount': 2,
        'soldQuantity': 37,
        'views': 4800,
        'likes': 750,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Xiaomi 14 Ultra',
        'lowerTitle': 'xiaomi 14 ultra',
        'description':
            'Thiết bị nổi bật về camera Leica, hiệu năng cao và mức giá dễ tiếp cận hơn nhóm flagship đầu bảng.',
        'price': 21000000,
        'salePrice': 20500000,
        'thumbnail': 'assets/images/smartphones/thumb_xiaomi14_ultra.jpg',
        'images': [
          'assets/images/banners/banner_3.jpg',
          'assets/images/banners/banner_4.jpg',
        ],
        'brandId': await _getBrandId('Xiaomi'),
        'categoryIds': [phoneCategory],
        'tags': ['camera', 'leica', 'value'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Midnight Black', 'Ocean Blue', 'Moon White']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['256GB', '512GB']
          }
        ],
        'stock': 88,
        'sku': 'XMI14ULTRA-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.6,
        'ratingCount': 720,
        'reviewsCount': 156,
        'fiveStarCount': 620,
        'fourStarCount': 85,
        'threeStarCount': 12,
        'twoStarCount': 2,
        'oneStarCount': 1,
        'soldQuantity': 29,
        'views': 3900,
        'likes': 620,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'OPPO Find X7 Ultra',
        'lowerTitle': 'oppo find x7 ultra',
        'description':
            'Máy chụp ảnh đẹp, thiết kế sang và sạc nhanh, phù hợp người thích trải nghiệm cao cấp khác biệt.',
        'price': 32900000,
        'salePrice': 31900000,
        'thumbnail': 'assets/images/smartphones/thumb_oppo_find_x7_ultra.jpg',
        'images': [
          'assets/images/banners/banner_4.jpg',
          'assets/images/banners/banner_5.jpg',
        ],
        'brandId': await _getBrandId('Oppo'),
        'categoryIds': [phoneCategory],
        'tags': ['camera', 'charging', 'design'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Black', 'White', 'Green']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['256GB', '512GB']
          }
        ],
        'stock': 70,
        'sku': 'OPPOFX7U-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.5,
        'ratingCount': 580,
        'reviewsCount': 128,
        'fiveStarCount': 490,
        'fourStarCount': 75,
        'threeStarCount': 10,
        'twoStarCount': 3,
        'oneStarCount': 2,
        'soldQuantity': 21,
        'views': 2800,
        'likes': 480,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'iPhone 15',
        'lowerTitle': 'iphone 15',
        'description':
            'Lựa chọn cân bằng của Apple với hiệu năng mạnh, camera tốt và thời lượng pin phù hợp dùng hằng ngày.',
        'price': 17900000,
        'salePrice': 17500000,
        'thumbnail': 'assets/images/smartphones/thumb_iphone15.jpg',
        'images': [
          'assets/images/banners/banner_5.jpg',
          'assets/images/banners/banner_6.jpg',
        ],
        'brandId': await _getBrandId('Apple'),
        'categoryIds': [phoneCategory],
        'tags': ['smartphone', 'apple'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Black', 'Blue', 'Pink', 'Yellow', 'Green']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['128GB', '256GB', '512GB']
          }
        ],
        'stock': 140,
        'sku': 'IPHONE15-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.6,
        'ratingCount': 890,
        'reviewsCount': 198,
        'fiveStarCount': 750,
        'fourStarCount': 120,
        'threeStarCount': 15,
        'twoStarCount': 3,
        'oneStarCount': 2,
        'soldQuantity': 54,
        'views': 6200,
        'likes': 950,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Google Pixel 8 Pro',
        'lowerTitle': 'google pixel 8 pro',
        'description':
            'Điện thoại nổi bật về AI, camera chân thực và trải nghiệm Android gọn gàng, mượt mà.',
        'price': 12900000,
        'salePrice': 12500000,
        'thumbnail': 'assets/images/smartphones/thumb_pixel8_pro.jpg',
        'images': [
          'assets/images/banners/banner_6.jpg',
          'assets/images/banners/banner_7.jpg',
        ],
        'brandId': await _getBrandId('Google'),
        'categoryIds': [phoneCategory],
        'tags': ['ai', 'camera', 'pixel'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Obsidian', 'Porcelain', 'Bay']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['128GB', '256GB']
          }
        ],
        'stock': 64,
        'sku': 'PIXEL8PRO-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.7,
        'ratingCount': 420,
        'reviewsCount': 94,
        'fiveStarCount': 350,
        'fourStarCount': 52,
        'threeStarCount': 12,
        'twoStarCount': 4,
        'oneStarCount': 2,
        'soldQuantity': 18,
        'views': 2600,
        'likes': 410,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'OnePlus 12',
        'lowerTitle': 'oneplus 12',
        'description':
            'Hiệu năng mạnh, màn hình đẹp và sạc nhanh, phù hợp người dùng cần máy Android cao cấp nhưng giá hợp lý.',
        'price': 15900000,
        'salePrice': 15500000,
        'thumbnail': 'assets/images/smartphones/thumb_oneplus12.jpg',
        'images': [
          'assets/images/banners/banner_7.jpg',
          'assets/images/banners/banner_8.jpg',
        ],
        'brandId': await _getBrandId('OnePlus'),
        'categoryIds': [phoneCategory],
        'tags': ['performance', 'fast-charge', 'android'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Silky Black', 'Flowy Emerald']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['256GB', '512GB']
          }
        ],
        'stock': 76,
        'sku': 'ONEPLUS12-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.6,
        'ratingCount': 360,
        'reviewsCount': 82,
        'fiveStarCount': 301,
        'fourStarCount': 43,
        'threeStarCount': 11,
        'twoStarCount': 3,
        'oneStarCount': 2,
        'soldQuantity': 17,
        'views': 2400,
        'likes': 390,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Samsung Galaxy A55',
        'lowerTitle': 'samsung galaxy a55',
        'description':
            'Dòng cận cao cấp dễ bán, pin ổn, màn hình đẹp và camera đủ tốt cho nhu cầu phổ thông.',
        'price': 7900000,
        'salePrice': 7500000,
        'thumbnail': 'assets/images/smartphones/thumb_samsung_a55.jpg',
        'images': [
          'assets/images/banners/banner_8.jpg',
          'assets/images/banners/banner_2.jpg',
        ],
        'brandId': await _getBrandId('Samsung'),
        'categoryIds': [phoneCategory],
        'tags': ['midrange', 'samsung', 'popular'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Awesome Navy', 'Awesome Lilac', 'Awesome Iceblue']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['128GB', '256GB']
          }
        ],
        'stock': 180,
        'sku': 'SGA55-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.4,
        'ratingCount': 510,
        'reviewsCount': 112,
        'fiveStarCount': 390,
        'fourStarCount': 88,
        'threeStarCount': 22,
        'twoStarCount': 6,
        'oneStarCount': 4,
        'soldQuantity': 35,
        'views': 3300,
        'likes': 460,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'iPhone 14',
        'lowerTitle': 'iphone 14',
        'description':
            'Mẫu iPhone vẫn rất được ưa chuộng với hiệu năng ổn định, camera tốt và mức giá dễ tiếp cận hơn.',
        'price': 13900000,
        'salePrice': 13500000,
        'thumbnail': 'assets/images/smartphones/thumb_iphone14.jpg',
        'images': [
          'assets/images/banners/banner_4.jpg',
          'assets/images/banners/banner_1.jpg',
        ],
        'brandId': await _getBrandId('Apple'),
        'categoryIds': [phoneCategory],
        'tags': ['apple', 'popular', 'ios'],
        'attributes': [
          {
            'attributeId': 'color',
            'name': 'Color',
            'values': ['Midnight', 'Starlight', 'Blue', 'Purple']
          },
          {
            'attributeId': 'storage',
            'name': 'Storage',
            'values': ['128GB', '256GB']
          }
        ],
        'stock': 96,
        'sku': 'IPHONE14-001',
        'productType': 'variable',
        'isFeatured': true,
        'isActive': true,
        'isDraft': false,
        'isDeleted': false,
        'isRecommended': true,
        'onSale': true,
        'isOutOfStock': false,
        'rating': 4.5,
        'ratingCount': 640,
        'reviewsCount': 141,
        'fiveStarCount': 520,
        'fourStarCount': 88,
        'threeStarCount': 20,
        'twoStarCount': 7,
        'oneStarCount': 5,
        'soldQuantity': 26,
        'views': 4100,
        'likes': 530,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    for (final product in products) {
      await _upsertByField(
        collection: 'products',
        field: 'title',
        value: product['title'] as String,
        data: product,
      );
    }
  }

  static Future<void> _upsertByField({
    required String collection,
    required String field,
    required String value,
    required Map<String, dynamic> data,
  }) async {
    final existing = await _db
        .collection(collection)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await _db.collection(collection).add(data);
      return;
    }

    await existing.docs.first.reference.update(data);
  }

  static Future<String?> _getBrandId(String brandName) async {
    final snap = await _db
        .collection('brands')
        .where('name', isEqualTo: brandName)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? snap.docs.first.id : null;
  }

  static Future<String?> _getCategoryId(String categoryName) async {
    final snap = await _db
        .collection('categories')
        .where('name', isEqualTo: categoryName)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? snap.docs.first.id : null;
  }
}
