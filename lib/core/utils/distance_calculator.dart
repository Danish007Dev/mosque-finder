import 'dart:math';

/// Utility for calculating geographic distances using the Haversine formula
class DistanceCalculator {
  DistanceCalculator._();

  static const double _earthRadiusKm = 6371.0;

  /// Calculate distance between two coordinates in kilometers
  /// Uses the Haversine formula for accuracy
  static double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final dLat = _degToRad(lat2 - lat1);
    final dLng = _degToRad(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  /// Calculate distance in miles
  static double calculateDistanceInMiles({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return calculateDistance(
          lat1: lat1,
          lng1: lng1,
          lat2: lat2,
          lng2: lng2,
        ) *
        0.621371;
  }

  /// Format distance for display
  /// Returns "X.X km" or "X.X mi"
  static String formatDistance(double distanceKm, {bool useMiles = false}) {
    final distance = useMiles ? distanceKm * 0.621371 : distanceKm;

    if (distance < 0.1) {
      return '${(distance * 1000).toStringAsFixed(0)} ${useMiles ? 'ft' : 'm'}';
    } else if (distance < 10) {
      return '${distance.toStringAsFixed(1)} ${useMiles ? 'mi' : 'km'}';
    } else {
      return '${distance.toStringAsFixed(0)} ${useMiles ? 'mi' : 'km'}';
    }
  }

  /// Convert degrees to radians
  static double _degToRad(double deg) => deg * (pi / 180.0);
}
