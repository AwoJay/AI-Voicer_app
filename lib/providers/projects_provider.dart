import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/voice_filter.dart';

/// Project type enum
enum ProjectType {
  textToSpeech,
  voiceChanger,
  voiceTranslate,
}

/// Project model
class Project {
  final String id;
  final String title;
  final String? filePath;
  final Duration duration;
  final DateTime createdAt;
  final ProjectType type;
  final String? audioUrl;
  final VoiceFilter? voiceFilter;

  Project({
    required this.id,
    required this.title,
    required this.duration,
    required this.createdAt,
    required this.type,
    this.filePath,
    this.audioUrl,
    this.voiceFilter,
  });

  String get typeLabel {
    switch (type) {
      case ProjectType.textToSpeech:
        return 'AI Text to Speech';
      case ProjectType.voiceChanger:
        return 'AI Voice Changer';
      case ProjectType.voiceTranslate:
        return 'AI Voice Translate';
    }
  }

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}s';
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  /// Convert Project to JSON for Supabase storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_path': filePath,
      'duration_seconds': duration.inSeconds,
      'created_at': createdAt.toIso8601String(),
      'type': type.name,
      'audio_url': audioUrl,
      'voice_language': voiceFilter?.language,
      'voice_gender': voiceFilter?.gender,
      'voice_age_group': voiceFilter?.ageGroup,
    };
  }

  /// Create Project from Supabase JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    VoiceFilter? filter;
    if (json['voice_language'] != null &&
        json['voice_gender'] != null &&
        json['voice_age_group'] != null) {
      filter = VoiceFilter(
        language: json['voice_language'] as String,
        gender: json['voice_gender'] as String,
        ageGroup: json['voice_age_group'] as String,
      );
    }

    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      filePath: json['file_path'] as String?,
      duration: Duration(seconds: json['duration_seconds'] as int),
      createdAt: DateTime.parse(json['created_at'] as String),
      type: ProjectType.values.firstWhere(
        (e) => e.name == json['type'] as String,
        orElse: () => ProjectType.textToSpeech,
      ),
      audioUrl: json['audio_url'] as String?,
      voiceFilter: filter,
    );
  }
}

/// Projects state
class ProjectsState {
  final List<Project> projects;
  final bool isLoading;

  const ProjectsState({
    this.projects = const [],
    this.isLoading = false,
  });

  ProjectsState copyWith({
    List<Project>? projects,
    bool? isLoading,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Projects notifier
class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier() : super(const ProjectsState()) {
    _loadProjects();
  }

  /// Load projects from Supabase
  Future<void> _loadProjects() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      state = const ProjectsState(projects: [], isLoading: false);
      return;
    }

    try {
      state = state.copyWith(isLoading: true);

      final response = await Supabase.instance.client
          .from('projects')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final projects = (response as List)
          .map((json) => Project.fromJson(json as Map<String, dynamic>))
          .toList();

      state = state.copyWith(projects: projects, isLoading: false);
    } catch (e) {
      // If table doesn't exist or error, use empty list
      state = state.copyWith(projects: [], isLoading: false);
    }
  }

  /// Create a new text-to-speech project
  Future<Project> createTextToSpeechProject(
    String title,
    VoiceFilter voiceFilter,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to create projects');
    }

    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call delay - in real app, this would call TTS API with voice filter
      await Future.delayed(const Duration(seconds: 2));

      // Generate audio URL based on voice filter
      // In a real implementation, this would be the actual TTS API response
      final audioUrl = _generateAudioUrl(voiceFilter);

      // Calculate dynamic duration based on text length and speech rate
      final duration = _calculateDuration(title, voiceFilter);

      final projectId = DateTime.now().millisecondsSinceEpoch.toString();
      final projectTitle = title.endsWith('.mp3') ? title : '$title.mp3';
      final createdAt = DateTime.now();

      final project = Project(
        id: projectId,
        title: projectTitle,
        duration: duration,
        createdAt: createdAt,
        type: ProjectType.textToSpeech,
        audioUrl: audioUrl,
        voiceFilter: voiceFilter,
      );

