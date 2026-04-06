import 'package:flutter/material.dart';
import 'exercise_detail_screen.dart';

class MuscleDetailScreen extends StatelessWidget {
  final String muscle;

  const MuscleDetailScreen({super.key, required this.muscle});

  List<String> getExercisesForMuscle(String muscle) {
    switch (muscle) {
      case 'Chest (Pectoralis)':
        return [
          'Bench Press',
          'Incline Bench Press',
          'Decline Bench Press',
          'Dumbbell Bench Press',
          'Incline Dumbbell Press',
          'Push-Up',
          'Incline Push-Up',
          'Decline Push-Up',
          'Chest Fly',
          'Dumbbell Fly',
          'Incline Dumbbell Fly',
          'Cable Fly',
          'Pec Deck Machine',
          'Chest Press Machine',
          'Smith Machine Bench Press',
          'Chest Dips',
          'Pullover',
          'Resistance Band Chest Press',
        ];

      case 'Back (Latissimus, Trapezius, Rhomboids)':
        return [
          'Pull-Up',
          'Lat Pulldown',
          'Barbell Row',
          'Seated Cable Row',
          'T-Bar Row',
          'Single Arm Dumbbell Row',
          'Deadlift',
          'Face Pull',
          'Reverse Fly',
          'Shrugs',
        ];

      case 'Shoulders (Deltoids)':
        return [
          'Shoulder Press',
          'Dumbbell Shoulder Press',
          'Arnold Press',
          'Lateral Raise',
          'Front Raise',
          'Rear Delt Fly',
          'Cable Lateral Raise',
          'Upright Row',
        ];

      case 'Biceps':
        return [
          'Barbell Curl',
          'Dumbbell Curl',
          'Hammer Curl',
          'Incline Dumbbell Curl',
          'Concentration Curl',
          'Preacher Curl',
          'Cable Curl',
          'EZ Bar Curl',
        ];

      case 'Triceps':
        return [
          'Triceps Pushdown',
          'Overhead Triceps Extension',
          'Close Grip Bench Press',
          'Triceps Dips',
          'Skull Crushers',
          'Kickbacks',
        ];

      case 'Forearms':
        return [
          'Wrist Curl',
          'Reverse Wrist Curl',
          'Farmer’s Walk',
          'Dead Hang',
          'Grip Trainer',
        ];

      default:
        return ['No exercises added yet'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = getExercisesForMuscle(muscle);

    return Scaffold(
      appBar: AppBar(title: Text(muscle)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(exercises[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ExerciseDetailScreen(
                          exerciseName: exercises[index],
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
