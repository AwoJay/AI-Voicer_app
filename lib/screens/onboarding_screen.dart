import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';

/// Main onboarding screen that displays different pages based on current index
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize with page 0, will sync with provider state in build
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingProvider);

    // If onboarding is completed, return empty container (should navigate away)
    if (currentPage >= 3) {
      return const SizedBox.shrink();
    }

    // Sync page controller with state changes from buttons
    if (_pageController.hasClients && _pageController.page?.round() != currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark charcoal background
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // Update state when page changes via swipe
            ref.read(onboardingProvider.notifier).setPage(index);
          },
          children: const [
            OnboardingPage1(),
            OnboardingPage2(),
            OnboardingPage3(),
          ],
        ),
      ),
    );
  }
}

/// First onboarding page: "Voicer - Your Creative Sound Studio"
class OnboardingPage1 extends ConsumerWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Illustration section
          Expanded(
            flex: 5,
            child: Image.asset(
              'images/voice.jpeg',
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(flex: 1),
          // Title
          const Text(
            'Voicer - Your Creative\nSound Studio',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          const Text(
            'Experience the magic of Text to Speech Voice\nChanger and Translate Audio seamlessly.\nLet your voice be the masterpiece!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProgressDot(isActive: true),
              const SizedBox(width: 8),
              _ProgressDot(isActive: false),
              const SizedBox(width: 8),
              _ProgressDot(isActive: false),
            ],
          ),
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _SkipButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).skip(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ContinueButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).next(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Second onboarding page: "Voicer Learns Your Voice, Make it Awesome!"
class OnboardingPage2 extends ConsumerWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Illustration section
          Expanded(
            flex: 5,
            child: Image.asset(
              'images/ai voi.jpeg',
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(flex: 1),
          // Title
          const Text(
            'Voicer Learns Your Voice,\nMake it Awesome!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          const Text(
            'Voicer learns your voice, allowing you to use it in Text to Speech. Your expressions your way - a new dimension in creative storytelling',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProgressDot(isActive: false),
              const SizedBox(width: 8),
              _ProgressDot(isActive: true),
              const SizedBox(width: 8),
              _ProgressDot(isActive: false),
            ],
          ),
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _SkipButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).skip(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ContinueButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).next(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Third onboarding page: "Upgrade to Premium Unlock Your Creativity"
class OnboardingPage3 extends ConsumerWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Illustration section
          Expanded(
            flex: 5,
            child: Image.asset(
              'images/ai.jpeg',
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(flex: 1),
          // Title
          const Text(
            'Upgrade to Premium\nUnlock Your Creativity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          const Text(
            'Enjoy unlimited access, export projects in\nvarious formats (MP3, WAV, ACC, FLAC) and\nelevate your creations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProgressDot(isActive: false),
              const SizedBox(width: 8),
              _ProgressDot(isActive: false),
              const SizedBox(width: 8),
              _ProgressDot(isActive: true),
            ],
          ),
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _SkipButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).skip(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ContinueButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).complete(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Progress dot indicator widget
class _ProgressDot extends StatelessWidget {
  final bool isActive;

  const _ProgressDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF9B59B6) : const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Skip button widget
class _SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SkipButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Continue button widget
class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9B59B6), // Vibrant purple
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Continue',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

