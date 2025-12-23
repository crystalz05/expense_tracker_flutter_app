
import 'package:expenses_tracker_app/features/budget/presentation/widgets/mini_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cubit/budget_cubit.dart';

class BudgetCardExpandedWidget extends StatelessWidget {

  final double totalSpent;
  final VoidCallback? onTap;

  const BudgetCardExpandedWidget({
    super.key,
    required this.totalSpent,
    this.onTap
  });


  @override
  Widget build(BuildContext context) {

    // String category = "Food & Dining";
    // IconData icon = Icons.no_meals_rounded;
    // String description = "Food";
    // Color color = Colors.lightGreen;
    double total = 20000.00;
    double spent = 7500.00;
    String period = "Monthly";
    DateTime startDate = DateTime(2025, 12, 1);
    DateTime endDate = DateTime(2025, 12, 30);

    return
      BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            final double fraction = spent / total;
            final String percentage = (fraction * 100).toStringAsFixed(1);

            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Card(
                color: Theme.of(context).colorScheme.surfaceContainer,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Budget", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                                  Text("₦${formatter.format(total)}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Remaining", style: Theme.of(context).textTheme.bodySmall,),
                              Text("₦${formatter.format(state.monthlyBudget-totalSpent)}", style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface))

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
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
                          Text("₦${formatter.format(spent)} spent"),
                          Text("$percentage%", style: Theme.of(context).textTheme.titleSmall,)
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MiniCardWidget(spent: spent),
                          MiniCardWidget(spent: spent)
                        ],
                      ),
                      SizedBox(height: 12,),
                      Divider(thickness: 0.5, color: Colors.grey,),
                      SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.timer_sharp, size: 18),
                              SizedBox(width: 6),
                              Text("Period", style: Theme.of(context).textTheme.bodyMedium,)
                            ],
                          ),
                          Text(period, style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today, size: 18),
                              SizedBox(width: 6),
                              Text("Period", style: Theme.of(context).textTheme.bodyMedium,)
                            ],
                          ),
                          Text("${startDate.day}/${startDate.month}/${startDate.year}"
                              "- ${endDate.day}/${endDate.month}/${endDate.year}", style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.repeat, size: 18,),
                              SizedBox(width: 6),
                              Text("Recurring", style: Theme.of(context).textTheme.bodyMedium,)
                            ],
                          ),
                          Text("Yes", style: Theme.of(context).textTheme.titleMedium),
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