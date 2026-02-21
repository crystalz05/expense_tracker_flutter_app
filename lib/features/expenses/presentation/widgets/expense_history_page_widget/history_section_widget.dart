// lib/features/expenses/presentation/widgets/history_section_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/presentation/cubit/currency_cubit.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/expense.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_event.dart';
import 'delete-confirmation_dialog.dart';

class HistorySection extends StatelessWidget {
  final List<Expense> expenses;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onDelete;
  final ValueChanged<Expense> onEdit;

  const HistorySection({
    super.key,
    required this.expenses,
    required this.selectionMode,
    required this.selectedIds,
    required this.onToggleSelect,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final groupedExpenses = _groupExpensesByDate(expenses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedExpenses.entries.map((entry) {
        return _DateSection(
          date: entry.key,
          expenses: entry.value,
          selectionMode: selectionMode,
          selectedIds: selectedIds,
          onToggleSelect: onToggleSelect,
          onDelete: onDelete,
          onEdit: onEdit,
        );
      }).toList(),
    );
  }

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};

    for (final expense in expenses) {
      final date = DateFormat('yyyy-MM-dd').format(expense.updatedAt);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(expense);
    }

    return grouped;
  }
}

class _DateSection extends StatelessWidget {
  final String date;
  final List<Expense> expenses;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onDelete;
  final ValueChanged<Expense> onEdit;

  const _DateSection({
    required this.date,
    required this.expenses,
    required this.selectionMode,
    required this.selectedIds,
    required this.onToggleSelect,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(date);
    final formattedDate = _formatDateHeader(dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            formattedDate,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...expenses.map(
          (expense) => _ExpenseListItem(
            expense: expense,
            selectionMode: selectionMode,
            isSelected: selectedIds.contains(expense.id),
            onToggleSelect: () => onToggleSelect(expense.id),
            onDelete: () => _handleDelete(context, expense.id),
            onEdit: () => onEdit(expense),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }

  void _handleDelete(BuildContext context, String id) {
    showSingleDeleteConfirmationDialog(
      context: context,
      onConfirm: () {
        context.read<ExpenseBloc>().add(SoftDeleteExpenseEvent(id));
      },
      onCancel: () {
        context.read<ExpenseBloc>().add(LoadExpensesEvent());
      },
    );
  }
}

class _ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ExpenseListItem({
    required this.expense,
    required this.selectionMode,
    required this.isSelected,
    required this.onToggleSelect,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: selectionMode
            ? onToggleSelect
            : () => context.push('/expense-detail-page', extra: expense),
        onLongPress: !selectionMode ? onToggleSelect : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (selectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggleSelect(),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description ?? 'No description',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expense.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BlocBuilder<CurrencyCubit, AppCurrency>(
                    builder: (context, currency) => Text(
                      formatCurrency(expense.amount, currency),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('h:mm a').format(expense.updatedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
