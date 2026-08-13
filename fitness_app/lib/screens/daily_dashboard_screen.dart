import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/daily_log_service.dart';
import 'food_search_screen.dart';
import 'workout_search_screen.dart';

class DailyDashboardScreen extends StatefulWidget {
  const DailyDashboardScreen({super.key});

  @override
  State<DailyDashboardScreen> createState() => _DailyDashboardScreenState();
}

class _DailyDashboardScreenState extends State<DailyDashboardScreen> {
  int selectedDayIndex = 0;

  bool isLoading = true;
  bool isSaving = false;

  int waterGoalMl = 2500;
  int waterDrunkMl = 0;

  int calorieGoal = 1800;
  int caloriesEaten = 0;

  int proteinIntake = 0;
  int carbsIntake = 0;
  int fiberIntake = 0;
  int fatIntake = 0;

  List<Map<String, dynamic>> workouts = [];
  List<Map<String, dynamic>> meals = [];

  DateTime get selectedDate =>
      DateTime.now().subtract(Duration(days: selectedDayIndex));

  bool get isToday => selectedDayIndex == 0;

  int get burnedCalories {
    return workouts.fold<int>(0, (sum, workout) {
      final value = workout['calories'];

      if (value is int) {
        return sum + value;
      }

      if (value is num) {
        return sum + value.round();
      }

      return sum;
    });
  }

  int get netCalories => caloriesEaten - burnedCalories;

  @override
  void initState() {
    super.initState();
    _loadDailyData();
  }

  Future<void> _loadDailyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await DailyLogService.loadDailyLog(selectedDate);

