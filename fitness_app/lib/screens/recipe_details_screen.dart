import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final List ingredients = recipe['ingredients'] ?? [];

    final List instructions = recipe['instructions'] ?? [];

    final List tags = recipe['tags'] ?? [];

    final String imageUrl = (recipe['imageUrl'] ?? '').toString().isNotEmpty
        ? recipe['imageUrl'].toString()
        : 'assets/images/recipes/breakfast/${recipe['id']}.jpg';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 440,
            pinned: true,
            elevation: 0,

            backgroundColor: AppTheme.backgroundColor,

            foregroundColor: AppTheme.textPrimaryColor,

            surfaceTintColor: Colors.transparent,

            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 18),

              title: Text(
                recipe['title'] ?? 'Recipe',

                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              background: Stack(
                fit: StackFit.expand,

                children: [
                  Container(color: AppTheme.backgroundColor),

                  Positioned(
                    top: 58,
                    left: 14,
                    right: 14,
                    bottom: 18,

                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,

                        borderRadius: BorderRadius.circular(30),

                        border: Border.all(color: AppTheme.borderColor),
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),

                        child: _recipeImage(imageUrl),
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

                  const SizedBox(height: 26),

                  if (tags.isNotEmpty) ...[
                    _sectionTitle('Tags'),

                    const SizedBox(height: 10),

                    _tagWrap(tags),

                    const SizedBox(height: 28),
                  ],

                  if (recipe['goal'] != null) ...[
                    _sectionTitle('Why this recipe is useful'),

                    const SizedBox(height: 10),

                    _goalBox(recipe['goal']),

                    const SizedBox(height: 28),
                  ],

                  _sectionTitle('Ingredients'),

                  const SizedBox(height: 12),

                  ...ingredients.map((item) => _bulletItem(item)),

                  const SizedBox(height: 30),

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
                  }),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipeImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

        errorBuilder: (_, __, ___) {
          return _imageFallback();
        },
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,

      errorBuilder: (_, __, ___) {
        return _imageFallback();
      },
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppTheme.surfaceLightColor,

      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppTheme.primaryColor,
          size: 56,
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 6),

        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: AppTheme.borderColor),
        ),

        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),

            const SizedBox(height: 8),

            Text(
              text,
              textAlign: TextAlign.center,

              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        color: AppTheme.textPrimaryColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _tagWrap(List tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),

          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.12),

            borderRadius: BorderRadius.circular(20),

            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.25)),
          ),

          child: Text(
            tag.toString(),

            style: const TextStyle(
              color: AppTheme.purpleSoft,
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
        color: AppTheme.purpleSurface,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.25)),
      ),

      child: Text(
        goal.toString(),

        style: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _bulletItem(dynamic text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppTheme.borderColor),
      ),

      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text.toString(),

              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepItem(dynamic number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppTheme.borderColor),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            radius: 16,

            backgroundColor: AppTheme.primaryColor,

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
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,

                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
