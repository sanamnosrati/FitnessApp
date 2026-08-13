import 'dart:convert';

import 'package:http/http.dart' as http;

class WorkoutApiService {
  static const String _baseUrl =
      'https://europe-west1-fitnesapp-6cfd4.cloudfunctions.net/searchActivities';

  static Future<List<Map<String, dynamic>>> searchActivities({
    required String query,
    required double weightKg,
    required int durationMinutes,
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.length < 2) {
      return [];
    }

    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'activity': cleanQuery,
          'weightKg': weightKg.toString(),
          'durationMinutes': durationMinutes.toString(),
        },
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Workout search failed: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        return [];
      }

      final rawActivities = data['activities'];

      if (rawActivities is! List) {
        return [];
      }

      return rawActivities
          .whereType<Map>()
          .map<Map<String, dynamic>>((raw) {
            final item = Map<String, dynamic>.from(raw);

            return {
              'id': item['id']?.toString() ?? '',
              'name': item['name']?.toString() ?? '',
              'caloriesPerHour': _toDouble(item['caloriesPerHour']),
              'durationMinutes': _toInt(item['durationMinutes']),
              'totalCalories': _toInt(item['totalCalories']),
              'weightKg': _toDouble(item['weightKg']),
              'source': item['source']?.toString() ?? 'API Ninjas',
            };
          })
          .where((item) => item['name'].toString().trim().isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Could not load activities: $e');
    }
  }

  static Future<int> calculateCalories({
    required String activity,
    required double weightKg,
    required int durationMinutes,
  }) async {
    final results = await searchActivities(
      query: activity,
      weightKg: weightKg,
      durationMinutes: durationMinutes,
    );

    if (results.isEmpty) {
      return 0;
    }

    final exact = results.where((item) {
      return item['name'].toString().toLowerCase().trim() ==
          activity.toLowerCase().trim();
    }).toList();

    final selected = exact.isNotEmpty ? exact.first : results.first;

    return _toInt(selected['totalCalories']);
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.round();
    }

    return double.tryParse(value?.toString() ?? '')?.round() ?? 0;
  }
}
