import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

/// Language selector widget (integrated into settings page)
/// This file exists for potential reuse in other parts of the app
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return DropdownButton<String>(
      value: settings.languageCode,
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'hi', child: Text('हिन्दी (Hindi)')),
        DropdownMenuItem(value: 'ur', child: Text('اردو (Urdu)')),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(settingsProvider.notifier).setLanguage(value);
        }
      },
    );
  }
}
