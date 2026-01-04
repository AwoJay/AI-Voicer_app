import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../providers/projects_provider.dart';
import '../models/voice_filter.dart';

/// My Projects screen
class MyProjectsScreen extends ConsumerStatefulWidget {
  const MyProjectsScreen({super.key});

  @override
  ConsumerState<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends ConsumerState<MyProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  ProjectType? _selectedFilter;
  String _searchQuery = '';
  Project? _currentlyPlaying;
  bool _isPlaying = false;
  Timer? _playbackTimer;
  double _playbackProgress = 0.0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<void>? _completeSubscription;

  @override
  void dispose() {
    _searchController.dispose();
    _playbackTimer?.cancel();
    _positionSubscription?.cancel();
    _stateSubscription?.cancel();
    _completeSubscription?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(
      projectsProvider,
    ); // Watch to rebuild when projects change

    // Show loading indicator if projects are loading
    if (projectsState.isLoading && projectsState.projects.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF9B59B6)),
        ),
      );
    }

    final filteredProjects = ref
        .read(projectsProvider.notifier)
        .getFilteredProjects(
          _searchQuery.isEmpty ? null : _searchQuery,
          _selectedFilter,
        );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Search Bar
            _buildSearchBar(),
            // Filter Tabs
            _buildFilterTabs(),
            // Projects List
            Expanded(
              child: filteredProjects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: _currentlyPlaying != null ? 80 : 20,
                      ),
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectItem(filteredProjects[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _currentlyPlaying != null
          ? _buildNowPlayingBar(_currentlyPlaying!)
          : null,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'My Projects',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by Voice Name',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4A90E2)),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterTab('All', null),
          const SizedBox(width: 16),
          _buildFilterTab('AI Text to Speech', ProjectType.textToSpeech),
          const SizedBox(width: 16),
          _buildFilterTab('AI Voice Changer', ProjectType.voiceChanger),
          const SizedBox(width: 16),
          _buildFilterTab('AI Voice Translate', ProjectType.voiceTranslate),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, ProjectType? type) {
    final isSelected = _selectedFilter == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[700] : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectItem(Project project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Project Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${project.formattedDuration} - ${project.formattedDate} - ${project.typeLabel}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                if (project.voiceFilter != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Voice: ${project.voiceFilter!.displayName}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          // Options Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF2A2A2A),
            onSelected: (value) async {
              if (value == 'delete') {
                await _deleteProject(project.id);
              } else if (value == 'play') {
                _playProject(project);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'play',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Play', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'No projects yet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first project to get started',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _playProject(Project project) async {
    // Stop any currently playing audio
    if (_isPlaying && _currentlyPlaying != null) {
      _playbackTimer?.cancel();
      await _audioPlayer.stop();
    }

    setState(() {
      _currentlyPlaying = project;
      _isPlaying = true;
      _playbackProgress = 0.0;
    });

    try {
      // Extract text from project title (remove .mp3 extension)
      String textToSpeak = project.title.replaceAll('.mp3', '').trim();

      if (textToSpeak.isEmpty) {
        throw Exception('No text to speak');
      }

      // Cancel any existing subscriptions
      _positionSubscription?.cancel();
      _stateSubscription?.cancel();
      _completeSubscription?.cancel();

      // Configure audio player
      await _audioPlayer.setVolume(1.0); // Maximum volume
      await _audioPlayer.setReleaseMode(ReleaseMode.stop); // Stop when done

      // Get TTS audio URL based on voice filter
      String audioUrl = await _getTtsAudioUrl(textToSpeak, project.voiceFilter);

      debugPrint('Playing TTS audio from: $audioUrl');
      debugPrint('Text: $textToSpeak');

      // Set up position tracking
      _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
        if (mounted && _currentlyPlaying != null) {
          final totalDuration = project.duration;
          setState(() {
            _playbackProgress =
                position.inMilliseconds / totalDuration.inMilliseconds;
            if (_playbackProgress >= 1.0) {
              _playbackProgress = 1.0;
            }
          });
        }
      });

      // Set up state tracking
      _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
        debugPrint('Audio player state changed: $state');
        if (state == PlayerState.completed || state == PlayerState.stopped) {
          if (mounted && _currentlyPlaying != null) {
            _positionSubscription?.cancel();
            _stateSubscription?.cancel();
            _completeSubscription?.cancel();
            setState(() {
              _isPlaying = false;
              _currentlyPlaying = null;
              _playbackProgress = 0.0;
            });
          }
        }
      });

      // Set up completion handler
      _completeSubscription = _audioPlayer.onPlayerComplete.listen((_) {
        debugPrint('Audio playback completed');
        if (mounted) {
          _positionSubscription?.cancel();
          _stateSubscription?.cancel();
          _completeSubscription?.cancel();
          setState(() {
            _isPlaying = false;
            _currentlyPlaying = null;
            _playbackProgress = 0.0;
          });
        }
      });

      // Play the audio
      // Add a small delay to ensure URL is ready
      await Future.delayed(const Duration(milliseconds: 100));

      try {
        await _audioPlayer.play(UrlSource(audioUrl));
        debugPrint('Audio play command sent successfully');
      } catch (playError) {
        debugPrint('Error playing audio URL: $playError');
        // Try with a simpler URL format as fallback
        final fallbackUrl = audioUrl.replaceAll('&client=tw-ob', '');
        debugPrint('Trying fallback URL: $fallbackUrl');
        await _audioPlayer.play(UrlSource(fallbackUrl));
      }

      // Show success message
      if (mounted) {
        String message = 'Playing ${project.title}';
        if (project.voiceFilter != null) {
          message += '\nVoice: ${project.voiceFilter!.displayName}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF9B59B6),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
        _currentlyPlaying = null;
        _playbackProgress = 0.0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Get TTS audio URL using Google Translate TTS API
  /// Note: This works on mobile apps (CORS doesn't apply)
  Future<String> _getTtsAudioUrl(String text, VoiceFilter? filter) async {
    String languageCode = 'en';
    if (filter != null) {
      debugPrint(
        'Voice filter received: ${filter.language}, ${filter.gender}, ${filter.ageGroup}',
      );
      languageCode = _getLanguageCodeForTts(filter.language);
      debugPrint(
        'Using language code: $languageCode for language: ${filter.language}',
      );
    } else {
      debugPrint('No voice filter provided, using default: en');
    }

    // Split long text into chunks (Google TTS has character limits)
    // Limit to 200 characters per request
    if (text.length > 200) {
      text = text.substring(0, 200);
    }

    // Google Translate TTS API (free, works on mobile)
    // Using the standard endpoint format with proper encoding
    final encodedText = Uri.encodeComponent(text);

    // Build TTS URL - Google Translate TTS endpoint
    // Use the language code directly
    // Note: Google Translate TTS uses ISO 639-1 codes
    final ttsUrl =
        'https://translate.google.com/translate_tts?ie=UTF-8&tl=$languageCode&client=tw-ob&q=$encodedText';

    debugPrint('=== TTS Configuration ===');
    debugPrint('Original text: $text');
    debugPrint('Language filter: ${filter?.language ?? "none"}');
    debugPrint('Language code: $languageCode');
    debugPrint('TTS URL: $ttsUrl');
    debugPrint('Text length: ${text.length}');
    debugPrint('======================');

    return ttsUrl;
  }

  /// Get language code for TTS API
  /// Google Translate TTS uses ISO 639-1 language codes
  /// Note: Some languages may need base codes without region
  String _getLanguageCodeForTts(String language) {
    final languageMap = {
      'English': 'en',
      'French': 'fr',
      'Spanish': 'es',
      'German': 'de',
      'Italian': 'it',
      'Portuguese': 'pt',
      'Russian': 'ru',
      'Japanese': 'ja',
      'Korean': 'ko',
      'Mandarin Chinese': 'zh', // Use base code for better compatibility
      'Arabic': 'ar',
      'Hindi': 'hi',
      'Bengali': 'bn',
      'Urdu': 'ur',
      'Swahili': 'sw',
    };

    final code = languageMap[language] ?? 'en';
    debugPrint('Language mapping: "$language" -> "$code"');

    if (code == 'en' && language != 'English') {
      debugPrint(
        'WARNING: Language "$language" not found in map, defaulting to English',
      );
    }

    return code;
  }

  Future<void> _stopPlaying() async {
    _playbackTimer?.cancel();
    await _audioPlayer.stop();
    setState(() {
      _currentlyPlaying = null;
      _isPlaying = false;
      _playbackProgress = 0.0;
    });
  }

  Future<void> _deleteProject(String projectId) async {
    try {
      await ref.read(projectsProvider.notifier).deleteProject(projectId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting project: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildNowPlayingBar(Project project) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9B59B6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First section - Project title and voice info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Playing ${project.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (project.voiceFilter != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Voice: ${project.voiceFilter!.displayName}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Second section - Progress bar and close button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: _playbackProgress.clamp(0.0, 1.0),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _stopPlaying,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
