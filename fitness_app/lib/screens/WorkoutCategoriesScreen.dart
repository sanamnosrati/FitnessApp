import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/muscle_group_card.dart';
import '../theme/app_theme.dart';

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
      {
        'name': 'Upper Body',
        'description': 'Build strength and definition in your chest, shoulders, back, and arms with targeted exercises. Our comprehensive upper body workouts focus on both pushing and pulling movements.',
        'illustration': 'assets/illustrations/muscles/upper_body.png',
        'muscles': [
          'Chest (Pectoralis)',
          'Shoulders (Deltoids)',
          'Back (Latissimus)',
          'Biceps',
          'Triceps',
        ],
      },
      {
        'name': 'Core',
        'description': 'Strengthen your core muscles and achieve better stability with focused ab workouts. A strong core is essential for better posture and overall fitness.',
        'illustration': 'assets/illustrations/muscles/core.png',
        'muscles': [
          'Rectus Abdominis',
          'Obliques',
          'Transverse Abdominis',
          'Lower Back',
        ],
      },
      {
        'name': 'Lower Body',
        'description': 'Build powerful legs and glutes with comprehensive lower body training. Our workouts target all major muscle groups in your legs for balanced development.',
        'illustration': 'assets/illustrations/muscles/lower_body.png',
        'muscles': [
          'Quadriceps',
          'Hamstrings',
          'Calves (Gastrocnemius)',
          'Glutes',
          'Hip Flexors',
        ],
      },
      {
        'name': 'Full Body',
        'description': 'Complete full body workouts that target multiple muscle groups for overall fitness. Perfect for efficient training and maximum calorie burn.',
        'illustration': 'assets/illustrations/muscles/full_body.png',
        'muscles': [
          'All Major Muscle Groups',
          'Compound Movements',
          'Functional Training',
        ],
      },
      {
        'name': 'Cardio',
        'description': 'Improve your cardiovascular health and endurance with dynamic cardio workouts. Mix of high-intensity and steady-state exercises.',
        'illustration': 'assets/illustrations/muscles/cardio.png',
        'muscles': [
          'Heart',
          'Lungs',
          'Full Body Conditioning',
          'Endurance Training',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Workout Categories',
        showBackButton: false,
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MuscleGroupCard(
                title: category['name'] as String,
                description: category['description'] as String,
                illustrationPath: category['illustration'] as String,
                targetMuscles: List<String>.from(category['muscles'] as List),
                onTap: () {
                  // TODO: Navigate to specific category workouts
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
      ),
    );
  }
}
