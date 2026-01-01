// lib/features/expenses/presentation/pages/expenses_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_history_page_widget/category_filter_widget.dart';
import '../widgets/expense_history_page_widget/delete-confirmation_dialog.dart';
import '../widgets/expense_history_page_widget/expense_filter_model.dart';
import '../widgets/expense_history_page_widget/filter_bottom_sheet.dart';
import '../widgets/expense_history_page_widget/history_content.dart';
import '../widgets/expense_history_page_widget/history_header.dart';
import '../widgets/expense_history_page_widget/history_search_bar.dart';
import '../widgets/expense_history_page_widget/history_snackbar_listener.dart';

class ExpensesHistoryPage extends StatefulWidget {
  const ExpensesHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExpensesHistoryPageState();
}

class _ExpensesHistoryPageState extends State<ExpensesHistoryPage> {
  ExpenseFilters _filters = const ExpenseFilters();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  bool _isSelectionMode = false;
  final Set<String> _selectedExpenseIds = {};

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedExpenseIds.clear();
      }
    });
  }

  void _toggleExpenseSelection(String id) {
    setState(() {
      if (_selectedExpenseIds.contains(id)) {
        _selectedExpenseIds.remove(id);
      } else {
        _selectedExpenseIds.add(id);
      }

      if (_selectedExpenseIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _selectAll(List<Expense> expenses) {
    setState(() {
      _selectedExpenseIds.clear();
      _selectedExpenseIds.addAll(expenses.map((e) => e.id));
    });
  }

  void _deleteSelected() {
    if (_selectedExpenseIds.isEmpty) return;

    showDeleteConfirmationDialog(
      context: context,
      count: _selectedExpenseIds.length,
      onConfirm: () {
        for (final id in _selectedExpenseIds) {
          context.read<ExpenseBloc>().add(SoftDeleteExpenseEvent(id));
        }

        setState(() {
          _selectedExpenseIds.clear();
          _isSelectionMode = false;
        });
      },
    );
  }

  List<Expense> _applyFilters(List<Expense> expenses) {
    return expenses.where((expense) {
      if (_filters.category != 'All' && expense.category != _filters.category) {
        return false;
      }

      if (_filters.minAmount != null && expense.amount < _filters.minAmount!) {
        return false;
      }
      if (_filters.maxAmount != null && expense.amount > _filters.maxAmount!) {
        return false;
      }

      if (_filters.startDate != null &&
          expense.updatedAt.isBefore(_filters.startDate!)) {
        return false;
      }
      if (_filters.endDate != null &&
          expense.updatedAt.isAfter(_filters.endDate!.add(Duration(days: 1)))) {
        return false;
      }

      if (_filters.searchQuery != null && _filters.searchQuery!.isNotEmpty) {
        final query = _filters.searchQuery!.toLowerCase();
        final description = (expense.description ?? '').toLowerCase();
        if (!description.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _filters,
        onApplyFilters: (newFilters) {
          setState(() {
            _filters = newFilters;
            if (newFilters.searchQuery != null) {
              _searchController.text = newFilters.searchQuery!;
            }
          });
        },
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = const ExpenseFilters();
      _searchController.clear();
    });
  }

  void _onCategorySelected(String filter) {
    setState(() {
      _filters = _filters.copyWith(category: filter);
    });

    if (filter == "All") {
      context.read<ExpenseBloc>().add(LoadExpensesEvent());
    } else {
      context.read<ExpenseBloc>().add(LoadExpensesEvent(category: filter));
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filters = _filters.copyWith(
        searchQuery: value.isEmpty ? null : value,
        clearSearchQuery: value.isEmpty,
      );
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filters = _filters.copyWith(clearSearchQuery: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HistorySnackbarListener(
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return _buildLoadingState(context);
          }

          List<Expense> expenses = [];
          if (state is ExpensesLoaded) {
            expenses = state.expenses;
          } else if (state is ExpensesByCategoryLoaded) {
            expenses = state.expenses;
          }

          final filteredExpenses = _applyFilters(expenses);

          return _buildHistoryView(
            context,
            filteredExpenses,
            expenses.length,
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading expenses...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView(
      BuildContext context,
      List<Expense> filteredExpenses,
      int totalCount,
      ) {
    final sortedExpenses = List.of(filteredExpenses)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
                child: HistoryHeader(
                  isSelectionMode: _isSelectionMode,
                  selectedCount: _selectedExpenseIds.length,
                  visibleCount: filteredExpenses.length,
                  totalCount: totalCount,
                  hasActiveFilters: _filters.hasActiveFilters,
                  activeFilterCount: _filters.activeFilterCount,
                  allExpenses: sortedExpenses,
                  onToggleSelectionMode: _toggleSelectionMode,
                  onSelectAll: () => _selectAll(sortedExpenses),
                  onDeselectAll: () => setState(() => _selectedExpenseIds.clear()),
                  onDeleteSelected: _deleteSelected,
                  onClearFilters: _clearAllFilters,
                  onShowFilters: _showFilterBottomSheet,
                ),
              ),
              if (!_isSelectionMode) ...[
                HistorySearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: _clearSearch,
                ),
                HistoryCategoryFilter(
                  scrollController: _scrollController,
                  activeFilter: _filters.category,
                  onCategorySelected: _onCategorySelected,
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: HistoryContent(
            expenses: sortedExpenses,
            isSelectionMode: _isSelectionMode,
            selectedIds: _selectedExpenseIds,
            hasActiveFilters: _filters.hasActiveFilters,
            categoryFilter: _filters.category,
            onToggleSelection: _toggleExpenseSelection,
            onRefresh: () async {
              context.read<ExpenseBloc>().add(const SyncExpensesEvent());
              await Future.delayed(const Duration(seconds: 1));
            },
            onClearFilters: _clearAllFilters,
          ),
        ),
      ],
    );
  }
}