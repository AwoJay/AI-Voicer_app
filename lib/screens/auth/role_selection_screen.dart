import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_profile_provider.dart';
import '../home_screen.dart';

/// Role selection screen
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  final List<String> _roles = [
    'Freelancer',
    'Content Creator',
    'Student',
    'Teacher',
    'Social Media Specialist',
    'Police',
  ];

  Future<void> _handleSignUp() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(userProfileProvider.notifier).updateRole(_selectedRole!);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Back button and progress indicator
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _ProgressDot(isActive: true),
                      const SizedBox(width: 4),
                      _ProgressDot(isActive: true),
                      const SizedBox(width: 4),
                      _ProgressDot(isActive: true),
                      const SizedBox(width: 4),
                      _ProgressDot(isActive: true),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Title
              const Row(
                children: [
                  Text(
                    "Let's Get to Know You Better",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '🚀',
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              const Text(
                "Select the option that best describe your role. Voicer tailors it's features to suit your needs.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Role options
              ..._roles.map((role) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RoleOption(
                      role: role,
                      isSelected: _selectedRole == role,
                      onTap: () {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                    ),
                  )),
              const SizedBox(height: 32),
              // Sign up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B59B6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Role option widget
class _RoleOption extends StatelessWidget {
  final String role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF9B59B6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF9B59B6),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Progress dot indicator
class _ProgressDot extends StatelessWidget {
  final bool isActive;

  const _ProgressDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF9B59B6) : const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}


















