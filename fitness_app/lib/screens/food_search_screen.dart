import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/food_api_service.dart';
import '../theme/app_theme.dart';

class FoodSearchScreen extends StatefulWidget {
  final String mealTitle;

  const FoodSearchScreen({super.key, required this.mealTitle});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  bool isLoading = false;

  List<Map<String, dynamic>> results = [];

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.length < 2) {
      setState(() {
        results = [];
      });

      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await Future.wait([
        FoodApiService.searchFoods(query),
        _searchRecipes(query),
      ]);

      final foods = data[0];
      final recipes = data[1];

      final combined = <Map<String, dynamic>>[...foods, ...recipes];

      final sorted = _sortResults(combined, query);

      if (!mounted) return;

      setState(() {
        results = sorted;
      });
    } catch (e) {
      if (!mounted) return;

      _showSnack('Could not search foods.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // RECIPES
  // ============================================================

  Future<List<Map<String, dynamic>>> _searchRecipes(String query) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .get();

      final q = query.trim().toLowerCase();

      final matches = <Map<String, dynamic>>[];

      for (final doc in snapshot.docs) {
        final recipe = doc.data();

        final title = (recipe['title'] ?? '').toString();
        final category = (recipe['category'] ?? '').toString();

        final rawIngredients = recipe['ingredients'] ?? [];

        final ingredients = rawIngredients is List
            ? rawIngredients.map((e) => e.toString()).toList()
            : <String>[];

        final titleMatch = title.toLowerCase().contains(q);

        final ingredientMatch = ingredients.any(
          (ingredient) => ingredient.toLowerCase().contains(q),
        );

        if (!titleMatch && !ingredientMatch) {
          continue;
        }

        matches.add({
          'id': 'recipe_${doc.id}',
          'externalId': doc.id,
          'source': 'Recipe',
          'type': 'Recipe',
          'name': title,
          'brand': category,
          'imageUrl': recipe['imageUrl'] ?? recipe['image'] ?? '',
          'calories': _toDouble(recipe['calories']),
          'protein': _toDouble(recipe['protein']),
          'carbs': _toDouble(recipe['carbs']),
          'fat': _toDouble(recipe['fat']),
          'fiber': _toDouble(recipe['fiber']),
          'sugar': _toDouble(recipe['sugar']),
          'sodium': _toDouble(recipe['sodium']),
          'servingDescription': '1 serving',
          'servingAmount': 1.0,
          'servingUnit': 'serving',
          'isRecipe': true,
          'servingOptions': [
            {
              'label': 'Serving',
              'unit': 'serving',
              'amount': 1.0,
              'grams': null,
            },
          ],
          'recipeData': recipe,
        });
      }

      return matches;
    } catch (_) {
      return [];
    }
  }

  // ============================================================
  // SORT
  // ============================================================

  List<Map<String, dynamic>> _sortResults(
    List<Map<String, dynamic>> items,
    String query,
  ) {
    final q = query.toLowerCase();

    items.sort((a, b) {
      final aName = (a['name'] ?? '').toString().toLowerCase();
      final bName = (b['name'] ?? '').toString().toLowerCase();

      if (aName == q && bName != q) return -1;
      if (bName == q && aName != q) return 1;

      final aStarts = aName.startsWith(q);
      final bStarts = bName.startsWith(q);

      if (aStarts && !bStarts) return -1;
      if (bStarts && !aStarts) return 1;

      final aContains = aName.contains(q);
      final bContains = bName.contains(q);

      if (aContains && !bContains) return -1;
      if (bContains && !aContains) return 1;

      return aName.length.compareTo(bName.length);
    });

    return items;
  }

  // ============================================================
  // SELECT
  // ============================================================

  Future<void> _openFood(Map<String, dynamic> item) async {
    FocusScope.of(context).unfocus();

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return _FoodAmountSheet(item: item, mealTitle: widget.mealTitle);
      },
    );

    if (!mounted || result == null) {
      return;
    }

    Navigator.pop(context, result);
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Add ${widget.mealTitle}',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: _searchBox(),
          ),

          if (isLoading)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppTheme.primaryColor,
              backgroundColor: Colors.transparent,
            ),

          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    final query = searchController.text.trim();

    if (query.length < 2) {
      return _emptySearch();
    }

    if (!isLoading && results.isEmpty) {
      return _nothingFound();
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _resultTile(results[index]);
      },
    );
  }

  Widget _searchBox() {
    return TextField(
      controller: searchController,
      autofocus: true,

      style: const TextStyle(color: AppTheme.textPrimaryColor),

      cursorColor: AppTheme.primaryColor,

      onChanged: (value) {
        setState(() {});
        _onSearchChanged(value);
      },

      textInputAction: TextInputAction.search,

      decoration: InputDecoration(
        hintText: 'Search food or recipe...',

        prefixIcon: const Icon(Icons.search_rounded),

        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  searchController.clear();

                  setState(() {
                    results = [];
                  });
                },
              ),
      ),
    );
  }

  Widget _resultTile(Map<String, dynamic> item) {
    final imageUrl = item['imageUrl']?.toString() ?? '';
    final brand = item['brand']?.toString() ?? '';

    final calories = _toDouble(item['calories']);
    final protein = _toDouble(item['protein']);
    final carbs = _toDouble(item['carbs']);
    final fat = _toDouble(item['fat']);

    final isRecipe = item['isRecipe'] == true;

    final servingText = isRecipe ? 'per serving' : _smallServingText(item);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openFood(item),

          child: Ink(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderColor),
            ),

            child: Row(
              children: [
                _resultImage(imageUrl),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']?.toString() ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      if (brand.trim().isNotEmpty) ...[
                        const SizedBox(height: 3),

                        Text(
                          brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      Text(
                        '${_formatNumber(calories)} kcal  •  '
                        'P ${_formatNumber(protein)}g  •  '
                        'C ${_formatNumber(carbs)}g  •  '
                        'F ${_formatNumber(fat)}g',

                        style: const TextStyle(
                          color: AppTheme.purpleSoft,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        servingText,

                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

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

  Widget _resultImage(String imageUrl) {
    if (imageUrl.trim().isEmpty) {
      return _foodPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),

      child: Image.network(
        imageUrl,
        width: 58,
        height: 58,
        fit: BoxFit.cover,

        errorBuilder: (_, __, ___) {
          return _foodPlaceholder();
        },
      ),
    );
  }

  Widget _foodPlaceholder() {
    return Container(
      width: 58,
      height: 58,

      decoration: BoxDecoration(
        color: AppTheme.purpleSurface,
        borderRadius: BorderRadius.circular(16),
      ),

      child: const Icon(Icons.restaurant_rounded, color: AppTheme.primaryColor),
    );
  }

  Widget _emptySearch() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,

              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.14),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.search_rounded,
                size: 36,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'What did you eat?',

              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Search foods, products or your saved recipes.',
              textAlign: TextAlign.center,

              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nothingFound() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),

        child: Text(
          'No food found.\nTry another name or brand.',
          textAlign: TextAlign.center,

          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _smallServingText(Map<String, dynamic> item) {
    final description = item['servingDescription']?.toString() ?? '';

    if (description.trim().isNotEmpty) {
      return description;
    }

    return '100 g';
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }

    return value.toStringAsFixed(1);
  }
}

// ============================================================
// FOOD AMOUNT SHEET
// ============================================================

class _FoodAmountSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  final String mealTitle;

  const _FoodAmountSheet({required this.item, required this.mealTitle});

  @override
  State<_FoodAmountSheet> createState() => _FoodAmountSheetState();
}

