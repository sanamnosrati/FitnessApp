import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        title: Text(screenTitle),
        backgroundColor: widget.categoryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          _searchBox(),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getRecipeQuery().snapshots(),

              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final search = _searchController.text.toLowerCase();

                final recipes =
                    snapshot.data!.docs.where((doc) {
                      final data = doc.data();

                      final title =
                          (data['title'] ?? '').toString().toLowerCase();

                      return title.contains(search);
                    }).toList();

                if (recipes.isEmpty) {
                  return const Center(child: Text('No recipes found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipes.length,

                  itemBuilder: (context, index) {
                    final recipe = recipes[index].data();

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

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: TextField(
        controller: _searchController,

        onChanged: (_) {
          setState(() {});
        },

        decoration: InputDecoration(
          hintText: 'Search recipe...',
          prefixIcon: const Icon(Icons.search_rounded),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _recipeCard(Map<String, dynamic> recipe) {
    final List tags = recipe['tags'] ?? [];

    final String imageUrl =
        (recipe['imageUrl'] ?? '').toString().isNotEmpty
            ? recipe['imageUrl']
            : 'assets/images/recipes/breakfast/${recipe['id']}.jpg';

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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            RecipeImage(
              imageUrl: imageUrl,
              height: 70,
              width: 70,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    recipe['title'] ?? '',

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text('${recipe['calories']} kcal'),

                      const SizedBox(width: 12),

                      Text('${recipe['protein']}g protein'),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,

                    children:
                        tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: widget.categoryColor.withOpacity(0.12),

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              tag.toString(),

                              style: TextStyle(
                                fontSize: 11,
                                color: widget.categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
