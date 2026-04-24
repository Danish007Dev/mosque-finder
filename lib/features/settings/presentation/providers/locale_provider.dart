import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_provider.dart';

/// Provider for current locale based on settings
final localeProvider = Provider<Locale>((ref) {
  final languageCode = ref.watch(settingsProvider).languageCode;
  return Locale(languageCode);
});

/// Provider for available locales
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale('en'), // English
    Locale('hi'), // Hindi
    Locale('ur'), // Urdu
  ];
});
