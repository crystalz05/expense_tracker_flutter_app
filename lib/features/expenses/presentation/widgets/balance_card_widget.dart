

import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cubit/budget_cubit.dart';

class BalanceCardWidget extends StatelessWidget {

  final double totalSpent;

  const BalanceCardWidget({super.key, required this.totalSpent});



  @override
  Widget build(BuildContext context) {

    return
      BlocBuilder<BudgetCubit, BudgetStateSecondary>(
          builder: (context, state) {
            final double fraction = totalSpent / state.monthlyBudget;
            final String percentage = (fraction * 100).toStringAsFixed(1);

            final double remaining = state.monthlyBudget - totalSpent;
            final bool isOverBudget = totalSpent > state.monthlyBudget;
            final bool isWarning = fraction > 0.8 && !isOverBudget;


            return
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0A2E5D), Color(0xFF2563EB)]),
                borderRadius: BorderRadius.circular(24),
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
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Icon(Icons.account_balance_wallet, color: Colors.white,),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Monthly Budget", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),),
                                Text("₦${formatter.format(state.monthlyBudget)}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Remaining", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),),
                            Text("₦${formatter.format(state.monthlyBudget-totalSpent)}", style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ],
                        )
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₦${formatter.format(totalSpent)} spent", style: TextStyle(color: Colors.white)),
                        Text("$percentage%", style: TextStyle(color: Colors.white))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
      );
  }

}