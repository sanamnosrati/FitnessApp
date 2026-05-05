import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget {
  final Map<String, dynamic> food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final categories = food['categories'] ?? [];
    final ingredients = food['ingredients'] ?? [];
    final instructions = food['instructions'] ?? [];
    final nutrition = food['nutritionalInfo'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(food['name'] ?? 'Food Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (food['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  food['image'],
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            Text(
              food['name'] ?? '',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map<Widget>((c) => Chip(label: Text(c.toString())))
                  .toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...ingredients.map<Widget>(
              (item) => Text('• $item', style: const TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 24),

            const Text(
              'Cooking Instructions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...instructions.asMap().entries.map<Widget>(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${entry.key + 1}. ${entry.value}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Nutritional Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calories: ${nutrition['calories'] ?? '-'}'),
                    Text('Protein: ${nutrition['protein'] ?? '-'}'),
                    Text('Carbs: ${nutrition['carbs'] ?? '-'}'),
                    Text('Fat: ${nutrition['fat'] ?? '-'}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}