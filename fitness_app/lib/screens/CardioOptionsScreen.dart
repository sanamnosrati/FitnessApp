import 'package:flutter/material.dart';

class CardioOptionsScreen extends StatelessWidget {
  const CardioOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardioWorkouts = [
      'Running / Jogging',
      'Cycling',
      'Jump Rope',
      'HIIT (High Intensity Interval Training)',
      'Swimming',
      'Rowing',
      'Stair Climbing',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Cardio Workouts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: cardioWorkouts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(cardioWorkouts[index]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to details if needed
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
