class RecipeSeedBreakfast {
  static final List<Map<String, dynamic>> recipes = [
    {
      'id': 'turkish_menemen',
      'title': 'Turkish Menemen',
      'category': 'Breakfast',
      'imageUrl': 'assets/images/recipes/breakfast/turkish_menemen.jpg',
      'calories': 315,
      'protein': 20,
      'carbs': 14,
      'fats': 20,
      'fiber': 4,
      'time': '15 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Vegetarian', 'Healthy Fats', 'Warm Meal'],
      'ingredients': [
        '2 eggs',
        '1 medium tomato, chopped',
        '1/2 green pepper, chopped',
        '1 tsp olive oil',
        '1 tbsp chopped parsley',
        'Salt, pepper and paprika',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare vegetables',
          'description': 'Wash and chop the tomato, green pepper and parsley.',
        },
        {
          'step': 2,
          'title': 'Cook vegetables',
          'description':
              'Heat olive oil in a pan and cook tomato and pepper for 4–5 minutes.',
        },
        {
          'step': 3,
          'title': 'Add eggs',
          'description':
              'Add the eggs, season with salt, pepper and paprika, then stir gently.',
        },
        {
          'step': 4,
          'title': 'Serve',
          'description':
              'Cook until the eggs are set and serve warm with parsley.',
        },
      ],
      'goal':
          'A warm high-protein breakfast with healthy fats, good for satiety and muscle maintenance.',
    },

    {
      'id': 'green_shakshuka',
      'title': 'Green Shakshuka',
      'category': 'Breakfast',
      'imageUrl': 'assets/images/recipes/breakfast/green_shakshuka.jpg',
      'calories': 340,
      'protein': 23,
      'carbs': 18,
      'fats': 19,
      'fiber': 6,
      'time': '18 min',
      'difficulty': 'Medium',
      'servings': 1,
      'tags': ['High Protein', 'Vegetarian', 'High Fiber', 'Low Sugar'],
      'ingredients': [
        '2 eggs',
        '100g spinach',
        '1/2 zucchini, chopped',
        '50g feta cheese',
        '1 tsp olive oil',
        'Garlic, salt and pepper',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Cook greens',
          'description':
              'Heat olive oil and cook zucchini, spinach and garlic until soft.',
        },
        {
          'step': 2,
          'title': 'Add eggs',
          'description':
              'Make two small spaces in the pan and crack the eggs into them.',
        },
        {
          'step': 3,
          'title': 'Cover and cook',
          'description':
              'Cover the pan and cook for 5–7 minutes until the eggs are ready.',
        },
        {
          'step': 4,
          'title': 'Finish',
          'description': 'Add feta on top and season with salt and pepper.',
        },
      ],
      'goal':
          'Great for weight loss or maintenance because it is filling, high in protein and contains vegetables.',
    },

    {
      'id': 'low_calorie_shakshuka',
      'title': 'Low Calorie Shakshuka',
      'category': 'Breakfast',
      'imageUrl': 'assets/images/recipes/breakfast/low_calorie_shakshuka.jpg',
      'calories': 255,
      'protein': 21,
      'carbs': 16,
      'fats': 11,
      'fiber': 5,
      'time': '15 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Low Calorie', 'High Protein', 'Vegetarian', 'Cutting'],
      'ingredients': [
        '1 whole egg',
        '2 egg whites',
        '150g canned tomatoes',
        '1/2 onion, chopped',
        '1/2 bell pepper, chopped',
        'Spices: paprika, chili, salt, pepper',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Cook sauce',
          'description':
              'Cook onion, bell pepper and tomatoes in a pan with spices.',
        },
        {
          'step': 2,
          'title': 'Add eggs',
          'description':
              'Add one whole egg and two egg whites into the tomato sauce.',
        },
        {
          'step': 3,
          'title': 'Simmer',
          'description':
              'Cover and cook for 5–6 minutes until the eggs are firm.',
        },
        {
          'step': 4,
          'title': 'Serve',
          'description':
              'Serve warm without bread for a lower calorie version.',
        },
      ],
      'goal':
          'A lighter version of shakshuka, ideal for fat loss and high-protein breakfast meals.',
    },

    {
      'id': 'japanese_rice_breakfast_bowl',
      'title': 'Japanese Rice Breakfast Bowl',
      'category': 'Breakfast',
      'imageUrl':
          'assets/images/recipes/breakfast/japanese_rice_breakfast_bowl.jpg',
      'calories': 390,
      'protein': 24,
      'carbs': 52,
      'fats': 10,
      'fiber': 4,
      'time': '12 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Balanced', 'Pre Workout', 'High Carb', 'Quick'],
      'ingredients': [
        '120g cooked rice',
        '1 egg',
        '80g smoked salmon or tuna',
        '50g cucumber',
        '1 tsp soy sauce',
        'Spring onion and sesame seeds',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare rice',
          'description': 'Warm the cooked rice and place it in a bowl.',
        },
        {
          'step': 2,
          'title': 'Add protein',
          'description': 'Add the egg and smoked salmon or tuna on top.',
        },
        {
          'step': 3,
          'title': 'Add vegetables',
          'description': 'Add cucumber, spring onion and sesame seeds.',
        },
        {
          'step': 4,
          'title': 'Season',
          'description': 'Drizzle with soy sauce and serve immediately.',
        },
      ],
      'goal':
          'A balanced breakfast with carbs and protein, useful before school, work or training.',
    },

    {
      'id': 'persian_tomato_egg_omelette',
      'title': 'Persian Tomato Egg Omelette',
      'category': 'Breakfast',
      'imageUrl':
          'assets/images/recipes/breakfast/persian_tomato_egg_omelette.jpg',
      'calories': 285,
      'protein': 19,
      'carbs': 12,
      'fats': 18,
      'fiber': 3,
      'time': '12 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Vegetarian', 'High Protein', 'Warm Meal', 'Budget Friendly'],
      'ingredients': [
        '2 eggs',
        '2 medium tomatoes, grated or chopped',
        '1 tsp olive oil',
        '1/2 tsp turmeric',
        'Salt and pepper',
        'Optional: parsley or mint',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Cook tomatoes',
          'description':
              'Heat olive oil and cook tomatoes until the water reduces.',
        },
        {
          'step': 2,
          'title': 'Season',
          'description': 'Add turmeric, salt and pepper and mix well.',
        },
        {
          'step': 3,
          'title': 'Add eggs',
          'description': 'Add eggs and stir gently until cooked.',
        },
        {
          'step': 4,
          'title': 'Serve',
          'description': 'Serve warm with herbs if desired.',
        },
      ],
      'goal':
          'Simple high-protein breakfast with few ingredients, good for everyday use.',
    },
    {
      'id': 'greek_yogurt_berry_bowl',

      'title': 'Greek Yogurt Berry Bowl',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/greek_yogurt_berry_bowl.jpg',

      'calories': 290,
      'protein': 24,
      'carbs': 28,
      'fats': 8,
      'fiber': 6,

      'time': '5 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['High Protein', 'Quick', 'Healthy', 'Low Fat'],

      'ingredients': [
        '200g greek yogurt',
        '50g mixed berries',
        '20g granola',
        '1 tsp honey',
        '1 tbsp chia seeds',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare bowl',
          'description': 'Add greek yogurt into a serving bowl.',
        },

        {
          'step': 2,
          'title': 'Add toppings',
          'description': 'Top with berries, granola and chia seeds.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Drizzle honey on top and serve immediately.',
        },
      ],

      'goal':
          'High protein breakfast that supports satiety and muscle recovery.',
    },

    {
      'id': 'avocado_egg_toast',

      'title': 'Avocado Egg Toast',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/avocado_egg_toast.jpg',

      'calories': 360,
      'protein': 18,
      'carbs': 26,
      'fats': 20,
      'fiber': 8,

      'time': '10 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Healthy Fats', 'Balanced', 'Quick', 'Vegetarian'],

      'ingredients': [
        '2 slices whole grain bread',
        '1/2 avocado',
        '2 eggs',
        'Salt and pepper',
        'Chili flakes',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Toast bread',
          'description': 'Toast the bread slices until golden brown.',
        },

        {
          'step': 2,
          'title': 'Prepare avocado',
          'description': 'Mash avocado with salt and pepper.',
        },

        {
          'step': 3,
          'title': 'Cook eggs',
          'description': 'Cook eggs to your preferred consistency.',
        },

        {
          'step': 4,
          'title': 'Assemble',
          'description': 'Spread avocado on toast and place eggs on top.',
        },
      ],

      'goal': 'Balanced breakfast with protein, healthy fats and fiber.',
    },

    {
      'id': 'banana_oatmeal_bowl',

      'title': 'Banana Oatmeal Bowl',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/banana_oatmeal_bowl.jpg',

      'calories': 340,
      'protein': 16,
      'carbs': 52,
      'fats': 8,
      'fiber': 9,

      'time': '8 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['High Fiber', 'Healthy', 'Pre Workout', 'Budget Friendly'],

      'ingredients': [
        '50g oats',
        '1 banana',
        '200ml milk',
        '1 tsp peanut butter',
        'Cinnamon',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook oats',
          'description': 'Cook oats with milk for 5 minutes.',
        },

        {
          'step': 2,
          'title': 'Add banana',
          'description': 'Slice banana and place on top.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Add peanut butter and cinnamon before serving.',
        },
      ],

      'goal': 'High fiber breakfast that provides long-lasting energy.',
    },
    {
      'id': 'turkish_simit_breakfast_plate',

      'title': 'Turkish Simit Breakfast Plate',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/turkish_simit_breakfast_plate.jpg',

      'calories': 445,
      'protein': 19,
      'carbs': 48,
      'fats': 18,
      'fiber': 6,

      'time': '10 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Balanced', 'Mediterranean', 'Traditional', 'Healthy'],

      'ingredients': [
        '1/2 simit',
        '2 boiled eggs',
        '40g feta cheese',
        'Cucumber slices',
        'Tomato slices',
        'Olives',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare vegetables',
          'description': 'Slice cucumber and tomatoes.',
        },

        {
          'step': 2,
          'title': 'Cook eggs',
          'description': 'Boil eggs for 8–10 minutes.',
        },

        {
          'step': 3,
          'title': 'Assemble plate',
          'description':
              'Arrange simit, eggs, feta cheese and vegetables on a plate.',
        },
      ],

      'goal':
          'Balanced Mediterranean breakfast with protein, fiber and healthy fats.',
    },

    {
      'id': 'korean_egg_rice_bowl',

      'title': 'Korean Egg Rice Bowl',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/korean_egg_rice_bowl.jpg',

      'calories': 395,
      'protein': 22,
      'carbs': 47,
      'fats': 12,
      'fiber': 3,

      'time': '12 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Asian', 'Balanced', 'Quick', 'Comfort Food'],

      'ingredients': [
        '120g cooked rice',
        '2 eggs',
        '1 tsp soy sauce',
        'Spring onion',
        'Sesame seeds',
        'Seaweed flakes',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook eggs',
          'description': 'Fry eggs until slightly crispy on the edges.',
        },

        {
          'step': 2,
          'title': 'Prepare bowl',
          'description': 'Place warm rice into a bowl.',
        },

        {
          'step': 3,
          'title': 'Add toppings',
          'description': 'Add eggs, soy sauce, sesame seeds and spring onion.',
        },
      ],

      'goal': 'Comforting balanced breakfast with carbohydrates and protein.',
    },

    {
      'id': 'mexican_breakfast_tacos',

      'title': 'Mexican Breakfast Tacos',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/mexican_breakfast_tacos.jpg',

      'calories': 430,
      'protein': 26,
      'carbs': 34,
      'fats': 20,
      'fiber': 7,

      'time': '15 min',

      'difficulty': 'Medium',

      'servings': 1,

      'tags': ['High Protein', 'Mexican', 'Savory', 'Meal Prep'],

      'ingredients': [
        '2 mini tortillas',
        '2 eggs',
        '50g black beans',
        '30g cheese',
        'Tomato salsa',
        'Avocado slices',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook eggs',
          'description': 'Scramble eggs in a non-stick pan.',
        },

        {
          'step': 2,
          'title': 'Warm tortillas',
          'description': 'Heat tortillas for 1 minute.',
        },

        {
          'step': 3,
          'title': 'Assemble tacos',
          'description': 'Fill tortillas with eggs, beans, salsa and avocado.',
        },
      ],

      'goal': 'Protein-rich breakfast that keeps you full for longer.',
    },

    {
      'id': 'french_toast_with_berries',

      'title': 'French Toast with Berries',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/french_toast_with_berries.jpg',

      'calories': 410,
      'protein': 18,
      'carbs': 49,
      'fats': 15,
      'fiber': 5,

      'time': '14 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Sweet', 'Classic', 'Family Friendly', 'Comfort Food'],

      'ingredients': [
        '2 slices brioche bread',
        '1 egg',
        '60ml milk',
        'Mixed berries',
        'Cinnamon',
        '1 tsp maple syrup',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare mixture',
          'description': 'Whisk egg, milk and cinnamon together.',
        },

        {
          'step': 2,
          'title': 'Dip bread',
          'description': 'Dip bread slices into the egg mixture.',
        },

        {
          'step': 3,
          'title': 'Cook toast',
          'description': 'Cook bread on both sides until golden.',
        },

        {
          'step': 4,
          'title': 'Serve',
          'description': 'Top with berries and maple syrup.',
        },
      ],

      'goal': 'Comforting breakfast with carbohydrates for energy.',
    },

    {
      'id': 'middle_eastern_hummus_breakfast_bowl',

      'title': 'Middle Eastern Hummus Breakfast Bowl',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/middle_eastern_hummus_breakfast_bowl.jpg',

      'calories': 375,
      'protein': 17,
      'carbs': 32,
      'fats': 18,
      'fiber': 9,

      'time': '10 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Vegetarian', 'Middle Eastern', 'High Fiber', 'Healthy'],

      'ingredients': [
        '120g hummus',
        '1 boiled egg',
        'Cherry tomatoes',
        'Cucumber',
        'Olive oil',
        'Parsley',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare bowl',
          'description': 'Spread hummus into a serving bowl.',
        },

        {
          'step': 2,
          'title': 'Add toppings',
          'description': 'Top with egg, cucumber and tomatoes.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Drizzle olive oil and garnish with parsley.',
        },
      ],

      'goal': 'Fiber-rich breakfast that supports digestion and fullness.',
    },
    {
      'id': 'swedish_cinnamon_quark_bowl',

      'title': 'Swedish Cinnamon Quark Bowl',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/swedish_cinnamon_quark_bowl.jpg',

      'calories': 310,
      'protein': 28,
      'carbs': 27,
      'fats': 8,
      'fiber': 5,

      'time': '5 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['High Protein', 'Scandinavian', 'Quick', 'Healthy'],

      'ingredients': [
        '200g quark',
        '1 apple',
        'Cinnamon',
        '15g walnuts',
        '1 tsp honey',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare bowl',
          'description': 'Add quark into a bowl.',
        },

        {
          'step': 2,
          'title': 'Slice apple',
          'description': 'Cut apple into thin slices.',
        },

        {
          'step': 3,
          'title': 'Add toppings',
          'description': 'Top with walnuts, cinnamon and honey.',
        },
      ],

      'goal': 'Protein-rich breakfast with fiber and healthy fats.',
    },

    {
      'id': 'thai_coconut_oatmeal',

      'title': 'Thai Coconut Oatmeal',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/thai_coconut_oatmeal.jpg',

      'calories': 360,
      'protein': 14,
      'carbs': 49,
      'fats': 12,
      'fiber': 7,

      'time': '10 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Exotic', 'High Fiber', 'Sweet', 'Warm Meal'],

      'ingredients': [
        '50g oats',
        '150ml coconut milk',
        '1/2 mango',
        '1 tsp chia seeds',
        'Coconut flakes',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook oats',
          'description': 'Cook oats with coconut milk until creamy.',
        },

        {
          'step': 2,
          'title': 'Prepare mango',
          'description': 'Dice mango into small cubes.',
        },

        {
          'step': 3,
          'title': 'Serve',
          'description': 'Top oatmeal with mango and coconut flakes.',
        },
      ],

      'goal': 'Provides long-lasting energy and healthy carbohydrates.',
    },

    {
      'id': 'italian_caprese_breakfast_toast',

      'title': 'Italian Caprese Breakfast Toast',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/italian_caprese_breakfast_toast.jpg',

      'calories': 390,
      'protein': 20,
      'carbs': 28,
      'fats': 21,
      'fiber': 4,

      'time': '8 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Italian', 'Savory', 'Balanced', 'Mediterranean'],

      'ingredients': [
        '2 slices sourdough bread',
        '50g mozzarella',
        'Tomato slices',
        'Fresh basil',
        '1 tsp olive oil',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Toast bread',
          'description': 'Toast bread slices until golden.',
        },

        {
          'step': 2,
          'title': 'Assemble toast',
          'description': 'Add mozzarella and tomato slices.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Top with basil and olive oil.',
        },
      ],

      'goal': 'Balanced Mediterranean breakfast with healthy fats and protein.',
    },

    {
      'id': 'indian_masala_egg_wrap',

      'title': 'Indian Masala Egg Wrap',

      'category': 'Breakfast',

      'imageUrl': 'assets/images/recipes/breakfast/indian_masala_egg_wrap.jpg',

      'calories': 425,
      'protein': 24,
      'carbs': 35,
      'fats': 19,
      'fiber': 6,

      'time': '15 min',

      'difficulty': 'Medium',

      'servings': 1,

      'tags': ['Indian', 'Spicy', 'High Protein', 'Meal Prep'],

      'ingredients': [
        '1 whole grain wrap',
        '2 eggs',
        '1/2 onion',
        'Tomato',
        'Indian spices',
        'Coriander',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook vegetables',
          'description': 'Cook onion and tomato with spices.',
        },

        {
          'step': 2,
          'title': 'Add eggs',
          'description': 'Add eggs and scramble together.',
        },

        {
          'step': 3,
          'title': 'Prepare wrap',
          'description': 'Fill mixture into wrap and fold.',
        },
      ],

      'goal': 'High-protein savory breakfast with warming spices.',
    },

    {
      'id': 'norwegian_salmon_crispbread',

      'title': 'Norwegian Salmon Crispbread',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/norwegian_salmon_crispbread.jpg',

      'calories': 345,
      'protein': 25,
      'carbs': 20,
      'fats': 16,
      'fiber': 5,

      'time': '7 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Scandinavian', 'Omega 3', 'High Protein', 'Quick'],

      'ingredients': [
        '3 crispbreads',
        '80g smoked salmon',
        'Cream cheese',
        'Cucumber slices',
        'Fresh dill',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Spread cream cheese',
          'description': 'Spread cream cheese on crispbread.',
        },

        {
          'step': 2,
          'title': 'Add salmon',
          'description': 'Top with smoked salmon and cucumber.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Garnish with fresh dill before serving.',
        },
      ],

      'goal': 'Protein-rich breakfast with healthy omega-3 fats.',
    },

    {
      'id': 'turkish_potato_egg_skillet',

      'title': 'Turkish Potato Egg Skillet',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/turkish_potato_egg_skillet.jpg',

      'calories': 395,
      'protein': 22,
      'carbs': 31,
      'fats': 19,
      'fiber': 5,

      'time': '18 min',

      'difficulty': 'Medium',

      'servings': 1,

      'tags': ['Fitness', 'Warm Meal', 'Balanced', 'High Protein'],

      'ingredients': [
        '150g potatoes',
        '2 eggs',
        '1 tsp olive oil',
        'Paprika',
        'Parsley',
        'Salt and pepper',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook potatoes',
          'description': 'Dice potatoes and cook in olive oil until golden.',
        },

        {
          'step': 2,
          'title': 'Add eggs',
          'description': 'Crack eggs over potatoes and season with spices.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Cook until eggs are ready and top with parsley.',
        },
      ],

      'goal':
          'Balanced breakfast with protein and carbohydrates for sustained energy.',
    },

    {
      'id': 'mango_chia_fitness_pudding',

      'title': 'Mango Chia Fitness Pudding',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/mango_chia_fitness_pudding.jpg',

      'calories': 320,
      'protein': 20,
      'carbs': 29,
      'fats': 13,
      'fiber': 11,

      'time': '6 min + overnight',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['Healthy', 'High Fiber', 'Fitness', 'Meal Prep'],

      'ingredients': [
        '25g chia seeds',
        '200ml almond milk',
        '1/2 mango',
        '100g greek yogurt',
        '1 tsp honey',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare pudding',
          'description': 'Mix chia seeds with almond milk.',
        },

        {
          'step': 2,
          'title': 'Refrigerate',
          'description': 'Leave overnight until thickened.',
        },

        {
          'step': 3,
          'title': 'Serve',
          'description': 'Top with mango and greek yogurt.',
        },
      ],

      'goal':
          'Fiber-rich breakfast supporting digestion and long-lasting fullness.',
    },

    {
      'id': 'fitness_beef_breakfast_bowl',

      'title': 'Fitness Beef Breakfast Bowl',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/fitness_beef_breakfast_bowl.jpg',

      'calories': 465,
      'protein': 39,
      'carbs': 34,
      'fats': 18,
      'fiber': 6,

      'time': '20 min',

      'difficulty': 'Medium',

      'servings': 1,

      'tags': ['High Protein', 'Muscle Gain', 'Fitness', 'Meal Prep'],

      'ingredients': [
        '100g lean ground beef',
        '120g rice',
        '1 egg',
        'Spinach',
        'Paprika',
        'Spring onion',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook beef',
          'description': 'Cook lean beef with spices until browned.',
        },

        {
          'step': 2,
          'title': 'Prepare egg',
          'description': 'Cook egg separately to preferred consistency.',
        },

        {
          'step': 3,
          'title': 'Assemble bowl',
          'description': 'Serve rice with beef, spinach and egg.',
        },
      ],

      'goal': 'High-protein breakfast supporting muscle growth and recovery.',
    },

    {
      'id': 'strawberry_cottage_cheese_bowl',

      'title': 'Strawberry Cottage Cheese Bowl',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/strawberry_cottage_cheese_bowl.jpg',

      'calories': 285,
      'protein': 27,
      'carbs': 22,
      'fats': 9,
      'fiber': 4,

      'time': '5 min',

      'difficulty': 'Easy',

      'servings': 1,

      'tags': ['High Protein', 'Low Fat', 'Quick', 'Healthy'],

      'ingredients': [
        '200g cottage cheese',
        '80g strawberries',
        '1 tsp honey',
        '10g almonds',
        'Cinnamon',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Prepare bowl',
          'description': 'Add cottage cheese into a bowl.',
        },

        {
          'step': 2,
          'title': 'Prepare strawberries',
          'description': 'Slice strawberries into smaller pieces.',
        },

        {
          'step': 3,
          'title': 'Finish',
          'description': 'Top with almonds, honey and cinnamon.',
        },
      ],

      'goal': 'Light high-protein breakfast ideal for fat loss phases.',
    },

    {
      'id': 'sweet_potato_protein_hash',

      'title': 'Sweet Potato Protein Hash',

      'category': 'Breakfast',

      'imageUrl':
          'assets/images/recipes/breakfast/sweet_potato_protein_hash.jpg',

      'calories': 430,
      'protein': 30,
      'carbs': 37,
      'fats': 17,
      'fiber': 8,

      'time': '18 min',

      'difficulty': 'Medium',

      'servings': 1,

      'tags': ['Fitness', 'Balanced', 'High Fiber', 'Meal Prep'],

      'ingredients': [
        '150g sweet potato',
        '2 eggs',
        '60g turkey breast',
        'Spinach',
        '1 tsp olive oil',
      ],

      'instructions': [
        {
          'step': 1,
          'title': 'Cook sweet potato',
          'description': 'Dice sweet potato and cook until soft.',
        },

        {
          'step': 2,
          'title': 'Add turkey',
          'description': 'Add turkey breast and cook for 2 minutes.',
        },

        {
          'step': 3,
          'title': 'Cook eggs',
          'description': 'Add eggs and cook until ready.',
        },
      ],

      'goal':
          'Balanced breakfast with complex carbs and high protein for active lifestyles.',
    },
  ];
}
