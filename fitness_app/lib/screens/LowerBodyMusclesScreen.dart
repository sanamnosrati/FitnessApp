import 'package:flutter/material.dart';
import 'muscle_detail_screen.dart';

class LowerBodyMusclesScreen extends StatelessWidget {
  const LowerBodyMusclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lowerBodyMuscles = [
      'Glutes (Maximus, Medius, Minimus)',
      'Quadriceps (Front thighs)',
      'Hamstrings (Back thighs)',
      'Adductors (Inner thighs)',
      'Abductors (Outer thighs)',
      'Calves (Gastrocnemius, Soleus)',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lower Body Muscles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: lowerBodyMuscles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(lowerBodyMuscles[index]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MuscleDetailScreen(
                            muscle: lowerBodyMuscles[index],
                          ),
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
