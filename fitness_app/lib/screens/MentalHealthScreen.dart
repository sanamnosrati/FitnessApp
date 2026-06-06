import 'package:flutter/material.dart';
import 'mental_health_service.dart';
import 'HistoryScreen.dart';

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  final MentalHealthService _service = MentalHealthService();
  final TextEditingController journalController = TextEditingController();

  bool isSavingJournal = false;
  bool isSavingMood = false;

  List<String> selectedFeelings = [];

  final List<Map<String, String>> feelings = [
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

  Future<void> saveJournal() async {
    final text = journalController.text.trim();
    if (text.isEmpty) return;

    setState(() => isSavingJournal = true);

    await _service.saveMentalEntry(moods: [], score: 3, reflection: text);

    journalController.clear();

    setState(() => isSavingJournal = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Journal saved ❤️')));
  }

  Future<void> saveFeelings() async {
    if (selectedFeelings.isEmpty) return;

    setState(() => isSavingMood = true);

    await _service.saveMentalEntry(
      moods: selectedFeelings,
      score: 3,
      reflection: '',
    );

    selectedFeelings.clear();

    setState(() => isSavingMood = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Feelings saved ❤️')));
  }

  void toggleFeeling(String label) {
    setState(() {
      if (selectedFeelings.contains(label)) {
        selectedFeelings.remove(label);
      } else {
        if (selectedFeelings.length < 4) {
          selectedFeelings.add(label);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximal 4 Gefühle auswählen.')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFF8F6F2);
    const Color dark = Color(0xFF171717);
    const Color softPink = Color(0xFFFFDDE5);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: journalController,
                      maxLines: 7,
                      style: const TextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        hintText: 'Journal your day...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSavingJournal ? null : saveJournal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          isSavingJournal ? 'Saving...' : 'Save ❤️',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How do I feel today?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose up to 4 feelings.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          feelings.map((feeling) {
                            final label = feeling['label']!;
                            final emoji = feeling['emoji']!;
                            final selected = selectedFeelings.contains(label);

                            return GestureDetector(
                              onTap: () => toggleFeeling(label),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? softPink
                                          : const Color(0xFFF6F4F1),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color:
                                        selected
                                            ? const Color(0xFFEFA6B4)
                                            : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  '$emoji $label',
                                  style: TextStyle(
                                    fontWeight:
                                        selected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSavingMood ? null : saveFeelings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          isSavingMood ? 'Saving...' : 'Save ❤️',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
