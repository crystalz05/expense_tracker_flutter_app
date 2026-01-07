import 'package:expenses_tracker_app/core/utils/currency_formatter.dart';
import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/core/utils/format_date.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../widgets/budget_detail_widgets/analyics_section.dart';
import '../widgets/budget_detail_widgets/main_budget_card.dart';
import '../widgets/budget_detail_widgets/transaction_section.dart';

class BudgetDetailPage extends StatefulWidget {
  final String budgetId;

  const BudgetDetailPage({super.key, required this.budgetId});

  @override
  State<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage> {

  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(LoadBudgetProgress(widget.budgetId));
  }

  bool _popListenerAdded = false;

  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_popListenerAdded) return;

    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      _onPopToBudgetPage();
      return true;
    });

    _popListenerAdded = true;
  }

  void _onPopToBudgetPage(){
    // context.read<ExpenseBloc>().add(const LoadExpensesEvent());
    context.read<BudgetBloc>().add(LoadAllBudgetProgress());
    context.read<ExpenseBloc>().add(LoadExpensesByPeriodEvent(from: firstDay, to: lastDay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is BudgetOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(state.message),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop();
          }
          if (state is BudgetProgressLoaded) {
            final budget = state.progress.budget;
            context.read<ExpenseBloc>().add(
              LoadExpensesEvent(
                category: budget.category,
                from: budget.startDate,
                to: budget.endDate,
              ),
            );
          }
        },
        builder: (context, budgetState) {
          if (budgetState is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (budgetState is BudgetProgressLoaded) {
            final progress = budgetState.progress;
            final budget = progress.budget;

            return BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, expenseState) {
                final expenses = expenseState is ExpensesLoaded
                    ? expenseState.expenses
                    : <Expense>[];

                return _buildContent(context, budget, progress, expenses);
              },
            );
          }

          if (budgetState is BudgetError) {
            return _buildErrorState(context, budgetState.message);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      Budget budget,
      dynamic progress,
      List<Expense> expenses,
      ) {
    final categoryData = ExpenseCategories.fromName(budget.category);

    return CustomScrollView(
      slivers: [
        // Modern App Bar
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: Color(0xFF0A2E5D),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              _onPopToBudgetPage();
              context.pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                context.push('/edit-budget-page', extra: budget);
              }
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _showDeleteDialog(context, budget),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A2E5D),
                    Color(0xFF0A2E5D).withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      categoryData.icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    budget.category,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Budget Card
                MainBudgetCard(
                  budget: budget,
                  progress: progress,
                  categoryData: categoryData,
                ),

                const SizedBox(height: 24),

                // Analytics Section
                AnalyticsSection(
                  budget: budget,
                  expenses: expenses,
                  spent: progress.spent,
                ),

                const SizedBox(height: 24),

                // Transactions Section
                TransactionsSection(expenses: expenses),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text('Failed to load budget', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              context.read<BudgetBloc>().add(LoadBudgetProgress(widget.budgetId));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Budget budget) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Budget'),
        content: Text('Are you sure you want to delete "${budget.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BudgetBloc>().add(DeleteBudgetEvent(budget.id));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}