      setState(() {
        waterGoalMl = data['waterGoalMl'] ?? 2500;
        waterDrunkMl = data['waterDrunkMl'] ?? 0;

        calorieGoal = data['calorieGoal'] ?? 1800;
        caloriesEaten = data['caloriesEaten'] ?? 0;

        proteinIntake = data['protein'] ?? 0;
        carbsIntake = data['carbs'] ?? 0;
        fiberIntake = data['fiber'] ?? 0;
        fatIntake = data['fat'] ?? 0;

        meals = _loadMeals(data['meals']);
        workouts = _loadWorkouts(data['workouts']);

        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load daily data.')),
      );
    }
  }

  List<Map<String, dynamic>> _loadMeals(dynamic rawMeals) {
    final fallback = DailyLogService.defaultMeals();

    if (rawMeals is! List) {
      return fallback;
    }

    return rawMeals.map<Map<String, dynamic>>((meal) {
      final map = Map<String, dynamic>.from(meal as Map);

      return {
        'title': map['title'] ?? 'Meal',
        'protein': map['protein'] ?? 0,
        'calories': map['calories'] ?? 0,
        'items': map['items'] ?? 'Not added yet',
        'icon': _mealIcon(map['title'] ?? ''),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _loadWorkouts(dynamic rawWorkouts) {
    if (rawWorkouts is! List) {
      return [];
    }

    return rawWorkouts.map<Map<String, dynamic>>((workout) {
      final map = Map<String, dynamic>.from(workout as Map);

      return {
        'name': map['name'] ?? 'Workout',
        'duration': map['duration'] ?? 0,
        'calories': map['calories'] ?? 0,
        'icon': Icons.fitness_center_rounded,
      };
    }).toList();
  }

  IconData _mealIcon(String title) {
    switch (title) {
      case 'Breakfast':
        return Icons.free_breakfast_rounded;

      case 'Lunch':
        return Icons.lunch_dining_rounded;

      case 'Dinner':
        return Icons.dinner_dining_rounded;

      case 'Snacks':
        return Icons.cookie_rounded;

      case 'Drinks':
        return Icons.local_drink_rounded;

      case 'Dessert':
        return Icons.icecream_rounded;

      case 'Starter':
        return Icons.tapas_rounded;

      default:
        return Icons.restaurant_rounded;
    }
  }

  Future<void> _saveDailyData() async {
    if (!isToday) return;

    setState(() {
      isSaving = true;
    });

    try {
      await DailyLogService.saveFullDailyLog(
        date: selectedDate,
        waterGoalMl: waterGoalMl,
        waterDrunkMl: waterDrunkMl,
        calorieGoal: calorieGoal,
        caloriesEaten: caloriesEaten,
        protein: proteinIntake,
        carbs: carbsIntake,
        fiber: fiberIntake,
        fat: fatIntake,
        meals: meals,
        workouts: workouts,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String _dateText() {
    if (selectedDayIndex == 0) {
      return 'Today';
    }

    if (selectedDayIndex == 1) {
      return 'Yesterday';
    }

    final d = selectedDate;

    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }

  String _subtitleText() {
    return isToday ? 'Add and edit your day' : 'Read-only saved overview';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final double waterProgress = waterGoalMl == 0
        ? 0
        : waterDrunkMl / waterGoalMl;

    final double calorieProgress = calorieGoal == 0
        ? 0
        : caloriesEaten / calorieGoal;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                children: [
                  _profileHeader(user),

                  const SizedBox(height: 18),

                  _dateSwitcher(),

                  const SizedBox(height: 22),

                  _overviewCard(waterProgress, calorieProgress),

                  const SizedBox(height: 18),

                  _calorieSummary(),

                  const SizedBox(height: 18),

                  _macroPanel(),

                  const SizedBox(height: 22),

                  _waterCard(),

                  const SizedBox(height: 24),

                  _mealsSection(),

                  const SizedBox(height: 24),

                  _workoutSection(),

                  if (isSaving)
                    const Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _profileHeader(User? user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFE5DBFF),
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(
                  Icons.person_rounded,
                  size: 34,
                  color: Color(0xFF6C4DCC),
                )
              : null,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(fontSize: 14, color: Color(0xFF7A728A)),
              ),

              Text(
                user?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF241C3B),
                ),
              ),
            ],
          ),
        ),

        if (isToday)
          IconButton(
            onPressed: _showEditDailySheet,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6C4DCC),
            ),
            icon: const Icon(Icons.edit_rounded),
          ),
      ],
    );
  }

  Widget _dateSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: selectedDayIndex >= 29
                ? null
                : () async {
                    setState(() {
                      selectedDayIndex++;
                    });

                    await _loadDailyData();
                  },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  _dateText(),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF241C3B),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _subtitleText(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A728A),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: selectedDayIndex <= 0
                ? null
                : () async {
                    setState(() {
                      selectedDayIndex--;
                    });

                    await _loadDailyData();
                  },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(double waterProgress, double calorieProgress) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF241C3B),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          Text(
            isToday ? 'Today’s Progress' : 'Saved Day Overview',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 230,
            width: 230,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 220,
                  width: 220,
                  child: CircularProgressIndicator(
                    value: calorieProgress.clamp(0, 1.3),
                    strokeWidth: 17,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    color: _calorieColor(),
                    strokeCap: StrokeCap.round,
                  ),
                ),

                SizedBox(
                  height: 168,
                  width: 168,
                  child: CircularProgressIndicator(
                    value: waterProgress.clamp(0, 1),
                    strokeWidth: 14,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    color: const Color(0xFF42A5F5),
                    strokeCap: StrokeCap.round,
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$caloriesEaten',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const Text(
                      'kcal eaten',
                      style: TextStyle(color: Color(0xFFCFC8E6)),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '$waterDrunkMl ml',
                      style: const TextStyle(
                        color: Color(0xFF42A5F5),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const Text(
                      'water',
                      style: TextStyle(color: Color(0xFFCFC8E6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calorieSummary() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Eaten',
            value: '$caloriesEaten',
            unit: 'kcal',
            icon: Icons.restaurant_rounded,
            color: const Color(0xFF4CAF50),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _summaryCard(
            title: 'Burned',
            value: '-$burnedCalories',
            unit: 'kcal',
            icon: Icons.local_fire_department_rounded,
            color: const Color(0xFFFF7043),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _summaryCard(
            title: 'Net',
            value: '$netCalories',
            unit: 'kcal',
            icon: Icons.balance_rounded,
            color: const Color(0xFF6C4DCC),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF241C3B),
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),

          Text(
            unit,
            style: const TextStyle(color: Color(0xFF7A728A), fontSize: 11),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(color: Color(0xFF7A728A), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _macroPanel() {
    return Row(
      children: [
        Expanded(child: _macroSmallCard('Protein', proteinIntake, 'g')),

        const SizedBox(width: 9),

        Expanded(child: _macroSmallCard('Carbs', carbsIntake, 'g')),

        const SizedBox(width: 9),

        Expanded(child: _macroSmallCard('Fiber', fiberIntake, 'g')),

        const SizedBox(width: 9),

        Expanded(child: _macroSmallCard('Fat', fatIntake, 'g')),
      ],
    );
  }

  Widget _macroSmallCard(String title, int value, String unit) {
    return GestureDetector(
      onTap: isToday ? _showEditDailySheet : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          children: [
            Text(
              '$value$unit',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Color(0xFF241C3B),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7A728A)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE7F4FF),
            child: Icon(Icons.water_drop_rounded, color: Color(0xFF42A5F5)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              '$waterDrunkMl / $waterGoalMl ml water',
              style: const TextStyle(
                color: Color(0xFF241C3B),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),

          if (isToday) ...[
            IconButton(
              onPressed: () async {
                setState(() {
                  waterDrunkMl = max(0, waterDrunkMl - 250);
                });

                await _saveDailyData();
              },
              icon: const Icon(Icons.remove_rounded),
            ),

            IconButton(
              onPressed: () async {
                setState(() {
                  waterDrunkMl += 250;
                });

                await _saveDailyData();
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ],
      ),
    );
  }

  Widget _mealsSection() {
    return _section(
      title: 'Meals',
      child: Column(
        children: meals.map((meal) => _mealListTile(meal)).toList(),
      ),
    );
  }

  Widget _mealListTile(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFECE5FF),
            child: Icon(meal['icon'], color: const Color(0xFF6C4DCC)),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF241C3B),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  meal['items'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A728A),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${meal['protein']}g protein • '
                  '${meal['calories']} kcal',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),

          if (isToday)
            IconButton(
              onPressed: () {
                _showEditMealSheet(meal);
              },
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DCC),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add_rounded),
            ),
        ],
      ),
    );
  }

  Widget _workoutSection() {
    return _section(
      title: 'Workout Activity',

      trailing: isToday
          ? IconButton(
              onPressed: _openWorkoutSearch,
              icon: const Icon(Icons.add_rounded),
              color: const Color(0xFF6C4DCC),
            )
          : Text(
              '-$burnedCalories kcal',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFFFF7043),
              ),
            ),

      child: workouts.isEmpty
          ? const Text(
              'No workout saved for this day.',
              style: TextStyle(color: Color(0xFF7A728A)),
            )
          : Column(
              children: workouts
                  .map((workout) => _workoutListTile(workout))
                  .toList(),
            ),
    );
  }

  Widget _workoutListTile(Map<String, dynamic> workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFFFFE3D8),
            child: Icon(Icons.fitness_center_rounded, color: Color(0xFFFF7043)),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              '${workout['name']} • '
              '${_durationText(workout['duration'])}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF241C3B),
              ),
            ),
          ),

          Text(
            '-${workout['calories']} kcal',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF7043),
            ),
          ),

          if (isToday)
            IconButton(
              onPressed: () {
                _showEditWorkoutItemSheet(workout);
              },
              icon: const Icon(Icons.edit_rounded, size: 20),
              color: const Color(0xFF6C4DCC),
            ),
        ],
      ),
    );
  }

  String _durationText(dynamic rawMinutes) {
    final minutes = rawMinutes is num ? rawMinutes.round() : 0;

    final hours = minutes ~/ 60;

    final remaining = minutes % 60;

    if (hours > 0 && remaining > 0) {
      return '${hours}h ${remaining}min';
    }

    if (hours > 0) {
      return '${hours}h';
    }

    return '${remaining}min';
  }

  Widget _section({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF241C3B),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              if (trailing != null) trailing,
            ],
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  Future<void> _openWorkoutSearch() async {
    if (!isToday) {
      return;
    }

    // Später automatisch aus User Profile holen.
    const double weightKg = 60;

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const WorkoutSearchScreen(weightKg: weightKg),
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      workouts.add({
        'name': result['name'] ?? 'Workout',

        'duration': result['duration'] ?? 0,

        'calories': result['calories'] ?? 0,

        'icon': Icons.fitness_center_rounded,
      });
    });

    await _saveDailyData();
  }

  void _showEditDailySheet() {
    if (!isToday) {
      return;
    }

    final waterController = TextEditingController(
      text: waterDrunkMl.toString(),
    );

    final caloriesController = TextEditingController(
      text: caloriesEaten.toString(),
    );

    final proteinController = TextEditingController(
      text: proteinIntake.toString(),
    );

    final carbsController = TextEditingController(text: carbsIntake.toString());

    final fiberController = TextEditingController(text: fiberIntake.toString());

    final fatController = TextEditingController(text: fatIntake.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return _editSheet(
          title: 'Edit Today',

          children: [
            _numberField(waterController, 'Water ml'),

            _numberField(caloriesController, 'Calories eaten'),

            _numberField(proteinController, 'Protein g'),

            _numberField(carbsController, 'Carbs g'),

            _numberField(fiberController, 'Fiber g'),

            _numberField(fatController, 'Fat g'),
          ],

          onSave: () async {
            setState(() {
              waterDrunkMl = int.tryParse(waterController.text) ?? waterDrunkMl;

              caloriesEaten =
                  int.tryParse(caloriesController.text) ?? caloriesEaten;

              proteinIntake =
                  int.tryParse(proteinController.text) ?? proteinIntake;

              carbsIntake = int.tryParse(carbsController.text) ?? carbsIntake;

              fiberIntake = int.tryParse(fiberController.text) ?? fiberIntake;

              fatIntake = int.tryParse(fatController.text) ?? fatIntake;
            });

            await _saveDailyData();

            if (!mounted) return;

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showEditWorkoutItemSheet(Map<String, dynamic> workout) {
    if (!isToday) {
      return;
    }

    final nameController = TextEditingController(text: workout['name']);

    final minutesController = TextEditingController(
      text: workout['duration'].toString(),
    );

    final caloriesController = TextEditingController(
      text: workout['calories'].toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return _editSheet(
          title: 'Edit Workout',

          children: [
            _textField(nameController, 'Workout name'),

            _numberField(minutesController, 'Duration minutes'),

            _numberField(caloriesController, 'Burned calories'),

            TextButton.icon(
              onPressed: () async {
                setState(() {
                  workouts.remove(workout);
                });

                await _saveDailyData();

                if (!mounted) return;

                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_rounded),
              label: const Text('Delete Workout'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],

          onSave: () async {
            setState(() {
              workout['name'] = nameController.text.trim().isEmpty
                  ? 'Workout'
                  : nameController.text.trim();

              workout['duration'] =
                  int.tryParse(minutesController.text) ?? workout['duration'];

              workout['calories'] =
                  int.tryParse(caloriesController.text) ?? workout['calories'];
            });

            await _saveDailyData();

            if (!mounted) return;

            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _showEditMealSheet(Map<String, dynamic> meal) async {
    if (!isToday) {
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => FoodSearchScreen(mealTitle: meal['title'].toString()),
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      meal['items'] = result['foodName'] ?? 'Not added yet';

      meal['calories'] = result['calories'] ?? 0;

      meal['protein'] = result['protein'] ?? 0;

      meal['carbs'] = result['carbs'] ?? 0;

      meal['fat'] = result['fat'] ?? 0;

      meal['fiber'] = result['fiber'] ?? 0;

      caloriesEaten = meals.fold<int>(0, (sum, m) {
        final value = m['calories'];

        if (value is num) {
          return sum + value.round();
        }

        return sum;
      });

      proteinIntake = meals.fold<int>(0, (sum, m) {
        final value = m['protein'];

        if (value is num) {
          return sum + value.round();
        }

        return sum;
      });

      carbsIntake = meals.fold<int>(0, (sum, m) {
        final value = m['carbs'];

        if (value is num) {
          return sum + value.round();
        }

        return sum;
      });

      fatIntake = meals.fold<int>(0, (sum, m) {
        final value = m['fat'];

        if (value is num) {
          return sum + value.round();
        }

        return sum;
      });

      fiberIntake = meals.fold<int>(0, (sum, m) {
        final value = m['fiber'];

        if (value is num) {
          return sum + value.round();
        }

        return sum;
      });
    });

    await _saveDailyData();
  }

  Widget _editSheet({
    required String title,
    required List<Widget> children,
    required Future<void> Function() onSave,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF241C3B),
              ),
            ),

            const SizedBox(height: 18),

            ...children,

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DCC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Color _calorieColor() {
    final percent = calorieGoal == 0 ? 0 : caloriesEaten / calorieGoal;

    if (percent <= 0.8) {
      return const Color(0xFF4CAF50);
    }

    if (percent <= 1.05) {
      return const Color(0xFFFFC107);
    }

    return const Color(0xFFE53935);
  }
}
