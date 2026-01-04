import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  void _init() {
    // Set initial user if already authenticated
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      state = state.copyWith(user: currentUser);
    }

    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        state = state.copyWith(
          user: session?.user,
          isLoading: false,
          error: null,
        );
      } else if (event == AuthChangeEvent.signedOut) {
        state = const AuthState(
          user: null,
          isLoading: false,
          error: null,
        );
      } else if (event == AuthChangeEvent.userUpdated) {
        state = state.copyWith(user: session?.user);
      }
    });
  }

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = state.copyWith(
          user: response.user,
          isLoading: false,
          error: null,
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = state.copyWith(
          user: response.user,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Please check your email to confirm your account.',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Sign in with OAuth provider
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await Supabase.instance.client.auth.signInWithOAuth(
        provider,
        redirectTo: 'io.supabase.voicerapp://login-callback',
      );

      // Reset loading state after OAuth flow starts
      // The actual auth state will be updated via the auth state listener
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to sign in with ${provider.name}. Please try again.',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await Supabase.instance.client.auth.signOut();
      state = const AuthState(user: null, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to sign out. Please try again.',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resend confirmation email
  Future<void> resendConfirmationEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );

      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to resend confirmation email. Please try again.',
      );
    }
  }
}

/// Provider for authentication
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
