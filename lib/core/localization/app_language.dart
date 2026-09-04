import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppLanguage extends Equatable {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  Locale get locale => Locale(code);
  String get displayTitle => '$flag  $nativeName';
  String get displaySubtitle => name;
  String get fullSearchText => '$code $name $nativeName'.toLowerCase();

  @override
  List<Object?> get props => [code, name, nativeName, flag];
}

/// Curated registry of supported languages in DailyPouch
const List<AppLanguage> kSupportedLanguages = [
  AppLanguage(code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸'),
  AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
  AppLanguage(code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸'),
  AppLanguage(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
  AppLanguage(code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪'),
  AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
  AppLanguage(code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦'),
  AppLanguage(code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
  AppLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵'),
];

AppLanguage findLanguage(String code) {
  final clean = code.trim().toLowerCase();
  for (final l in kSupportedLanguages) {
    if (l.code == clean) {
      return l;
    }
  }
  return kSupportedLanguages.first; // Default English
}
