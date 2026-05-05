import 'package:flutter/material.dart';

class StoreImage extends StatelessWidget {
  const StoreImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallback,
  });

  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? fallback;

  static bool isAssetPath(String? path) {
    if (path == null) return false;
    return path.startsWith('assets/');
  }

  static ImageProvider<Object> providerFor(String path) {
    if (isAssetPath(path)) {
      return AssetImage(path);
    }
    return NetworkImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final normalizedPath = imagePath?.trim();
    final hasImage = normalizedPath != null && normalizedPath.isNotEmpty;

    Widget child;
    if (!hasImage) {
      child = _buildFallback();
    } else {
      child = Image(
        image: providerFor(normalizedPath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      child = ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }

  Widget _buildFallback() {
    return fallback ??
        Image.asset(
          'assets/images/banners/default_image.png',
          width: width,
          height: height,
          fit: fit,
        );
  }
}
