import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for now
    final int workoutsCompleted = 18;
    final int weeklyGoal = 4;
    final int workoutsThisWeek = 3;
    final int currentStreak = 5;
    final String lastWorkoutDate = '06.04.2026';
    final String lastWorkoutName = 'Lower Body - Squat & Glutes';

    final List<Map<String, String>> recentActivities = [
      {'date': '06.04.2026', 'workout': 'Lower Body Workout'},
      {'date': '05.04.2026', 'workout': 'Core Training'},
      {'date': '03.04.2026', 'workout': 'Upper Body Workout'},
      {'date': '01.04.2026', 'workout': 'Full Body Stretch'},
    ];

    final List<Map<String, dynamic>> weeklyStats = [
      {'day': 'Mon', 'count': 1},
      {'day': 'Tue', 'count': 0},
      {'day': 'Wed', 'count': 1},
      {'day': 'Thu', 'count': 0},
      {'day': 'Fri', 'count': 1},
      {'day': 'Sat', 'count': 0},
      {'day': 'Sun', 'count': 0},
    ];

    final double weeklyProgress = workoutsThisWeek / weeklyGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Fitness Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    title: 'Workouts Completed',
                    value: workoutsCompleted.toString(),
                    icon: Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard(
                    title: 'Current Streak',
                    value: '$currentStreak days',
                    icon: Icons.local_fire_department,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _progressCard(
              title: 'Weekly Goal',
              subtitle: '$workoutsThisWeek of $weeklyGoal workouts completed',
              progress: weeklyProgress > 1 ? 1 : weeklyProgress,
            ),

            const SizedBox(height: 16),

            _lastWorkoutCard(
              date: lastWorkoutDate,
              workoutName: lastWorkoutName,
            ),

            const SizedBox(height: 24),

            const Text(
              'Weekly Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      weeklyStats.map((stat) {
                        final int count = stat['count'] as int;
                        final double barHeight = count == 0 ? 12 : count * 30;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 22,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(stat['day'] as String),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...recentActivities.map(
              (activity) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(activity['workout']!),
                  subtitle: Text(activity['date']!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressCard({
    required String title,
    required String subtitle,
    required double progress,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lastWorkoutCard({required String date, required String workoutName}) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.history, color: Colors.blue),
        title: const Text(
          'Last Workout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$workoutName\n$date'),
      ),
    );
  }
}
