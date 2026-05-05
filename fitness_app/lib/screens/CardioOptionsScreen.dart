import 'package:flutter/material.dart';
import 'cardio_detail_screen.dart';

class CardioOptionsScreen extends StatelessWidget {
  const CardioOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardioWorkouts = [
      'Running',
      'Cycling',
      'Jump Rope',
      'HIIT',
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
            final workout = cardioWorkouts[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(workout),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CardioDetailScreen(cardioName: workout),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
