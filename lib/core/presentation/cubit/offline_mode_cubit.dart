import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineModeCubit extends Cubit<bool> {
  final SharedPreferences prefs;
  static const String _offlineModeKey = 'offline_mode_enabled';

  OfflineModeCubit(this.prefs) : super(false) {
    _loadOfflineMode();
  }

  void _loadOfflineMode() {
    final isOffline = prefs.getBool(_offlineModeKey) ?? false;
    emit(isOffline);
  }

  Future<void> setOfflineMode(bool enabled) async {
    await prefs.setBool(_offlineModeKey, enabled);
    emit(enabled);
  }

  Future<void> toggleOfflineMode() async {
    await setOfflineMode(!state);
  }
}