class _FoodAmountSheetState extends State<_FoodAmountSheet> {
  late final TextEditingController amountController;

  late List<_ServingChoice> choices;
  late _ServingChoice selectedChoice;

  @override
  void initState() {
    super.initState();

    choices = _buildServingChoices();
    selectedChoice = choices.first;

    amountController = TextEditingController(
      text: selectedChoice.unit == 'g' ? '100' : '1',
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  bool get isRecipe => widget.item['isRecipe'] == true;

  double get enteredAmount {
    return double.tryParse(amountController.text.trim().replaceAll(',', '.')) ??
        0;
  }

  List<_ServingChoice> _buildServingChoices() {
    if (widget.item['isRecipe'] == true) {
      return [
        const _ServingChoice(label: 'Serving', unit: 'serving', grams: null),
      ];
    }

    final result = <_ServingChoice>[
      const _ServingChoice(label: 'g', unit: 'g', grams: 1),
    ];

    final rawOptions = widget.item['servingOptions'];

    if (rawOptions is List) {
      for (final raw in rawOptions) {
        if (raw is! Map) continue;

        final map = Map<String, dynamic>.from(raw);

        final label = map['label']?.toString().trim() ?? '';
        final unit = map['unit']?.toString().trim().toLowerCase() ?? '';
        final grams = _nullableDouble(map['grams']);

        if (label.isEmpty) continue;
        if (unit == 'g') continue;
        if (grams == null || grams <= 0) continue;

        result.add(
          _ServingChoice(
            label: _friendlyLabel(label),
            unit: unit.isEmpty ? label.toLowerCase() : unit,
            grams: grams,
          ),
        );
      }
    }

    final servingAmount = _toDouble(widget.item['servingAmount']);

    final servingUnit = widget.item['servingUnit']?.toString().toLowerCase();

    final description = widget.item['servingDescription']?.toString().trim();

    if (servingUnit == 'g' &&
        servingAmount > 0 &&
        servingAmount != 100 &&
        description != null &&
        description.isNotEmpty) {
      final alreadyExists = result.any(
        (choice) => choice.label.toLowerCase() == description.toLowerCase(),
      );

      if (!alreadyExists) {
        result.add(
          _ServingChoice(
            label: _friendlyLabel(description),
            unit: 'portion',
            grams: servingAmount,
          ),
        );
      }
    }

    return result;
  }

  double get totalGrams {
    if (isRecipe) return 0;

    if (selectedChoice.unit == 'g') {
      return enteredAmount;
    }

    return enteredAmount * (selectedChoice.grams ?? 0);
  }

  double get multiplier {
    if (isRecipe) {
      return enteredAmount;
    }

    final baseAmount = _toDouble(widget.item['servingAmount']);

    final baseUnit = widget.item['servingUnit']?.toString().toLowerCase();

    if (baseUnit == 'g' && baseAmount > 0) {
      return totalGrams / baseAmount;
    }

    return totalGrams / 100;
  }

  double _calc(String key) {
    final base = _toDouble(widget.item[key]);

    return base * multiplier;
  }

  void _save() {
    if (enteredAmount <= 0) return;

    final name = widget.item['name']?.toString() ?? '';
    final brand = widget.item['brand']?.toString() ?? '';

    final foodName = brand.trim().isEmpty ? name : '$name • $brand';

    Navigator.pop(context, {
      'id': widget.item['id'],
      'externalId': widget.item['externalId'],
      'source': widget.item['source'],
      'type': widget.item['type'],
      'foodName': foodName,
      'name': name,
      'brand': brand,
      'imageUrl': widget.item['imageUrl'],
      'amount': enteredAmount,
      'unit': selectedChoice.unit,
      'servingLabel': selectedChoice.label,
      'grams': isRecipe ? null : totalGrams,
      'calories': _calc('calories').round(),
      'protein': _calc('protein'),
      'carbs': _calc('carbs'),
      'fat': _calc('fat'),
      'fiber': _calc('fiber'),
      'sugar': _calc('sugar'),
      'sodium': _calc('sodium'),
      'isRecipe': isRecipe,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .82,
      ),

      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 5,
            margin: const EdgeInsets.only(top: 10, bottom: 6),

            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['name']?.toString() ?? '',

                    style: const TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  if ((widget.item['brand']?.toString() ?? '')
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(height: 4),

                    Text(
                      widget.item['brand'].toString(),

                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  const Text(
                    'Amount',

                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amountController,

                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                          ),

                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),

                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: DropdownButtonFormField<_ServingChoice>(
                          value: selectedChoice,
                          isExpanded: true,

                          dropdownColor: AppTheme.surfaceLightColor,

                          decoration: const InputDecoration(),

                          items: choices.map((option) {
                            return DropdownMenuItem(
                              value: option,

                              child: Text(
                                option.label,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              selectedChoice = value;

                              amountController.text = value.unit == 'g'
                                  ? '100'
                                  : '1';
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  if (!isRecipe &&
                      selectedChoice.unit != 'g' &&
                      selectedChoice.grams != null) ...[
                    const SizedBox(height: 9),

                    Text(
                      '1 ${selectedChoice.label} ≈ '
                      '${_formatNumber(selectedChoice.grams!)} g',

                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppTheme.purpleSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.25),
                      ),
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    'Calories',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    '${_calc('calories').round()} kcal',

                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: _macro('Protein', _calc('protein')),
                            ),
                            Expanded(child: _macro('Carbs', _calc('carbs'))),
                            Expanded(child: _macro('Fat', _calc('fat'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              14 + MediaQuery.of(context).padding.bottom,
            ),

            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(top: BorderSide(color: AppTheme.borderColor)),
            ),

            child: SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton(
                onPressed: enteredAmount > 0 ? _save : null,

                child: Text(
                  'Add to ${widget.mealTitle}',

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _macro(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,

          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          '${_formatNumber(value)} g',

          style: const TextStyle(
            color: AppTheme.purpleSoft,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  static String _friendlyLabel(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('slice')) return 'Slice';

    if (lower.contains('piece') || lower.contains('pcs') || lower == '1 item') {
      return 'Piece';
    }

    if (lower.contains('serving')) return 'Serving';

    if (lower.contains('portion')) return 'Portion';

    return input;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  static double? _nullableDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }

    return value.toStringAsFixed(1);
  }
}

class _ServingChoice {
  final String label;
  final String unit;
  final double? grams;

  const _ServingChoice({
    required this.label,
    required this.unit,
    required this.grams,
  });
}
