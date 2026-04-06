import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;

  const ExerciseDetailScreen({super.key, required this.exerciseName});

  Map<String, dynamic> getExerciseDetails(String name) {
    switch (name) {
      case 'Bench Press':
        return {
          'description':
              'A compound exercise targeting the chest, shoulders, and triceps.',
          'sets': '3-4',
          'reps': '8-12',
          'tips': 'Keep your back slightly arched and control the movement.',
        };

      case 'Push-Up':
        return {
          'description': 'Bodyweight chest exercise.',
          'sets': '3',
          'reps': '10-20',
          'tips': 'Keep your body straight and core tight.',
        };

      default:
        return {
          'description': 'No description yet.',
          'sets': '-',
          'reps': '-',
          'tips': '-',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = getExerciseDetails(exerciseName);

    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details['description'], style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            Text('Sets: ${details['sets']}'),
            Text('Reps: ${details['reps']}'),

            const SizedBox(height: 20),

            Text('Tips:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(details['tips']),
          ],
        ),
      ),
    );
  }
}
