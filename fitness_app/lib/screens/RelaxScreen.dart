import 'package:flutter/material.dart';

class RelaxScreen extends StatelessWidget {
  const RelaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Relax'), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Breathing Exercise',
              icon: Icons.air,
              color: Colors.teal,
              child: const Text(
                'Try this simple breathing:\n\n'
                '• Breathe in for 4 seconds\n'
                '• Hold for 4 seconds\n'
                '• Breathe out for 6 seconds\n'
                '• Repeat 5 times',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 14),
            _sectionCard(
              title: 'Quick Relax Tips',
              icon: Icons.spa,
              color: Colors.green,
              child: const Text(
                '• Sit comfortably\n'
                '• Relax your shoulders\n'
                '• Unclench your jaw\n'
                '• Put your phone away for 2 minutes\n'
                '• Focus only on your breathing',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 14),
            _sectionCard(
              title: '5-4-3-2-1 Grounding',
              icon: Icons.visibility,
              color: Colors.blue,
              child: const Text(
                'When you feel overwhelmed:\n\n'
                '• 5 things you can see\n'
                '• 4 things you can touch\n'
                '• 3 things you can hear\n'
                '• 2 things you can smell\n'
                '• 1 thing you can taste',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
