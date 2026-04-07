import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;

  const ExerciseDetailScreen({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('exercises')
                .where('name', isEqualTo: exerciseName)
                .limit(1)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No exercise data found.'));
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;

          final targetMuscles = data['targetMuscles'] ?? 'Not added yet';
          final instructions =
              data['instructions'] ?? 'No instructions available yet.';
          final sets = data['sets'] ?? '-';
          final reps = data['reps'] ?? '-';
          final tips = data['tips'] ?? 'Add more details later.';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  'Target Muscles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(targetMuscles),
                const SizedBox(height: 20),
                const Text(
                  'How to Perform',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(instructions),
                const SizedBox(height: 20),
                Text('Sets: $sets'),
                Text('Reps: $reps'),
                const SizedBox(height: 20),
                const Text(
                  'Tips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(tips),
              ],
            ),
          );
        },
      ),
    );
  }
}
