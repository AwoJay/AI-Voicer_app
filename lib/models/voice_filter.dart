/// Voice filter model
class VoiceFilter {
  final String language;
  final String gender;
  final String ageGroup;

  const VoiceFilter({
    required this.language,
    required this.gender,
    required this.ageGroup,
  });

  VoiceFilter copyWith({String? language, String? gender, String? ageGroup}) {
    return VoiceFilter(
      language: language ?? this.language,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
    );
  }

  String get displayName {
    return '$language - $gender - $ageGroup';
  }
}

/// Language options
class LanguageOption {
  final String name;
  final String flag;

  const LanguageOption({required this.name, required this.flag});
}

final List<LanguageOption> availableLanguages = const [
  LanguageOption(name: 'English', flag: '🇺🇸'),
  LanguageOption(name: 'French', flag: '🇫🇷'),
  LanguageOption(name: 'Mandarin Chinese', flag: '🇨🇳'),
  LanguageOption(name: 'Portuguese', flag: '🇵🇹'),
  LanguageOption(name: 'Urdu', flag: '🇵🇰'),
  LanguageOption(name: 'Spanish', flag: '🇪🇸'),
  LanguageOption(name: 'Arabic', flag: '🇸🇦'),
  LanguageOption(name: 'Hindi', flag: '🇮🇳'),
  LanguageOption(name: 'Korean', flag: '🇰🇷'),
  LanguageOption(name: 'Bengali', flag: '🇧🇩'),
  LanguageOption(name: 'Russian', flag: '🇷🇺'),
  LanguageOption(name: 'Japanese', flag: '🇯🇵'),
  LanguageOption(name: 'Swahili', flag: '🇰🇪'),
  LanguageOption(name: 'German', flag: '🇩🇪'),
];

/// Gender options
enum Gender { male, female }

/// Age group options
enum AgeGroup { all, kid, young, middleAged, old }
