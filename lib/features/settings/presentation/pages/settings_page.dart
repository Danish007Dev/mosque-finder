import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

/// Settings page for app configuration
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Appearance section
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeSelector(context, ref, settings),
          const Divider(),

          // Language section
          _buildSectionHeader(context, 'Language'),
          _buildLanguageSelector(context, ref, settings),
          const Divider(),

          // Preferences section
          _buildSectionHeader(context, 'Preferences'),
          SwitchListTile(
            title: const Text('Use Metric System'),
            subtitle: const Text('Show distances in km/m'),
            value: settings.useMetricSystem,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleMeasurementSystem();
            },
            secondary: const Icon(Icons.straighten),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Get prayer time reminders'),
            value: settings.notificationsEnabled,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleNotifications();
            },
            secondary: const Icon(Icons.notifications_outlined),
          ),
          const Divider(),

          // Account section
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Login / Sign Up'),
            subtitle: const Text('Sync your favorites across devices'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to login page (future implementation)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login feature coming soon')),
              );
            },
          ),
          const Divider(),

          // About section
          _buildSectionHeader(context, 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Developer'),
            trailing: Text('Smart Mosque Team'),
          ),
          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              'Smart Mosque Finder',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  Widget _buildThemeSelector(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<ThemeModeOption>(
        segments: const [
          ButtonSegment(
            value: ThemeModeOption.light,
            icon: Icon(Icons.light_mode),
            label: Text('Light'),
          ),
          ButtonSegment(
            value: ThemeModeOption.dark,
            icon: Icon(Icons.dark_mode),
            label: Text('Dark'),
          ),
          ButtonSegment(
            value: ThemeModeOption.system,
            icon: Icon(Icons.settings_brightness),
            label: Text('System'),
          ),
        ],
        selected: {settings.themeMode},
        onSelectionChanged: (selected) {
          ref.read(settingsProvider.notifier).setThemeMode(selected.first);
        },
      ),
    );
  }

  Widget _buildLanguageSelector(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _LanguageOption(
            languageCode: 'en',
            label: 'English',
            isSelected: settings.languageCode == 'en',
            onSelected: () {
              ref.read(settingsProvider.notifier).setLanguage('en');
            },
          ),
          const SizedBox(height: 4),
          _LanguageOption(
            languageCode: 'hi',
            label: 'हिन्दी (Hindi)',
            isSelected: settings.languageCode == 'hi',
            onSelected: () {
              ref.read(settingsProvider.notifier).setLanguage('hi');
            },
          ),
          const SizedBox(height: 4),
          _LanguageOption(
            languageCode: 'ur',
            label: 'اردو (Urdu)',
            isSelected: settings.languageCode == 'ur',
            onSelected: () {
              ref.read(settingsProvider.notifier).setLanguage('ur');
            },
          ),
        ],
      ),
    );
  }
}

/// Language option tile
class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _LanguageOption({
    required this.languageCode,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : null,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
