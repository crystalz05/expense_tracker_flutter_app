import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/category_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';

class ExpenseFilters {
  final String category;
  final double? minAmount;
  final double? maxAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const ExpenseFilters({
    this.category = 'All',
    this.minAmount,
    this.maxAmount,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  ExpenseFilters copyWith({
    String? category,
    double? minAmount,
    double? maxAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    bool clearMinAmount = false,
    bool clearMaxAmount = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearSearchQuery = false,
  }) {
    return ExpenseFilters(
      category: category ?? this.category,
      minAmount: clearMinAmount ? null : (minAmount ?? this.minAmount),
      maxAmount: clearMaxAmount ? null : (maxAmount ?? this.maxAmount),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }

  bool get hasActiveFilters =>
      category != 'All' ||
          minAmount != null ||
          maxAmount != null ||
          startDate != null ||
          endDate != null ||
          (searchQuery != null && searchQuery!.isNotEmpty);

  int get activeFilterCount {
    int count = 0;
    if (category != 'All') count++;
    if (minAmount != null || maxAmount != null) count++;
    if (startDate != null || endDate != null) count++;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    return count;
  }
}

class ExpensesHistoryPage extends StatefulWidget {
  const ExpensesHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExpensesHistoryPage();
}

class _ExpensesHistoryPage extends State<ExpensesHistoryPage> {
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

      // Exit selection mode if no items selected
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

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${_selectedExpenseIds.length} Transaction${_selectedExpenseIds.length > 1 ? 's' : ''}'),
        content: Text('Are you sure you want to delete ${_selectedExpenseIds.length} transaction${_selectedExpenseIds.length > 1 ? 's' : ''}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              // Delete each selected expense
              for (final id in _selectedExpenseIds) {
                context.read<ExpenseBloc>().add(SoftDeleteExpenseEvent(id));
              }

              setState(() {
                _selectedExpenseIds.clear();
                _isSelectionMode = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_selectedExpenseIds.length} transaction${_selectedExpenseIds.length > 1 ? 's' : ''} deleted'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Expense> _applyFilters(List<Expense> expenses) {
    return expenses.where((expense) {
      // Category filter
      if (_filters.category != 'All' && expense.category != _filters.category) {
        return false;
      }

      // Amount range filter
      if (_filters.minAmount != null && expense.amount < _filters.minAmount!) {
        return false;
      }
      if (_filters.maxAmount != null && expense.amount > _filters.maxAmount!) {
        return false;
      }

      // Date range filter
      if (_filters.startDate != null &&
          expense.updatedAt.isBefore(_filters.startDate!)) {
        return false;
      }
      if (_filters.endDate != null &&
          expense.updatedAt.isAfter(_filters.endDate!.add(Duration(days: 1)))) {
        return false;
      }

      // Description search
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
      builder: (context) => _FilterBottomSheet(
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        List<Expense> expenses = [];
        if (state is ExpensesLoaded) {
          expenses = state.expenses;
        } else if (state is ExpensesByCategoryLoaded) {
          expenses = state.expenses;
        }

        final filteredExpenses = _applyFilters(expenses);

        return _buildWidget(context, filteredExpenses, expenses.length);
      },
    );
  }

  Widget _buildWidget(
      BuildContext context, List<Expense> expenses, int totalCount) {
    final sortedExpenses = List.of(expenses)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Column(
      children: [
        // Fixed header
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
              // Header with filter button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _isSelectionMode
                    ? _buildSelectionHeader(sortedExpenses)
                    : _buildNormalHeader(context, expenses.length, totalCount),
              ),

              // Search bar (hidden in selection mode)
              if (!_isSelectionMode)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by description...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _filters = _filters.copyWith(
                                clearSearchQuery: true);
                          });
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filters = _filters.copyWith(
                          searchQuery: value.isEmpty ? null : value,
                          clearSearchQuery: value.isEmpty,
                        );
                      });
                    },
                  ),
                ),

