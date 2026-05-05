import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/recipe_card.dart';
import '../theme/app_theme.dart';
import 'recipe_details_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Pre-Workout',
    'Post-Workout',
  ];

  // Sample recipe data with high-quality photos
  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Protein-Packed Oatmeal Bowl',
      'imageUrl': 'https://images.unsplash.com/photo-1517673400267-0251440c45dc',
      'duration': '15 min',
      'calories': '320',
      'protein': '20g',
      'category': 'Breakfast',
      'tags': ['High Protein', 'Vegetarian', 'Quick'],
    },
    {
      'title': 'Grilled Chicken Salad',
      'imageUrl': 'https://images.unsplash.com/photo-1546793665-c74683f339c1',
      'duration': '25 min',
      'calories': '400',
      'protein': '35g',
      'category': 'Lunch',
      'tags': ['High Protein', 'Low Carb', 'Keto'],
    },
    {
      'title': 'Salmon with Sweet Potato',
      'imageUrl': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288',
      'duration': '30 min',
      'calories': '450',
      'protein': '28g',
      'category': 'Dinner',
      'tags': ['Omega-3', 'Healthy Fats', 'Complex Carbs'],
    },
    {
      'title': 'Pre-Workout Energy Smoothie',
      'imageUrl': 'https://images.unsplash.com/photo-1526424382096-74a93e105682',
      'duration': '5 min',
      'calories': '200',
      'protein': '15g',
      'category': 'Pre-Workout',
      'tags': ['Quick', 'Energy Boost', 'Natural'],
    },
    {
      'title': 'Greek Yogurt Parfait',
      'imageUrl': 'https://images.unsplash.com/photo-1488477181946-6428a0291777',
      'duration': '10 min',
      'calories': '250',
      'protein': '18g',
      'category': 'Breakfast',
      'tags': ['High Protein', 'Low Fat', 'Quick'],
    },
    {
      'title': 'Quinoa Buddha Bowl',
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
      'duration': '20 min',
      'calories': '380',
      'protein': '15g',
      'category': 'Lunch',
      'tags': ['Vegan', 'High Fiber', 'Nutrient-Rich'],
    },
    {
      'title': 'Post-Workout Protein Shake',
      'imageUrl': 'https://images.unsplash.com/photo-1506458961255-571f40df5aad',
      'duration': '5 min',
      'calories': '220',
      'protein': '30g',
      'category': 'Post-Workout',
      'tags': ['High Protein', 'Recovery', 'Quick'],
    },
    {
      'title': 'Turkey Meatballs with Zucchini Noodles',
      'imageUrl': 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
      'duration': '35 min',
      'calories': '420',
      'protein': '32g',
      'category': 'Dinner',
      'tags': ['Low Carb', 'High Protein', 'Gluten-Free'],
    },
  ];

  List<Map<String, dynamic>> get filteredRecipes {
    if (_selectedCategory == 'All') {
      return _recipes;
    }
    return _recipes.where((recipe) => recipe['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Nutrition',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(isSelected ? 1 : 0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.backgroundColor
                                : AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Recipes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return RecipeCard(
                  title: recipe['title'],
                  imageUrl: recipe['imageUrl'],
                  duration: recipe['duration'],
                  calories: recipe['calories'],
                  protein: recipe['protein'],
                  tags: List<String>.from(recipe['tags']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailsScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 