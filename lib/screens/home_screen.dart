import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/theme_provider.dart';
import '../models/voice_filter.dart';
import 'my_projects_screen.dart';
import 'filter_ai_voices_screen.dart';
import 'upload_audio_screen.dart';

/// Home screen that appears after onboarding and authentication
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Upgrade to Pro Banner
                    _buildUpgradeBanner(),
                    const SizedBox(height: 24),
                    // Feature Cards
                    _buildFeatureCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.chat_bubble_outline,
                      title: 'Convert text to speech',
                      description: 'Convert your text into stunning speech.',
                      onTap: () {
                        _showTextToSpeechDialog(context);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.mic,
                      title: 'AI Voice Changer',
                      description:
                          'Change your voice to someone else\'s voice.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadAudioScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.translate,
                      title: 'AI Voice Translate',
                      description:
                          'Translate your voice into another language.',
                      onTap: () {
                        // TODO: Navigate to voice translate screen
                      },
                    ),
                    const SizedBox(height: 32),
                    // Explore AI Voices Section
                    _buildExploreVoicesSection(),
                    const SizedBox(height: 80), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          // Theme Toggle Switch
          GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            child: Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF9B59B6) : Colors.grey[400],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: isDarkMode ? 22 : 2,
                    top: 2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // App Title
          Expanded(
            child: Text(
              'Voicer',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Bell Icon
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF9B59B6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.workspace_premium,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Enjoy all benefits without any restrictions.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Profile pictures collage (simplified)
              SizedBox(
                width: 80,
                height: 32,
                child: Stack(
                  children: List.generate(
                    4,
                    (index) => Positioned(
                      left: index * 20.0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to upgrade screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7D3C98),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Upgrade',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Topographic pattern background (simplified)
          Positioned.fill(
            child: CustomPaint(painter: _TopographicPatternPainter()),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF9B59B6), size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF9B59B6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B59B6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreVoicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Explore AI Voices',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to all voices screen
              },
              child: Row(
                children: const [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF9B59B6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF9B59B6),
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildVoiceCard(
                name: 'Olivia (F)',
                age: 'Young',
                country: 'US',
                imageUrl: null, // Will use placeholder
              ),
              const SizedBox(width: 16),
              _buildVoiceCard(
                name: 'Mike (M)',
                age: 'Young',
                country: 'US',
                imageUrl: null, // Will use placeholder
              ),
              const SizedBox(width: 16),
              _buildVoiceCard(
                name: 'Sarah (F)',
                age: 'Middle-aged',
                country: 'UK',
                imageUrl: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCard({
    required String name,
    required String age,
    required String country,
    String? imageUrl,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Profile Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  shape: BoxShape.circle,
                ),
                child: imageUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 35)
                    : ClipOval(
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),
              ),
              // Heart Icon
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flag, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  age,
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  // TODO: Play voice preview
                },
              ),
              const SizedBox(width: 4),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Select voice
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B59B6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Select', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.mic, 'My Voices', 1),
              _buildNavItem(Icons.grid_view, 'My Projects', 2),
              _buildNavItem(Icons.person, 'Account', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        if (index == 2) {
          // Navigate to My Projects
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyProjectsScreen()),
          ).then((_) {
            // Reset to home when coming back
            setState(() {
              _currentIndex = 0;
            });
          });
        }
        // TODO: Navigate to other screens (My Voices, Account)
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF9B59B6) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showTextToSpeechDialog(BuildContext context) async {
    VoiceFilter? selectedFilter;

    // First, show the filter screen
    selectedFilter = await Navigator.push<VoiceFilter>(
      context,
      MaterialPageRoute(builder: (context) => const FilterAiVoicesScreen()),
    );

    // If user cancelled filter selection, return
    if (selectedFilter == null || !context.mounted) return;

    // Then show the project title dialog
    // Allow changing filter from within the dialog
    while (selectedFilter != null && context.mounted) {
      final result = await showModalBottomSheet<VoiceFilter>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Consumer(
          builder: (context, ref, child) =>
              _TextToSpeechDialog(ref: ref, voiceFilter: selectedFilter!),
        ),
      );

      if (result != null) {
        // User changed the filter, update and show dialog again
        selectedFilter = result;
      } else {
        // User cancelled or created project
        break;
      }
    }
  }
}

/// Text to Speech Dialog Widget
class _TextToSpeechDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final VoiceFilter voiceFilter;

  const _TextToSpeechDialog({required this.ref, required this.voiceFilter});

  @override
  ConsumerState<_TextToSpeechDialog> createState() =>
      _TextToSpeechDialogState();
}

class _TextToSpeechDialogState extends ConsumerState<_TextToSpeechDialog> {
  final projectTitleController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    projectTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Create Ai Text to Speech',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Selected Voice Filter Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.record_voice_over,
                  color: Color(0xFF9B59B6),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Voice',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.voiceFilter.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final newFilter = await Navigator.push<VoiceFilter>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterAiVoicesScreen(
                          initialFilter: widget.voiceFilter,
                        ),
                      ),
                    );
                    if (newFilter != null && mounted) {
                      // Update the filter and rebuild
                      Navigator.pop(context, newFilter);
                    }
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(color: Color(0xFF9B59B6), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Project Title Input
          const Text(
            'Project title',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: projectTitleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Promotion My Market',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
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
                borderSide: const BorderSide(
                  color: Color(0xFF9B59B6),
                  width: 2,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (projectTitleController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a project title'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            setState(() {
                              isLoading = true;
                            });

                            // Create the project with voice filter
                            await ref
                                .read(projectsProvider.notifier)
                                .createTextToSpeechProject(
                                  projectTitleController.text.trim(),
                                  widget.voiceFilter,
                                );

                            if (context.mounted) {
                              Navigator.pop(context);
                              // Navigate to My Projects screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyProjectsScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B59B6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for topographic pattern background
class _TopographicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A90E2).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw curved lines to simulate topographic pattern
    final path = Path();
    for (double y = 0; y < size.height; y += 20) {
      path.reset();
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += 10) {
        path.quadraticBezierTo(x + 5, y + (x % 20 == 0 ? 3 : -3), x + 10, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
