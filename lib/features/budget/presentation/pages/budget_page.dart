import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/expenses_categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/format_date.dart';
import '../widgets/budget_page_widgets/budget_card.dart';
import '../widgets/budget_page_widgets/empty_budget.dart';
import '../widgets/budget_page_widgets/error_widget.dart';
import '../widgets/budget_page_widgets/total_spending_card.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
    _reload();
  }

  void _reload(){
    context.read<BudgetBloc>().add(LoadAllBudgetProgress());
    context.read<ExpenseBloc>().add(LoadExpensesByPeriodEvent(from: firstDay, to: lastDay));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Manager',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Track your spending goals',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Total Spending Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  final totalSpent = state is ExpensesByPeriodLoaded ? state.totalSpent : 0.0;
                  return TotalSpendingCard(totalSpent: totalSpent);
                },
              ),
            ),
          ),

          // Header with Add Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Budgets',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final success = await context.push('/add-budget-page');
                      if(success == true && mounted){
                        _reload();
                      }
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Create'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Budget Cards List
          BlocConsumer<BudgetBloc, BudgetState>(
            listener: (context, state) {
              if (state is BudgetError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(child: Text(state.message)),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is BudgetLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is AllBudgetProgressLoaded) {
                final budgetProgressList = state.progress;

                if (budgetProgressList.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyBudgetState(
                      onCreateBudget: () => context.push('/add-budget-page'),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final progress = budgetProgressList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BudgetCard(
                            progress: progress,
                            onTap: () => context.push(
                              '/budget-detail-page/${progress.budget.id}',
                            ),
                          ),
                        );
                      },
                      childCount: budgetProgressList.length,
                    ),
                  ),
                );
              }

              if (state is BudgetError) {
                return SliverFillRemaining(
                  child: ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<BudgetBloc>().add(LoadAllBudgetProgress());
                    },
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
        ],
      ),
    );
  }
}