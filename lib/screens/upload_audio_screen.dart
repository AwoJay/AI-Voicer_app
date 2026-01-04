import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'voice_editor_screen.dart';

/// Upload Audio File Screen
/// Shown after creating an AI Voice Changer project
class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  File? _selectedFile;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final themeState = Theme.of(context);
    final isDarkMode = themeState.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header with back button
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Title Section
              Row(
                children: [
                  Text(
                    'Upload Audio File',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.volume_up, color: Colors.grey[400], size: 28),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your audio file to get started.',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              const SizedBox(height: 40),
              // Upload Area
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _pickAudioFile,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedFile != null
                              ? const Color(0xFF9B59B6)
                              : (isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!),
                          width: 2,
                        ),
                      ),
                      child: _selectedFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 64,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Support .mp3, .wav, .flac, .acc',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tap to select file',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[500]
                                        : Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.audiotrack,
                                  size: 64,
                                  color: const Color(0xFF9B59B6),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  _selectedFile!.path.split('/').last,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _pickAudioFile,
                                  child: const Text(
                                    'Change File',
                                    style: TextStyle(color: Color(0xFF9B59B6)),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7D3C98), Color(0xFF9B59B6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: _selectedFile != null && !_isUploading
                        ? _handleContinue
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.grey[600],
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
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
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Pick audio file from device
  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'flac', 'aac', 'm4a'],
        withData: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      // Handle MissingPluginException specifically
      String errorMessage = 'Error selecting file';
      if (e.toString().contains('MissingPluginException')) {
        errorMessage =
            'File picker plugin not initialized. Please restart the app completely (stop and restart, not hot reload).';
      } else {
        errorMessage = 'Error selecting file: ${e.toString()}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Handle continue button press
  Future<void> _handleContinue() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // TODO: Upload file to backend/process audio
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Navigate to voice editor screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceEditorScreen(
              projectTitle: 'Promotion My Market',
              audioFile: _selectedFile,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
