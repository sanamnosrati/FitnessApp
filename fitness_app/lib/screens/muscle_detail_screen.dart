import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'exercise_detail_screen.dart';

class MuscleDetailScreen extends StatelessWidget {
  final String muscle;

  const MuscleDetailScreen({super.key, required this.muscle});

  String getFirestoreMuscleName(String muscle) {
    switch (muscle) {
      case 'Chest (Pectoralis)':
        return 'Chest';
      case 'Back (Latissimus, Trapezius, Rhomboids)':
        return 'Back';
      case 'Shoulders (Deltoids)':
        return 'Shoulders';
      case 'Biceps':
        return 'Biceps';
      case 'Triceps':
        return 'Triceps';
      case 'Forearms':
        return 'Forearms';

      case 'Rectus Abdominis (Six-pack)':
        return 'Rectus Abdominis';
      case 'Obliques (Side abs)':
        return 'Obliques';
      case 'Transverse Abdominis (Deep core)':
        return 'Transverse Abdominis';
      case 'Lower Back (Erector Spinae)':
        return 'Lower Back';

      case 'Glutes (Maximus, Medius, Minimus)':
        return 'Glutes';
      case 'Quadriceps (Front thighs)':
        return 'Quadriceps';
      case 'Hamstrings (Back thighs)':
        return 'Hamstrings';
      case 'Adductors (Inner thighs)':
        return 'Adductors';
      case 'Abductors (Outer thighs)':
        return 'Abductors';
      case 'Calves (Gastrocnemius, Soleus)':
        return 'Calves';

      default:
        return muscle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreMuscle = getFirestoreMuscleName(muscle);

    return Scaffold(
      appBar: AppBar(title: Text(muscle)),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('exercises')
                .where('muscle', isEqualTo: firestoreMuscle)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No exercises found for this muscle group.'),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final exerciseName = data['name'] ?? 'Unnamed Exercise';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(exerciseName),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ExerciseDetailScreen(
                              exerciseName: exerciseName,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
