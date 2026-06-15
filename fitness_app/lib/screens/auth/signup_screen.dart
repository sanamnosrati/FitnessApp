import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/user_repository.dart';
import '../../theme/app_theme.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    try {
      setState(() => isLoading = true);

      final credential = await AuthService.signUp(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;

      if (uid == null) {
        _showMessage('Could not create user.');
        return;
      }

      await credential.user?.updateDisplayName(name);

      await UserRepository.createUser(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      _showMessage('Sign up failed. Please try another email.');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: AppTheme.textSecondaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        foregroundColor: AppTheme.textPrimaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        children: [
          const Text(
            'Create account',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Start tracking your fitness, nutrition and wellness journey.',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15),
          ),

          const SizedBox(height: 30),

          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration(
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              label: 'Email Address',
              icon: Icons.email_outlined,
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(
              label: 'Phone Number',
              icon: Icons.phone_outlined,
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: _inputDecoration(
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.textSecondaryColor,
                ),
                onPressed: () {
                  setState(() => obscurePassword = !obscurePassword);
                },
              ),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            decoration: _inputDecoration(
              label: 'Confirm Password',
              icon: Icons.lock_reset_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.textSecondaryColor,
                ),
                onPressed: () {
                  setState(
                    () => obscureConfirmPassword = !obscureConfirmPassword,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text(
                        'Create Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
