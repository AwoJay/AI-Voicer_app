import 'package:flutter/material.dart';
import 'dart:io';

/// Voice Editor Screen
/// Screen for editing text-to-speech projects with voice controls
class VoiceEditorScreen extends StatefulWidget {
  final String projectTitle;
  final File? audioFile; // Optional audio file if coming from upload

  const VoiceEditorScreen({
    super.key,
    required this.projectTitle,
    this.audioFile,
  });

  @override
  State<VoiceEditorScreen> createState() => _VoiceEditorScreenState();
}

class _VoiceEditorScreenState extends State<VoiceEditorScreen> {
  String _selectedVoice = 'Nathali (F)';
  double _pitch = 0.0;
  double _speed = 0.5;
  final List<ScriptSegment> _scriptSegments = [];
  final TextEditingController _newTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with default script if no audio file
    if (widget.audioFile == null) {
      _scriptSegments.add(
        ScriptSegment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text:
              'Promotion can include elements such as advertising, public relations, sales promotions, personal selling, and direct marketing. The goal of promotional efforts is to create a positive perception of the product or brand, generate interest, and ultimately drive customer engagement and sales.',
        ),
      );
    }
  }

  @override
  void dispose() {
    _newTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Theme.of(context);
    final isDarkMode = themeState.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isDarkMode),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Voice Selection
                    _buildVoiceSelector(isDarkMode),
                    const SizedBox(height: 16),
                    // Voice Controls
                    _buildVoiceControls(isDarkMode),
                    const SizedBox(height: 24),
                    // Script Section
                    _buildScriptSection(isDarkMode),
                    const SizedBox(height: 24),
                    // New Text Input
                    _buildNewTextInput(isDarkMode),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Export Button
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.projectTitle,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // TODO: Show menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSelector(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // TODO: Show voice selection dialog
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Profile Picture
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF9B59B6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedVoice,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceControls(bool isDarkMode) {
    return Column(
      children: [
        // First Row: Pitch buttons
        Row(
          children: [
            Expanded(
              child: _buildControlButton(
                isDarkMode,
                'Pitch ${(_pitch * 100).toInt()}%',
                Icons.tune,
                () {
                  // TODO: Show pitch adjustment
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                isDarkMode,
                'Pitch ${(_pitch * 100).toInt()}%',
                Icons.tune,
                () {
                  // TODO: Show pitch adjustment
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second Row: Add Pause and Pronunciation
        Row(
          children: [
            Expanded(
              child: _buildControlButton(
                isDarkMode,
                'Add Pause',
                Icons.pause_circle_outline,
                () {
                  // TODO: Add pause
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                isDarkMode,
                'Pronunciation',
                Icons.volume_up,
                () {
                  // TODO: Show pronunciation settings
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Speed Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Speed',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _speed,
              onChanged: (value) {
                setState(() {
                  _speed = value;
                });
              },
              activeColor: const Color(0xFF9B59B6),
              inactiveColor: Colors.grey[700],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(
    bool isDarkMode,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF9B59B6),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScriptSection(bool isDarkMode) {
    final totalDuration = _scriptSegments.length * 5; // Simulated duration

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Script',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  '$totalDuration s',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.play_circle_outline,
                    color: Color(0xFF9B59B6),
                  ),
                  onPressed: () {
                    // TODO: Play all script
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Script Segments
        ..._scriptSegments.map((segment) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildScriptSegment(segment, isDarkMode),
            )),
      ],
    );
  }

  Widget _buildScriptSegment(ScriptSegment segment, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 20,
                ),
                onPressed: () {
                  // TODO: Show segment settings
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.drag_handle,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      // TODO: Reorder segments
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: Color(0xFF9B59B6),
                      size: 24,
                    ),
                    onPressed: () {
                      // TODO: Play segment
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            segment.text,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewTextInput(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.grid_view,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _newTextController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your text here ...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                ),
                border: InputBorder.none,
              ),
              maxLines: 3,
              onSubmitted: (_) => _addNewTextSegment(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: const Color(0xFF9B59B6),
              size: 28,
            ),
            onPressed: _addNewTextSegment,
            tooltip: 'Add to script',
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            onPressed: () {
              // TODO: Show text input settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7D3C98),
                  Color(0xFF9B59B6),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Export audio
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exporting audio...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Export',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addNewTextSegment() {
    if (_newTextController.text.trim().isNotEmpty) {
      setState(() {
        _scriptSegments.add(
          ScriptSegment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: _newTextController.text.trim(),
          ),
        );
        _newTextController.clear();
      });
    }
  }
}

/// Script Segment Model
class ScriptSegment {
  final String id;
  final String text;

  ScriptSegment({
    required this.id,
    required this.text,
  });
}

