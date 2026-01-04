import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final SharedPreferences prefs;
  static const String _offlineModeKey = 'offline_mode_enabled';

  NetworkInfoImpl(this.connectivity, this.prefs);

  @override
  Future<bool> get isConnected async {
    // Check if offline mode is enabled
    final offlineModeEnabled = prefs.getBool(_offlineModeKey) ?? false;

    // If offline mode is enabled, always return false
    if (offlineModeEnabled) {
      return false;
    }

    // Check connectivity - now returns List<ConnectivityResult>
    final results = await connectivity.checkConnectivity();

    // Check if any of the results indicate connectivity
    // (could be mobile, wifi, ethernet, etc.)
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}