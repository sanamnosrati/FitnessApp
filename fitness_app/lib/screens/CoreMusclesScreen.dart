import 'package:flutter/material.dart';
import 'muscle_detail_screen.dart';

class CoreMusclesScreen extends StatelessWidget {
  const CoreMusclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coreMuscles = [
      'Rectus Abdominis (Six-pack)',
      'Obliques (Side abs)',
      'Transverse Abdominis (Deep core)',
      'Lower Back (Erector Spinae)',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Core Muscles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: coreMuscles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(coreMuscles[index]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MuscleDetailScreen(muscle: coreMuscles[index]),
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
