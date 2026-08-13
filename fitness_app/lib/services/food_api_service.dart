import 'dart:convert';

import 'package:http/http.dart' as http;

class FoodApiService {
  static const String _baseUrl = 'https://searchfood-k25ytiffza-ew.a.run.app';

  static Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    final cleanQuery = query.trim();

    if (cleanQuery.length < 2) {
      return [];
    }

    try {
      final uri = Uri.parse(
        _baseUrl,
      ).replace(queryParameters: {'q': cleanQuery});

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Food search failed: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return [];
      }

      final rawFoods = decoded['foods'];

      if (rawFoods is! List) {
        return [];
      }

      return rawFoods
          .whereType<Map>()
          .map<Map<String, dynamic>>((rawFood) {
            final food = Map<String, dynamic>.from(rawFood);

            final servingAmount = _toDouble(food['servingAmount']);

            final rawServingOptions = food['servingOptions'];

            final servingOptions = <Map<String, dynamic>>[];

            if (rawServingOptions is List) {
              for (final option in rawServingOptions) {
                if (option is Map) {
                  servingOptions.add(Map<String, dynamic>.from(option));
                }
              }
            }

            return {
              // =================================================
              // IDENTIFIERS
              // =================================================
              'id': food['id']?.toString() ?? '',

              'externalId': food['externalId']?.toString() ?? '',

              // Keep source internally.
              // We DO NOT display this in the UI.
              'source': food['source']?.toString() ?? '',

              'type': food['type']?.toString() ?? 'Food',

              // =================================================
              // BASIC INFORMATION
              // =================================================
              'name': food['name']?.toString() ?? '',

              'brand': food['brand']?.toString() ?? '',

              'imageUrl': food['imageUrl']?.toString() ?? '',

              // =================================================
              // NUTRITION
              // =================================================
              'calories': _toDouble(food['calories']),

              'protein': _toDouble(food['protein']),

              'carbs': _toDouble(food['carbs']),

              'fat': _toDouble(food['fat']),

              'fiber': _toDouble(food['fiber']),

              'sugar': _toDouble(food['sugar']),

              'sodium': _toDouble(food['sodium']),

              // =================================================
              // BASE SERVING
              // =================================================
              'servingDescription':
                  food['servingDescription']?.toString() ?? '100 g',

              'servingAmount': servingAmount <= 0 ? 100.0 : servingAmount,

              'servingUnit': food['servingUnit']?.toString() ?? 'g',

              // =================================================
              // SERVING OPTIONS
              //
              // Example:
              //
              // [
              //   {
              //     "label": "Slice",
              //     "unit": "slice",
              //     "grams": 28
              //   },
              //   {
              //     "label": "Piece",
              //     "unit": "piece",
              //     "grams": 50
              //   }
              // ]
              //
              // =================================================
              'servingOptions': servingOptions,

              // External food = false.
              // Own Firestore recipes are set to true
              // inside FoodSearchScreen.
              'isRecipe': false,
            };
          })
          .where((food) {
            final name = food['name'].toString().trim();

            return name.isNotEmpty;
          })
          .toList();
    } catch (e) {
      throw Exception('Could not load foods: $e');
    }
  }

  // =============================================================
  // HELPERS
  // =============================================================

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }
}
