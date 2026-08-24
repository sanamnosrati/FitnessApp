import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/exercise_seed_data.dart';
import '../theme/app_theme.dart';

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
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'name': 'Core',
        'subtitle': 'Abs, stability and strong center',
        'icon': Icons.accessibility_new_rounded,
        'color': const Color(0xFF3B82F6),
      },
      {
        'name': 'Lower Body',
        'subtitle': 'Legs, glutes and power training',
        'icon': Icons.directions_run_rounded,
        'color': const Color(0xFFF97316),
      },
      {
        'name': 'Full Body Stretch',
        'subtitle': 'Mobility, flexibility and recovery',
        'icon': Icons.self_improvement_rounded,
        'color': const Color(0xFF14B8A6),
      },
      {
        'name': 'Cardio',
        'subtitle': 'Burn calories and improve endurance',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFFEF4444),
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Workout Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        foregroundColor: AppTheme.textPrimaryColor,
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          ...categories.map((category) {
            return _WorkoutCategoryCard(
              title: category['name'] as String,
              subtitle: category['subtitle'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
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
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _WorkoutCategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            height: 92,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.28), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(icon, color: color, size: 28),
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
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondaryColor,
                  size: 27,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
