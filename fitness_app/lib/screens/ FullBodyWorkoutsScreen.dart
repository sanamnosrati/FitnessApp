import 'package:flutter/material.dart';

class FullBodyWorkoutsScreen extends StatelessWidget {
  const FullBodyWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fullBodyWorkouts = [
      'Full Body Circuit',
      'Burpees Workout',
      'Bodyweight Training',
      'Kettlebell Complex',
      'Functional Fitness',
      'CrossFit Style Training',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Full Body Workouts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: fullBodyWorkouts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(fullBodyWorkouts[index]),
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
