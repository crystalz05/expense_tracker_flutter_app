
import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cubit/budget_cubit.dart';

class BudgetCardWidget extends StatelessWidget {

  final Budget budget;
  final VoidCallback? onTap;

  const BudgetCardWidget({
    super.key,
    required this.budget,
    this.onTap
  });


  @override
  Widget build(BuildContext context) {
    final categoryData = ExpenseCategories.fromName(budget.category);

    return
      BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            final double fraction = budget.amount / budget.amount;
            final String percentage = (fraction * 100).toStringAsFixed(1);

            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5)
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(color: categoryData.color,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Icon(categoryData.icon, color: Theme.of(context).colorScheme.onPrimary,),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(budget.category, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  Text(budget.description, style: Theme.of(context).textTheme.bodySmall,),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey,)
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
                          SizedBox(width: 4),
                          Text("${budget.period}: ${budget.startDate.day}/${budget.startDate.month}/${budget.startDate.year} - ${budget.endDate.day}/${budget.endDate.month}/${budget.endDate.year}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              )),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          }
      );
  }

}