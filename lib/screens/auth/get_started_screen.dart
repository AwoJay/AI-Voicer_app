import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/auth_provider.dart';
import 'sign_up_screen.dart';
import 'login_screen.dart';

/// Get Started screen - Initial authentication screen
class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // App name
              const Text(
                'Voicer',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9B59B6),
                ),
              ),
              const SizedBox(height: 32),
              // Main heading
              const Text(
                "Let's Get Started!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              const Text(
                "Let's dive in into your account",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(flex: 2),
              // Social login buttons
              _SocialLoginButton(
                icon: Icons.g_mobiledata,
                label: 'Continue with Google',
                onPressed:
                    () =>
                        _handleSocialLogin(context, ref, OAuthProvider.google),
                iconColor: Colors.white,
              ),
              const SizedBox(height: 16),
              _SocialLoginButton(
                icon: Icons.apple,
                label: 'Continue with Apple',
                onPressed:
                    () => _handleSocialLogin(context, ref, OAuthProvider.apple),
                iconColor: Colors.white,
              ),
              const SizedBox(height: 16),
              _SocialLoginButton(
                icon: Icons.facebook,
                label: 'Continue with Facebook',
                onPressed:
                    () => _handleSocialLogin(
                      context,
                      ref,
                      OAuthProvider.facebook,
                    ),
                iconColor: const Color(0xFF1877F2),
              ),
              const SizedBox(height: 16),
              _SocialLoginButton(
                icon: Icons.alternate_email,
                label: 'Continue with Twitter',
                onPressed:
                    () =>
                        _handleSocialLogin(context, ref, OAuthProvider.twitter),
                iconColor: const Color(0xFF1DA1F2),
              ),
              const SizedBox(height: 32),
              // Sign up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B59B6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Login button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9B59B6),
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSocialLogin(
    BuildContext context,
    WidgetRef ref,
    OAuthProvider provider,
  ) async {
    try {
      await ref.read(authProvider.notifier).signInWithOAuth(provider);
    } catch (e) {
      // Show error message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Social login button widget
class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color iconColor;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.grey, width: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
