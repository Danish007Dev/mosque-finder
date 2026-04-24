import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/mosque.dart';

/// State for the map view
class MapState {
  final Mosque? selectedMosque;
  final double zoomLevel;
  final bool isFollowingUser;

  const MapState({
    this.selectedMosque,
    this.zoomLevel = 12.0,
    this.isFollowingUser = true,
  });

  MapState copyWith({
    Mosque? selectedMosque,
    double? zoomLevel,
    bool? isFollowingUser,
    bool clearSelection = false,
  }) {
    return MapState(
      selectedMosque: clearSelection ? null : (selectedMosque ?? this.selectedMosque),
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    );
  }
}

/// Provider for map state management
class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(const MapState());

  /// Select a mosque marker on the map
  void selectMosque(Mosque mosque) {
    state = state.copyWith(
      selectedMosque: mosque,
      zoomLevel: 15.0,
    );
  }

  /// Clear the selected mosque
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }

  /// Update zoom level
  void setZoomLevel(double zoom) {
    state = state.copyWith(zoomLevel: zoom);
  }

  /// Toggle following user location
  void toggleFollowUser() {
    state = state.copyWith(isFollowingUser: !state.isFollowingUser);
  }
}

/// Provider for map state
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});
