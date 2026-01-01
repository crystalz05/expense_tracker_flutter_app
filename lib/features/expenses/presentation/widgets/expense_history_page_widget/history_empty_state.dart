// lib/features/expenses/presentation/widgets/expense_history/history_empty_state.dart

import 'package:flutter/material.dart';

class HistoryEmptyState extends StatelessWidget {
  final bool hasActiveFilters;
  final String categoryFilter;
  final VoidCallback onClearFilters;

  const HistoryEmptyState({
    super.key,
    required this.hasActiveFilters,
    required this.categoryFilter,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasActiveFilters
                ? Icons.search_off
                : Icons.receipt_long_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            _getEmptyStateTitle(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? "Try adjusting your filters"
                : "Start tracking your expenses",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
          if (hasActiveFilters) ...[
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onClearFilters,
              icon: Icon(Icons.clear_all),
              label: Text('Clear all filters'),
            ),
          ],
        ],
      ),
    );
  }

  String _getEmptyStateTitle() {
    if (hasActiveFilters) {
      return "No matching transactions";
    }
    if (categoryFilter == "All") {
      return "No transactions yet";
    }
    return "No $categoryFilter transactions";
  }
}