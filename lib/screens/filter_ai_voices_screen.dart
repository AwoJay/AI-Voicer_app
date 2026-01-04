import 'package:flutter/material.dart';
import '../models/voice_filter.dart';

/// Filter AI Voices Screen
class FilterAiVoicesScreen extends StatefulWidget {
  final VoiceFilter? initialFilter;

  const FilterAiVoicesScreen({super.key, this.initialFilter});

  @override
  State<FilterAiVoicesScreen> createState() => _FilterAiVoicesScreenState();
}

class _FilterAiVoicesScreenState extends State<FilterAiVoicesScreen> {
  late String selectedLanguage;
  late Gender selectedGender;
  late AgeGroup selectedAgeGroup;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.initialFilter?.language ?? 'French';
    selectedGender = widget.initialFilter?.gender == 'Male'
        ? Gender.male
        : Gender.female;
    selectedAgeGroup = _parseAgeGroup(
      widget.initialFilter?.ageGroup ?? 'Young',
    );
  }

  AgeGroup _parseAgeGroup(String ageGroup) {
    switch (ageGroup.toLowerCase()) {
      case 'kid':
        return AgeGroup.kid;
      case 'young':
        return AgeGroup.young;
      case 'middle-aged':
      case 'middleaged':
        return AgeGroup.middleAged;
      case 'old':
        return AgeGroup.old;
      default:
        return AgeGroup.young;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Language Section
                    _buildLanguageSection(),
                    const SizedBox(height: 32),
                    // Gender Section
                    _buildGenderSection(),
                    const SizedBox(height: 32),
                    // Age Groups Section
                    _buildAgeGroupsSection(),
                    const SizedBox(height: 40),
                    // Apply Button
                    _buildApplyButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              'Filter AI Voices',
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
              // Reset filters
              setState(() {
                selectedLanguage = 'English';
                selectedGender = Gender.female;
                selectedAgeGroup = AgeGroup.young;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Language',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              availableLanguages.map((lang) {
                final isSelected = selectedLanguage == lang.name;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguage = lang.name;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9B59B6)
                          : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF9B59B6)
                            : Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          lang.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()..add(
                GestureDetector(
                  onTap: () {
                    // TODO: Show more languages
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[800]!, width: 1),
                    ),
                    child: const Text(
                      'More +',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = Gender.male;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: selectedGender == Gender.male
                        ? const Color(0xFF9B59B6)
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedGender == Gender.male
                          ? const Color(0xFF9B59B6)
                          : Colors.grey[800]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('👨', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      const Text(
                        'Male',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = Gender.female;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: selectedGender == Gender.female
                        ? const Color(0xFF9B59B6)
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedGender == Gender.female
                          ? const Color(0xFF9B59B6)
                          : Colors.grey[800]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('👩', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      const Text(
                        'Female',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age Groups',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildAgeGroupChip('All Age Groups', AgeGroup.all),
            _buildAgeGroupChip('Kid', AgeGroup.kid),
            _buildAgeGroupChip('Young', AgeGroup.young),
            _buildAgeGroupChip('Middle-Aged', AgeGroup.middleAged),
            _buildAgeGroupChip('Old', AgeGroup.old),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeGroupChip(String label, AgeGroup ageGroup) {
    final isSelected = selectedAgeGroup == ageGroup;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAgeGroup = ageGroup;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9B59B6) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF9B59B6) : Colors.grey[800]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final filter = VoiceFilter(
            language: selectedLanguage,
            gender: selectedGender == Gender.male ? 'Male' : 'Female',
            ageGroup: _getAgeGroupString(selectedAgeGroup),
          );
          Navigator.pop(context, filter);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9B59B6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Apply Filter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getAgeGroupString(AgeGroup ageGroup) {
    switch (ageGroup) {
      case AgeGroup.all:
        return 'All';
      case AgeGroup.kid:
        return 'Kid';
      case AgeGroup.young:
        return 'Young';
      case AgeGroup.middleAged:
        return 'Middle-Aged';
      case AgeGroup.old:
        return 'Old';
    }
  }
}
