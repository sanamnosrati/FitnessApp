import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../theme/app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'About Us', showBackButton: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _heroCard(),
          const SizedBox(height: 20),

          _sectionTitle('What is Fitness App?'),
          _textCard(
            'Fitness App helps users build a healthier lifestyle by combining workouts, nutrition, daily tracking and mental health support in one simple app.',
          ),

          _sectionTitle('Main Features'),
          _featureItem(
            Icons.fitness_center_rounded,
            'Workouts',
            'Training categories for upper body, lower body, core, cardio and stretching.',
          ),
          _featureItem(
            Icons.restaurant_rounded,
            'Nutrition',
            'Healthy recipes with calories, protein, carbs, fats and preparation steps.',
          ),
          _featureItem(
            Icons.dashboard_rounded,
            'Daily Dashboard',
            'Track water, meals, calories and daily progress.',
          ),
          _featureItem(
            Icons.favorite_rounded,
            'Mental Health',
            'Save moods, journal your thoughts and check your emotional history.',
          ),

          const SizedBox(height: 18),
          _sectionTitle('Our Goal'),
          _textCard(
            'The goal of this app is to make health tracking easier, more motivating and more personal. It is designed especially for people who want structure without complicated tools.',
          ),

          _sectionTitle('Version'),
          _textCard('Fitness App Version 1.0.0'),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: const [
          Icon(Icons.spa_rounded, size: 54, color: AppTheme.primaryColor),
          SizedBox(height: 14),
          Text(
            'Fitness App',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your personal health, fitness and wellness companion.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _textCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
}
