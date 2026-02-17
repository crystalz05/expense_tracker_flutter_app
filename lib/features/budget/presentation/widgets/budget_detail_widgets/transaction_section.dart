import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/currency_formatter.dart';
import '../../../../../core/utils/expenses_categories.dart';
import '../../../../expenses/domain/entities/expense.dart';

class TransactionsSection extends StatelessWidget {
  final List<Expense> expenses;

  const TransactionsSection({required this.expenses});

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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                final categoryData = ExpenseCategories.fromName(
                  expense.category,
                );
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

  const _TransactionItem({required this.expense, required this.categoryData});

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
          child: Icon(categoryData.icon, color: categoryData.color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.description ?? 'No description',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                DateFormat('MMM d, yyyy • h:mm a').format(expense.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Text(
          formatNaira(expense.amount),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
