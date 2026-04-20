import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('workouts')
                .where('userId', isEqualTo: user.uid)
                .orderBy('date', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          final int workoutsCompleted = docs.length;

          String lastWorkoutDate = '-';
          String lastWorkoutName = 'No workout yet';

          if (docs.isNotEmpty) {
            final lastDoc = docs.first;
            final Timestamp? ts = lastDoc['date'] as Timestamp?;
            final DateTime? date = ts?.toDate();

            lastWorkoutDate =
                date != null ? DateFormat('dd.MM.yyyy').format(date) : '-';

            lastWorkoutName =
                (lastDoc.data() as Map<String, dynamic>)['exercise'] ??
                (lastDoc.data() as Map<String, dynamic>)['type'] ??
                'Workout';
          }

          final recentActivities =
              docs.take(4).map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final Timestamp? ts = data['date'] as Timestamp?;
                final DateTime? date = ts?.toDate();

                return {
                  'date':
                      date != null
                          ? DateFormat('dd.MM.yyyy').format(date)
                          : '-',
                  'workout':
                      (data['exercise'] ?? data['type'] ?? 'Workout')
                          .toString(),
                };
              }).toList();

          final int weeklyGoal = 4;
          final int workoutsThisWeek = _countWorkoutsThisWeek(docs);
          final double weeklyProgress =
              weeklyGoal == 0 ? 0 : workoutsThisWeek / weeklyGoal;

          final int currentStreak = _calculateStreak(docs);

          final weeklyStats = _buildWeeklyStats(docs);

          return SingleChildScrollView(
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
                  subtitle:
                      '$workoutsThisWeek of $weeklyGoal workouts completed',
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
                            final double barHeight =
                                count == 0 ? 12 : count * 30;

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

                if (recentActivities.isEmpty)
                  const Card(child: ListTile(title: Text('No activity yet')))
                else
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
          );
        },
      ),
    );
  }

  static int _countWorkoutsThisWeek(List<QueryDocumentSnapshot> docs) {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    int count = 0;

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final Timestamp? ts = data['date'] as Timestamp?;
      if (ts == null) continue;

      final workoutDate = ts.toDate();
      if (workoutDate.isAfter(
        startOfWeek.subtract(const Duration(seconds: 1)),
      )) {
        count++;
      }
    }

    return count;
  }

  static int _calculateStreak(List<QueryDocumentSnapshot> docs) {
    final workoutDates =
        docs
            .map(
              (doc) =>
                  (doc.data() as Map<String, dynamic>)['date'] as Timestamp?,
            )
            .where((ts) => ts != null)
            .map(
              (ts) => DateTime(
                ts!.toDate().year,
                ts.toDate().month,
                ts.toDate().day,
              ),
            )
            .toSet()
            .toList();

    workoutDates.sort((a, b) => b.compareTo(a));

    if (workoutDates.isEmpty) return 0;

    int streak = 0;
    DateTime current = DateTime.now();
    current = DateTime(current.year, current.month, current.day);

    for (final date in workoutDates) {
      final diff = current.difference(date).inDays;

      if (diff == 0 || diff == 1) {
        streak++;
        current = date;
      } else {
        break;
      }
    }

    return streak;
  }

  static List<Map<String, dynamic>> _buildWeeklyStats(
    List<QueryDocumentSnapshot> docs,
  ) {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final counts = List.generate(7, (_) => 0);

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final Timestamp? ts = data['date'] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      final normalized = DateTime(date.year, date.month, date.day);

      for (int i = 0; i < 7; i++) {
        final day = startOfWeek.add(Duration(days: i));
        if (normalized == DateTime(day.year, day.month, day.day)) {
          counts[i]++;
        }
      }
    }

    return List.generate(7, (i) => {'day': days[i], 'count': counts[i]});
  }

  static Widget _infoCard({
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

  static Widget _progressCard({
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

  static Widget _lastWorkoutCard({
    required String date,
    required String workoutName,
  }) {
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
