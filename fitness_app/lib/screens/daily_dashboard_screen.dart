// lib/screens/daily_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class DailyDashboardScreen extends StatefulWidget {
  const DailyDashboardScreen({super.key});

  @override
  State<DailyDashboardScreen> createState() => _DailyDashboardScreenState();
}

class _DailyDashboardScreenState extends State<DailyDashboardScreen> {
  int selectedDayIndex = 0;

  int waterGoalMl = 2500;
  int waterDrunkMl = 1450;

  int calorieGoal = 1800;
  int caloriesEaten = 1120;

  int proteinIntake = 74;
  int carbsIntake = 98;
  int fiberIntake = 18;
  int fatIntake = 42;

  final List<Map<String, dynamic>> workouts = [
    {
      'name': 'Walking',
      'duration': 35,
      'calories': 160,
      'icon': Icons.directions_walk_rounded,
    },
    {
      'name': 'Strength Training',
      'duration': 25,
      'calories': 100,
      'icon': Icons.fitness_center_rounded,
    },
  ];

  final List<Map<String, dynamic>> meals = [
    {
      'title': 'Breakfast',
      'icon': Icons.free_breakfast_rounded,
      'protein': 24,
      'calories': 320,
      'items': 'Egg toast, Skyr',
    },
    {
      'title': 'Lunch',
      'icon': Icons.lunch_dining_rounded,
      'protein': 38,
      'calories': 520,
      'items': 'Chicken rice bowl',
    },
    {
      'title': 'Dinner',
      'icon': Icons.dinner_dining_rounded,
      'protein': 0,
      'calories': 0,
      'items': 'Not added yet',
    },
    {
      'title': 'Snacks',
      'icon': Icons.cookie_rounded,
      'protein': 12,
      'calories': 180,
      'items': 'Protein yogurt',
    },
    {
      'title': 'Drinks',
      'icon': Icons.local_drink_rounded,
      'protein': 0,
      'calories': 40,
      'items': 'Water, tea',
    },
    {
      'title': 'Dessert',
      'icon': Icons.icecream_rounded,
      'protein': 0,
      'calories': 0,
      'items': 'Not added yet',
    },
    {
      'title': 'Starter',
      'icon': Icons.tapas_rounded,
      'protein': 0,
      'calories': 60,
      'items': 'Small salad',
    },
  ];

  int get burnedCalories {
    return workouts.fold<int>(
      0,
      (sum, workout) => sum + (workout['calories'] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final double waterProgress = waterDrunkMl / waterGoalMl;
    final double calorieProgress = caloriesEaten / calorieGoal;
    final int netCalories = caloriesEaten - burnedCalories;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileHeader(user),
              const SizedBox(height: 20),
              _dateSwitcher(),
              const SizedBox(height: 22),

              Center(
                child: _nutritionCircle(
                  waterProgress: waterProgress,
                  calorieProgress: calorieProgress,
                ),
              ),

              const SizedBox(height: 14),

              _burnedCaloriesFocus(netCalories),

              const SizedBox(height: 18),

              _macroCompactPanel(),

              const SizedBox(height: 22),

              _waterEditor(),

              const SizedBox(height: 24),

              _mealsSection(),

              const SizedBox(height: 24),

              _workoutSection(),
            ],
          ),
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
          backgroundImage:
              user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
          child:
              user?.photoURL == null
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
                user?.displayName ?? 'Sanam',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF241C3B),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _showEditDailySheet(),
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
    final DateTime date = DateTime.now().subtract(
      Duration(days: selectedDayIndex),
    );

