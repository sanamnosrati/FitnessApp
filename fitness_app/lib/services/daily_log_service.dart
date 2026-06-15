import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyLogService {
  DailyLogService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get uid => _auth.currentUser?.uid;

  static String dateId(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static List<Map<String, dynamic>> defaultMeals() {
    return [
      {
        'title': 'Breakfast',
        'protein': 0,
        'calories': 0,
        'items': 'Not added yet',
      },
      {'title': 'Lunch', 'protein': 0, 'calories': 0, 'items': 'Not added yet'},
      {
        'title': 'Dinner',
        'protein': 0,
        'calories': 0,
        'items': 'Not added yet',
      },
      {
        'title': 'Snacks',
        'protein': 0,
        'calories': 0,
        'items': 'Not added yet',
      },
      {
        'title': 'Drinks',
        'protein': 0,
        'calories': 0,
        'items': 'Not added yet',
      },
      {
        'title': 'Dessert',
        'protein': 0,
        'calories': 0,
        'items': 'Not added yet',
      },
      {
        'title': 'Starter',
        'protein': 0,
        'calories': 0,
        'items': 'Not added yet',
      },
    ];
  }

  static DocumentReference<Map<String, dynamic>> _dailyRef(DateTime date) {
    final currentUid = uid;
    if (currentUid == null) {
      throw Exception('No logged in user');
    }

    return _db
        .collection('users')
        .doc(currentUid)
        .collection('daily_logs')
        .doc(dateId(date));
  }

  static Future<Map<String, dynamic>> loadDailyLog(DateTime date) async {
    final doc = await _dailyRef(date).get();

    if (!doc.exists) {
      final defaultData = _defaultDailyLog(date);
      await _dailyRef(date).set(defaultData, SetOptions(merge: true));
      return defaultData;
    }

    return doc.data() ?? _defaultDailyLog(date);
  }

  static Future<void> saveDailySummary({
    required DateTime date,
    required int waterGoalMl,
    required int waterDrunkMl,
    required int calorieGoal,
    required int caloriesEaten,
    required int protein,
    required int carbs,
    required int fiber,
    required int fat,
  }) async {
    await _dailyRef(date).set({
      'date': dateId(date),
      'waterGoalMl': waterGoalMl,
      'waterDrunkMl': waterDrunkMl,
      'calorieGoal': calorieGoal,
      'caloriesEaten': caloriesEaten,
      'protein': protein,
      'carbs': carbs,
      'fiber': fiber,
      'fat': fat,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> saveMeals({
    required DateTime date,
    required List<Map<String, dynamic>> meals,
  }) async {
    final cleanMeals =
        meals.map((meal) {
          return {
            'title': meal['title'],
            'protein': meal['protein'],
            'calories': meal['calories'],
            'items': meal['items'],
          };
        }).toList();

    await _dailyRef(date).set({
      'meals': cleanMeals,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> saveWorkouts({
    required DateTime date,
    required List<Map<String, dynamic>> workouts,
  }) async {
    final cleanWorkouts =
        workouts.map((workout) {
          return {
            'name': workout['name'],
            'duration': workout['duration'],
            'calories': workout['calories'],
          };
        }).toList();

    await _dailyRef(date).set({
      'workouts': cleanWorkouts,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> saveFullDailyLog({
    required DateTime date,
    required int waterGoalMl,
    required int waterDrunkMl,
    required int calorieGoal,
    required int caloriesEaten,
    required int protein,
    required int carbs,
    required int fiber,
    required int fat,
    required List<Map<String, dynamic>> meals,
    required List<Map<String, dynamic>> workouts,
  }) async {
    final cleanMeals =
        meals.map((meal) {
          return {
            'title': meal['title'],
            'protein': meal['protein'],
            'calories': meal['calories'],
            'items': meal['items'],
          };
        }).toList();

    final cleanWorkouts =
        workouts.map((workout) {
          return {
            'name': workout['name'],
            'duration': workout['duration'],
            'calories': workout['calories'],
          };
        }).toList();

    await _dailyRef(date).set({
      'date': dateId(date),
      'waterGoalMl': waterGoalMl,
      'waterDrunkMl': waterDrunkMl,
      'calorieGoal': calorieGoal,
      'caloriesEaten': caloriesEaten,
      'protein': protein,
      'carbs': carbs,
      'fiber': fiber,
      'fat': fat,
      'meals': cleanMeals,
      'workouts': cleanWorkouts,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Map<String, dynamic> _defaultDailyLog(DateTime date) {
    return {
      'date': dateId(date),
      'waterGoalMl': 2500,
      'waterDrunkMl': 0,
      'calorieGoal': 1800,
      'caloriesEaten': 0,
      'protein': 0,
      'carbs': 0,
      'fiber': 0,
      'fat': 0,
      'meals': [
        {
          'title': 'Breakfast',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
        {
          'title': 'Lunch',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
        {
          'title': 'Dinner',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
        {
          'title': 'Snacks',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
        {
          'title': 'Drinks',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
        {
          'title': 'Dessert',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
        {
          'title': 'Starter',
          'protein': 0,
          'calories': 0,
          'items': 'Not added yet',
        },
      ],
      'workouts': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
