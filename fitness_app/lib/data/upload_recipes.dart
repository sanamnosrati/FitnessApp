import 'package:cloud_firestore/cloud_firestore.dart';

import 'recipe_seed_breakfast.dart';
import 'recipe_seed_lunch.dart';
import 'recipe_seed_dinner.dart';
import 'recipe_seed_snack.dart';
import 'recipe_seed_drinks.dart';
import 'recipe_seed_dessert.dart';
import 'recipe_seed_starter.dart';

class RecipeSeedUploader {
  static Future<void> uploadAllRecipes() async {
    final firestore = FirebaseFirestore.instance;

    final allRecipes = [
      ...RecipeSeedBreakfast.recipes,
      ...RecipeSeedLunch.recipes,
      ...RecipeSeedDinner.recipes,
      ...RecipeSeedSnack.recipes,
      ...RecipeSeedDrinks.recipes,
      ...RecipeSeedDessert.recipes,
      ...RecipeSeedStarter.recipes,
    ];

    for (final recipe in allRecipes) {
      await firestore.collection('recipes').doc(recipe['id']).set(recipe);
    }
  }
}
