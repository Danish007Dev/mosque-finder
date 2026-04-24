import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check network connectivity
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo() : _connectivity = Connectivity();

  /// Returns true if device is connected to the internet
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectedResult(result);
  }

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnectedResult);
  }

  bool _isConnectedResult(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }
}
