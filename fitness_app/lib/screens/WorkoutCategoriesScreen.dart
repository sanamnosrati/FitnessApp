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
      {'name': 'Upper Body', 'icon': Icons.fitness_center},
      {'name': 'Core', 'icon': Icons.accessibility_new},
      {'name': 'Lower Body', 'icon': Icons.directions_run},
      {'name': 'Full Body Stretch', 'icon': Icons.self_improvement},
      {'name': 'Cardio', 'icon': Icons.favorite},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Categories')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: uploadExercises,
              child: const Text('Upload Exercises to Firebase'),
            ),
          ),
          ...categories.map((category) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(category['icon'] as IconData),
                title: Text(category['name'] as String),
                trailing: const Icon(Icons.arrow_forward_ios),
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
              ),
            );
          }),
        ],
      ),
    );
  }
}
