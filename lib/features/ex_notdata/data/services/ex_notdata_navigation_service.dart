import 'dart:async';
import 'dart:developer';

// Navigation callback type
typedef NavigationCallback = void Function(String route, Map<String, dynamic>? arguments);

class ExNotDataNavigationService {
  NavigationCallback? _navigationCallback;
  Timer? _navigationDebounceTimer;
  String? _lastProcessedVn;
  DateTime? _lastNavigationTime;
  static const Duration _navigationDebounceTime = Duration(seconds: 2);

  void setNavigationCallback(NavigationCallback callback) {
    _navigationCallback = callback;
    log('Navigation callback set successfully');
  }

  bool get hasNavigationCallback => _navigationCallback != null;

  void debounceNavigation(String vn) {
    // Check if navigation callback is set
    if (!hasNavigationCallback) {
      log('Navigation callback not set, cannot navigate to homepage');
      return;
    }

    _navigationDebounceTimer?.cancel();

    if (_lastProcessedVn == vn && _lastNavigationTime != null) {
      final timeSinceLastNavigation = DateTime.now().difference(_lastNavigationTime!);
      if (timeSinceLastNavigation < _navigationDebounceTime) {
        log('Navigation debounced for VN: $vn (last navigation was ${timeSinceLastNavigation.inMilliseconds}ms ago)');
        return;
      }
    }

    log('Scheduling navigation for VN: $vn in ${_navigationDebounceTime.inSeconds} seconds');

    // Set new navigation timer
    _navigationDebounceTimer = Timer(_navigationDebounceTime, () {
      _lastProcessedVn = vn;
      _lastNavigationTime = DateTime.now();
      _performNavigation(vn);
    });
  }

  void _performNavigation(String vn) {
    if (hasNavigationCallback) {
      try {
        _navigationCallback!('/home', {'vn': vn});
        log('Navigation triggered to homepage with VN: $vn');
      } catch (e) {
        log('Error during navigation: $e');
      }
    } else {
      log('Navigation callback not set, cannot navigate to homepage');
    }
  }

  void clearNavigationCallback() {
    _navigationCallback = null;
    log('Navigation callback cleared');
  }

  void dispose() {
    _navigationDebounceTimer?.cancel();
    clearNavigationCallback();
  }
}
