
import 'package:expenses_tracker_app/core/navigation/app_router.dart';
import 'package:expenses_tracker_app/features/budget/presentation/dummy_data/mock_data.dart';
import 'package:expenses_tracker_app/features/budget/presentation/pages/add_budget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/budget.dart';
import '../widgets/add_budget_dialog.dart';
import '../widgets/delete_budget_dialog.dart';

class BudgetPage extends StatelessWidget {

  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Budget'),

            //add a return to previous page button
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.pop();
              },
            )
        ),

        body: BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ExpensesLoaded) {
                return SingleChildScrollView(
                    child: Padding(padding: EdgeInsets.all(16),
                      child:
                      Column(
                        children: [
                          BalanceCardWidget(totalSpent: state.totalSpent),
                          SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("My Budges", style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                              ElevatedButton(onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (_) => AddBudget(onBudgetAdded: () {})
                                );
                              },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Theme
                                              .of(context)
                                              .colorScheme
                                              .primary)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add, color: Theme
                                          .of(context)
                                          .colorScheme
                                          .onPrimary),
                                      SizedBox(width: 8,),
                                      Text("Add Budget",
                                        style: TextStyle(color: Theme
                                            .of(context)
                                            .colorScheme
                                            .onPrimary),),
                                    ],
                                  )
                              )
                            ],
                          ),
                          SizedBox(height: 16,),
                          Column(
                            children: [
                              for(final budget in budgets)
                                Column(
                                  children: [
                                    BudgetCardWidget(budget: budget,
                                      onTap: () {
                                        context.push("/budget-detail-page",
                                            extra: budget);
                                      },
                                    ),
                                  ],
                                )
                            ],
                          )

                        ],
                      ),
                    )
                );
              }
              return const SizedBox();
            }
        )
    );
  }
}