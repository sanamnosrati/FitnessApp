import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: borderRadius ?? BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              size: 45,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
