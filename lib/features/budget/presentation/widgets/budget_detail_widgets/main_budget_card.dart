import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/currency_formatter.dart';
import '../../../../../core/utils/expenses_categories.dart';
import '../../../domain/entities/budget.dart';

class MainBudgetCard extends StatelessWidget {
  final Budget budget;
  final dynamic progress;
  final ExpenseCategory categoryData;

  const MainBudgetCard({
    super.key,
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          formatNaira(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
