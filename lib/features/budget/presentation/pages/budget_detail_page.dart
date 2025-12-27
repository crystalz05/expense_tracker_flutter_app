
import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_card_expanded_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_transaction_history_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/delete_budget_dialog.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../expenses/presentation/bloc/expense_bloc.dart';
import '../../../expenses/presentation/bloc/expense_state.dart';
import '../../domain/entities/budget.dart';

class BudgetDetailPage extends StatefulWidget {
  final Budget budget;

  const BudgetDetailPage({
    super.key,
    required this.budget,
  });

  @override
  State<StatefulWidget> createState() => _BudgetDetailPageState();

}

class _BudgetDetailPageState extends State<BudgetDetailPage> {

  @override void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpensesEvent(category: widget.budget.category, from: widget.budget.startDate, to: widget.budget.endDate));
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = ExpenseCategories.fromName(widget.budget.category);
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            context.read<ExpenseBloc>().add(LoadExpensesEvent());
          }
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text("Budget Details"),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => context.pop(),
                )
            ),
            body: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state){
                  if (state is ExpenseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(state is ExpensesLoaded){
                    final expenses = state.expenses;
                    final totalSpent = state.totalSpent;

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.budget.category, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                        Text(widget.budget.description, style: Theme.of(context).textTheme.bodyMedium,),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (_) => DeleteBudgetDialog(onConfirm: () {}));
                                    },
                                    icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error,))
                              ],
                            ),
                            SizedBox(height: 24),
                            BudgetCardExpandedWidget(budget: widget.budget, totalSpent: totalSpent, categoryExpenses: expenses),
                            SizedBox(height: 24),
                            Text("Recent Transactions", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),


                            if(expenses.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(child: Text("No Transactions yet"),),
                              )
                            else
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: BudgetTransactionHistoryWidget(expenses: state.expenses),
                              )
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }
            )
        )
    );

  }
}