    final String text =
        selectedDayIndex == 0
            ? 'Today'
            : '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (selectedDayIndex < 29) {
                setState(() => selectedDayIndex++);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF241C3B),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (selectedDayIndex > 0) {
                setState(() => selectedDayIndex--);
              }
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  Widget _nutritionCircle({
    required double waterProgress,
    required double calorieProgress,
  }) {
    final Color calorieColor = _calorieColor();

    return SizedBox(
      height: 285,
      width: 285,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 270,
            width: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C4DCC).withOpacity(0.13),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 245,
            width: 245,
            child: CircularProgressIndicator(
              value: calorieProgress.clamp(0, 1.3),
              strokeWidth: 17,
              backgroundColor: const Color(0xFFEDE8F8),
              color: calorieColor,
              strokeCap: StrokeCap.round,
            ),
          ),
          SizedBox(
            height: 195,
            width: 195,
            child: CircularProgressIndicator(
              value: waterProgress.clamp(0, 1),
              strokeWidth: 15,
              backgroundColor: const Color(0xFFE7F4FF),
              color: const Color(0xFF42A5F5),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$caloriesEaten',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: calorieColor,
                ),
              ),
              const Text(
                'kcal eaten',
                style: TextStyle(fontSize: 13, color: Color(0xFF7A728A)),
              ),
              const SizedBox(height: 14),
              Text(
                '$waterDrunkMl ml',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF42A5F5),
                ),
              ),
              const Text(
                'water',
                style: TextStyle(fontSize: 13, color: Color(0xFF7A728A)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _burnedCaloriesFocus(int netCalories) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1A2E),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7043).withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF7043),
              size: 34,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Burned through workout',
                  style: TextStyle(color: Color(0xFFCFC8E6), fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  '-$burnedCalories kcal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Net calories: $netCalories kcal',
                  style: const TextStyle(
                    color: Color(0xFFFFCCBC),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroCompactPanel() {
    return Row(
      children: [
        Expanded(child: _macroSmallCard('Protein', proteinIntake, 'g')),
        const SizedBox(width: 10),
        Expanded(child: _macroSmallCard('Carbs', carbsIntake, 'g')),
        const SizedBox(width: 10),
        Expanded(child: _macroSmallCard('Fiber', fiberIntake, 'g')),
        const SizedBox(width: 10),
        Expanded(child: _macroSmallCard('Fat', fatIntake, 'g')),
      ],
    );
  }

  Widget _macroSmallCard(String title, int value, String unit) {
    return GestureDetector(
      onTap: () => _showEditDailySheet(),
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

  Widget _waterEditor() {
    return Row(
      children: [
        Expanded(
          child: _infoButton(
            title: 'Water',
            value: '$waterDrunkMl / $waterGoalMl ml',
            icon: Icons.water_drop_rounded,
            color: const Color(0xFF42A5F5),
            onTap: () => _showEditDailySheet(),
          ),
        ),
        const SizedBox(width: 10),
        _roundActionButton(Icons.remove_rounded, () {
          setState(() => waterDrunkMl = max(0, waterDrunkMl - 250));
        }),
        const SizedBox(width: 8),
        _roundActionButton(Icons.add_rounded, () {
          setState(() => waterDrunkMl += 250);
        }),
      ],
    );
  }

  Widget _infoButton({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A728A),
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF241C3B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundActionButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6C4DCC),
        fixedSize: const Size(48, 48),
      ),
      icon: Icon(icon),
    );
  }

  Widget _mealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meals',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Color(0xFF241C3B),
          ),
        ),
        const SizedBox(height: 12),
        ...meals.map((meal) => _mealListTile(meal)),
      ],
    );
  }

  Widget _mealListTile(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF241C3B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  meal['items'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A728A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${meal['protein']}g protein • ${meal['calories']} kcal',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showEditMealSheet(meal),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF6C4DCC),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
    );
  }

  Widget _workoutSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Workout Activity',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF241C3B),
                  ),
                ),
              ),
              Text(
                '-$burnedCalories kcal',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF7043),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'What you did today',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF7A728A),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          if (workouts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'No workout added yet',
                style: TextStyle(
                  color: Color(0xFF7A728A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            ...workouts.map((workout) => _workoutListTile(workout)),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddWorkoutSheet(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF241C3B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add Workout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
          CircleAvatar(
            radius: 23,
            backgroundColor: const Color(0xFFFFE3D8),
            child: Icon(
              workout['icon'] as IconData,
              color: const Color(0xFFFF7043),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout['name'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF241C3B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout['duration']} min',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7A728A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-${workout['calories']} kcal',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF7043),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => _showEditWorkoutItemSheet(workout),
            icon: const Icon(Icons.edit_rounded, size: 20),
            color: const Color(0xFF6C4DCC),
          ),
        ],
      ),
    );
  }

  void _showEditDailySheet() {
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
          title: 'Edit Daily Intake',
          children: [
            _numberField(waterController, 'Water ml'),
            _numberField(caloriesController, 'Calories eaten'),
            _numberField(proteinController, 'Protein g'),
            _numberField(carbsController, 'Carbs g'),
            _numberField(fiberController, 'Fiber g'),
            _numberField(fatController, 'Fat g'),
          ],
          onSave: () {
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
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showAddWorkoutSheet() {
    final nameController = TextEditingController();
    final minutesController = TextEditingController();
    final caloriesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return _editSheet(
          title: 'Add Workout',
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Workout name',
                hintText: 'e.g. Running, Walking, Gym',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _numberField(minutesController, 'Duration minutes'),
            _numberField(caloriesController, 'Burned calories'),
          ],
          onSave: () {
            final String name =
                nameController.text.trim().isEmpty
                    ? 'Workout'
                    : nameController.text.trim();

            final int minutes = int.tryParse(minutesController.text) ?? 0;
            final int calories =
                int.tryParse(caloriesController.text) ?? max(0, minutes * 6);

            setState(() {
              workouts.add({
                'name': name,
                'duration': minutes,
                'calories': calories,
                'icon': Icons.fitness_center_rounded,
              });
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showEditWorkoutItemSheet(Map<String, dynamic> workout) {
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
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Workout name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _numberField(minutesController, 'Duration minutes'),
            _numberField(caloriesController, 'Burned calories'),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  workouts.remove(workout);
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_rounded),
              label: const Text('Delete Workout'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
              ),
            ),
          ],
          onSave: () {
            setState(() {
              workout['name'] =
                  nameController.text.trim().isEmpty
                      ? 'Workout'
                      : nameController.text.trim();
              workout['duration'] =
                  int.tryParse(minutesController.text) ?? workout['duration'];
              workout['calories'] =
                  int.tryParse(caloriesController.text) ?? workout['calories'];
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showEditMealSheet(Map<String, dynamic> meal) {
    final itemController = TextEditingController(text: meal['items']);
    final proteinController = TextEditingController(
      text: meal['protein'].toString(),
    );
    final caloriesController = TextEditingController(
      text: meal['calories'].toString(),
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
          title: 'Edit ${meal['title']}',
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(
                labelText: 'Food eaten',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _numberField(proteinController, 'Protein g'),
            _numberField(caloriesController, 'Calories kcal'),
          ],
          onSave: () {
            setState(() {
              meal['items'] = itemController.text.trim();
              meal['protein'] =
                  int.tryParse(proteinController.text) ?? meal['protein'];
              meal['calories'] =
                  int.tryParse(caloriesController.text) ?? meal['calories'];
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _editSheet({
    required String title,
    required List<Widget> children,
    required VoidCallback onSave,
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
                fontWeight: FontWeight.bold,
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
                  style: TextStyle(fontWeight: FontWeight.bold),
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

  Color _calorieColor() {
    final double percent = caloriesEaten / calorieGoal;

    if (percent <= 0.8) return const Color(0xFF4CAF50);
    if (percent <= 1.05) return const Color(0xFFFFC107);
    return const Color(0xFFE53935);
  }
}
