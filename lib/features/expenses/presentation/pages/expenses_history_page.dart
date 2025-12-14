
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/category_filter_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';

class ExpensesHistoryPage extends StatefulWidget {
  const ExpensesHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExpensesHistoryPage();
}

class _ExpensesHistoryPage extends State<ExpensesHistoryPage>{

  @override
  Widget build(BuildContext context) {

    return
      BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state){
          if(state is ExpenseActionSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green)
            );
          }else if (state is ExpenseError){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red)
            );
          }
        },
        builder: (context, state){
          if(state is ExpenseLoading){
            return const Center(child: CircularProgressIndicator());
          }if(state is ExpensesLoaded){
            return _buildWidget(context, expenses: state.expenses);
          }
          else if(state is ExpensesByCategoryLoaded){
            return _buildWidget(context, expenses: state.expenses);
          }
          return const SizedBox.shrink();
        },
      );
  }

  Widget _buildWidget(
      BuildContext context, {required List<Expense> expenses}
      ){

    final sortedExpenses = List.of(expenses)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return SingleChildScrollView(
        child: Padding(padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("History", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text("View all your transactions", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, size: 20),
                    SizedBox(width: 8,),
                    Text("Filter", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                CategoryFilterWidget(onCategorySelected: (filter) {
                  if(filter == "All"){
                    context.read<ExpenseBloc>().add(LoadExpensesEvent());
                  }else{
                    context.read<ExpenseBloc>().add(LoadExpensesByCategoryEvent(filter));
                  }
                },),
                SizedBox(height: 32),
                HistorySection(
                  expenses: sortedExpenses,
                  onDelete: (id){
                    context.read<ExpenseBloc>()
                        .add(DeleteExpenseEvent(id)
                    );
                  },
                ),
              ],
            )
        )
    );
  }
}
