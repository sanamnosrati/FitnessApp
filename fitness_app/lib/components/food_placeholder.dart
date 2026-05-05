import 'package:flutter/material.dart';

class FoodPlaceholder extends StatelessWidget {
  final String foodName;
  final List<String> categories;

  const FoodPlaceholder({
    Key? key,
    required this.foodName,
    required this.categories,
  }) : super(key: key);

  Color _getCategoryColor() {
    if (categories.contains('Vegan')) {
      return Colors.green[100]!;
    } else if (categories.contains('High-Protein')) {
      return Colors.red[100]!;
    } else if (categories.contains('Low-Carb')) {
      return Colors.blue[100]!;
    } else if (categories.contains('Keto')) {
      return Colors.purple[100]!;
    }
    return Colors.grey[100]!;
  }

  IconData _getCategoryIcon() {
    if (categories.contains('Vegan')) {
      return Icons.eco;
    } else if (categories.contains('High-Protein')) {
      return Icons.fitness_center;
    } else if (categories.contains('Low-Carb')) {
      return Icons.grain;
    } else if (categories.contains('Keto')) {
      return Icons.local_fire_department;
    }
    return Icons.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getCategoryColor(),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(4),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              _getCategoryIcon(),
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                categories.first,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 