import 'package:flutter/material.dart';
import 'package:fitness_app/theme/app_theme.dart';

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

  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentBlue = Color(0xFF00B8FF);
  static const Color softBorder = Color(0xFF2A2D35);

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
          backgroundColor: AppTheme.surfaceColor,
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
          backgroundColor: AppTheme.surfaceColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving entry: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.surfaceColor,
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimaryColor,
        title: const Text(
          'Mental Health',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: accentPurple,
        backgroundColor: AppTheme.surfaceColor,
        onRefresh: loadWeeklyMood,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroCard(),

              const SizedBox(height: 18),

              _currentMoodCard(),

              const SizedBox(height: 20),

              if (selectedMoods.isNotEmpty) _selectedFeelings(),

              const Text(
                'Choose up to 4 feelings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 14),

              ...moodGroups.entries.map((entry) => _moodGroup(entry)),

              const SizedBox(height: 8),

              _dailyCheckInCard(),

              const SizedBox(height: 24),

              _weeklyMoodGraph(),

              const SizedBox(height: 26),

              const Text(
                'Health Care Tools',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
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
                    accent: accentPurple,
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
                    icon: Icons.auto_awesome,
                    accent: accentBlue,
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
                    subtitle: 'Past notes',
                    icon: Icons.history_rounded,
                    accent: accentPurple,
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
                    icon: Icons.psychology_rounded,
                    accent: accentBlue,
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

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D1F24), Color(0xFF15161A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: softBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite_rounded, color: accentPurple, size: 28),
          SizedBox(height: 14),
          Text(
            'How do you feel today?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Track your emotions, reflect on your day, and care for your mental well-being.',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondaryColor,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentMoodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: softBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: accentPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Current mood: ${getMoodEmoji()} ${getMoodText()}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedFeelings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Feelings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
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
                      labelStyle: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: accentPurple.withOpacity(0.18),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppTheme.textPrimaryColor,
                      ),
                      side: BorderSide(color: accentPurple.withOpacity(0.35)),
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
    );
  }

  Widget _moodGroup(MapEntry<String, List<Map<String, String>>> entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.key,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondaryColor,
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
                              ? accentPurple.withOpacity(0.18)
                              : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? accentPurple : softBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            color:
                                selected
                                    ? AppTheme.textPrimaryColor
                                    : AppTheme.textSecondaryColor,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w500,
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
  }

  Widget _dailyCheckInCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Check-In',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${getMoodEmoji()} ${getMoodText()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: accentPurple,
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
                            ? accentPurple
                            : AppTheme.surfaceLightColor,
                    border: Border.all(
                      color: moodScore == value ? accentPurple : softBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color:
                            moodScore == value
                                ? Colors.white
                                : AppTheme.textSecondaryColor,
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
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: reflectionController,
            maxLines: 5,
            style: const TextStyle(color: AppTheme.textPrimaryColor),
            decoration: InputDecoration(
              hintText: 'Write about your day...',
              hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
              filled: true,
              fillColor: AppTheme.surfaceLightColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
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
                  selectedMoods.isEmpty || isSaving ? null : saveMentalEntry,
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
              label: Text(isSaving ? 'Saving...' : 'Save Mental Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyMoodGraph() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softBorder),
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
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              IconButton(
                onPressed: loadWeeklyMood,
                icon: const Icon(
                  Icons.refresh,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Your recent mood scores from 1 to 5',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 20),
          if (isLoadingGraph)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(color: accentPurple),
              ),
            )
          else if (weeklyMood.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 42,
                      color: AppTheme.textSecondaryColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No mood data yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Save your first mental entry to see the graph.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                  ],
                ),
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
                  final day = index < weekDays.length ? weekDays[index] : '-';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 26,
                        height: value * 25,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [accentPurple, accentBlue],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  const _HealthCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  static const Color softBorder = Color(0xFF2A2D35);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppTheme.surfaceColor,
          border: Border.all(color: softBorder),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: accent.withOpacity(0.14),
              child: Icon(icon, size: 26, color: accent),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
