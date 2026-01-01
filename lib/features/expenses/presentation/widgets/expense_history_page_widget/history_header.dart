// lib/features/expenses/presentation/widgets/expense_history/history_header.dart

import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';

class HistoryHeader extends StatelessWidget {
  final bool isSelectionMode;
  final int selectedCount;
  final int visibleCount;
  final int totalCount;
  final bool hasActiveFilters;
  final int activeFilterCount;
  final List<Expense> allExpenses;
  final VoidCallback onToggleSelectionMode;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onDeleteSelected;
  final VoidCallback onClearFilters;
  final VoidCallback onShowFilters;

  const HistoryHeader({
    super.key,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveFilters,
    required this.activeFilterCount,
    required this.allExpenses,
    required this.onToggleSelectionMode,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onDeleteSelected,
    required this.onClearFilters,
    required this.onShowFilters,
  });

  @override
  Widget build(BuildContext context) {
    return isSelectionMode
        ? _SelectionHeader(
      selectedCount: selectedCount,
      allExpenses: allExpenses,
      onCancel: onToggleSelectionMode,
      onSelectAll: onSelectAll,
      onDeselectAll: onDeselectAll,
      onDelete: onDeleteSelected,
    )
        : _NormalHeader(
      visibleCount: visibleCount,
      totalCount: totalCount,
      hasActiveFilters: hasActiveFilters,
      activeFilterCount: activeFilterCount,
      onToggleSelection: onToggleSelectionMode,
      onClearFilters: onClearFilters,
      onShowFilters: onShowFilters,
    );
  }
}

class _NormalHeader extends StatelessWidget {
  final int visibleCount;
  final int totalCount;
  final bool hasActiveFilters;
  final int activeFilterCount;
  final VoidCallback onToggleSelection;
  final VoidCallback onClearFilters;
  final VoidCallback onShowFilters;

  const _NormalHeader({
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveFilters,
    required this.activeFilterCount,
    required this.onToggleSelection,
    required this.onClearFilters,
    required this.onShowFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction History",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasActiveFilters) ...[
                SizedBox(height: 4),
                Text(
                  '$visibleCount of $totalCount transactions',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Row(
          children: [
            if (visibleCount > 0)
              IconButton(
                onPressed: onToggleSelection,
                icon: Icon(Icons.checklist),
                tooltip: 'Select items',
              ),
            if (hasActiveFilters)
              IconButton(
                onPressed: onClearFilters,
                icon: Icon(Icons.clear_all),
                tooltip: 'Clear filters',
              ),
            Stack(
              children: [
                IconButton(
                  onPressed: onShowFilters,
                  icon: Icon(Icons.tune),
                  tooltip: 'Filters',
                ),
                if (hasActiveFilters)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '$activeFilterCount',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectionHeader extends StatelessWidget {
  final int selectedCount;
  final List<Expense> allExpenses;
  final VoidCallback onCancel;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onDelete;

  const _SelectionHeader({
    required this.selectedCount,
    required this.allExpenses,
    required this.onCancel,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final allSelected =
        allExpenses.isNotEmpty && selectedCount == allExpenses.length;

    return Row(
      children: [
        IconButton(
          onPressed: onCancel,
          icon: Icon(Icons.close),
          tooltip: 'Cancel selection',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$selectedCount selected',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: allSelected ? onDeselectAll : onSelectAll,
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          label: Text(allSelected ? 'Deselect All' : 'Select All'),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: selectedCount == 0 ? null : onDelete,
          icon: Icon(Icons.delete),
          color: Colors.red,
          tooltip: 'Delete selected',
        ),
      ],
    );
  }
}