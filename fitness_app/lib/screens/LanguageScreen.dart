import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../theme/app_theme.dart';
import '../services/user_settings_service.dart';

class LanguageScreen extends StatefulWidget {
  final String currentLanguage;

  const LanguageScreen({super.key, required this.currentLanguage});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String selectedLanguage;
  bool isSaving = false;

  final List<Map<String, String>> languages = const [
    {'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
    {'name': 'Deutsch', 'native': 'Deutsch', 'flag': '🇩🇪'},
    {'name': 'Persian', 'native': 'فارسی', 'flag': '🇮🇷'},
    {'name': 'Turkish', 'native': 'Türkçe', 'flag': '🇹🇷'},
    {'name': 'Arabic', 'native': 'العربية', 'flag': '🇸🇦'},
    {'name': 'French', 'native': 'Français', 'flag': '🇫🇷'},
    {'name': 'Spanish', 'native': 'Español', 'flag': '🇪🇸'},
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.currentLanguage;
  }

  Future<void> _selectLanguage(String language) async {
    setState(() {
      selectedLanguage = language;
      isSaving = true;
    });

    await UserSettingsService.saveLanguage(language);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    Navigator.pop(context, language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Language', showBackButton: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _headerCard(),
          const SizedBox(height: 24),

          const Text(
            'Choose App Language',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          ...languages.map((language) {
            final name = language['name']!;
            final native = language['native']!;
            final flag = language['flag']!;
            final isSelected = selectedLanguage == name;

            return _languageCard(
              name: name,
              native: native,
              flag: flag,
              isSelected: isSelected,
              onTap: () => _selectLanguage(name),
            );
          }),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.language_rounded,
            color: AppTheme.primaryColor,
            size: 42,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Language',
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your language preference is saved to your account.',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (isSaving)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _languageCard({
    required String name,
    required String native,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 1.4,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: Text(flag, style: const TextStyle(fontSize: 30)),
        title: Text(
          name,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          native,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 13,
          ),
        ),
        trailing:
            isSelected
                ? const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.primaryColor,
                  size: 26,
                )
                : const Icon(
                  Icons.circle_outlined,
                  color: AppTheme.textSecondaryColor,
                  size: 22,
                ),
        onTap: isSaving ? null : onTap,
      ),
    );
  }
}
