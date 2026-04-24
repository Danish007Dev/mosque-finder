import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/mosque.dart';
import '../../../mosque_detail/presentation/widgets/mosque_bottom_sheet.dart';
import '../providers/map_provider.dart';

/// Map widget showing mosque markers using Google Maps.
class MosqueMapWidget extends ConsumerWidget {
  final List<Mosque> mosques;

  const MosqueMapWidget({super.key, required this.mosques});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final markers = _buildMarkers(ref);

    final defaultLocation = CameraPosition(
      target: LatLng(
        AppConstants.defaultLatitude,
        AppConstants.defaultLongitude,
      ),
      zoom: mapState.zoomLevel,
    );

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: defaultLocation,
          markers: markers,
          myLocationEnabled: mapState.isFollowingUser,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          trafficEnabled: false,
          onTap: (_) => ref.read(mapProvider.notifier).clearSelection(),
          onCameraMove: (position) {
            ref.read(mapProvider.notifier).setZoomLevel(position.zoom);
          },
        ),

        // Bottom sheet for selected mosque
        if (mapState.selectedMosque != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MosqueBottomSheet(
              mosque: mapState.selectedMosque!,
              onClose: () => ref.read(mapProvider.notifier).clearSelection(),
            ),
          ),

        // Controls overlay
        Positioned(
          right: 16,
          top: 16,
          child: Column(
            children: [
              _MapControlButton(
                icon: Icons.my_location,
                onPressed: () {
                  ref.read(mapProvider.notifier).toggleFollowUser();
                },
                isActive: mapState.isFollowingUser,
              ),
              const SizedBox(height: 8),
              _MapControlButton(
                icon: Icons.add,
                onPressed: () {
                  ref.read(mapProvider.notifier).setZoomLevel(
                        mapState.zoomLevel + 1,
                      );
                },
              ),
              const SizedBox(height: 8),
              _MapControlButton(
                icon: Icons.remove,
                onPressed: () {
                  ref.read(mapProvider.notifier).setZoomLevel(
                        mapState.zoomLevel - 1,
                      );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers(WidgetRef ref) {
    return mosques.map((mosque) {
      final isSelected =
          ref.read(mapProvider).selectedMosque?.id == mosque.id;

      return Marker(
        markerId: MarkerId(mosque.id),
        position: LatLng(mosque.latitude, mosque.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected
              ? BitmapDescriptor.hueAzure
              : mosque.isVerified
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueOrange,
        ),
        infoWindow: InfoWindow(
          title: mosque.name,
          snippet: mosque.address ??
              '${mosque.rating.toStringAsFixed(1)} - ${mosque.reviewCount} reviews',
        ),
        onTap: () => ref.read(mapProvider.notifier).selectMosque(mosque),
      );
    }).toSet();
  }
}

/// Map control button
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: isActive ? Colors.white : AppColors.grey700,
          ),
          onPressed: onPressed,
          tooltip: '',
        ),
      ),
    );
  }
}

/// Grid painter for map placeholder
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey300
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
