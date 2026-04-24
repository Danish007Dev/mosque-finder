import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/mosque.dart';

/// Action buttons for mosque detail (directions, share, favorite)
class ActionButtons extends StatelessWidget {
  final Mosque mosque;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ActionButtons({
    super.key,
    required this.mosque,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: () => _openDirections(context),
              icon: const Icon(Icons.directions),
              label: const Text('Directions'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onFavoriteToggle,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : null,
              ),
              label: Text(isFavorite ? 'Saved' : 'Save'),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.outlined(
            onPressed: () => _shareMosque(context),
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${mosque.latitude},${mosque.longitude}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  void _shareMosque(BuildContext context) {
    // In production, use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share: ${mosque.name} - ${mosque.address ?? "Mosque"}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
