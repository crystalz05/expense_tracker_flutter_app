// ==================== HOME PAGE WITH MONTH NAVIGATION ====================
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/core/presentation/cubit/budget_cubit.dart';
import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../widgets/modern_balance_card.dart';
import '../widgets/modern_category_grid.dart';
import '../widgets/modern_quick_stats.dart';
import '../widgets/modern_transaction_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  DateTime _selectedMonth = DateTime.now();
  final int _initialPage = 1000; // Start in middle to allow backward navigation

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _loadExpensesForMonth(_selectedMonth);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadExpensesForMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    context.read<ExpenseBloc>().add(
      LoadExpensesEvent(from: firstDay, to: lastDay),
    );
  }

  void _onPageChanged(int page) {
    final monthOffset = page - _initialPage;
    final newMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + monthOffset,
    );

    setState(() {
      _selectedMonth = newMonth;
    });

    _loadExpensesForMonth(newMonth);
  }

  void _showMonthPicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final monthOffset = (picked.year - DateTime.now().year) * 12 +
          (picked.month - DateTime.now().month);

      setState(() {
        _selectedMonth = picked;
      });

      _pageController.jumpToPage(_initialPage + monthOffset);
      _loadExpensesForMonth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topCategories = [
      {'title': 'Bills & Utilities'},
      {'title': 'Shopping'},
      {'title': 'Food & Dining'},
      {'title': 'Transport'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildMonthNavigator(context),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _buildMonthContent(context, topCategories);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigator(BuildContext context) {
    final isCurrentMonth = _selectedMonth.year == DateTime.now().year &&
        _selectedMonth.month == DateTime.now().month;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(CupertinoIcons.chevron_left),
            iconSize: 20,
          ),
          InkWell(
            onTap: _showMonthPicker,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('MMM yyyy').format(_selectedMonth),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    CupertinoIcons.calendar,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              if (!isCurrentMonth)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        _pageController.animateToPage(
                          //move to current month
                          1000,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              IconButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(CupertinoIcons.chevron_right),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthContent(BuildContext context, List<Map<String, dynamic>> topCategories) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return _buildLoadingState(context);
        } else if (state is ExpensesLoaded) {
          final sortedExpenses = List.of(state.expenses)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          return SingleChildScrollView(
            child: Column(
              children: [
                // Balance Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: ModernBalanceCard(totalSpent: state.totalSpent),
                ),

                // Quick Stats
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: ModernQuickStats(
                    totalSpent: state.totalSpent,
                    transactionCount: state.expenses.length,
                  ),
                ),

                // Categories Section
                _buildSection(
                  context,
                  title: "Spending by Category",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ModernCategoryGrid(
                      categories: topCategories,
                      categoryTotals: state.categoryTotals,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Transactions Section
                _buildSection(
                  context,
                  title: "Recent Activity",
                  child: ModernTransactionList(transactions: sortedExpenses),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Text(
                        "Hi, ${state.user.displayName?.split(' ')[0]}",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's manage your finances",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildAppBarIcon(context, CupertinoIcons.chart_bar_circle_fill, () {
                context.push("/budget-page");
              }),
              const SizedBox(width: 12),
              _buildAppBarIcon(context, CupertinoIcons.bell_fill, () {}),
              const SizedBox(width: 16),
              _buildProfileAvatar(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(CupertinoIcons.person_fill, size: 24, color: Theme.of(context).colorScheme.primary,),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading expenses...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}