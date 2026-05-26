import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final BoxFit fit;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _placeholder();
    }

    final bool isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return ClipRRect(
      borderRadius: borderRadius,
      child:
          isNetworkImage
              ? Image.network(
                imageUrl,
                height: height,
                width: width,
                fit: fit,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
              : Image.asset(
                imageUrl,
                height: height,
                width: width,
                fit: fit,
                errorBuilder: (_, __, ___) => _placeholder(),
              ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      child: const Icon(Icons.restaurant_rounded, size: 42, color: Colors.grey),
    );
  }
}
