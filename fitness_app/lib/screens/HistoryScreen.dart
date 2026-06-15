import 'package:flutter/material.dart';

import 'mental_health_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final MentalHealthService _service = MentalHealthService();

  bool isLoading = true;
  List<Map<String, dynamic>> last30Days = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);

    final logs = await _service.getLast30Days();

    setState(() {
      last30Days = logs;
      isLoading = false;
    });
  }

  String _dateId(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _scoreEmoji(double score) {
    if (score <= 1.5) return '😢';
    if (score <= 2.5) return '🙁';
    if (score <= 3.5) return '😐';
    if (score <= 4.5) return '🙂';
    return '😄';
  }

  String _scoreLabel(double score) {
    if (score == 0) return 'No data yet';
    if (score <= 1.5) return 'Very Low';
    if (score <= 2.5) return 'Low';
    if (score <= 3.5) return 'Okay';
    if (score <= 4.5) return 'Good';
    return 'Great';
  }

  List<Map<String, dynamic>> _logsForLastDays(int days) {
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: days - 1));

    return last30Days.where((log) {
      final dateText = log['date']?.toString();
      if (dateText == null) return false;

      final date = DateTime.tryParse(dateText);
      if (date == null) return false;

      final pureDate = DateTime(date.year, date.month, date.day);

      return !pureDate.isBefore(start);
    }).toList();
  }

  double _averageForLastDays(int days) {
    final logs = _logsForLastDays(days).where((log) => log['score'] != null);

    if (logs.isEmpty) return 0;

    final total = logs.fold<int>(
      0,
      (sum, log) => sum + ((log['score'] ?? 0) as int),
    );

    return total / logs.length;
  }

  int _loggedDaysForLastDays(int days) {
    return _logsForLastDays(days).length;
  }

  List<int> _scoreBarsForLastDays(int days) {
    final result = <int>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final id = _dateId(date);

      final matches = last30Days.where((log) => log['date'] == id);

      if (matches.isEmpty) {
        result.add(0);
      } else {
        result.add(matches.first['score'] as int? ?? 0);
      }
    }

    return result;
  }

  List<String> _barLabelsForLastDays(int days) {
    final labels = <String>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      if (days == 7) {
        const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        labels.add(weekdays[date.weekday - 1]);
      } else {
        labels.add(date.day.toString());
      }
    }

    return labels;
  }

  String _mostCommonMood(int days) {
    final logs = _logsForLastDays(days);
    final counts = <String, int>{};

    for (final log in logs) {
      final moods = List<String>.from(log['moods'] ?? []);
      for (final mood in moods) {
        counts[mood] = (counts[mood] ?? 0) + 1;
      }
    }

    if (counts.isEmpty) return 'No mood saved';

    final sorted =
        counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  int _noteDays(int days) {
    final logs = _logsForLastDays(days);

    return logs.where((log) {
      final note = (log['reflection'] ?? '').toString().trim();
      return note.isNotEmpty;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F6F2);
    const dark = Color(0xFF171717);
    const accent = Color(0xFFEFA6B4);
    const soft = Color(0xFFFFEEF2);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: dark,
        title: const Text(
          'Mental Overview',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator(color: dark))
              : RefreshIndicator(
                onRefresh: _loadHistory,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  children: [
                    _headerCard(dark, soft),
                    const SizedBox(height: 22),
                    _analysisCard(
                      title: 'This Week',
                      subtitle: 'Last 7 days',
                      days: 7,
                      dark: dark,
                      accent: accent,
                      soft: soft,
                    ),
                    const SizedBox(height: 22),
                    _analysisCard(
                      title: 'Monthly Analysis',
                      subtitle: 'Last 30 days',
                      days: 30,
                      dark: dark,
                      accent: accent,
                      soft: soft,
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _headerCard(Color dark, Color soft) {
    final weekAvg = _averageForLastDays(7);
    final monthAvg = _averageForLastDays(30);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Row(
        children: [
          Text(_scoreEmoji(monthAvg), style: const TextStyle(fontSize: 52)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthAvg == 0 ? 'No overview yet' : 'Your mood overview',
                  style: TextStyle(
                    color: dark,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  monthAvg == 0
                      ? 'Save mood scores in Mind Check-In to see weekly and monthly analysis.'
                      : 'Week avg: ${weekAvg.toStringAsFixed(1)} • Month avg: ${monthAvg.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Color(0xFF7A706C),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analysisCard({
    required String title,
    required String subtitle,
    required int days,
    required Color dark,
    required Color accent,
    required Color soft,
  }) {
    final average = _averageForLastDays(days);
    final loggedDays = _loggedDaysForLastDays(days);
    final commonMood = _mostCommonMood(days);
    final noteDays = _noteDays(days);
    final bars = _scoreBarsForLastDays(days);
    final labels = _barLabelsForLastDays(days);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_scoreEmoji(average), style: const TextStyle(fontSize: 38)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: dark,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8A817C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                average == 0 ? '-' : average.toStringAsFixed(1),
                style: TextStyle(
                  color: accent,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: soft,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              average == 0
                  ? 'No mood scores saved in this period.'
                  : '${_scoreLabel(average)} mood trend based on $loggedDays saved day${loggedDays == 1 ? '' : 's'}.',
              style: TextStyle(
                color: dark,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (index) {
                final score = bars[index];
                final label = labels[index];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: days == 7 ? 22 : 10,
                              height: score == 0 ? 8 : score * 22,
                              decoration: BoxDecoration(
                                color:
                                    score == 0
                                        ? const Color(0xFFE9E2DC)
                                        : accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8A817C),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _smallInsight(
                  title: 'Saved Days',
                  value: '$loggedDays',
                  icon: Icons.calendar_month_rounded,
                  soft: soft,
                  accent: accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _smallInsight(
                  title: 'Top Mood',
                  value: commonMood,
                  icon: Icons.favorite_rounded,
                  soft: soft,
                  accent: accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _smallInsight(
                  title: 'Notes',
                  value: '$noteDays days',
                  icon: Icons.edit_note_rounded,
                  soft: soft,
                  accent: accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _smallInsight(
                  title: 'Trend',
                  value: _scoreLabel(average),
                  icon: Icons.trending_up_rounded,
                  soft: soft,
                  accent: accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInsight({
    required String title,
    required String value,
    required IconData icon,
    required Color soft,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 24),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF8A817C),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
