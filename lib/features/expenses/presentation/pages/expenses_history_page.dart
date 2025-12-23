
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

class _ExpensesHistoryPage extends State<ExpensesHistoryPage> {
  String _activeFilter = "All";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        }
      },
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExpensesLoaded) {
          return _buildWidget(context, state.expenses);
        }

        if (state is ExpensesByCategoryLoaded) {
          return _buildWidget(context, state.expenses);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWidget(BuildContext context, List<Expense> expenses) {
    final sortedExpenses = List.of(expenses)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("History"),
            const SizedBox(height: 24),

            CategoryFilterWidget(
              activeFilter: _activeFilter,
              onCategorySelected: (filter) {
                setState(() => _activeFilter = filter);

                if (filter == "All") {
                  context.read<ExpenseBloc>().add(LoadExpensesEvent());
                } else {
                  context
                      .read<ExpenseBloc>()
                      .add(LoadExpensesEvent(category: filter));
                }
              },
            ),

            const SizedBox(height: 32),

            HistorySection(
              expenses: sortedExpenses,
              onDelete: (id) {
                context.read<ExpenseBloc>().add(SoftDeleteExpenseEvent(id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
