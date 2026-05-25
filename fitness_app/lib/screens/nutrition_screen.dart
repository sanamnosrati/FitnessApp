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
      'color': Color(0xFFFFB74D),
      'description': 'Oatmeal, eggs, pancakes',
    },
    {
      'title': 'Lunch',
      'icon': Icons.lunch_dining_rounded,
      'color': Color(0xFF4DB6AC),
      'description': 'Bowls, salads, wraps',
    },
    {
      'title': 'Dinner',
      'icon': Icons.dinner_dining_rounded,
      'color': Color(0xFF9575CD),
      'description': 'Warm healthy meals',
    },
    {
      'title': 'Snacks',
      'icon': Icons.cookie_rounded,
      'color': Color(0xFFF06292),
      'description': 'Small fitness snacks',
    },
    {
      'title': 'Drinks',
      'icon': Icons.local_drink_rounded,
      'color': Color(0xFF64B5F6),
      'description': 'Smoothies and drinks',
    },
    {
      'title': 'Dessert',
      'icon': Icons.cake_rounded,
      'color': Color(0xFFA1887F),
      'description': 'Sweet healthy ideas',
    },
    {
      'title': 'Starter',
      'icon': Icons.restaurant_menu_rounded,
      'color': Color(0xFF81C784),
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

    return found['color'];
  }

  void _openRecipeList({String? category, String? tag, Color? color}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RecipeListScreen(
              categoryTitle: category,
              selectedTag: tag,
              categoryColor: color ?? AppTheme.primaryColor,
            ),
      ),
    );
  }

  bool _ingredientMatches(String ingredient, String search) {
    final cleanIngredient = ingredient.toLowerCase();

    final words =
        cleanIngredient
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Find recipes by title or ingredient',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Delete this button after uploading recipes once.
          ElevatedButton(
            onPressed: () async {
              await RecipeSeedUploader.uploadAllRecipes();
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
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search recipe title or ingredient...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon:
              isSearching
                  ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _tagSection() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: nutritionTags.length,
        itemBuilder: (context, index) {
          final tag = nutritionTags[index];
          final tagTitle = tag['title'];
          final tagIcon = tag['icon'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(tagTitle),
              avatar: Icon(tagIcon, size: 18),
              backgroundColor: Colors.white,
              side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.25)),
              labelStyle: TextStyle(
                color: AppTheme.primaryColor,
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
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return _categoryCard(category);
      },
    );
  }

  Widget _categoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        _openRecipeList(category: category['title'], color: category['color']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: category['color'].withOpacity(0.16),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: category['color'].withOpacity(0.35)),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: category['color'],
              radius: 28,
              child: Icon(category['icon'], color: Colors.white, size: 30),
            ),
            const Spacer(),
            Text(
              category['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              category['description'],
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ],
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
          return const Center(child: CircularProgressIndicator());
        }

        final groupedRecipes = _groupRecipesByCategory(snapshot.data!.docs);

        if (groupedRecipes.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }

        final sortedCategories =
            categories
                .map((category) => category['title'].toString())
                .where(
                  (categoryTitle) => groupedRecipes.containsKey(categoryTitle),
                )
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
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '(${recipes.length})',
              style: TextStyle(
                color: Colors.grey.shade600,
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${recipe['calories']} kcal • ${recipe['protein']}g protein • ${recipe['time']}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children:
                        tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.11),
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
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
