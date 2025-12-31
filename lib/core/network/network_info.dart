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

    final offlineModeEnabled = prefs.getBool(_offlineModeKey) ?? false;

    // If offline mode is enabled, always return false
    if (offlineModeEnabled) {
      return false;
    }

    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}