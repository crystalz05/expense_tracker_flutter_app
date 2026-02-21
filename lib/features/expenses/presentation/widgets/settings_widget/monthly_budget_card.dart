import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/presentation/cubit/currency_cubit.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../../../../../features/monthly_budget/domain/entities/monthly_budget.dart';
import '../../../../../features/monthly_budget/presentation/bloc/monthly_budget_bloc.dart';
import '../../../../monthly_budget/presentation/bloc/monthly_budget_event.dart';
import '../../../../monthly_budget/presentation/bloc/monthly_budget_state.dart';
import '../../misc/formatter.dart';
import '../monthly_budget_dialog.dart';

class MonthlyBudgetCard extends StatefulWidget {
  const MonthlyBudgetCard({super.key});

  @override
  State<MonthlyBudgetCard> createState() => _MonthlyBudgetCardState();
}

class _MonthlyBudgetCardState extends State<MonthlyBudgetCard> {
  @override
  void initState() {
    super.initState();
    // Load budget for current month
    final now = DateTime.now();
    context.read<MonthlyBudgetBloc>().add(
      LoadMonthlyBudgetByMonthYearEvent(month: now.month, year: now.year),
    );
  }

  String get _currentMonthYear {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<MonthlyBudgetBloc, MonthlyBudgetState>(
          listener: (context, state) {
            if (state is MonthlyBudgetOperationSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              // Reload after operation
              final now = DateTime.now();
              context.read<MonthlyBudgetBloc>().add(
                LoadMonthlyBudgetByMonthYearEvent(
                  month: now.month,
                  year: now.year,
                ),
              );
            } else if (state is MonthlyBudgetError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            MonthlyBudget? currentBudget;
            double budgetAmount = 0.0;
            bool isLoading = state is MonthlyBudgetLoading;

            if (state is MonthlyBudgetByMonthYearLoaded) {
              currentBudget = state.budget;
              budgetAmount = currentBudget?.amount ?? 0.0;
            }

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Monthly Budget",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentMonthYear,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BlocBuilder<CurrencyCubit, AppCurrency>(
                        builder: (context, currency) => Text(
                          currentBudget != null
                              ? formatCurrency(budgetAmount, currency)
                              : "Not Set",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: currentBudget != null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () async {
                          final now = DateTime.now();
                          final newBudget = await showDialog<double>(
                            context: context,
                            builder: (_) => MonthlyBudgetDialog(
                              initialBudget: budgetAmount,
                              month: now.month,
                              year: now.year,
                            ),
                          );

                          if (newBudget != null && mounted) {
                            if (currentBudget != null) {
                              // Update existing budget
                              final updated = MonthlyBudget(
                                id: currentBudget.id,
                                userId: currentBudget.userId,
                                month: now.month,
                                year: now.year,
                                amount: newBudget,
                                createdAt: currentBudget.createdAt,
                                updatedAt: DateTime.now(),
                              );
                              context.read<MonthlyBudgetBloc>().add(
                                UpdateMonthlyBudgetEvent(updated),
                              );
                            } else {
                              // Create new budget
                              final created = MonthlyBudget(
                                id: const Uuid().v4(),
                                userId: '',
                                month: now.month,
                                year: now.year,
                                amount: newBudget,
                                createdAt: DateTime.now(),
                              );
                              context.read<MonthlyBudgetBloc>().add(
                                CreateMonthlyBudgetEvent(created),
                              );
                            }
                          }
                        },
                        icon: Icon(
                          currentBudget != null ? Icons.edit : Icons.add,
                          size: 16,
                        ),
                        label: Text(
                          currentBudget != null ? 'Edit' : 'Set Budget',
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
