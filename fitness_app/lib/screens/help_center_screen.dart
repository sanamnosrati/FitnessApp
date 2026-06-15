import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../theme/app_theme.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  static const String supportEmail = 'nosratisanam@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Help Center', showBackButton: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _supportCard(context),

          const SizedBox(height: 24),

          _sectionTitle('Quick Help'),

          _quickHelpCard(
            icon: Icons.person_outline_rounded,
            title: 'Profile',
            subtitle: 'Edit your personal information and fitness goals.',
          ),
          _quickHelpCard(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'Change the app language from your settings.',
          ),
          _quickHelpCard(
            icon: Icons.fitness_center_rounded,
            title: 'Workouts',
            subtitle: 'Browse workouts by body area and training type.',
          ),
          _quickHelpCard(
            icon: Icons.restaurant_rounded,
            title: 'Nutrition',
            subtitle: 'Explore recipes with calories and macros.',
          ),
          _quickHelpCard(
            icon: Icons.favorite_border_rounded,
            title: 'Mental Health',
            subtitle: 'Track moods, feelings and journal entries.',
          ),

          const SizedBox(height: 24),

          _sectionTitle('Frequently Asked Questions'),

          _faqItem(
            question: 'How do I edit my profile?',
            answer:
                'Go to Settings and tap on your profile header. Then you can open your profile and update your personal information.',
          ),
          _faqItem(
            question: 'How do I change the language?',
            answer:
                'Open Settings, tap Language and choose your preferred language from the list.',
          ),
          _faqItem(
            question: 'How do I save a journal entry?',
            answer:
                'Open Mental Health, write your journal text and press Save. Your entry will be stored in your history.',
          ),
          _faqItem(
            question: 'How do I use the workout section?',
            answer:
                'Open Workouts, choose a category such as Upper Body, Lower Body, Core, Cardio or Stretching and select an exercise.',
          ),
          _faqItem(
            question: 'How can I contact support?',
            answer: 'You can contact support by email: $supportEmail',
          ),

          const SizedBox(height: 24),

          _feedbackCard(context),
        ],
      ),
    );
  }

  Widget _supportCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              size: 42,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Need Help?',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We are happy to help you with account issues, workouts, nutrition, technical problems or feedback.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            supportEmail,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please contact: $supportEmail')),
              );
            },
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('Contact Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _quickHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 13,
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

  Widget _faqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        title: Text(
          question,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.star_rounded,
            color: AppTheme.primaryColor,
            size: 42,
          ),
          const SizedBox(height: 12),
          const Text(
            'Have an idea?',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We love hearing your feedback. Share ideas, problems or suggestions with us.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Send your feedback to: $supportEmail'),
                ),
              );
            },
            icon: const Icon(Icons.feedback_outlined),
            label: const Text('Send Feedback'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
