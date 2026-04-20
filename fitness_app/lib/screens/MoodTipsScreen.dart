import 'package:flutter/material.dart';

class MoodTipsScreen extends StatelessWidget {
  const MoodTipsScreen({super.key});

  final List<Map<String, dynamic>> tips = const [
    {
      'title': 'Take 5 deep breaths',
      'icon': Icons.air,
      'color': Colors.teal,
      'text':
          'Slow breathing can calm your body and reduce stress. Inhale deeply through your nose and exhale slowly through your mouth.',
    },
    {
      'title': 'Drink some water',
      'icon': Icons.water_drop,
      'color': Colors.blue,
      'text':
          'Sometimes tiredness, headaches, and low mood can feel worse when you are dehydrated.',
    },
    {
      'title': 'Go for a short walk',
      'icon': Icons.directions_walk,
      'color': Colors.green,
      'text':
          'A 5 to 10 minute walk can help clear your mind, reduce stress, and improve your mood.',
    },
    {
      'title': 'Write down your thoughts',
      'icon': Icons.edit_note,
      'color': Colors.purple,
      'text':
          'Journaling helps you process emotions and understand what is bothering you.',
    },
    {
      'title': 'Take a small break',
      'icon': Icons.spa,
      'color': Colors.orange,
      'text':
          'Pause for a moment. Step away from stress, close your eyes, and let your mind rest.',
    },
    {
      'title': 'Talk to someone you trust',
      'icon': Icons.people_alt,
      'color': Colors.pink,
      'text':
          'Sharing your feelings with a trusted person can make you feel supported and less alone.',
    },
    {
      'title': 'Listen to calming music',
      'icon': Icons.music_note,
      'color': Colors.indigo,
      'text':
          'Soft music can reduce tension, slow your thoughts, and help you relax.',
    },
    {
      'title': 'Be kind to yourself',
      'icon': Icons.favorite,
      'color': Colors.red,
      'text':
          'You do not need to be perfect. Rest, mistakes, and difficult days are all part of growth.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Mood Tips'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Color(0xFF7BB6FF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Small tips for difficult moments',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try one small action to feel a little better.',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: tips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return Container(
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: (tip['color'] as Color).withOpacity(
                            0.12,
                          ),
                          child: Icon(
                            tip['icon'] as IconData,
                            color: tip['color'] as Color,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip['title'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tip['text'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
