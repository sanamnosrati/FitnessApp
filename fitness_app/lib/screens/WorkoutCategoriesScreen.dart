import 'package:flutter/material.dart';

// Korrekte Importe der Klassen
import 'cardioOptionsScreen.dart';
import 'coreMusclesScreen.dart';
import 'lowerBodyMusclesScreen.dart';
import 'upperBodyMusclesScreen.dart';
import ' FullBodyWorkoutsScreen.dart';

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Upper Body', 'icon': Icons.fitness_center},
      {'name': 'Core', 'icon': Icons.accessibility_new},
      {'name': 'Lower Body', 'icon': Icons.directions_run},
      {'name': 'Full Body', 'icon': Icons.accessibility},
      {'name': 'Cardio', 'icon': Icons.favorite},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Categories')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(category['icon'] as IconData),
              title: Text(category['name'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                switch (category['name']) {
                  case 'Upper Body':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpperBodyMusclesScreen(),
                      ),
                    );
                    break;
                  case 'Core':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoreMusclesScreen(),
                      ),
                    );
                    break;
                  case 'Lower Body':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LowerBodyMusclesScreen(),
                      ),
                    );
                    break;
                  case 'Full Body':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FullBodyWorkoutsScreen(),
                      ),
                    );
                    break;
                  case 'Cardio':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CardioOptionsScreen(),
                      ),
                    );
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }
}
