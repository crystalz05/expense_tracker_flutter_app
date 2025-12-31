import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    // Load all expenses for balance card
    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
    context.read<BudgetBloc>().add(LoadAllBudgetProgress());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget', style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ExpenseBloc>().add(const LoadExpensesEvent());
          context.read<BudgetBloc>().add(LoadAllBudgetProgress());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Balance Card - shows total spending
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpensesLoaded) {
                      return BalanceCardWidget(totalSpent: state.totalSpent);
                    }
                    return const BalanceCardWidget(totalSpent: 0.0);
                  },
                ),

                const SizedBox(height: 16),

                // Header with Add Budget button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Budgets",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push("/add-budget-page");
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Add Budget",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Budget Cards List
                BlocConsumer<BudgetBloc, BudgetState>(
                  listener: (context, state) {
                    if (state is BudgetError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is BudgetLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is AllBudgetProgressLoaded) {
                      final budgetProgressList = state.progress;

                      if (budgetProgressList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No budgets yet",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Create a budget to track your spending",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: budgetProgressList.map((progress) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: BudgetCardWidget(
                              budget: progress.budget,
                              spent: progress.spent,
                              percentageUsed: progress.percentageUsed,
                              isOverBudget: progress.isOverBudget,
                              shouldAlert: progress.shouldAlert,
                              onTap: () {
                                context.push(
                                  "/budget-detail-page/${progress.budget.id}",
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }

                    if (state is BudgetError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load budgets',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(state.message),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<BudgetBloc>().add(LoadAllBudgetProgress());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}