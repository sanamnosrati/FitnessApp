import 'package:flutter/material.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  String _dateTitle() {
    final date = selectedDate;

    if (selectedDayIndex == 0) return 'Today';
    if (selectedDayIndex == 1) return 'Yesterday';

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
    const bg = Color(0xFFF8F6F2);
    const dark = Color(0xFF171717);
    const soft = Color(0xFFFFEEF2);
    const accent = Color(0xFFEFA6B4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator(color: dark))
                : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  children: [
                    _topBar(dark),
                    const SizedBox(height: 20),
                    _dateSwitcher(dark),
                    const SizedBox(height: 22),
                    _overviewCard(dark, soft, accent),
                    const SizedBox(height: 22),

                    if (selectedDayIndex == 0) ...[
                      _moodScoreCard(dark, accent),
                      const SizedBox(height: 22),
                      _moodPickerCard(dark, soft, accent),
                      const SizedBox(height: 22),
                      _noteCard(dark),
                      const SizedBox(height: 22),
                    ],

                    _savedLogCard(dark, soft, accent),
                  ],
                ),
      ),
    );
  }

  Widget _topBar(Color dark) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Mind Check-In',
            style: TextStyle(
              color: dark,
              fontSize: 31,
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
            backgroundColor: Colors.white,
            foregroundColor: dark,
          ),
          icon: const Icon(Icons.insights_rounded),
        ),
      ],
    );
  }

  Widget _dateSwitcher(Color dark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _dateTitle(),
                  style: TextStyle(
                    color: dark,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _dateSubtitle(),
                  style: const TextStyle(
                    color: Color(0xFF8A817C),
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
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(Color dark, Color soft, Color accent) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Text(_scoreEmoji(moodScore), style: const TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSavedMood || hasSavedNote
                      ? 'Log saved for ${_dateTitle()}'
                      : 'No log saved yet',
                  style: TextStyle(
                    color: dark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasSavedMood
                      ? 'Mood score: $moodScore / 5 • ${_scoreText(moodScore)}'
                      : 'Save your mood and note separately.',
                  style: const TextStyle(
                    color: Color(0xFF7A706C),
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

  Widget _moodScoreCard(Color dark, Color accent) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Score',
            style: TextStyle(
              color: dark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_scoreEmoji(moodScore)}  $moodScore / 5 • ${_scoreText(moodScore)}',
            style: const TextStyle(
              color: Color(0xFF7A706C),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: moodScore.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            activeColor: accent,
            inactiveColor: const Color(0xFFFFDDE5),
            label: '$moodScore',
            onChanged: (value) {
              setState(() => moodScore = value.round());
            },
          ),
        ],
      ),
    );
  }

  Widget _moodPickerCard(Color dark, Color soft, Color accent) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How do you feel?',
            style: TextStyle(
              color: dark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose up to 4 feelings.',
            style: TextStyle(color: Color(0xFF8A817C)),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                moods.map((mood) {
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
                        color: selected ? soft : const Color(0xFFF6F4F1),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: selected ? accent : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        '$emoji $label',
                        style: TextStyle(
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: dark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(Color dark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Note',
            style: TextStyle(
              color: dark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Write what happened today, how you felt or what helped you.',
            style: TextStyle(color: Color(0xFF8A817C), height: 1.4),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: noteController,
            maxLines: 7,
            style: const TextStyle(fontSize: 16, height: 1.4),
            decoration: InputDecoration(
              hintText: 'Write your note...',
              filled: true,
              fillColor: const Color(0xFFF8F6F2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSavingNote ? null : _saveNote,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(isSavingNote ? 'Saving...' : 'Save Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: dark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _savedLogCard(Color dark, Color soft, Color accent) {
    final savedMoods = List<String>.from(dayLog?['moods'] ?? []);
    final note = (dayLog?['reflection'] ?? '').toString().trim();
    final savedScore = dayLog?['score'] as int? ?? moodScore;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFECE7E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved Log',
            style: TextStyle(
              color: dark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _dateTitle(),
            style: const TextStyle(
              color: Color(0xFF8A817C),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (savedMoods.isEmpty && note.isEmpty)
            const Text(
              'No mood or note saved for this day.',
              style: TextStyle(color: Color(0xFF8A817C)),
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
                  'Score $savedScore / 5 • ${_scoreText(savedScore)}',
                  style: TextStyle(color: dark, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            if (savedMoods.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    savedMoods.map((mood) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: soft,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: accent),
                        ),
                        child: Text(
                          mood,
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
                  color: Color(0xFF4B4542),
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
}
