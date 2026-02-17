import 'package:shared_preferences/shared_preferences.dart';

import '../../features/expenses/presentation/bloc/expense_bloc.dart';
import '../../features/expenses/presentation/bloc/expense_event.dart';

class CleanupManager {
  static const _lastCleanupKey = 'last_cleanup_date';

  static Future<void> checkAndPerformCleanup(ExpenseBloc bloc) async {
    final prefs = await SharedPreferences.getInstance();
    final lastCleanup = prefs.getString(_lastCleanupKey);

    final now = DateTime.now();
    final shouldCleanup =
        lastCleanup == null ||
        DateTime.parse(lastCleanup).difference(now).inDays.abs() >= 30;

    if (shouldCleanup) {
      bloc.add(const PurgeSoftDeletedEvent());
      await prefs.setString(_lastCleanupKey, now.toIso8601String());
    }
  }
}
