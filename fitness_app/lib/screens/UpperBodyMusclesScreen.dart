import 'package:flutter/material.dart';
import 'muscle_detail_screen.dart';

class UpperBodyMusclesScreen extends StatelessWidget {
  const UpperBodyMusclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upperBodyMuscles = [
      'Chest (Pectoralis)',
      'Back (Latissimus, Trapezius, Rhomboids)',
      'Shoulders (Deltoids)',
      'Biceps',
      'Triceps',
      'Forearms',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Upper Body Muscles')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: upperBodyMuscles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(upperBodyMuscles[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            MuscleDetailScreen(muscle: upperBodyMuscles[index]),
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
