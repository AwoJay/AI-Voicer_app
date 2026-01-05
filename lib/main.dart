import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'providers/onboarding_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth/get_started_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before running the app
  // Only initialize if credentials are configured (not placeholders)
  final hasValidConfig = SupabaseConfig.supabaseUrl != 'YOUR_SUPABASE_URL_HERE' &&
      SupabaseConfig.supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY_HERE' &&
      SupabaseConfig.supabaseUrl.isNotEmpty &&
      SupabaseConfig.supabaseAnonKey.isNotEmpty;

  if (hasValidConfig) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      // Continue anyway - error will be shown in UI
    }
  } else {
    debugPrint('Supabase not configured - using placeholder credentials. Please update lib/config/supabase_config.dart');
  }

  runApp(const ProviderScope(child: VoicerApp()));
}

class VoicerApp extends ConsumerWidget {
  const VoicerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Voicer',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      // Light theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B59B6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B59B6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const AppNavigator(),
    );
  }
}

/// Navigator widget that shows onboarding, auth, or home based on state
class AppNavigator extends ConsumerWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final authState = ref.watch(authProvider);

    // Flow: Onboarding -> Authentication -> Home
    // 1. Show onboarding if not completed
    if (onboardingState < 3) {
      return const OnboardingScreen();
    }

    // 2. Show authentication if not authenticated
    if (!authState.isAuthenticated) {
      return const GetStartedScreen();
    }

    // 3. Show home if authenticated
    return const HomeScreen();
  }
}
