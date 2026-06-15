import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/user_repository.dart';
import '../../theme/app_theme.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isChecking = false;
  bool isSending = false;

  Future<void> _checkVerification() async {
    try {
      setState(() => isChecking = true);

      await AuthService.reloadUser();

      final user = AuthService.currentUser;

      if (user != null && user.emailVerified) {
        await UserRepository.markEmailVerified(user.uid);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully.')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email is not verified yet. Please check your inbox.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isChecking = false);
      }
    }
  }

  Future<void> _resendEmail() async {
    try {
      setState(() => isSending = true);

      await AuthService.resendVerificationEmail();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent again.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send verification email.')),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService.currentUser?.email ?? 'your email';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  size: 56,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'We sent a verification link to:\n$email\n\nPlease confirm your email before continuing.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isChecking ? null : _checkVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child:
                      isChecking
                          ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'I verified my email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: isSending ? null : _resendEmail,
                child: Text(
                  isSending ? 'Sending...' : 'Resend verification email',
                ),
              ),

              TextButton(
                onPressed: _logout,
                child: const Text('Use another account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
