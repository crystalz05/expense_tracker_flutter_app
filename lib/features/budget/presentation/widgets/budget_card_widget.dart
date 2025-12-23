
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cubit/budget_cubit.dart';

class BudgetCardWidget extends StatelessWidget {

  final double totalSpent;
  final VoidCallback? onTap;

  const BudgetCardWidget({
    super.key,
    required this.totalSpent,
    this.onTap
  });


  @override
  Widget build(BuildContext context) {

    String category = "Food & Dining";
    IconData icon = Icons.no_meals_rounded;
    String description = "Food";
    Color color = Colors.lightGreen;
    double total = 20000.00;
    double spent = 7500.00;
    String period = "Monthly";
    DateTime startDate = DateTime(2024, 6, 1);
    DateTime endDate = DateTime(2024, 6, 30);

    return
      BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            final double fraction = spent / total;
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
                                decoration: BoxDecoration(color: color,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary,),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(category, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  Text(description, style: Theme.of(context).textTheme.bodySmall,),
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
                          Text("$period: ${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              )),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: fraction,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₦${formatter.format(spent)} / ₦${formatter.format(total)}"),
                          Text("$percentage%", style: Theme.of(context).textTheme.titleSmall,)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      );
  }

}