              // Category filter (hidden in selection mode)
              if (!_isSelectionMode)
                CategoryFilterWidget(
                  scrollController: _scrollController,
                  activeFilter: _filters.category,
                  onCategorySelected: (filter) {
                    setState(() {
                      _filters = _filters.copyWith(category: filter);
                    });

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
        // Expanded(
        //   child: sortedExpenses.isEmpty
        //       ? _buildEmptyState(context)
        //       : RefreshIndicator(
        //     onRefresh: () async {
        //       context.read<ExpenseBloc>().add(
        //         const SyncExpensesEvent(),
        //       );
        //       await Future.delayed(Duration(seconds: 1));
        //     },
        //     child: SingleChildScrollView(
        //       physics: AlwaysScrollableScrollPhysics(),
        //       padding: const EdgeInsets.all(16),
        //       child: HistorySection(
        //         expenses: sortedExpenses,
        //         onDelete: (id) {
        //           _showDeleteConfirmation(context, id);
        //         },
        //         onEdit: (expense) {
        //           context.push('/edit-expense', extra: expense);
        //         },
        //       ),
        //     ),
        //   ),
        // ),
        Expanded(
          child: sortedExpenses.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
            onRefresh: () async {
              context.read<ExpenseBloc>().add(
                const SyncExpensesEvent(),
              );
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: HistorySection(
                expenses: sortedExpenses,
                selectionMode: _isSelectionMode,
                selectedIds: _selectedExpenseIds,
                onToggleSelect: (id) {
                  setState(() {
                    _isSelectionMode = true;
                    if (_selectedExpenseIds.contains(id)) {
                      _selectedExpenseIds.remove(id);
                    } else {
                      _selectedExpenseIds.add(id);
                    }

                    if (_selectedExpenseIds.isEmpty) {
                      _isSelectionMode = false;
                    }
                  });
                },
                onDelete: (id) => _showDeleteConfirmation(context, id),
                onEdit: (expense) {
                  context.push('/edit-expense', extra: expense);
                },
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildNormalHeader(BuildContext context, int visibleCount, int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction History",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_filters.hasActiveFilters) ...[
                SizedBox(height: 4),
                Text(
                  '$visibleCount of $totalCount transactions',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
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
                onPressed: _toggleSelectionMode,
                icon: Icon(Icons.checklist),
                tooltip: 'Select items',
              ),
            if (_filters.hasActiveFilters)
              IconButton(
                onPressed: _clearAllFilters,
                icon: Icon(Icons.clear_all),
                tooltip: 'Clear filters',
              ),
            Stack(
              children: [
                IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: Icon(Icons.tune),
                  tooltip: 'Filters',
                ),
                if (_filters.hasActiveFilters)
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
                          '${_filters.activeFilterCount}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary,
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

  Widget _buildSelectionHeader(List<Expense> expenses) {
    final allSelected = expenses.isNotEmpty &&
        _selectedExpenseIds.length == expenses.length;

    return Row(
      children: [
        IconButton(
          onPressed: _toggleSelectionMode,
          icon: Icon(Icons.close),
          tooltip: 'Cancel selection',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${_selectedExpenseIds.length} selected',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => allSelected
              ? setState(() => _selectedExpenseIds.clear())
              : _selectAll(expenses),
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          label: Text(allSelected ? 'Deselect All' : 'Select All'),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _selectedExpenseIds.isEmpty ? null : _deleteSelected,
          icon: Icon(Icons.delete),
          color: Colors.red,
          tooltip: 'Delete selected',
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
            _filters.hasActiveFilters
                ? Icons.search_off
                : Icons.receipt_long_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            _filters.hasActiveFilters
                ? "No matching transactions"
                : (_filters.category == "All"
                ? "No transactions yet"
                : "No ${_filters.category} transactions"),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _filters.hasActiveFilters
                ? "Try adjusting your filters"
                : "Start tracking your expenses",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
          if (_filters.hasActiveFilters) ...[
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _clearAllFilters,
              icon: Icon(Icons.clear_all),
              label: Text('Clear all filters'),
            ),
          ],
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
            onPressed: () {
              Navigator.pop(dialogContext);
              if (_filters.category == "All") {
                context.read<ExpenseBloc>().add(LoadExpensesEvent());
              } else {
                context
                    .read<ExpenseBloc>()
                    .add(LoadExpensesEvent(category: _filters.category));
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



// ==================== FILTER BOTTOM SHEET ====================
class _FilterBottomSheet extends StatefulWidget {
  final ExpenseFilters currentFilters;
  final ValueChanged<ExpenseFilters> onApplyFilters;

  const _FilterBottomSheet({
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _minAmountController = TextEditingController(
      text: widget.currentFilters.minAmount?.toString() ?? '',
    );
    _maxAmountController = TextEditingController(
      text: widget.currentFilters.maxAmount?.toString() ?? '',
    );
    _startDate = widget.currentFilters.startDate;
    _endDate = widget.currentFilters.endDate;
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Amount Range
            Text(
              'Amount Range',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min',
                      prefixText: '₦',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Max',
                      prefixText: '₦',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Date Range
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DateButton(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    onClear: _startDate != null
                        ? () => setState(() => _startDate = null)
                        : null,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _DateButton(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    onClear:
                    _endDate != null ? () => setState(() => _endDate = null) : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _minAmountController.clear();
                        _maxAmountController.clear();
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: Text('Reset'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final minAmount = double.tryParse(_minAmountController.text);
                      final maxAmount = double.tryParse(_maxAmountController.text);

                      widget.onApplyFilters(
                        widget.currentFilters.copyWith(
                          minAmount: minAmount,
                          maxAmount: maxAmount,
                          startDate: _startDate,
                          endDate: _endDate,
                          clearMinAmount: _minAmountController.text.isEmpty,
                          clearMaxAmount: _maxAmountController.text.isEmpty,
                          clearStartDate: _startDate == null,
                          clearEndDate: _endDate == null,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date != null
                        ? DateFormat('dd MMM yyyy').format(date!)
                        : 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (onClear != null)
              IconButton(
                icon: Icon(Icons.clear, size: 20),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              )
            else
              Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }
}