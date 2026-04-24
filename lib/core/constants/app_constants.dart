/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Smart Mosque Finder';
  static const String appVersion = '1.0.0';
  static const String defaultLanguage = 'en';
  static const double defaultLatitude = 28.7041; // Default: Delhi
  static const double defaultLongitude = 77.1025;
  static const int defaultRadiusKm = 50;
  static const int paginationLimit = 5;
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration locationTimeout = Duration(seconds: 30);
  static const double searchDebounceMilliseconds = 500;
}
