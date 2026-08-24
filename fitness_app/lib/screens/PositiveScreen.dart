import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PositiveScreen extends StatefulWidget {
  const PositiveScreen({super.key});

  @override
  State<PositiveScreen> createState() => _PositiveScreenState();
}

class _PositiveScreenState extends State<PositiveScreen> {
  final List<String> quotes = [
    'You are doing your best.',
    'Small progress is still progress.',
    'You are stronger than you think.',
    'Today is a new beginning.',
    'Believe in yourself.',
    'Your feelings are valid.',
    'Rest is productive too.',
    'You can start again at any time.',
  ];

  final List<String> affirmations = [
    'I am enough.',
    'I can handle today.',
    'I am growing every day.',
    'I deserve peace.',
  ];

  String currentQuote = '';

  static const positiveColor = Color(0xFFFFB74D);

  @override
  void initState() {
    super.initState();

    currentQuote = quotes.first;
  }

  void newQuote() {
    quotes.shuffle();

    setState(() {
      currentQuote = quotes.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Positive Thoughts',

          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    positiveColor.withOpacity(0.28),
                    AppTheme.purpleSurface,
                    AppTheme.surfaceColor,
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(26),

                border: Border.all(color: positiveColor.withOpacity(0.30)),
              ),

              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      color: positiveColor.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: positiveColor,
                      size: 31,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    currentQuote,

                    style: const TextStyle(
                      fontSize: 22,
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),

                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: newQuote,

                icon: const Icon(Icons.auto_awesome_rounded),

                style: ElevatedButton.styleFrom(
                  backgroundColor: positiveColor,
                  foregroundColor: Colors.black,

                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),

                label: const Text(
                  'New Thought',

                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(color: AppTheme.borderColor),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Row(
                      children: [
                        Icon(Icons.favorite_rounded, color: positiveColor),

                        SizedBox(width: 10),

                        Text(
                          'Daily Affirmations',

                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Expanded(
                      child: ListView.separated(
                        itemCount: affirmations.length,

                        separatorBuilder: (_, __) => const SizedBox(height: 10),

                        itemBuilder: (context, index) {
                          final item = affirmations[index];

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 14,
                            ),

                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLightColor,

                              borderRadius: BorderRadius.circular(16),

                              border: Border.all(
                                color: positiveColor.withOpacity(0.15),
                              ),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,

                                  decoration: BoxDecoration(
                                    color: positiveColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.favorite_rounded,
                                    color: positiveColor,
                                    size: 17,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    item,

                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
