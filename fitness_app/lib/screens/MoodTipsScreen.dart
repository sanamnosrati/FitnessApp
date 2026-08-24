import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MoodTipsScreen extends StatelessWidget {
  const MoodTipsScreen({super.key});

  final List<Map<String, dynamic>> tips = const [
    {
      'title': 'Take 5 deep breaths',
      'icon': Icons.air_rounded,
      'color': Color(0xFF14B8A6),
      'text':
          'Slow breathing can calm your body and reduce stress. Inhale deeply through your nose and exhale slowly through your mouth.',
    },
    {
      'title': 'Drink some water',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFF38BDF8),
      'text':
          'Sometimes tiredness, headaches, and low mood can feel worse when you are dehydrated.',
    },
    {
      'title': 'Go for a short walk',
      'icon': Icons.directions_walk_rounded,
      'color': Color(0xFF4ADE80),
      'text':
          'A 5 to 10 minute walk can help clear your mind, reduce stress, and improve your mood.',
    },
    {
      'title': 'Write down your thoughts',
      'icon': Icons.edit_note_rounded,
      'color': AppTheme.primaryColor,
      'text':
          'Journaling helps you process emotions and understand what is bothering you.',
    },
    {
      'title': 'Take a small break',
      'icon': Icons.spa_rounded,
      'color': Color(0xFFFFB74D),
      'text':
          'Pause for a moment. Step away from stress, close your eyes, and let your mind rest.',
    },
    {
      'title': 'Talk to someone you trust',
      'icon': Icons.people_alt_rounded,
      'color': Color(0xFFF472B6),
      'text':
          'Sharing your feelings with a trusted person can make you feel supported and less alone.',
    },
    {
      'title': 'Listen to calming music',
      'icon': Icons.music_note_rounded,
      'color': Color(0xFF818CF8),
      'text':
          'Soft music can reduce tension, slow your thoughts, and help you relax.',
    },
    {
      'title': 'Be kind to yourself',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFFB7185),
      'text':
          'You do not need to be perfect. Rest, mistakes, and difficult days are all part of growth.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Mood Tips',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF211A33), Color(0xFF15161A)],
                ),

                borderRadius: BorderRadius.circular(24),

                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.28),
                ),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_alt_rounded,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Small tips for difficult moments',

                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 9),

                  Text(
                    'Try one small action to feel a little better.',

                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),

                itemCount: tips.length,

                separatorBuilder: (_, __) => const SizedBox(height: 12),

                itemBuilder: (context, index) {
                  final tip = tips[index];

                  final color = tip['color'] as Color;

                  return Container(
                    padding: const EdgeInsets.all(17),

                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(color: color.withOpacity(0.22)),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Container(
                          width: 50,
                          height: 50,

                          decoration: BoxDecoration(
                            color: color.withOpacity(0.13),

                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: Icon(tip['icon'] as IconData, color: color),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                tip['title'] as String,

                                style: const TextStyle(
                                  color: AppTheme.textPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                tip['text'] as String,

                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondaryColor,
                                  height: 1.45,
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
