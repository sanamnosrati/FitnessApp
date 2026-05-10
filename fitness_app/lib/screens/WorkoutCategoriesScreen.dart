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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.fitWidth),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.72),
                      Colors.black.withOpacity(0.25),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(icon, color: Colors.white, size: 22),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
