import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth/complete_profile_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/main_navigation.dart';
import '../services/auth_service.dart';
import '../services/user_repository.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const WelcomeScreen();
        }

        if (!user.emailVerified) {
          return const EmailVerificationScreen();
        }

        return FutureBuilder<bool>(
          future: UserRepository.isProfileCompleted(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (profileSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    'Could not load profile. Please try again.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }

            final profileCompleted = profileSnapshot.data ?? false;

            if (!profileCompleted) {
              return const CompleteProfileScreen();
            }

            return const MainNavigation();
          },
        );
      },
    );
  }
}
