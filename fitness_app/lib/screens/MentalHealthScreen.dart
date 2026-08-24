import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'HistoryScreen.dart';
import 'mental_health_service.dart';

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  final MentalHealthService _service = MentalHealthService();
  final TextEditingController noteController = TextEditingController();

  int selectedDayIndex = 0;
  int moodScore = 3;

  bool isLoading = true;
  bool isSavingMood = false;
  bool isSavingNote = false;

  List<String> selectedMoods = [];
  Map<String, dynamic>? dayLog;

  final List<Map<String, String>> moods = const [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '🙏', 'label': 'Grateful'},
    {'emoji': '💪', 'label': 'Motivated'},
    {'emoji': '🙂', 'label': 'Okay'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '🤔', 'label': 'Thoughtful'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😫', 'label': 'Stressed'},
    {'emoji': '😟', 'label': 'Anxious'},
    {'emoji': '😤', 'label': 'Angry'},
    {'emoji': '🥺', 'label': 'Overwhelmed'},
  ];

  DateTime get selectedDate {
    return DateTime.now().subtract(Duration(days: selectedDayIndex));
  }

  @override
  void initState() {
    super.initState();
    _loadDay();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> _loadDay() async {
    setState(() => isLoading = true);

    final log = await _service.getDayLog(selectedDate);

    final loadedMoods = List<String>.from(log?['moods'] ?? []);
    final loadedScore = log?['score'] as int? ?? 3;
    final loadedNote = (log?['reflection'] ?? '').toString();

    if (!mounted) return;

    setState(() {
      dayLog = log;
      selectedMoods = loadedMoods;
      moodScore = loadedScore;
      noteController.text = loadedNote;
      isLoading = false;
    });
  }

  Future<void> _saveMood() async {
    if (selectedMoods.isEmpty) {
      _showSnack('Choose at least one mood.');
      return;
    }

    setState(() => isSavingMood = true);

    await _service.saveMood(
      date: selectedDate,
      moods: selectedMoods,
      score: moodScore,
    );

    await _loadDay();

    if (!mounted) return;

    setState(() => isSavingMood = false);

    _showSnack('Mood saved ❤️');
  }

  Future<void> _saveNote() async {
    final note = noteController.text.trim();

    if (note.isEmpty) {
      _showSnack('Write a note first.');
      return;
    }

    setState(() => isSavingNote = true);

    await _service.saveNote(date: selectedDate, note: note);

    await _loadDay();

    if (!mounted) return;

    setState(() => isSavingNote = false);

    _showSnack('Note saved 📝');
  }

  void _toggleMood(String label) {
    setState(() {
      if (selectedMoods.contains(label)) {
        selectedMoods.remove(label);
      } else {
        if (selectedMoods.length >= 4) {
          _showSnack('You can choose up to 4 moods.');
          return;
        }

        selectedMoods.add(label);
      }
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _dateTitle() {
    final date = selectedDate;

    if (selectedDayIndex == 0) return 'Today';
    if (selectedDayIndex == 1) return 'Yesterday';

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  String _dateSubtitle() {
    final date = selectedDate;

    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[date.weekday - 1];
  }

  String _scoreEmoji(int score) {
    switch (score) {
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

  String _scoreText(int score) {
    switch (score) {
      case 1:
        return 'Very low';
      case 2:
        return 'Low';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return 'Okay';
    }
  }

  bool get hasSavedMood {
    final moods = List<String>.from(dayLog?['moods'] ?? []);

    return moods.isNotEmpty;
  }

  bool get hasSavedNote {
    final note = (dayLog?['reflection'] ?? '').toString().trim();

    return note.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                children: [
                  _topBar(),

                  const SizedBox(height: 20),

                  _dateSwitcher(),

                  const SizedBox(height: 20),

                  _overviewCard(),

                  const SizedBox(height: 20),

                  if (selectedDayIndex == 0) ...[
                    _moodScoreCard(),

                    const SizedBox(height: 20),

                    _moodPickerCard(),

                    const SizedBox(height: 20),

                    _noteCard(),

                    const SizedBox(height: 20),
                  ],

                  _savedLogCard(),
                ],
              ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Mind Check-In',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          },

          style: IconButton.styleFrom(
            backgroundColor: AppTheme.surfaceLightColor,
            foregroundColor: AppTheme.primaryColor,
          ),

          icon: const Icon(Icons.insights_rounded),
        ),
      ],
    );
  }

  Widget _dateSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AppTheme.borderColor),
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              if (selectedDayIndex < 29) {
                setState(() => selectedDayIndex++);

                await _loadDay();
              }
            },

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textSecondaryColor,
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  _dateTitle(),

                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _dateSubtitle(),

                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () async {
              if (selectedDayIndex > 0) {
                setState(() => selectedDayIndex--);

                await _loadDay();
              }
            },

            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewCard() {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: AppTheme.purpleSurface,
        borderRadius: BorderRadius.circular(26),

        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.28)),
      ),

      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.13),
              shape: BoxShape.circle,
            ),

            child: Center(
              child: Text(
                _scoreEmoji(moodScore),
                style: const TextStyle(fontSize: 35),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSavedMood || hasSavedNote
                      ? 'Log saved for ${_dateTitle()}'
                      : 'No log saved yet',

                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  hasSavedMood
                      ? 'Mood score: $moodScore / 5 • ${_scoreText(moodScore)}'
                      : 'Save your mood and note separately.',

                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moodScoreCard() {
    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mood Score',

            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${_scoreEmoji(moodScore)}  '
            '$moodScore / 5 • ${_scoreText(moodScore)}',

            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,

              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: AppTheme.surfaceLightColor,

              thumbColor: AppTheme.primaryColor,

              overlayColor: AppTheme.primaryColor.withOpacity(0.15),
            ),

            child: Slider(
              value: moodScore.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$moodScore',

              onChanged: (value) {
                setState(() {
                  moodScore = value.round();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _moodPickerCard() {
    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How do you feel?',

            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Choose up to 4 feelings.',

            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: moods.map((mood) {
              final label = mood['label']!;
              final emoji = mood['emoji']!;

              final selected = selectedMoods.contains(label);

              return GestureDetector(
                onTap: () => _toggleMood(label),

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),

                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.primaryColor.withOpacity(0.16)
                        : AppTheme.surfaceLightColor,

                    borderRadius: BorderRadius.circular(22),

                    border: Border.all(
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.borderColor,
                    ),
                  ),

                  child: Text(
                    '$emoji $label',

                    style: TextStyle(
                      color: selected
                          ? AppTheme.purpleSoft
                          : AppTheme.textSecondaryColor,

                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: isSavingMood ? null : _saveMood,

              icon: const Icon(Icons.favorite_rounded),

              label: Text(isSavingMood ? 'Saving...' : 'Save Mood'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard() {
    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Daily Note',

            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Write what happened today, how you felt or what helped you.',

            style: TextStyle(color: AppTheme.textSecondaryColor, height: 1.4),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: noteController,
            maxLines: 7,

            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
              height: 1.4,
            ),

            decoration: const InputDecoration(hintText: 'Write your note...'),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: isSavingNote ? null : _saveNote,

              icon: const Icon(Icons.edit_note_rounded),

              label: Text(isSavingNote ? 'Saving...' : 'Save Note'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _savedLogCard() {
    final savedMoods = List<String>.from(dayLog?['moods'] ?? []);

    final note = (dayLog?['reflection'] ?? '').toString().trim();

    final savedScore = dayLog?['score'] as int? ?? moodScore;

    return _darkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Saved Log',

            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _dateTitle(),

            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          if (savedMoods.isEmpty && note.isEmpty)
            const Text(
              'No mood or note saved for this day.',

              style: TextStyle(color: AppTheme.textSecondaryColor),
            )
          else ...[
            Row(
              children: [
                Text(
                  _scoreEmoji(savedScore),
                  style: const TextStyle(fontSize: 30),
                ),

                const SizedBox(width: 10),

                Text(
                  'Score $savedScore / 5 • '
                  '${_scoreText(savedScore)}',

                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            if (savedMoods.isNotEmpty) ...[
              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,

                children: savedMoods.map((mood) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.12),

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.35),
                      ),
                    ),

                    child: Text(
                      mood,

                      style: const TextStyle(
                        color: AppTheme.purpleSoft,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (note.isNotEmpty) ...[
              const SizedBox(height: 16),

              Text(
                note,

                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  height: 1.45,
                  fontSize: 15,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _darkCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AppTheme.borderColor),
      ),

      child: child,
    );
  }
}
