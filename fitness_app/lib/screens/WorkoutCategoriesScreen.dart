import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/exercise_seed_data.dart';
import 'cardioOptionsScreen.dart';
import 'coreMusclesScreen.dart';
import 'lowerBodyMusclesScreen.dart';
import 'upperBodyMusclesScreen.dart';
import 'fullBodyStretchScreen.dart';

Future<void> uploadExercises() async {
  for (final exercise in exerciseSeedData) {
    final docId = exercise['name']!.replaceAll(' ', '_').toLowerCase();

    await FirebaseFirestore.instance
        .collection('exercises')
        .doc(docId)
        .set(exercise);
  }

  print('UPLOAD DONE');
}

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Upper Body',
        'subtitle': 'Chest, back, shoulders and arms',
        'image': 'assets/images/workouts/upper_body.jpg',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Core',
        'subtitle': 'Abs, stability and strong center',
        'image': 'assets/images/workouts/core.jpg',
        'icon': Icons.accessibility_new,
      },
      {
        'name': 'Lower Body',
        'subtitle': 'Legs, glutes and power training',
        'image': 'assets/images/workouts/lower_body.jpg',
        'icon': Icons.directions_run,
      },
      {
        'name': 'Full Body Stretch',
        'subtitle': 'Mobility, flexibility and recovery',
        'image': 'assets/images/workouts/stretch.jpg',
        'icon': Icons.self_improvement,
      },
      {
        'name': 'Cardio',
        'subtitle': 'Burn calories and improve endurance',
        'image': 'assets/images/workouts/cardio.jpg',
        'icon': Icons.favorite,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3FA),
      appBar: AppBar(
        title: const Text(
          'Workout Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F3FA),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...categories.map((category) {
            return _WorkoutCategoryCard(
              title: category['name'] as String,
              subtitle: category['subtitle'] as String,
              imagePath: category['image'] as String,
              icon: category['icon'] as IconData,
              onTap: () {
                switch (category['name']) {
                  case 'Upper Body':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpperBodyMusclesScreen(),
                      ),
                    );
                    break;

                  case 'Core':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoreMusclesScreen(),
                      ),
                    );
                    break;

                  case 'Lower Body':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LowerBodyMusclesScreen(),
                      ),
                    );
                    break;

                  case 'Full Body Stretch':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FullBodyStretchScreen(),
                      ),
                    );
                    break;

                  case 'Cardio':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CardioOptionsScreen(),
                      ),
                    );
                    break;
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

class _WorkoutCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final IconData icon;
  final VoidCallback onTap;

  const _WorkoutCategoryCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.icon,
    required this.onTap,
  });

  Color getAccentColor() {
    switch (title) {
      case 'Upper Body':
        return const Color(0xFF7C4DFF);

      case 'Core':
        return const Color(0xFF00B8FF);

      case 'Lower Body':
        return const Color(0xFFFF7043);

      case 'Full Body Stretch':
        return const Color(0xFF26A69A);

      case 'Cardio':
        return const Color(0xFFE53935);

      default:
        return const Color(0xFF7C4DFF);
    }
  }

  String getWorkoutCount() {
    switch (title) {
      case 'Upper Body':
        return '42 workouts';

      case 'Core':
        return '18 workouts';

      case 'Lower Body':
        return '36 workouts';

      case 'Full Body Stretch':
        return '15 workouts';

      case 'Cardio':
        return '20 workouts';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = getAccentColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFF1B1B1F), Color(0xFF121316)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: accent.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.65)],
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getWorkoutCount(),
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade500,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
