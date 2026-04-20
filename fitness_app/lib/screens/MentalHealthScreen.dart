import 'package:flutter/material.dart';
import 'mental_health_service.dart';
import 'RelaxScreen.dart';
import 'PositiveScreen.dart';
import 'HistoryScreen.dart';
import 'MoodTipsScreen.dart';

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  List<String> selectedMoods = [];
  int moodScore = 3;

  final TextEditingController reflectionController = TextEditingController();
  final MentalHealthService _mentalHealthService = MentalHealthService();

  bool isSaving = false;
  bool isLoadingGraph = true;

  List<int> weeklyMood = [];
  List<String> weekDays = [];

  final Map<String, List<Map<String, String>>> moodGroups = {
    'Positive': [
      {'emoji': '😄', 'label': 'Happy'},
      {'emoji': '😌', 'label': 'Calm'},
      {'emoji': '💪', 'label': 'Motivated'},
      {'emoji': '🤩', 'label': 'Excited'},
      {'emoji': '🙏', 'label': 'Grateful'},
      {'emoji': '🥰', 'label': 'Loved'},
    ],
    'Neutral': [
      {'emoji': '🙂', 'label': 'Okay'},
      {'emoji': '😴', 'label': 'Tired'},
      {'emoji': '🤔', 'label': 'Thoughtful'},
      {'emoji': '😶', 'label': 'Numb'},
      {'emoji': '😐', 'label': 'Normal'},
    ],
    'Difficult': [
      {'emoji': '😔', 'label': 'Sad'},
      {'emoji': '😫', 'label': 'Stressed'},
      {'emoji': '😤', 'label': 'Angry'},
      {'emoji': '😟', 'label': 'Anxious'},
      {'emoji': '😞', 'label': 'Lonely'},
      {'emoji': '🥺', 'label': 'Overwhelmed'},
    ],
  };

  @override
  void initState() {
    super.initState();
    loadWeeklyMood();
  }

  Future<void> loadWeeklyMood() async {
    try {
      setState(() {
        isLoadingGraph = true;
      });

      final entries = await _mentalHealthService.getRecentMentalEntries(
        limit: 7,
      );

      final reversedEntries = entries.reversed.toList();

      final loadedScores = <int>[];
      final loadedDays = <String>[];

      for (final entry in reversedEntries) {
        final score = entry['score'] as int? ?? 3;
        loadedScores.add(score);

        final createdAt = entry['createdAt'];
        if (createdAt != null) {
          final date = createdAt.toDate();
          loadedDays.add(_dayLabel(date.weekday));
        } else {
          loadedDays.add('-');
        }
      }

      setState(() {
        weeklyMood = loadedScores;
        weekDays = loadedDays;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading graph: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isLoadingGraph = false;
      });
    }
  }

  String _dayLabel(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mo';
      case 2:
        return 'Tu';
      case 3:
        return 'We';
      case 4:
        return 'Th';
      case 5:
        return 'Fr';
      case 6:
        return 'Sa';
      case 7:
        return 'Su';
      default:
        return '-';
    }
  }

  Future<void> saveMentalEntry() async {
    if (selectedMoods.isEmpty) return;

    try {
      setState(() {
        isSaving = true;
      });

      await _mentalHealthService.saveMentalEntry(
        moods: selectedMoods,
        score: moodScore,
        reflection: reflectionController.text,
      );

      setState(() {
        selectedMoods.clear();
        moodScore = 3;
        reflectionController.clear();
      });

      await loadWeeklyMood();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mental entry saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving entry: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  String getMoodText() {
    switch (moodScore) {
      case 1:
        return 'Very bad';
      case 2:
        return 'Bad';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Very good';
      default:
        return 'Okay';
    }
  }

  String getMoodEmoji() {
    switch (moodScore) {
      case 1:
        return '😢';
      case 2:
        return '🙁';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  @override
  void dispose() {
    reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Colors.teal;
    final bgColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const Text('Mental Health'),
      ),
      body: RefreshIndicator(
        onRefresh: loadWeeklyMood,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.teal, Color(0xFF64C9C0)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How do you feel today?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Track your emotions, reflect on your day, and care for your mental well-being.',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Current mood: ${getMoodEmoji()} ${getMoodText()}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (selectedMoods.isNotEmpty) ...[
                const Text(
                  'Selected Feelings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      selectedMoods
                          .map(
                            (m) => Chip(
                              label: Text(m),
                              backgroundColor: Colors.teal.withOpacity(0.15),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  selectedMoods.remove(m);
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 20),
              ],

              const Text(
                'Choose up to 4 feelings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),

              ...moodGroups.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          entry.value.map((mood) {
                            final label = mood['label']!;
                            final emoji = mood['emoji']!;
                            final selected = selectedMoods.contains(label);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selected) {
                                    selectedMoods.remove(label);
                                  } else if (selectedMoods.length < 4) {
                                    selectedMoods.add(label);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? accent.withOpacity(0.15)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        selected
                                            ? accent
                                            : Colors.grey.shade300,
                                    width: 1.3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontWeight:
                                            selected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],
                );
              }),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Check-In',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${getMoodEmoji()} ${getMoodText()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(5, (index) {
                        final value = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              moodScore = value;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  moodScore == value
                                      ? accent
                                      : Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  color:
                                      moodScore == value
                                          ? Colors.white
                                          : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Short Note',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: reflectionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Write about your day...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            selectedMoods.isEmpty || isSaving
                                ? null
                                : saveMentalEntry,
                        icon:
                            isSaving
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Icon(Icons.favorite),
                        label: Text(
                          isSaving ? 'Saving...' : 'Save Mental Entry',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weekly Mood Graph',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: loadWeeklyMood,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your recent mood scores from 1 to 5',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    if (isLoadingGraph)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (weeklyMood.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: const Column(
                          children: [
                            Icon(Icons.bar_chart, size: 42, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'No mood data yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Save your first mental entry to see the graph.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black45),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: 170,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(weeklyMood.length, (index) {
                            final value = weeklyMood[index];
                            final day =
                                index < weekDays.length ? weekDays[index] : '-';

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 26,
                                  height: value * 25,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(day, style: const TextStyle(fontSize: 12)),
                              ],
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                'Health Care Tools',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _HealthCard(
                    title: 'Relax',
                    subtitle: 'Breathing & calming',
                    icon: Icons.self_improvement,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RelaxScreen()),
                      );
                    },
                  ),
                  _HealthCard(
                    title: 'Positive',
                    subtitle: 'Daily motivation',
                    icon: Icons.wb_sunny,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PositiveScreen(),
                        ),
                      );
                    },
                  ),
                  _HealthCard(
                    title: 'History',
                    subtitle: 'View past notes',
                    icon: Icons.history,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  _HealthCard(
                    title: 'Mood Tips',
                    subtitle: 'Small mental reset',
                    icon: Icons.psychology,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MoodTipsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _HealthCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, size: 26, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
