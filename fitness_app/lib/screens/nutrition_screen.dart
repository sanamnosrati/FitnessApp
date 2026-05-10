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

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Avocado Toast',
      'imageUrl': 'assets/images/foods/avocado_toast.jpg',
      'duration': '10 min',
      'calories': '280',
      'protein': '9g',
      'category': 'Breakfast',
      'tags': ['Healthy Fats', 'Quick', 'Vegetarian'],
      'ingredients': [
        '1 slice whole grain bread',
        '1/2 avocado',
        '1 boiled egg',
        'Cherry tomatoes',
        'Salt and pepper',
      ],
      'instructions': [
        'Toast the bread.',
        'Mash the avocado with salt and pepper.',
        'Spread avocado on the toast.',
        'Add egg and tomatoes on top.',
      ],
    },
    {
      'title': 'Chicken Rice Bowl',
      'imageUrl': 'assets/images/foods/chicken_rice.jpg',
      'duration': '25 min',
      'calories': '480',
      'protein': '38g',
      'category': 'Lunch',
      'tags': ['High Protein', 'Meal Prep', 'Fitness'],
      'ingredients': [
        '150g chicken breast',
        '1 cup cooked rice',
        'Broccoli',
        'Carrots',
        '1 tsp olive oil',
      ],
      'instructions': [
        'Cook the rice.',
        'Season and cook the chicken.',
        'Steam the vegetables.',
        'Put everything into a bowl and serve.',
      ],
    },
    {
      'title': 'Chicken Salad',
      'imageUrl': 'assets/images/foods/chicken_salad.jpg',
      'duration': '15 min',
      'calories': '360',
      'protein': '34g',
      'category': 'Lunch',
      'tags': ['High Protein', 'Low Carb', 'Fresh'],
      'ingredients': [
        '150g grilled chicken',
        'Mixed salad leaves',
        'Cucumber',
        'Tomatoes',
        'Light yogurt dressing',
      ],
      'instructions': [
        'Slice the grilled chicken.',
        'Wash and cut the vegetables.',
        'Mix everything in a bowl.',
        'Add dressing and serve.',
      ],
    },
    {
      'title': 'Greek Yogurt Parfait',
      'imageUrl': 'assets/images/foods/greek_yogurt_parfait.jpg',
      'duration': '10 min',
      'calories': '250',
      'protein': '18g',
      'category': 'Breakfast',
      'tags': ['High Protein', 'Low Fat', 'Quick'],
      'ingredients': [
        '200g Greek yogurt',
        '50g berries',
        '2 tbsp granola',
        '1 tsp honey',
      ],
      'instructions': [
        'Add yogurt to a glass.',
        'Add berries on top.',
        'Sprinkle granola.',
        'Drizzle honey and serve.',
      ],
    },
    {
      'title': 'Protein Pancakes',
      'imageUrl': 'assets/images/foods/protein_pancakes.jpg',
      'duration': '20 min',
      'calories': '350',
      'protein': '28g',
      'category': 'Breakfast',
      'tags': ['High Protein', 'Muscle Building', 'Sweet'],
      'ingredients': [
        '1 banana',
        '2 eggs',
        '30g oats',
        '1 scoop protein powder',
      ],
      'instructions': [
        'Blend all ingredients.',
        'Heat a pan.',
        'Cook small pancakes on both sides.',
        'Serve with berries.',
      ],
    },
    {
      'title': 'Quinoa Salad',
      'imageUrl': 'assets/images/foods/quinoa_salad.jpg',
      'duration': '20 min',
      'calories': '330',
      'protein': '14g',
      'category': 'Lunch',
      'tags': ['Vegetarian', 'Fresh', 'Gluten-Free'],
      'ingredients': [
        '1 cup cooked quinoa',
        'Cucumber',
        'Tomatoes',
        'Feta cheese',
        'Lemon juice',
      ],
      'instructions': [
        'Cook quinoa and let it cool.',
        'Cut vegetables.',
        'Mix everything in a bowl.',
        'Add lemon juice and serve.',
      ],
    },
    {
      'title': 'Salmon Avocado Bowl',
      'imageUrl': 'assets/images/foods/salmon_avocado.jpg',
      'duration': '30 min',
      'calories': '520',
      'protein': '34g',
      'category': 'Dinner',
      'tags': ['Omega-3', 'Healthy Fats', 'High Protein'],
      'ingredients': [
        '150g salmon',
        '1/2 avocado',
        'Rice or quinoa',
        'Spinach',
        'Lemon juice',
      ],
      'instructions': [
        'Cook the salmon.',
        'Prepare rice or quinoa.',
        'Slice avocado.',
        'Put everything in a bowl.',
      ],
    },
    {
      'title': 'Smoothie Bowl',
      'imageUrl': 'assets/images/foods/smoothie_bowl.jpg',
      'duration': '10 min',
      'calories': '300',
      'protein': '16g',
      'category': 'Snacks',
      'tags': ['Fresh', 'Sweet', 'Quick'],
      'ingredients': ['Frozen berries', 'Banana', 'Greek yogurt', 'Granola'],
      'instructions': [
        'Blend berries, banana and yogurt.',
        'Pour into a bowl.',
        'Add granola on top.',
      ],
    },
    {
      'title': 'Vegan Bowl',
      'imageUrl': 'assets/images/foods/vegan_bowl.jpg',
      'duration': '25 min',
      'calories': '390',
      'protein': '17g',
      'category': 'Dinner',
      'tags': ['Vegan', 'Fiber', 'Healthy'],
      'ingredients': [
        'Chickpeas',
        'Sweet potato',
        'Spinach',
        'Avocado',
        'Tahini sauce',
      ],
      'instructions': [
        'Roast sweet potato.',
        'Warm chickpeas.',
        'Add vegetables to a bowl.',
        'Top with tahini sauce.',
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredRecipes {
    if (_selectedCategory == 'All') return _recipes;

    return _recipes
        .where((recipe) => recipe['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Nutrition', showBackButton: false),
      body: Column(
        children: [
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
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(
                            isSelected ? 1 : 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color:
                                isSelected
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
