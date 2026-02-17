// lib/features/expenses/presentation/widgets/expense_history/history_content.dart

import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';
import '../history_section_widget.dart';
import 'history_empty_state.dart';

class HistoryContent extends StatelessWidget {
  final List<Expense> expenses;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final bool hasActiveFilters;
  final String categoryFilter;
  final ValueChanged<String> onToggleSelection;
  final ValueChanged<bool> toggleSelectionMode;
  final Future<void> Function() onRefresh;
  final VoidCallback onClearFilters;
  final ValueChanged<String> onSwipeDelete;
  final ValueChanged<Expense> onSwipeEdit;

  const HistoryContent({
    super.key,
    required this.expenses,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.hasActiveFilters,
    required this.categoryFilter,
    required this.onToggleSelection,
    required this.toggleSelectionMode,
    required this.onRefresh,
    required this.onClearFilters,
    required this.onSwipeDelete,
    required this.onSwipeEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return HistoryEmptyState(
        hasActiveFilters: hasActiveFilters,
        categoryFilter: categoryFilter,
        onClearFilters: onClearFilters,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: HistorySection(
          expenses: expenses,
          selectionMode: isSelectionMode,
          selectedIds: selectedIds,
          onToggleSelect: onToggleSelection,
          onDelete: (id) {
            onSwipeDelete(id);
          }, // Handled by parent
          onEdit: (expense) {
            onSwipeEdit(expense);
          },
          toggleSelectionMode: (bool value) {
            toggleSelectionMode(value);
          }, // Handled by parent
        ),
      ),
    );
  }
}
