import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'mental_health_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final MentalHealthService _mentalHealthService = MentalHealthService();

  bool isLoading = true;
  List<Map<String, dynamic>> entries = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      setState(() {
        isLoading = true;
      });

      final loadedEntries = await _mentalHealthService.getAllMentalEntries();

      setState(() {
        entries = loadedEntries;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading history: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return 'No date';

    if (createdAt is Timestamp) {
      final date = createdAt.toDate();
      return '${date.day}.${date.month}.${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return 'No date';
  }

  String _moodText(int score) {
    switch (score) {
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

  String _moodEmoji(int score) {
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

  List<int> _graphScores() {
    final reversed = entries.reversed.toList();
    return reversed.map((e) => (e['score'] as int?) ?? 3).toList();
  }

  List<String> _graphDays() {
    final reversed = entries.reversed.toList();

    return reversed.map((e) {
      final createdAt = e['createdAt'];
      if (createdAt is Timestamp) {
        final weekday = createdAt.toDate().weekday;
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
      return '-';
    }).toList();
  }

  double _averageScore() {
    if (entries.isEmpty) return 0;
    final total = entries.fold<int>(
      0,
      (sum, e) => sum + ((e['score'] as int?) ?? 3),
    );
    return total / entries.length;
  }

  @override
  Widget build(BuildContext context) {
    final avg = _averageScore();
    final graphScores = _graphScores();
    final graphDays = _graphDays();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Mental History'),
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: loadHistory,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : entries.isEmpty
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.history, size: 46, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'No history yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Save your first mental entry to see your mood history and notes here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.teal, Color(0xFF64C9C0)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Mental History',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Recent entries: ${entries.length}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Average mood score: ${avg.toStringAsFixed(1)} / 5',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                            'Mood Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Recent mood scores',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 170,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(graphScores.length, (
                                index,
                              ) {
                                final value = graphScores[index];
                                final day =
                                    index < graphDays.length
                                        ? graphDays[index]
                                        : '-';

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
                                      width: 24,
                                      height: value * 24,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      day,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Recent Notes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...entries.map((entry) {
                      final score = entry['score'] as int? ?? 3;
                      final moods = List<String>.from(entry['moods'] ?? []);
                      final reflection =
                          (entry['reflection'] ?? '').toString().trim();
                      final createdAt = entry['createdAt'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
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
                              children: [
                                Text(
                                  _moodEmoji(score),
                                  style: const TextStyle(fontSize: 22),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Score $score • ${_moodText(score)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(createdAt),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (moods.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    moods
                                        .map(
                                          (mood) => Chip(
                                            label: Text(mood),
                                            backgroundColor: Colors.teal
                                                .withOpacity(0.10),
                                          ),
                                        )
                                        .toList(),
                              ),
                            if (moods.isNotEmpty) const SizedBox(height: 12),
                            Text(
                              reflection.isEmpty
                                  ? 'No note written.'
                                  : reflection,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
      ),
    );
  }
}
