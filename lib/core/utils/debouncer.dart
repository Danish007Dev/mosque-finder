import 'dart:async';

/// Utility class to debounce rapid method calls
/// Useful for search input handling and scroll events
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Run a callback after the debounce delay
  /// If called again before the delay, the previous call is cancelled
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending debounced call
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Dispose the debouncer
  void dispose() {
    cancel();
  }
}
