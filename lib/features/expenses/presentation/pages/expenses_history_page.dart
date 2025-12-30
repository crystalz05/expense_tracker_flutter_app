import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/category_filter_widget.dart';
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

  // Key to maintain scroll position
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading expenses...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
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

    return Column(
      children: [
        // Fixed header with category filter
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transaction History",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CategoryFilterWidget(
                scrollController: _scrollController,
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
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: sortedExpenses.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
            onRefresh: () async {
              context.read<ExpenseBloc>().add(
                const SyncExpensesEvent(),
              );
              await Future.delayed(Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: HistorySection(
                expenses: sortedExpenses,
                onDelete: (id) {
                  _showDeleteConfirmation(context, id);
                },
                onEdit: (expense) {
                  // TODO: Navigate to edit page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                        content: Text('Edit functionality coming soon')
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            _activeFilter == "All"
                ? "No transactions yet"
                : "No $_activeFilter transactions",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Start tracking your expenses",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(dialogContext);
              if(_activeFilter == "All"){
                context.read<ExpenseBloc>().add(LoadExpensesEvent());
              }else{
                context
                    .read<ExpenseBloc>()
                    .add(LoadExpensesEvent(category:_activeFilter));
              }
            },
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ExpenseBloc>().add(SoftDeleteExpenseEvent(id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}