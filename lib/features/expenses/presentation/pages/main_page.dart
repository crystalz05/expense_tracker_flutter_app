import 'dart:async';

import 'package:expenses_tracker_app/features/analytics/presentation/pages/analytics_page.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/expenses_history_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/settings_page.dart';
import 'package:expenses_tracker_app/features/monthly_budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:expenses_tracker_app/features/monthly_budget/presentation/bloc/monthly_budget_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/format_date.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int currentIndex = 0;
  late final List<Widget> pages;
  Timer? _syncTimer;
  Timer? _cleanupCheckTimer;

  void _goHome() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize pages
    pages = [
      const HomePage(),
      AnalyticsPage(),
      const ExpensesHistoryPage(),
      const SettingsPage(),
    ];

    // Initialize app with sync and cleanup
    _initializeApp();

    // Periodic sync every 15 minutes
    _syncTimer = Timer.periodic(
      const Duration(minutes: 15),
          (_) {
        if (mounted) {
          _performBackgroundSync();
        }
      },
    );

    // Check for cleanup daily
    _cleanupCheckTimer = Timer.periodic(
      const Duration(hours: 24),
          (_) {
        if (mounted) {
          _checkAndPerformCleanup();
        }
      },
    );
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _cleanupCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final expenseBloc = context.read<ExpenseBloc>();
    final budgetBloc = context.read<BudgetBloc>();

    // Background sync without blocking UI
    expenseBloc.add(const SyncExpensesEvent(showLoading: false));
    budgetBloc.add(const SyncBudgetsEvent());

    // Load local data immediately for fast UI
    // expenseBloc.add(LoadExpensesEvent());
    context.read<ExpenseBloc>().add(LoadExpensesByPeriodEvent(from: firstDay, to: lastDay));
    budgetBloc.add(const LoadBudgetsEvent());

    // Check if cleanup is needed (runs once on app start)
    await _checkAndPerformCleanup();
  }

  void _performBackgroundSync() {
    context.read<ExpenseBloc>().add(
      const SyncExpensesEvent(showLoading: false),
    );
    context.read<BudgetBloc>().add(const SyncBudgetsEvent());
    context.read<MonthlyBudgetBloc>().add(SyncMonthlyBudgetsEvent());
  }

  Future<void> _checkAndPerformCleanup() async {
    final prefs = await SharedPreferences.getInstance();
    const lastCleanupKey = 'last_cleanup_date';
    final lastCleanup = prefs.getString(lastCleanupKey);

    final now = DateTime.now();
    bool shouldCleanup = false;

    if (lastCleanup == null) {
      // First time - cleanup after 30 days
      shouldCleanup = false;
    } else {
      final lastCleanupDate = DateTime.parse(lastCleanup);
      final daysSinceCleanup = now.difference(lastCleanupDate).inDays;
      shouldCleanup = daysSinceCleanup >= 30;
    }

    if (shouldCleanup && mounted) {
      // Perform cleanup silently in background
      context.read<ExpenseBloc>().add(const PurgeSoftDeletedEvent());
      await prefs.setString(lastCleanupKey, now.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {

    DateTime? _lastBackPressed;

    return PopScope(
      canPop: false, // we control popping manually
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        final now = DateTime.now();

        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          SystemNavigator.pop(); // second press → pop
        }
      },
      child: Scaffold(
        body: SafeArea(child: pages[currentIndex]),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.surface,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                );
              }
              return TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              );
            }),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
            ),
            child: NavigationBar(
              indicatorColor: Colors.transparent,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.chart_pie,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  selectedIcon: Icon(
                    CupertinoIcons.chart_pie_fill,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Analytics",
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.history_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  selectedIcon: Icon(
                    Icons.history,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "History",
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  selectedIcon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}