      // Save to Supabase
      await Supabase.instance.client.from('projects').insert({
        'id': projectId,
        'user_id': user.id,
        'title': projectTitle,
        'duration_seconds': duration.inSeconds,
        'created_at': createdAt.toIso8601String(),
        'type': ProjectType.textToSpeech.name,
        'audio_url': audioUrl,
        'voice_language': voiceFilter.language,
        'voice_gender': voiceFilter.gender,
        'voice_age_group': voiceFilter.ageGroup,
      });

      // Update local state
      state = state.copyWith(
        projects: [project, ...state.projects],
        isLoading: false,
      );

      return project;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Calculate duration based on text length and speech rate
  Duration _calculateDuration(String text, VoiceFilter filter) {
    // Remove .mp3 extension if present
    final cleanText = text.replaceAll('.mp3', '').trim();
    
    // Average speaking rate: ~150 words per minute (normal speed)
    // Adjust based on age group
    double wordsPerMinute = 150.0;
    switch (filter.ageGroup.toLowerCase()) {
      case 'kid':
        wordsPerMinute = 120.0; // Slower for kids
        break;
      case 'young':
        wordsPerMinute = 150.0; // Normal speed
        break;
      case 'middle-aged':
        wordsPerMinute = 140.0; // Slightly slower
        break;
      case 'old':
        wordsPerMinute = 120.0; // Slower for older voices
        break;
    }

    // Count words (split by spaces)
    final words = cleanText.split(' ').where((w) => w.isNotEmpty).length;
    
    // Calculate duration: (words / wordsPerMinute) * 60 seconds
    final seconds = (words / wordsPerMinute) * 60;
    
    // Minimum duration of 5 seconds, round up
    final durationSeconds = (seconds < 5 ? 5 : seconds.ceil());
    
    return Duration(seconds: durationSeconds);
  }

  /// Generate audio URL based on voice filter
  /// In a real implementation, this would call the TTS API with the filter parameters
  String _generateAudioUrl(VoiceFilter filter) {
    // Simulate generating URL based on filter
    // Format: /audio/{language}_{gender}_{ageGroup}_{timestamp}.mp3
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '/audio/${filter.language.toLowerCase()}_'
        '${filter.gender.toLowerCase()}_'
        '${filter.ageGroup.toLowerCase().replaceAll('-', '_')}_'
        '$timestamp.mp3';
  }

  /// Create a new voice changer project
  Future<Project> createVoiceChangerProject(String title) async {
    await Future.delayed(const Duration(seconds: 2));

    final project = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.endsWith('.mp3') ? title : '$title.mp3',
      duration: const Duration(seconds: 50),
      createdAt: DateTime.now(),
      type: ProjectType.voiceChanger,
    );

    state = state.copyWith(
      projects: [project, ...state.projects],
    );

    return project;
  }

  /// Create a new voice translate project
  Future<Project> createVoiceTranslateProject(String title) async {
    await Future.delayed(const Duration(seconds: 2));

    final project = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.endsWith('.mp3') ? title : '$title.mp3',
      duration: const Duration(seconds: 35),
      createdAt: DateTime.now(),
      type: ProjectType.voiceTranslate,
    );

    state = state.copyWith(
      projects: [project, ...state.projects],
    );

    return project;
  }

  /// Delete a project
  Future<void> deleteProject(String id) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to delete projects');
    }

    try {
      // Delete from Supabase
      await Supabase.instance.client
          .from('projects')
          .delete()
          .eq('id', id)
          .eq('user_id', user.id);

      // Update local state
      state = state.copyWith(
        projects: state.projects.where((p) => p.id != id).toList(),
      );
    } catch (e) {
      // If Supabase delete fails, still update local state
      state = state.copyWith(
        projects: state.projects.where((p) => p.id != id).toList(),
      );
      rethrow;
    }
  }

  /// Refresh projects from Supabase
  Future<void> refresh() async {
    await _loadProjects();
  }

  /// Get filtered projects
  List<Project> getFilteredProjects(String? searchQuery, ProjectType? filterType) {
    var filtered = state.projects;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (filterType != null) {
      filtered = filtered.where((p) => p.type == filterType).toList();
    }

    return filtered;
  }
}

/// Projects provider
final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  return ProjectsNotifier();
});

