import 'package:flutter/material.dart';

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
            expandedHeight: 470,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF8F9FB),
            foregroundColor: Colors.black,

            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 18),

              title: Text(
                recipe['title'] ?? 'Recipe',

                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              background: Stack(
                fit: StackFit.expand,

                children: [
                  Container(color: const Color(0xFFF8F9FB)),

                  Positioned(
                    top: 58,
                    left: 10,
                    right: 10,
                    bottom: 18,

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(42),

                        child: Container(
                          color: Colors.white,

                          padding: const EdgeInsets.all(14),

                          child: InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,

                            child: Image.asset(
                              imageUrl,

                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _infoCards(),

                  const SizedBox(height: 22),

                  if (tags.isNotEmpty) ...[
                    _sectionTitle('Tags'),

                    const SizedBox(height: 10),

                    _tagWrap(tags),

                    const SizedBox(height: 26),
                  ],

                  if (recipe['goal'] != null) ...[
                    _sectionTitle('Why this recipe is useful'),

                    const SizedBox(height: 10),

                    _goalBox(recipe['goal']),

                    const SizedBox(height: 26),
                  ],

                  _sectionTitle('Ingredients'),

                  const SizedBox(height: 12),

                  ...ingredients.map((item) => _bulletItem(item)).toList(),

                  const SizedBox(height: 28),

                  _sectionTitle('Preparation'),

                  const SizedBox(height: 12),

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
        padding: const EdgeInsets.symmetric(vertical: 17),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 24),

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

      style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
    );
  }

  Widget _tagWrap(List tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children:
          tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),

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

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.10),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Text(
        goal.toString(),

        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _bulletItem(dynamic text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

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

          Expanded(
            child: Text(text.toString(), style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _stepItem(dynamic number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

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
            radius: 16,
            backgroundColor: Colors.green,

            child: Text(
              '$number',

              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,

                  style: const TextStyle(height: 1.5, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
