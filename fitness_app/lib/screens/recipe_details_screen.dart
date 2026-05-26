import 'package:flutter/material.dart';
import '../widgets/recipe_image.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final List ingredients = recipe['ingredients'] ?? [];
    final List instructions = recipe['instructions'] ?? [];
    final List tags = recipe['tags'] ?? [];

    final String imageUrl =
        (recipe['imageUrl'] ?? '').toString().isNotEmpty
            ? recipe['imageUrl']
            : 'assets/images/recipes/breakfast/${recipe['id']}.jpg';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF8F9FB),
            foregroundColor: Colors.black,

            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),

              title: Text(
                recipe['title'] ?? 'Recipe',

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              background: Container(
                color: const Color(0xFFF8F9FB),

                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 70,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),

                      child: Container(
                        height: 230,
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: RecipeImage(
                          imageUrl: imageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _infoCards(),

                  const SizedBox(height: 20),

                  if (tags.isNotEmpty) ...[
                    _sectionTitle('Tags'),

                    const SizedBox(height: 10),

                    _tagWrap(tags),

                    const SizedBox(height: 24),
                  ],

                  if (recipe['goal'] != null) ...[
                    _sectionTitle('Why this recipe is useful'),

                    const SizedBox(height: 10),

                    _goalBox(recipe['goal']),

                    const SizedBox(height: 24),
                  ],

                  _sectionTitle('Ingredients'),

                  const SizedBox(height: 10),

                  ...ingredients.map((item) => _bulletItem(item)).toList(),

                  const SizedBox(height: 24),

                  _sectionTitle('Preparation'),

                  const SizedBox(height: 10),

                  ...instructions.asMap().entries.map((entry) {
                    final stepNumber = entry.key + 1;
                    final step = entry.value;

                    if (step is Map) {
                      return _stepItem(
                        step['step'] ?? stepNumber,
                        step['title'] ?? 'Step $stepNumber',
                        step['description'] ?? '',
                      );
                    }

                    return _stepItem(
                      stepNumber,
                      'Step $stepNumber',
                      step.toString(),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCards() {
    return Column(
      children: [
        Row(
          children: [
            _infoCard(
              Icons.local_fire_department_rounded,
              '${recipe['calories']} kcal',
            ),

            const SizedBox(width: 12),

            _infoCard(
              Icons.fitness_center_rounded,
              '${recipe['protein']}g protein',
            ),

            const SizedBox(width: 12),

            _infoCard(Icons.timer_rounded, recipe['time'] ?? 'No time'),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            _infoCard(Icons.rice_bowl_rounded, '${recipe['carbs']}g carbs'),

            const SizedBox(width: 12),

            _infoCard(Icons.opacity_rounded, '${recipe['fats']}g fats'),

            const SizedBox(width: 12),

            _infoCard(Icons.eco_rounded, '${recipe['fiber']}g fiber'),
          ],
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            Icon(icon, color: Colors.green),

            const SizedBox(height: 8),

            Text(
              text,
              textAlign: TextAlign.center,

              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _tagWrap(List tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children:
          tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                tag.toString(),

                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _goalBox(dynamic goal) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        goal.toString(),

        style: const TextStyle(
          fontSize: 15,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _bulletItem(dynamic text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green),

          const SizedBox(width: 12),

          Expanded(child: Text(text.toString())),
        ],
      ),
    );
  }

  Widget _stepItem(dynamic number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.green,

            child: Text(
              '$number',

              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(description, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
