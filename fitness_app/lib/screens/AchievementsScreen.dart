import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../theme/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        'title': 'Early Bird',
        'description': 'Complete 5 morning workouts',
        'icon': Icons.wb_sunny,
        'progress': 3,
        'total': 5,
        'color': Colors.orange,
      },
      {
        'title': 'Strength Master',
        'description': 'Complete 10 strength training sessions',
        'icon': Icons.fitness_center,
        'progress': 7,
        'total': 10,
        'color': Colors.blue,
      },
      {
        'title': 'Cardio King',
        'description': 'Burn 1000 calories in cardio workouts',
        'icon': Icons.favorite,
        'progress': 750,
        'total': 1000,
        'color': Colors.red,
      },
      {
        'title': 'Consistency Champion',
        'description': 'Work out 5 days in a row',
        'icon': Icons.calendar_today,
        'progress': 3,
        'total': 5,
        'color': Colors.green,
      },
      {
        'title': 'Flexibility Master',
        'description': 'Complete 15 yoga sessions',
        'icon': Icons.self_improvement,
        'progress': 8,
        'total': 15,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Achievements',
        showBackButton: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final progress = achievement['progress'] as int;
          final total = achievement['total'] as int;
          final percentage = progress / total;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (achievement['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          achievement['icon'] as IconData,
                          color: achievement['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement['title'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement['description'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: (achievement['color'] as Color).withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            achievement['color'] as Color,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$progress / $total',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
