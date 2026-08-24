import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/recipe_image.dart';
import 'recipe_details_screen.dart';

class RecipeListScreen extends StatefulWidget {
  final String? categoryTitle;
  final String? selectedTag;
  final Color categoryColor;

  const RecipeListScreen({
    super.key,
    this.categoryTitle,
    this.selectedTag,
    required this.categoryColor,
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Query<Map<String, dynamic>> getRecipeQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
      'recipes',
    );

    if (widget.categoryTitle != null) {
      query = query.where('category', isEqualTo: widget.categoryTitle);
    }

    if (widget.selectedTag != null) {
      query = query.where('tags', arrayContains: widget.selectedTag);
    }

    return query;
  }

  String get screenTitle {
    if (widget.categoryTitle != null && widget.selectedTag != null) {
      return '${widget.categoryTitle} • ${widget.selectedTag}';
    }

    if (widget.categoryTitle != null) {
      return widget.categoryTitle!;
    }

    if (widget.selectedTag != null) {
      return widget.selectedTag!;
    }

    return 'Recipes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          screenTitle,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 21,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.categoryColor,
                  widget.categoryColor.withOpacity(0.15),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          _categoryHeader(),

          _searchBox(),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getRecipeQuery().snapshots(),

              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _statusMessage(
                    Icons.error_outline_rounded,
                    'Something went wrong',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: widget.categoryColor,
                    ),
                  );
                }

                final search = _searchController.text.trim().toLowerCase();

                final recipes = snapshot.data!.docs.where((doc) {
                  final data = doc.data();

                  final title = (data['title'] ?? '').toString().toLowerCase();

                  return title.contains(search);
                }).toList();

                if (recipes.isEmpty) {
                  return _statusMessage(
                    Icons.restaurant_menu_rounded,
                    'No recipes found',
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
                  itemCount: recipes.length,

                  itemBuilder: (context, index) {
                    final recipe = Map<String, dynamic>.from(
                      recipes[index].data(),
                    );

                    recipe['id'] = recipes[index].id;

                    return _recipeCard(recipe);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryHeader() {
    final icon = _categoryIcon();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: widget.categoryColor.withOpacity(0.28)),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: widget.categoryColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(17),
            ),

            child: Icon(icon, color: widget.categoryColor, size: 27),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screenTitle,

                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _categorySubtitle(),

                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),

      child: TextField(
        controller: _searchController,

        style: const TextStyle(color: AppTheme.textPrimaryColor),

        cursorColor: widget.categoryColor,

        onChanged: (_) {
          setState(() {});
        },

        decoration: InputDecoration(
          hintText: 'Search recipe...',

          prefixIcon: Icon(Icons.search_rounded, color: widget.categoryColor),

          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondaryColor,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),

          filled: true,
          fillColor: AppTheme.surfaceLightColor,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: widget.categoryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _recipeCard(Map<String, dynamic> recipe) {
    final List tags = recipe['tags'] ?? [];

    final String imageUrl = (recipe['imageUrl'] ?? '').toString().isNotEmpty
        ? recipe['imageUrl'].toString()
        : 'assets/images/recipes/breakfast/${recipe['id']}.jpg';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(22),

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

              borderRadius: BorderRadius.circular(22),

              border: Border.all(color: AppTheme.borderColor),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: widget.categoryColor.withOpacity(0.22),
                    ),
                  ),

                  child: RecipeImage(
                    imageUrl: imageUrl,
                    height: 72,
                    width: 72,
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        recipe['title'] ?? '',

                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 15,
                            color: widget.categoryColor,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            '${recipe['calories']} kcal',

                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Icon(
                            Icons.fitness_center_rounded,
                            size: 15,
                            color: widget.categoryColor,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            '${recipe['protein']}g protein',

                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 6,
                          runSpacing: 6,

                          children: tags.take(4).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: widget.categoryColor.withOpacity(0.11),

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(
                                  color: widget.categoryColor.withOpacity(0.18),
                                ),
                              ),

                              child: Text(
                                tag.toString(),

                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: widget.categoryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusMessage(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: widget.categoryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: widget.categoryColor, size: 30),
          ),

          const SizedBox(height: 14),

          Text(
            message,

            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon() {
    switch (widget.categoryTitle) {
      case 'Breakfast':
        return Icons.wb_sunny_rounded;

      case 'Lunch':
        return Icons.lunch_dining_rounded;

      case 'Dinner':
        return Icons.dinner_dining_rounded;

      case 'Snacks':
        return Icons.cookie_rounded;

      case 'Drinks':
        return Icons.local_drink_rounded;

      case 'Dessert':
        return Icons.cake_rounded;

      case 'Starter':
        return Icons.restaurant_menu_rounded;

      default:
        return Icons.restaurant_rounded;
    }
  }

  String _categorySubtitle() {
    switch (widget.categoryTitle) {
      case 'Breakfast':
        return 'Start your day with something good';

      case 'Lunch':
        return 'Fresh and balanced midday meals';

      case 'Dinner':
        return 'Warm meals for the end of your day';

      case 'Snacks':
        return 'Quick bites for between meals';

      case 'Drinks':
        return 'Smoothies, shakes and refreshing drinks';

      case 'Dessert':
        return 'Something sweet without losing balance';

      case 'Starter':
        return 'Light dishes to begin your meal';

      default:
        return widget.selectedTag != null
            ? 'Recipes matching ${widget.selectedTag}'
            : 'Discover recipes for your goals';
    }
  }
}
