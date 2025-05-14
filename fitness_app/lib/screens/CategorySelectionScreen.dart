import 'package:flutter/material.dart';

// Assuming FoodDetailScreen is defined above or imported here
import 'food_detail_screen.dart'; // Import FoodDetailScreen if it's in a different file

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({Key? key}) : super(key: key);

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<String> categories = [
    'Under 15 Minutes',
    'Under 30 Minutes',
    'Under 45 Minutes',
    'Meal Prep',
    'Under 300 Calories',
    'Under 500 Calories',
    'Low-Calorie Recipes',
    'High-Protein',
    'Low-Carb',
    'High-Carb',
    'Keto',
    'Vegan',
    'Vegetarian',
    'Gluten-Free',
    'Lactose-Free',
    'Muscle Building',
    'Fat Loss',
    'Energy Boost',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Smoothies',
    'Soups',
    'Salads',
    'Italian',
    'Asian',
    'American',
    'Mediterranean',
  ];

  final Set<String> selectedCategories = {};

  final List<Map<String, dynamic>> foods = [
    {
      'name': 'Avocado Toast',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Carb',
        'Breakfast',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Chicken Salad',
      'categories': [
        'High-Protein',
        'Low-Carb',
        'Gluten-Free',
        'Lunch',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Spaghetti Bolognese',
      'categories': ['High-Carb', 'Italian', 'Dinner', 'Under 45 Minutes'],
    },
    {
      'name': 'Vegan Smoothie',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Breakfast',
        'Smoothies',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Grilled Chicken Breast',
      'categories': [
        'High-Protein',
        'Low-Carb',
        'Keto',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Quinoa Salad',
      'categories': [
        'Vegetarian',
        'Gluten-Free',
        'Salads',
        'Lunch',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Greek Yogurt Parfait',
      'categories': [
        'Vegetarian',
        'Breakfast',
        'Low-Calorie Recipes',
        'Snack',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Egg White Omelette',
      'categories': [
        'High-Protein',
        'Fat Loss',
        'Breakfast',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Beef Stir Fry',
      'categories': ['Asian', 'Dinner', 'High-Protein', 'Under 30 Minutes'],
    },
    {
      'name': 'Keto Zucchini Noodles',
      'categories': [
        'Keto',
        'Low-Carb',
        'Gluten-Free',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Tofu Scramble',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Breakfast',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Chickpea Salad',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Lunch',
        'Salads',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Turkey Lettuce Wraps',
      'categories': [
        'Low-Carb',
        'High-Protein',
        'Lunch',
        'Fat Loss',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Protein Pancakes',
      'categories': [
        'High-Protein',
        'Breakfast',
        'Muscle Building',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Green Detox Smoothie',
      'categories': [
        'Smoothies',
        'Vegan',
        'Energy Boost',
        'Breakfast',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Tomato Basil Soup',
      'categories': [
        'Vegetarian',
        'Soups',
        'Low-Calorie Recipes',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Shrimp Avocado Salad',
      'categories': ['Low-Carb', 'Gluten-Free', 'Salads', 'Under 15 Minutes'],
    },
    {
      'name': 'Oatmeal with Berries',
      'categories': [
        'Vegetarian',
        'Breakfast',
        'Energy Boost',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Cauliflower Fried Rice',
      'categories': ['Low-Carb', 'Asian', 'Keto', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Lentil Soup',
      'categories': [
        'Vegan',
        'Soups',
        'Low-Calorie Recipes',
        'Dinner',
        'Under 45 Minutes',
      ],
    },
    {
      'name': 'Grilled Salmon',
      'categories': [
        'High-Protein',
        'Muscle Building',
        'Dinner',
        'Mediterranean',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Stuffed Bell Peppers',
      'categories': ['Low-Carb', 'Dinner', 'American', 'Under 45 Minutes'],
    },
    {
      'name': 'Hummus and Veggie Wrap',
      'categories': [
        'Vegetarian',
        'Lunch',
        'Mediterranean',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Almond Butter Banana Toast',
      'categories': [
        'Vegetarian',
        'Breakfast',
        'Energy Boost',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Pesto Pasta',
      'categories': ['Vegetarian', 'Italian', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Zucchini Fritters',
      'categories': [
        'Vegetarian',
        'Low-Carb',
        'Gluten-Free',
        'Snack',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Chicken Stir Fry',
      'categories': ['High-Protein', 'Asian', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Beef Taco Salad',
      'categories': ['High-Protein', 'Low-Carb', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Baked Sweet Potatoes',
      'categories': [
        'Vegetarian',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Dinner',
        'Under 45 Minutes',
      ],
    },
    {
      'name': 'Cucumber Salad',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Salads',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Cabbage Stir Fry',
      'categories': ['Vegan', 'Low-Carb', 'Lunch', 'Under 15 Minutes'],
    },
    {
      'name': 'Chia Pudding',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Breakfast',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Turkey Meatballs',
      'categories': ['High-Protein', 'Low-Carb', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Salmon Avocado Bowl',
      'categories': [
        'High-Protein',
        'Keto',
        'Lunch',
        'Gluten-Free',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Eggplant Parmesan',
      'categories': ['Vegetarian', 'Italian', 'Dinner', 'Under 45 Minutes'],
    },
    {
      'name': 'Fruit Smoothie Bowl',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Breakfast',
        'Smoothies',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Chicken Caesar Salad',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Lunch',
        'Salads',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Spicy Tofu Stir Fry',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Asian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Mushroom Risotto',
      'categories': ['Vegetarian', 'Italian', 'Dinner', 'Under 45 Minutes'],
    },
    {
      'name': 'Chicken & Veggie Skewers',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Sweet Potato Hash',
      'categories': ['Vegan', 'Low-Carb', 'Breakfast', 'Under 30 Minutes'],
    },
    {
      'name': 'Prawn & Avocado Salad',
      'categories': [
        'Low-Carb',
        'High-Protein',
        'Salads',
        'Gluten-Free',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Tuna Salad Lettuce Wraps',
      'categories': [
        'Low-Carb',
        'Gluten-Free',
        'Lunch',
        'Fat Loss',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Paleo Pancakes',
      'categories': [
        'Gluten-Free',
        'High-Protein',
        'Breakfast',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Kale Chips',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Gluten-Free',
        'Snack',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Chicken Fajitas',
      'categories': ['High-Protein', 'Low-Carb', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Vegan Tacos',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Lunch',
        'Low-Carb',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Poke Bowl',
      'categories': [
        'Gluten-Free',
        'High-Protein',
        'Asian',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Avocado Chicken Salad',
      'categories': [
        'Low-Carb',
        'High-Protein',
        'Gluten-Free',
        'Lunch',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Caprese Salad',
      'categories': [
        'Vegetarian',
        'Italian',
        'Salads',
        'Gluten-Free',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Veggie Burger',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Carb',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Pasta Primavera',
      'categories': ['Vegetarian', 'Italian', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Zucchini Noodles with Pesto',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Carb',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Chicken Avocado Salad',
      'categories': [
        'High-Protein',
        'Low-Carb',
        'Gluten-Free',
        'Lunch',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Vegetable Soup',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Gluten-Free',
        'Soup',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Tofu Stir Fry',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Asian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Salmon with Roasted Vegetables',
      'categories': ['High-Protein', 'Keto', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Chickpea Salad',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Salads',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Egg Salad Lettuce Wraps',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Lunch',
        'Low-Carb',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Cauliflower Fried Rice',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Asian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Grilled Shrimp Skewers',
      'categories': ['High-Protein', 'Keto', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Chia Seed Pudding',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Breakfast',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Roasted Brussels Sprouts',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Side',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Spinach and Feta Stuffed Chicken',
      'categories': ['High-Protein', 'Low-Carb', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Avocado Chicken Wrap',
      'categories': ['High-Protein', 'Low-Carb', 'Lunch', 'Under 15 Minutes'],
    },
    {
      'name': 'Sweet Potato and Black Bean Tacos',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Greek Yogurt Parfait',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Breakfast',
        'Snack',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Tomato Basil Soup',
      'categories': ['Vegetarian', 'Gluten-Free', 'Soup', 'Under 30 Minutes'],
    },
    {
      'name': 'Cauliflower Mac and Cheese',
      'categories': [
        'Low-Carb',
        'Keto',
        'Vegetarian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Vegan Buddha Bowl',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Lunch',
        'Low-Carb',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Grilled Chicken Salad',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Lunch',
        'Salads',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Lentil Soup',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Soup',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Grilled Veggie Wraps',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Salmon with Asparagus',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Eggplant Stir Fry',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Asian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Vegan Lentil Tacos',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Gluten-Free',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Cucumber and Tomato Salad',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Gluten-Free',
        'Salads',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Shakshuka',
      'categories': [
        'Vegetarian',
        'Gluten-Free',
        'Breakfast',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Baked Salmon with Garlic',
      'categories': ['High-Protein', 'Keto', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Spaghetti Squash Primavera',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Italian',
        'Dinner',
        'Under 45 Minutes',
      ],
    },
    {
      'name': 'Grilled Chicken Tacos',
      'categories': ['High-Protein', 'Low-Carb', 'Lunch', 'Under 30 Minutes'],
    },
    {
      'name': 'Vegan Chocolate Smoothie',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Smoothies',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Spinach and Mushroom Frittata',
      'categories': [
        'Vegetarian',
        'High-Protein',
        'Breakfast',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Quinoa Salad with Avocado',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Salads',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Roast Chicken with Vegetables',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Dinner',
        'Under 45 Minutes',
      ],
    },
    {
      'name': 'Grilled Tofu Steaks',
      'categories': ['Vegan', 'Low-Carb', 'Dinner', 'Under 30 Minutes'],
    },
    {
      'name': 'Lemon Garlic Shrimp',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Dinner',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Beef Stir Fry',
      'categories': [
        'High-Protein',
        'Low-Carb',
        'Asian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Sweet Potato Fries',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Snack',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Cauliflower Pizza',
      'categories': [
        'Low-Carb',
        'Gluten-Free',
        'Vegetarian',
        'Dinner',
        'Under 45 Minutes',
      ],
    },
    {
      'name': 'Chicken and Avocado Wrap',
      'categories': ['High-Protein', 'Low-Carb', 'Lunch', 'Under 15 Minutes'],
    },
    {
      'name': 'Tofu Scramble',
      'categories': ['Vegan', 'Low-Carb', 'Breakfast', 'Under 15 Minutes'],
    },
    {
      'name': 'Beef and Broccoli Stir Fry',
      'categories': [
        'High-Protein',
        'Low-Carb',
        'Asian',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Zoodle Salad',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Carb',
        'Salads',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Avocado and Egg Toast',
      'categories': ['Vegetarian', 'Low-Carb', 'Breakfast', 'Under 15 Minutes'],
    },
    {
      'name': 'Grilled Veggie Skewers',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Gluten-Free',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Mushroom and Spinach Quinoa',
      'categories': [
        'Vegan',
        'Gluten-Free',
        'Low-Calorie Recipes',
        'Dinner',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Greek Salad with Chicken',
      'categories': [
        'High-Protein',
        'Gluten-Free',
        'Lunch',
        'Salads',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Buffalo Cauliflower Bites',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Snack',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Veggie & Bean Chili',
      'categories': [
        'Vegan',
        'Low-Calorie Recipes',
        'Soup',
        'Under 45 Minutes',
      ],
    },
    {
      'name': 'Cauliflower Rice Bowl',
      'categories': [
        'Vegan',
        'Low-Carb',
        'Gluten-Free',
        'Lunch',
        'Under 30 Minutes',
      ],
    },
    {
      'name': 'Shrimp and Avocado Salad',
      'categories': [
        'High-Protein',
        'Low-Carb',
        'Gluten-Free',
        'Lunch',
        'Under 15 Minutes',
      ],
    },
    {
      'name': 'Coconut Curry Soup',
      'categories': ['Vegan', 'Gluten-Free', 'Soup', 'Under 45 Minutes'],
    },
  ];

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  List<Map<String, dynamic>> getFilteredFoods() {
    if (selectedCategories.isEmpty) return foods;
    return foods.where((food) {
      return food['categories'].any(
        (category) => selectedCategories.contains(category),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = getFilteredFoods();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories & Recipes')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children:
                  categories.map((category) {
                    final isSelected = selectedCategories.contains(category);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => toggleCategory(category),
                        selectedColor: Colors.blueAccent,
                        checkmarkColor: Colors.white,
                      ),
                    );
                  }).toList(),
            ),
          ),
          const Divider(),
          Expanded(
            child:
                filteredFoods.isEmpty
                    ? const Center(
                      child: Text('No foods match the selected categories.'),
                    )
                    : ListView.builder(
                      itemCount: filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = filteredFoods[index];
                        return ListTile(
                          title: Text(food['name']),
                          subtitle: Text(food['categories'].join(', ')),
                          onTap: () {
                            // Navigate to FoodDetailScreen on tapping the item
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => FoodDetailScreen(food: food),
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

void main() {
  runApp(const MaterialApp(home: CategorySelectionScreen()));
}
