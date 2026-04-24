import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/auth_local_datasource.dart';

/// Theme mode enum
enum ThemeModeOption {
  light,
  dark,
  system,
}

/// State for settings
class SettingsState {
  final ThemeModeOption themeMode;
  final String languageCode;
  final bool useMetricSystem;
  final bool notificationsEnabled;

  const SettingsState({
    this.themeMode = ThemeModeOption.system,
    this.languageCode = 'en',
    this.useMetricSystem = true,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    ThemeModeOption? themeMode,
    String? languageCode,
    bool? useMetricSystem,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      useMetricSystem: useMetricSystem ?? this.useMetricSystem,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

/// Provider for settings management
class SettingsNotifier extends StateNotifier<SettingsState> {
  final AuthLocalDataSource _localDataSource;

  SettingsNotifier(this._localDataSource) : super(const SettingsState()) {
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final language = await _localDataSource.getLanguagePreference();
    final isDark = await _localDataSource.getThemePreference();

    state = state.copyWith(
      languageCode: language,
      themeMode: isDark ? ThemeModeOption.dark : ThemeModeOption.light,
    );
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeModeOption mode) async {
    state = state.copyWith(themeMode: mode);
    await _localDataSource.saveThemePreference(mode == ThemeModeOption.dark);
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _localDataSource.saveLanguagePreference(languageCode);
  }

  /// Toggle metric/imperial system
  void toggleMeasurementSystem() {
    state = state.copyWith(useMetricSystem: !state.useMetricSystem);
  }

  /// Toggle notifications
  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }
}

/// Provider for settings
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(AuthLocalDataSource());
});
