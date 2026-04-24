import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/mosque.dart';

/// Section displaying detailed mosque information
class MosqueInfoSection extends StatelessWidget {
  final Mosque mosque;

  const MosqueInfoSection({super.key, required this.mosque});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (mosque.description != null) ...[
            _buildSectionTitle(context, 'About'),
            const SizedBox(height: 8),
            Text(
              mosque.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20),
          ],

          // Contact Info
          if (mosque.phone != null || mosque.website != null) ...[
            _buildSectionTitle(context, 'Contact'),
            const SizedBox(height: 8),
            if (mosque.phone != null) _buildInfoRow(Icons.phone, mosque.phone!),
            if (mosque.website != null)
              _buildInfoRow(Icons.language, mosque.website!),
            const SizedBox(height: 20),
          ],

          // Address
          if (mosque.address != null ||
              mosque.city != null &&
                  mosque.state != null) ...[
            _buildSectionTitle(context, 'Address'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, _buildFullAddress()),
            const SizedBox(height: 20),
          ],

          // Opening Hours
          if (mosque.openingHours != null) ...[
            _buildSectionTitle(context, 'Hours'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, mosque.openingHours!),
            const SizedBox(height: 20),
          ],

          // Amenities
          if (mosque.amenities.isNotEmpty) ...[
            _buildSectionTitle(context, 'Amenities'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: mosque.amenities.map((amenity) {
                return Chip(
                  avatar: Icon(
                    _getAmenityIcon(amenity),
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(_formatAmenityName(amenity)),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Prayer Times Tags
          if (mosque.prayerTimeTags.isNotEmpty) ...[
            _buildSectionTitle(context, 'Prayer Services'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: mosque.prayerTimeTags.map((tag) {
                return Chip(
                  label: Text(_formatAmenityName(tag)),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                );
              }).toList(),
            ),
          ],

          // Community Trust Score
          if (mosque.isCommunityTrusted) ...[
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Community Trust'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.groups, color: AppColors.communityTrustedBadge),
                const SizedBox(width: 8),
                Text('Trust Score: ${mosque.communityTrustScore}/100'),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: mosque.communityTrustScore / 100,
                      backgroundColor: AppColors.grey200,
                      color: AppColors.communityTrustedBadge,
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.grey600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  String _buildFullAddress() {
    final parts = <String>[];
    if (mosque.address != null) parts.add(mosque.address!);
    if (mosque.city != null) parts.add(mosque.city!);
    if (mosque.state != null) parts.add(mosque.state!);
    if (mosque.country != null) parts.add(mosque.country!);
    return parts.join(', ');
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity) {
      case 'wudu_area':
        return Icons.water_drop;
      case 'parking':
        return Icons.local_parking;
      case 'women_section':
        return Icons.woman;
      case 'library':
        return Icons.local_library;
      case 'air_conditioned':
        return Icons.ac_unit;
      case 'cafe':
        return Icons.local_cafe;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _formatAmenityName(String name) {
    return name
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}
