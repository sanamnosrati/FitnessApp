class RecipeSeedSnack {
  static final List<Map<String, dynamic>> recipes = [
    {
      'id': 'greek_yogurt_berry_cup',
      'title': 'Greek Yogurt Berry Cup',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/greek_yogurt_berry_cup.jpg',
      'calories': 220,
      'protein': 20,
      'carbs': 18,
      'fats': 7,
      'fiber': 4,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': [
        'High Protein',
        'Quick',
        'Post Workout',
        'Sweet',
        'Vegetarian',
        'No Cook',
      ],
      'ingredients': [
        '200g Greek yogurt',
        '50g mixed berries',
        '1 tsp honey',
        '1 tbsp granola',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare ingredients',
          'description': 'Wash the berries and place yogurt into a bowl.',
        },
        {
          'step': 2,
          'title': 'Add toppings',
          'description': 'Top with berries, granola and honey.',
        },
      ],
      'goal':
          'A quick high-protein snack supporting muscle recovery and satiety.',
    },

    {
      'id': 'apple_peanut_butter_snack',
      'title': 'Apple Peanut Butter Snack',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/apple_peanut_butter_snack.jpg',
      'calories': 260,
      'protein': 8,
      'carbs': 22,
      'fats': 15,
      'fiber': 5,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Healthy Fats', 'Quick', 'Vegetarian', 'Pre Workout', 'No Cook'],
      'ingredients': ['1 apple', '1 tbsp peanut butter'],
      'instructions': [
        {
          'step': 1,
          'title': 'Slice apple',
          'description': 'Cut apple into slices.',
        },
        {
          'step': 2,
          'title': 'Serve',
          'description': 'Serve with peanut butter for dipping.',
        },
      ],
      'goal': 'Provides natural energy and healthy fats before workouts.',
    },

    {
      'id': 'protein_energy_balls',
      'title': 'Protein Energy Balls',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/protein_energy_balls.jpg',
      'calories': 190,
      'protein': 12,
      'carbs': 16,
      'fats': 8,
      'fiber': 4,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 2,
      'tags': ['High Protein', 'Meal Prep', 'Sweet', 'Quick', 'No Cook'],
      'ingredients': [
        '40g oats',
        '1 scoop protein powder',
        '1 tbsp peanut butter',
        '1 tsp honey',
        'Splash of milk',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Mix ingredients',
          'description': 'Combine all ingredients in a bowl.',
        },
        {
          'step': 2,
          'title': 'Shape balls',
          'description': 'Roll mixture into small balls.',
        },
        {
          'step': 3,
          'title': 'Chill',
          'description': 'Place in fridge for 15 minutes before serving.',
        },
      ],
      'goal': 'A convenient protein-rich snack for energy and muscle recovery.',
    },

    {
      'id': 'cottage_cheese_crackers',
      'title': 'Cottage Cheese Crackers',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/cottage_cheese_crackers.jpg',
      'calories': 210,
      'protein': 18,
      'carbs': 14,
      'fats': 8,
      'fiber': 3,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Quick', 'Vegetarian', 'Low Calorie', 'No Cook'],
      'ingredients': [
        '150g cottage cheese',
        '4 whole grain crackers',
        'Cherry tomatoes',
        'Pepper',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare crackers',
          'description': 'Place crackers on a plate.',
        },
        {
          'step': 2,
          'title': 'Add toppings',
          'description': 'Top with cottage cheese and sliced tomatoes.',
        },
      ],
      'goal': 'A light protein snack ideal for healthy eating and recovery.',
    },

    {
      'id': 'banana_chocolate_protein_shake',
      'title': 'Banana Chocolate Protein Shake',
      'category': 'Snacks',
      'imageUrl':
          'assets/images/recipes/snacks/banana_chocolate_protein_shake.jpg',
      'calories': 320,
      'protein': 30,
      'carbs': 28,
      'fats': 8,
      'fiber': 5,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Post Workout', 'Quick', 'Sweet', 'Muscle Gain'],
      'ingredients': [
        '1 banana',
        '1 scoop chocolate protein powder',
        '250ml milk',
        'Ice cubes',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Blend ingredients',
          'description': 'Blend all ingredients until smooth.',
        },
      ],
      'goal': 'Supports post-workout muscle recovery with protein and carbs.',
    },

    {
      'id': 'hummus_veggie_box',
      'title': 'Hummus Veggie Box',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/hummus_veggie_box.jpg',
      'calories': 180,
      'protein': 7,
      'carbs': 16,
      'fats': 10,
      'fiber': 6,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Vegan', 'High Fiber', 'Healthy Fats', 'No Cook', 'Gluten Free'],
      'ingredients': [
        '3 tbsp hummus',
        'Carrot sticks',
        'Cucumber sticks',
        'Bell pepper strips',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare vegetables',
          'description': 'Wash and cut vegetables into sticks.',
        },
        {
          'step': 2,
          'title': 'Serve',
          'description': 'Serve vegetables with hummus dip.',
        },
      ],
      'goal': 'A fiber-rich snack that supports digestion and healthy eating.',
    },

    {
      'id': 'rice_cakes_tuna_stack',
      'title': 'Rice Cakes Tuna Stack',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/rice_cakes_tuna_stack.jpg',
      'calories': 240,
      'protein': 22,
      'carbs': 18,
      'fats': 7,
      'fiber': 2,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Low Fat', 'Quick', 'Post Workout', 'No Cook'],
      'ingredients': [
        '2 rice cakes',
        '1 can tuna',
        '1 tsp light mayo',
        'Cucumber slices',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare tuna',
          'description': 'Mix tuna with light mayo.',
        },
        {
          'step': 2,
          'title': 'Assemble snack',
          'description': 'Spread tuna over rice cakes and top with cucumber.',
        },
      ],
      'goal':
          'A lean high-protein snack perfect for recovery and cutting phases.',
    },

    {
      'id': 'dark_chocolate_nut_mix',
      'title': 'Dark Chocolate Nut Mix',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/dark_chocolate_nut_mix.jpg',
      'calories': 290,
      'protein': 9,
      'carbs': 16,
      'fats': 21,
      'fiber': 5,
      'time': '2 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Healthy Fats', 'Sweet', 'Quick', 'Vegetarian', 'No Cook'],
      'ingredients': ['20g dark chocolate', '20g almonds', '15g walnuts'],
      'instructions': [
        {
          'step': 1,
          'title': 'Combine ingredients',
          'description': 'Place nuts and dark chocolate into a snack bowl.',
        },
      ],
      'goal': 'Provides healthy fats and sustained energy throughout the day.',
    },

    {
      'id': 'egg_avocado_toast',
      'title': 'Egg Avocado Toast',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/egg_avocado_toast.jpg',
      'calories': 310,
      'protein': 15,
      'carbs': 20,
      'fats': 18,
      'fiber': 6,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Healthy Fats', 'Vegetarian', 'Pre Workout', 'Quick'],
      'ingredients': [
        '1 slice whole grain bread',
        '1 egg',
        '1/4 avocado',
        'Salt and pepper',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Toast bread',
          'description': 'Toast bread until crispy.',
        },
        {
          'step': 2,
          'title': 'Cook egg',
          'description': 'Cook egg to your preference.',
        },
        {
          'step': 3,
          'title': 'Assemble',
          'description': 'Spread avocado on toast and top with egg.',
        },
      ],
      'goal':
          'A balanced snack with protein and healthy fats for steady energy.',
    },

    {
      'id': 'frozen_yogurt_bark',
      'title': 'Frozen Yogurt Bark',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/frozen_yogurt_bark.jpg',
      'calories': 170,
      'protein': 14,
      'carbs': 15,
      'fats': 5,
      'fiber': 3,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 2,
      'tags': [
        'Sweet',
        'Low Calorie',
        'High Protein',
        'Meal Prep',
        'Vegetarian',
      ],
      'ingredients': [
        '200g Greek yogurt',
        'Mixed berries',
        '1 tsp honey',
        '1 tsp dark chocolate chips',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare yogurt',
          'description': 'Spread yogurt onto a tray lined with baking paper.',
        },
        {
          'step': 2,
          'title': 'Add toppings',
          'description': 'Top with berries and chocolate chips.',
        },
        {
          'step': 3,
          'title': 'Freeze',
          'description': 'Freeze for 2–3 hours and break into pieces.',
        },
      ],
      'goal':
          'A refreshing protein snack with fewer calories and a sweet flavor.',
    },
    {
      'id': 'protein_cookie_dough',
      'title': 'Protein Cookie Dough',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/protein_cookie_dough.jpg',
      'calories': 245,
      'protein': 23,
      'carbs': 24,
      'fats': 8,
      'fiber': 4,
      'time': '5 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Sweet', 'Trendy', 'Quick', 'No Cook'],
      'ingredients': [
        '100g Greek yogurt',
        '20g vanilla protein powder',
        '15g oat flour',
        '1 tsp peanut butter',
        '1 tsp dark chocolate chips',
        'Splash of milk',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Mix base',
          'description':
              'Mix Greek yogurt, protein powder and oat flour until thick and creamy.',
        },
        {
          'step': 2,
          'title': 'Add toppings',
          'description':
              'Fold in peanut butter and chocolate chips and serve immediately.',
        },
      ],
      'goal':
          'A high-protein sweet snack that satisfies dessert cravings while supporting muscle recovery.',
    },

    {
      'id': 'cottage_cheese_hot_honey_toast',
      'title': 'Cottage Cheese Hot Honey Toast',
      'category': 'Snacks',
      'imageUrl':
          'assets/images/recipes/snacks/cottage_cheese_hot_honey_toast.jpg',
      'calories': 275,
      'protein': 21,
      'carbs': 31,
      'fats': 8,
      'fiber': 4,
      'time': '7 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Savory', 'Trendy', 'Quick', 'Vegetarian'],
      'ingredients': [
        '1 slice sourdough bread',
        '120g cottage cheese',
        '1 tsp honey',
        'Pinch of chili flakes',
        'Salt and pepper',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Toast bread',
          'description': 'Toast the sourdough bread until golden and crispy.',
        },
        {
          'step': 2,
          'title': 'Assemble',
          'description':
              'Spread cottage cheese over the toast and season with salt and pepper.',
        },
        {
          'step': 3,
          'title': 'Add hot honey',
          'description': 'Drizzle with honey and finish with chili flakes.',
        },
      ],
      'goal':
          'A protein-rich sweet and savory snack providing lasting energy and satiety.',
    },

    {
      'id': 'chocolate_strawberry_protein_bites',
      'title': 'Chocolate Strawberry Protein Bites',
      'category': 'Snacks',
      'imageUrl':
          'assets/images/recipes/snacks/chocolate_strawberry_protein_bites.jpg',
      'calories': 190,
      'protein': 16,
      'carbs': 19,
      'fats': 7,
      'fiber': 4,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Sweet', 'Trendy', 'Low Calorie', 'Meal Prep'],
      'ingredients': [
        '100g strawberries',
        '100g Greek yogurt',
        '15g vanilla protein powder',
        '15g dark chocolate',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare filling',
          'description':
              'Chop strawberries and mix with Greek yogurt and protein powder.',
        },
        {
          'step': 2,
          'title': 'Shape bites',
          'description':
              'Spoon small portions onto baking paper and freeze until firm.',
        },
        {
          'step': 3,
          'title': 'Coat',
          'description': 'Drizzle the frozen bites with melted dark chocolate.',
        },
      ],
      'goal':
          'A refreshing high-protein dessert-style snack ideal for satisfying sweet cravings.',
    },

    {
      'id': 'crispy_rice_cake_pizza',
      'title': 'Crispy Rice Cake Pizza',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/crispy_rice_cake_pizza.jpg',
      'calories': 215,
      'protein': 18,
      'carbs': 22,
      'fats': 6,
      'fiber': 2,
      'time': '8 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Savory', 'Low Calorie', 'Quick', 'Trendy'],
      'ingredients': [
        '2 rice cakes',
        '2 tbsp tomato sauce',
        '60g light mozzarella',
        'Cherry tomatoes',
        'Oregano',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Add toppings',
          'description':
              'Spread tomato sauce over rice cakes and top with mozzarella and sliced tomatoes.',
        },
        {
          'step': 2,
          'title': 'Cook',
          'description':
              'Air fry or bake for 5 minutes until the cheese is melted.',
        },
        {
          'step': 3,
          'title': 'Finish',
          'description': 'Sprinkle with oregano and serve warm.',
        },
      ],
      'goal':
          'A light high-protein alternative to pizza that works well during a calorie-controlled diet.',
    },

    {
      'id': 'tiramisu_protein_cup',
      'title': 'Tiramisu Protein Cup',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/tiramisu_protein_cup.jpg',
      'calories': 230,
      'protein': 25,
      'carbs': 23,
      'fats': 5,
      'fiber': 2,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Sweet', 'Trendy', 'Meal Prep', 'Low Fat'],
      'ingredients': [
        '170g Greek yogurt',
        '20g vanilla protein powder',
        '2 ladyfinger biscuits',
        '30ml espresso',
        '1 tsp cocoa powder',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare cream',
          'description':
              'Mix Greek yogurt with protein powder until smooth and creamy.',
        },
        {
          'step': 2,
          'title': 'Layer',
          'description':
              'Dip ladyfingers briefly in espresso and layer with the protein cream.',
        },
        {
          'step': 3,
          'title': 'Finish',
          'description': 'Dust with cocoa powder and chill before serving.',
        },
      ],
      'goal':
          'A high-protein version of tiramisu designed to satisfy dessert cravings with fewer calories.',
    },

    {
      'id': 'buffalo_chicken_cucumber_boats',
      'title': 'Buffalo Chicken Cucumber Boats',
      'category': 'Snacks',
      'imageUrl':
          'assets/images/recipes/snacks/buffalo_chicken_cucumber_boats.jpg',
      'calories': 195,
      'protein': 28,
      'carbs': 8,
      'fats': 6,
      'fiber': 2,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['High Protein', 'Savory', 'Low Carb', 'Trendy', 'Low Calorie'],
      'ingredients': [
        '1 cucumber',
        '100g cooked chicken breast',
        '1 tbsp Greek yogurt',
        '1 tsp hot sauce',
        '20g light cheese',
        'Spring onion',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare cucumber',
          'description':
              'Slice cucumber lengthwise and scoop out the center to create boats.',
        },
        {
          'step': 2,
          'title': 'Prepare filling',
          'description':
              'Mix shredded chicken with Greek yogurt and hot sauce.',
        },
        {
          'step': 3,
          'title': 'Fill',
          'description':
              'Fill cucumber boats with chicken mixture and top with cheese and spring onion.',
        },
      ],
      'goal':
          'A lean high-protein and low-carb snack ideal for cutting and muscle recovery.',
    },

    {
      'id': 'snickers_date_bites',
      'title': 'Snickers Date Bites',
      'category': 'Snacks',
      'imageUrl': 'assets/images/recipes/snacks/snickers_date_bites.jpg',
      'calories': 210,
      'protein': 7,
      'carbs': 27,
      'fats': 10,
      'fiber': 4,
      'time': '10 min',
      'difficulty': 'Easy',
      'servings': 1,
      'tags': ['Sweet', 'Trendy', 'Healthy Fats', 'Pre Workout', 'Meal Prep'],
      'ingredients': [
        '3 Medjool dates',
        '15g peanut butter',
        '10g dark chocolate',
        '5g crushed peanuts',
        'Pinch of sea salt',
      ],
      'instructions': [
        {
          'step': 1,
          'title': 'Prepare dates',
          'description': 'Slice dates open lengthwise and remove the pits.',
        },
        {
          'step': 2,
          'title': 'Fill',
          'description':
              'Fill each date with peanut butter and sprinkle with crushed peanuts.',
        },
        {
          'step': 3,
          'title': 'Add chocolate',
          'description':
              'Drizzle with melted dark chocolate and finish with a pinch of sea salt.',
        },
      ],
      'goal':
          'A naturally sweet energy-rich snack providing quick carbohydrates and healthy fats before training.',
    },
  ];
}
