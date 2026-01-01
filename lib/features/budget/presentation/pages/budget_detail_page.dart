import 'package:expenses_tracker_app/core/utils/currency_formatter.dart';
import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context.read<ExpenseBloc>().add(const LoadExpensesEvent());
          context.read<BudgetBloc>().add(LoadAllBudgetProgress());
        }
      },
      child: Scaffold(
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
                const SnackBar(content: Text('Budget deleted successfully')),
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
                  final expenses = expenseState is ExpensesByCategoryLoaded
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
          backgroundColor: categoryData.color,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => context.push('/edit-budget-page', extra: budget),
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
                    categoryData.color,
                    categoryData.color.withOpacity(0.7),
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
                      color: Colors.white.withOpacity(0.2),
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
                _MainBudgetCard(
                  budget: budget,
                  progress: progress,
                  categoryData: categoryData,
                ),

                const SizedBox(height: 24),

                // Analytics Section
                _AnalyticsSection(
                  budget: budget,
                  expenses: expenses,
                  spent: progress.spent,
                ),

                const SizedBox(height: 24),

                // Transactions Section
                _TransactionsSection(expenses: expenses),

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

class _MainBudgetCard extends StatelessWidget {
  final Budget budget;
  final dynamic progress;
  final ExpenseCategory categoryData;

  const _MainBudgetCard({
    required this.budget,
    required this.progress,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    final percentageUsed = progress.percentageUsed;
    final isOverBudget = progress.isOverBudget;

    Color statusColor = isOverBudget
        ? Colors.red
        : progress.shouldAlert
        ? Colors.orange
        : Colors.green;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Amounts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AmountColumn(
                label: 'Budget',
                amount: budget.amount,
                color: Theme.of(context).colorScheme.primary,
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _AmountColumn(
                label: 'Spent',
                amount: progress.spent,
                color: statusColor,
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _AmountColumn(
                label: 'Remaining',
                amount: progress.remaining,
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress Bar
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (percentageUsed / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Percentage
          Text(
            '${percentageUsed.toStringAsFixed(1)}% used',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (isOverBudget || progress.shouldAlert) ...[
            const SizedBox(height: 16),
            _AlertBanner(
              isOverBudget: isOverBudget,
              budget: budget,
              spent: progress.spent,
              remaining: progress.remaining,
              percentageUsed: percentageUsed,
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _AmountColumn({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          formatNaira(amount),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final bool isOverBudget;
  final Budget budget;
  final double spent;
  final double remaining;
  final double percentageUsed;

  const _AlertBanner({
    required this.isOverBudget,
    required this.budget,
    required this.spent,
    required this.remaining,
    required this.percentageUsed,
  });

  @override
  Widget build(BuildContext context) {
    final color = isOverBudget ? Colors.red : Colors.orange;
    final icon = isOverBudget ? Icons.error_outline : Icons.warning_amber;
    final title = isOverBudget ? 'Over Budget!' : 'Budget Alert';
    final message = isOverBudget
        ? 'You\'ve exceeded your budget by ${formatNaira(spent - budget.amount)}'
        : 'You\'ve reached ${percentageUsed.toStringAsFixed(0)}% of your budget. ${formatNaira(remaining)} remaining.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  final Budget budget;
  final List<Expense> expenses;
  final double spent;

  const _AnalyticsSection({
    required this.budget,
    required this.expenses,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate daily spending
    final daysPassed = DateTime.now().difference(budget.startDate).inDays + 1;
    final totalDays = budget.endDate.difference(budget.startDate).inDays + 1;
    final double avgDailySpending = daysPassed > 0 ? spent / daysPassed : 0;
    final projectedSpending = avgDailySpending * totalDays;

    // Group expenses by day
    final Map<DateTime, double> dailySpending = {};
    for (final expense in expenses) {
      final date = DateTime(
        expense.createdAt.year,
        expense.createdAt.month,
        expense.createdAt.day,
      );
      dailySpending[date] = (dailySpending[date] ?? 0) + expense.amount;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Daily Avg',
                  value: formatNaira(avgDailySpending),
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Transactions',
                  value: expenses.length.toString(),
                  icon: Icons.receipt,
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Days Passed',
                  value: '$daysPassed / $totalDays',
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Projected',
                  value: formatNaira(projectedSpending),
                  icon: Icons.trending_up,
                  color: projectedSpending > budget.amount ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),

          if (dailySpending.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Spending Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _SpendingChart(dailySpending: dailySpending),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  final Map<DateTime, double> dailySpending;

  const _SpendingChart({required this.dailySpending});

  @override
  Widget build(BuildContext context) {
    final sortedDates = dailySpending.keys.toList()..sort();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₦${(value / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedDates.length) return const SizedBox();
                return Text(
                  DateFormat('MM/dd').format(sortedDates[value.toInt()]),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: sortedDates.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), dailySpending[e.value]!);
            }).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  final List<Expense> expenses;

  const _TransactionsSection({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (expenses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No transactions yet'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final categoryData = ExpenseCategories.fromName(expense.category);
                return _TransactionItem(
                  expense: expense,
                  categoryData: categoryData,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Expense expense;
  final ExpenseCategory categoryData;

  const _TransactionItem({
    required this.expense,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: categoryData.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            categoryData.icon,
            color: categoryData.color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.description ?? 'No description',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                DateFormat('MMM d, yyyy • h:mm a').format(expense.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Text(
          formatNaira(expense.amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}