import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_card_expanded_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_transaction_history_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/delete_budget_dialog.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/budget.dart';

class BudgetDetailPage extends StatefulWidget {
  final String budgetId;

  const BudgetDetailPage({
    super.key,
    required this.budgetId,
  });

  @override
  State<StatefulWidget> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load budget progress from BudgetBloc
    context.read<BudgetBloc>().add(LoadBudgetProgress(widget.budgetId));
  }

  void _deleteBudget(Budget budget) {
    context.read<BudgetBloc>().add(DeleteBudgetEvent(budget.id));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          // Reload all budgets and clear expense filters
          context.read<ExpenseBloc>().add(const LoadExpensesEvent());
          context.read<BudgetBloc>().add(LoadAllBudgetProgress());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Budget Details"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            // Handle successful deletion
            if (state is BudgetOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Budget deleted successfully')),
                );
                context.pop();
            }

            // When budget progress loads, fetch expenses for that period
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
              final categoryData = ExpenseCategories.fromName(budget.category);

              return BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, expenseState) {

                  // Show loading for expenses while budget progress is loaded
                  final isLoadingExpenses = expenseState is ExpenseLoading;
                  final List<Expense>expenses = expenseState is ExpensesByCategoryLoaded ? expenseState.expenses : [];
                  final totalSpent = expenseState is ExpensesByCategoryLoaded ? expenseState.total : progress.spent;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with category and delete button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: categoryData.color,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(
                                        categoryData.icon,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            budget.category,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            budget.description,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => DeleteBudgetDialog(
                                      onConfirm: () => _deleteBudget(budget),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Budget progress card
                          BudgetCardExpandedWidget(
                            budget: progress.budget,
                            totalSpent: progress.spent,
                            categoryExpenses: expenses,
                          ),

                          // Alert badge if threshold exceeded
                          if (progress.shouldAlert && !progress.isOverBudget) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Budget Alert',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'You\'ve reached ${progress.percentageUsed.toStringAsFixed(0)}% of your ${budget.category} budget. You have ₦${progress.remaining.toStringAsFixed(2)} remaining.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: Colors.orange.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Over budget warning
                          if (progress.isOverBudget) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.error,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Over Budget!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                            color: Theme.of(context).colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'You\'ve exceeded your ${budget.category} budget by ₦${(totalSpent - budget.amount).toStringAsFixed(2)}.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Transactions header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Transactions",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (isLoadingExpenses)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Transactions list or empty state
                          if (expenseState is ExpenseLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (expenses.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: Text("No Transactions yet"),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: BudgetTransactionHistoryWidget(
                                expenses: expenses,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (budgetState is BudgetError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load budget',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(budgetState.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BudgetBloc>().add(
                          LoadBudgetProgress(widget.budgetId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}