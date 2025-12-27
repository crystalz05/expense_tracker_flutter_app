import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/expenses_categories.dart';

class BudgetTransactionHistoryWidget extends StatelessWidget {
  final List<Expense> expenses;

  const BudgetTransactionHistoryWidget({
    super.key,
    required this.expenses,
  });

  String _formattedTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(child: Text("No transactions yet"));
    }

    return ListView.separated(
      shrinkWrap: true, // use if inside another scrollable
      physics: NeverScrollableScrollPhysics(), // disable inner scrolling
      itemCount: expenses.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final categoryData = ExpenseCategories.fromName(expense.category);
        final date = expense.updatedAt;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(categoryData.icon, color: categoryData.color, size: 18),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description ?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "${DateFormat('MMM').format(date)} ${date.day}, ${date.year} - ${_formattedTime(date)}",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "₦${expense.amount.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
