import 'package:flutter/material.dart';

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Positive Thoughts'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Color(0xFFFFC46A)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.white, size: 36),
                  const SizedBox(height: 14),
                  Text(
                    currentQuote,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: newQuote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('New Thought'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Affirmations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...affirmations.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 16),
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
