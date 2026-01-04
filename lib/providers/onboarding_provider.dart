import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier for managing onboarding state
class OnboardingNotifier extends StateNotifier<int> {
  OnboardingNotifier() : super(0) {
    _loadOnboardingStatus();
  }

  /// Load onboarding status from shared preferences
  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;
    if (hasCompletedOnboarding) {
      state = 3; // Skip to end if already completed
    }
  }

  /// Move to next onboarding screen
  void next() {
    if (state < 2) {
      state = state + 1;
    }
  }

  /// Move to previous onboarding screen
  void previous() {
    if (state > 0) {
      state = state - 1;
    }
  }

  /// Set current page index
  void setPage(int page) {
    if (page >= 0 && page <= 2) {
      state = page;
    }
  }

  /// Skip onboarding and mark as completed
  Future<void> skip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    state = 3; // Mark as completed
  }

  /// Complete onboarding and mark as completed
  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    state = 3; // Mark as completed
  }

  /// Check if onboarding is completed
  bool get isCompleted => state >= 3;
}

/// Provider for onboarding notifier
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, int>((ref) {
  return OnboardingNotifier();
});

