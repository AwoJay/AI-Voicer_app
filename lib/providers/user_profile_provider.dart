import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// User profile data
class UserProfile {
  final String id;
  final String? email;
  final String? role;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    this.email,
    this.role,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// User profile notifier
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  final Ref ref;

  /// Load user profile from Supabase
  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      state = AsyncValue.data(UserProfile.fromJson(response));
    } catch (e) {
      // Profile might not exist yet, create it
      state = const AsyncValue.data(null);
    }
  }

  /// Update user role
  Future<void> updateRole(String role) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      state = const AsyncValue.loading();

      // Check if profile exists
      final existingProfile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingProfile != null) {
        // Update existing profile
        await Supabase.instance.client
            .from('profiles')
            .update({'role': role})
            .eq('id', user.id);
      } else {
        // Create new profile
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'role': role,
        });
      }

      // Reload profile
      await _loadProfile();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Refresh profile
  Future<void> refresh() async {
    await _loadProfile();
  }
}

/// User profile provider
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier(ref);
});


















