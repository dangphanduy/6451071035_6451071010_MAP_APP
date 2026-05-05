import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/controllers/cart_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/login_controller.dart';
import 'package:map_app_6451071035_6451071010/controllers/wishlist_controller.dart';
import 'package:map_app_6451071035_6451071010/data/models/cart_item_model.dart';
import 'package:map_app_6451071035_6451071010/data/models/product_model.dart';
import 'package:map_app_6451071035_6451071010/screens/product/product_detail_screen.dart';
import 'package:map_app_6451071035_6451071010/utils/currency_formatter.dart';

import 'store_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final wishlistController = Get.find<WishlistController>();

    final bool isOutOfStock =
        product.isOutOfStock == true ||
        product.stock <= 0 ||
        product.soldQuantity >= product.stock;

    final bool hasDiscount =
        product.salePrice != null &&
        product.salePrice! > 0 &&
        product.salePrice! < product.price;
    final double currentPrice = hasDiscount ? product.salePrice! : product.price;
    final double discountPercent = hasDiscount
        ? ((product.price - product.salePrice!) / product.price) * 100
        : 0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(() => ProductDetailScreen(productId: product.id));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: StoreImage(
                    imagePath: product.thumbnail,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    fallback: Container(
                      color: Colors.grey[100],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "HẾT HÀNG",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (hasDiscount && !isOutOfStock)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "-${discountPercent.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Obx(() {
                    final isFav = wishlistController.isInWishlist(product.id);
                    return IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFav ? Colors.red : Colors.grey[400],
                      ),
                      onPressed: () async {
                        final authController = Get.find<AuthController>();
                        if (authController.currentUser == null) {
                          _showLoginDialog();
                          return;
                        }
                        await wishlistController.toggleWishlist(product);
                      },
                    );
                  }),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brandName?.toUpperCase() ?? 'BRAND',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          CurrencyFormatter.formatVnd(currentPrice),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 4),
                          Text(
                            CurrencyFormatter.formatVnd(product.price),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${product.rating}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          final defaultVariation = _buildDefaultVariation(product);
                          final isAdded = cartController.isInCart(
                            product.id,
                            defaultVariation,
                          );

                          if (isAdded) {
                            return const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: Colors.green,
                            );
                          }

                          if (isOutOfStock) {
                            return const SizedBox.shrink();
                          }

                          return InkWell(
                            onTap: () {
                              cartController.addToCart(
                                CartItemModel(
                                  productId: product.id,
                                  quantity: 1,
                                  image: product.thumbnail,
                                  price: currentPrice,
                                  title: product.title,
                                  brandName: product.brandName,
                                  selectedVariation: defaultVariation,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _buildDefaultVariation(ProductModel product) {
    final variation = <String, String>{};
    for (final attribute in product.attributes) {
      if (attribute.values.isNotEmpty) {
        variation[attribute.name] = attribute.values.first;
      }
    }
    return variation;
  }

  void _showLoginDialog() {
    Get.defaultDialog(
      title: "Yêu cầu đăng nhập",
      middleText: "Vui lòng đăng nhập để thực hiện chức năng này",
      textConfirm: "Đăng nhập",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () {
        Get.back();
        Get.toNamed('/login');
      },
    );
  }
}
