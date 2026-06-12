import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PositiveScreen extends StatefulWidget {
  const PositiveScreen({super.key});

  @override
  State<PositiveScreen> createState() => _PositiveScreenState();
}

class _PositiveScreenState extends State<PositiveScreen> {
  final List<String> quotes = [
    "You are doing your best.",
    "Small progress is still progress.",
    "You are stronger than you think.",
    "Today is a new beginning.",
    "Believe in yourself.",
    "Your feelings are valid.",
    "Rest is productive too.",
    "You can start again at any time.",
  ];

  final List<String> affirmations = [
    "I am enough.",
    "I can handle today.",
    "I am growing every day.",
    "I deserve peace.",
  ];

  String currentQuote = "";

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
        title: const Text('Positive Thoughts'),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.95),
                    AppTheme.secondaryColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 38),
                  const SizedBox(height: 18),
                  Text(
                    currentQuote,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
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
                icon: const Icon(Icons.refresh),
                label: const Text('New Thought'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
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
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Affirmations',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...affirmations.map(
                      (item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLightColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
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
