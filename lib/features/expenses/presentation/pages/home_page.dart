// lib/features/expenses/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/format_date.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../widgets/home_page_widget/home_app_bar.dart';
import '../widgets/home_page_widget/home_content.dart';
import '../widgets/home_page_widget/home_fab_widget.dart';
import '../widgets/home_page_widget/home_month_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  DateTime _selectedMonth = DateTime.now();
  final int _initialPage = 1000;

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
      LoadExpensesByPeriodEvent(from: firstDay, to: lastDay),
    );
  }

  void _onPageChanged(int page) {
    final monthOffset = page - _initialPage;
    final newMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + monthOffset,
    );

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    if (newMonth.isAfter(currentMonth)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(_initialPage);
      });
      return;
    }

    setState(() => _selectedMonth = newMonth);
    _loadExpensesForMonth(newMonth);
  }

  void _showMonthPicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) =>
          Theme(data: Theme.of(context), child: child!),
    );

    if (picked != null) {
      final monthOffset =
          (picked.year - DateTime.now().year) * 12 +
          (picked.month - DateTime.now().month);

      setState(() => _selectedMonth = picked);
      _pageController.jumpToPage(_initialPage + monthOffset);
      _loadExpensesForMonth(picked);
    }
  }

  void _goToCurrentMonth() {
    _pageController.animateToPage(
      _initialPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _refreshPage() {
    context.read<ExpenseBloc>().add(
      LoadExpensesByPeriodEvent(from: firstDay, to: lastDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: HomeFab(
        onTap: () async {
          final success = await context.push('/add-expense');
          if (success == true && mounted) {
            _refreshPage();
          }
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            HomeMonthNavigator(
              selectedMonth: _selectedMonth,
              onMonthPickerTap: _showMonthPicker,
              onPreviousMonth: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              onNextMonth: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              onTodayTap: _goToCurrentMonth,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => const HomeContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
