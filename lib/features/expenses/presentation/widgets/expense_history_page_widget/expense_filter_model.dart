// lib/features/expenses/presentation/widgets/expense_history/expense_filters_model.dart

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
