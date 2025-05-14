import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: upperBodyMuscles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(upperBodyMuscles[index]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to a detail workout for this muscle if needed
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
