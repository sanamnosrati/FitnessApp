import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'recipe_list_screen.dart';
import 'recipe_details_screen.dart';
import '../data/upload_recipes.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> nutritionTags = [
    {'title': 'High Protein', 'icon': Icons.fitness_center_rounded},
    {'title': 'Low Calorie', 'icon': Icons.local_fire_department_rounded},
    {'title': 'Quick', 'icon': Icons.flash_on_rounded},
    {'title': 'Low Carb', 'icon': Icons.rice_bowl_outlined},
    {'title': 'Vegetarian', 'icon': Icons.eco_rounded},
    {'title': 'Vegan', 'icon': Icons.spa_rounded},
    {'title': 'High Fiber', 'icon': Icons.grass_rounded},
    {'title': 'Sweet', 'icon': Icons.cake_rounded},
    {'title': 'Pre Workout', 'icon': Icons.directions_run_rounded},
    {'title': 'Post Workout', 'icon': Icons.sports_gymnastics_rounded},
    {'title': 'No Cook', 'icon': Icons.kitchen_rounded},
    {'title': 'Healthy Fats', 'icon': Icons.water_drop_rounded},
    {'title': 'Budget Friendly', 'icon': Icons.savings_rounded},
    {'title': 'Kid Friendly', 'icon': Icons.child_care_rounded},
    {'title': 'Gluten Free', 'icon': Icons.no_food_rounded},
    {'title': 'Dairy Free', 'icon': Icons.no_drinks_rounded},
    {'title': 'Bulking', 'icon': Icons.trending_up_rounded},
    {'title': 'Cutting', 'icon': Icons.trending_down_rounded},
    {'title': 'Muscle Gain', 'icon': Icons.monitor_weight_rounded},
    {'title': 'Weight Loss', 'icon': Icons.scale_rounded},
    {'title': 'Meal Prep', 'icon': Icons.lunch_dining_rounded},
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Breakfast',
      'icon': Icons.wb_sunny_rounded,
      'color': const Color(0xFFFFB74D),
      'description': 'Oatmeal, eggs, pancakes',
    },
    {
      'title': 'Lunch',
      'icon': Icons.lunch_dining_rounded,
      'color': const Color(0xFF4DB6AC),
      'description': 'Bowls, salads, wraps',
    },
    {
      'title': 'Dinner',
      'icon': Icons.dinner_dining_rounded,
      'color': const Color(0xFF9575CD),
      'description': 'Warm healthy meals',
    },
    {
      'title': 'Snacks',
      'icon': Icons.cookie_rounded,
      'color': const Color(0xFFF06292),
      'description': 'Small fitness snacks',
    },
    {
      'title': 'Drinks',
      'icon': Icons.local_drink_rounded,
      'color': const Color(0xFF64B5F6),
      'description': 'Smoothies and drinks',
    },
    {
      'title': 'Dessert',
      'icon': Icons.cake_rounded,
      'color': const Color(0xFFA1887F),
      'description': 'Sweet healthy ideas',
    },
    {
      'title': 'Starter',
      'icon': Icons.restaurant_menu_rounded,
      'color': const Color(0xFF81C784),
      'description': 'Light meals before dinner',
    },
  ];

  bool get isSearching => _searchController.text.trim().isNotEmpty;

  List<Map<String, dynamic>> get filteredCategories {
    final search = _searchController.text.toLowerCase();

    if (search.isEmpty) return categories;

    return categories.where((category) {
      return category['title'].toLowerCase().contains(search) ||
          category['description'].toLowerCase().contains(search);
    }).toList();
  }

  Color _categoryColor(String category) {
    final found = categories.firstWhere(
      (item) => item['title'] == category,
      orElse: () => {'color': AppTheme.primaryColor},
    );

    return found['color'] as Color;
  }

  void _openRecipeList({String? category, String? tag, Color? color}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeListScreen(
          categoryTitle: category,
          selectedTag: tag,
          categoryColor: color ?? AppTheme.primaryColor,
        ),
      ),
    );
  }

  bool _ingredientMatches(String ingredient, String search) {
    final cleanIngredient = ingredient.toLowerCase();

    final words = cleanIngredient
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ')
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .toList();

    return words.any((word) => word == search);
  }

  Map<String, List<Map<String, dynamic>>> _groupRecipesByCategory(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final search = _searchController.text.trim().toLowerCase();

    final Map<String, List<Map<String, dynamic>>> groupedRecipes = {};

    for (final doc in docs) {
      final recipe = doc.data();

      recipe['id'] = doc.id;

      final title = (recipe['title'] ?? '').toString().toLowerCase();

      final category = (recipe['category'] ?? '').toString();

      final ingredients = List<String>.from(recipe['ingredients'] ?? []);

      final matchesTitle = title.contains(search);

      final matchesIngredient = ingredients.any((ingredient) {
        return _ingredientMatches(ingredient.toString(), search);
      });

      if (matchesTitle || matchesIngredient) {
        groupedRecipes.putIfAbsent(category, () => []);

        groupedRecipes[category]!.add(recipe);
      }
    }

    return groupedRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _searchBox(),

            if (!isSearching) _tagSection(),

            Expanded(child: isSearching ? _searchResults() : _categoryGrid()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),

      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Nutrition',

                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Find recipes by title or ingredient',

                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              try {
                await RecipeSeedUploader.uploadAllRecipes();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recipes uploaded successfully!'),
                  ),
                );
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
              }
            },

            child: const Text('Upload Recipes'),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

      child: TextField(
        controller: _searchController,

        style: const TextStyle(color: AppTheme.textPrimaryColor),

        cursorColor: AppTheme.primaryColor,

        onChanged: (_) {
          setState(() {});
        },

        decoration: InputDecoration(
          hintText: 'Search recipe title or ingredient...',

          prefixIcon: const Icon(Icons.search_rounded),

          suffixIcon: isSearching
              ? IconButton(
                  icon: const Icon(Icons.close_rounded),

                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _tagSection() {
    return SizedBox(
      height: 56,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemCount: nutritionTags.length,

        itemBuilder: (context, index) {
          final tag = nutritionTags[index];

          final tagTitle = tag['title'].toString();

          final tagIcon = tag['icon'] as IconData;

          return Padding(
            padding: const EdgeInsets.only(right: 8),

            child: ActionChip(
              label: Text(tagTitle),

              avatar: Icon(tagIcon, size: 18, color: AppTheme.primaryColor),

              backgroundColor: AppTheme.surfaceLightColor,

              side: const BorderSide(color: AppTheme.borderColor),

              labelStyle: const TextStyle(
                color: AppTheme.purpleSoft,
                fontWeight: FontWeight.w600,
              ),

              onPressed: () {
                _openRecipeList(tag: tagTitle);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _categoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: filteredCategories.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),

      itemBuilder: (context, index) {
        final category = filteredCategories[index];

        return _categoryCard(category);
      },
    );
  }

  Widget _categoryCard(Map<String, dynamic> category) {
    final color = category['color'] as Color;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: () {
          _openRecipeList(category: category['title'], color: color);
        },

        child: Ink(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(color: AppTheme.borderColor),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(17),
                ),

                child: Icon(
                  category['icon'] as IconData,
                  color: color,
                  size: 28,
                ),
              ),

              const Spacer(),

              Text(
                category['title'],

                style: const TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                category['description'],

                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchResults() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        final groupedRecipes = _groupRecipesByCategory(snapshot.data!.docs);

        if (groupedRecipes.isEmpty) {
          return const Center(
            child: Text(
              'No recipes found.',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          );
        }

        final sortedCategories = categories
            .map((category) => category['title'].toString())
            .where((categoryTitle) => groupedRecipes.containsKey(categoryTitle))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

          itemCount: sortedCategories.length,

          itemBuilder: (context, index) {
            final categoryTitle = sortedCategories[index];

            final recipes = groupedRecipes[categoryTitle]!;

            final color = _categoryColor(categoryTitle);

            return _searchCategorySection(categoryTitle, recipes, color);
          },
        );
      },
    );
  }

  Widget _searchCategorySection(
    String categoryTitle,
    List<Map<String, dynamic>> recipes,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            Text(
              categoryTitle,

              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 8),

            Text(
              '(${recipes.length})',

              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ...recipes.take(8).map((recipe) {
          return _recipeResultCard(recipe, color);
        }),

        if (recipes.length > 8)
          TextButton(
            onPressed: () {
              _openRecipeList(category: categoryTitle, color: color);
            },

            child: Text('View all ${recipes.length} $categoryTitle recipes'),
          ),
      ],
    );
  }

  Widget _recipeResultCard(Map<String, dynamic> recipe, Color color) {
    final List tags = recipe['tags'] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(20),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailsScreen(recipe: recipe),
              ),
            );
          },

          child: Ink(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,

              borderRadius: BorderRadius.circular(20),

              border: Border.all(color: AppTheme.borderColor),
            ),

            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(
                    color: color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(17),
                  ),

                  child: Icon(Icons.restaurant_rounded, color: color),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        recipe['title'] ?? '',

                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${recipe['calories']} kcal • '
                        '${recipe['protein']}g protein • '
                        '${recipe['time']}',

                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Wrap(
                        spacing: 5,
                        runSpacing: 5,

                        children: tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),

                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: Text(
                              tag.toString(),

                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.5,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
