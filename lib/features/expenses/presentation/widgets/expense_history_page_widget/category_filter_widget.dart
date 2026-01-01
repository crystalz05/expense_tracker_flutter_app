// lib/features/expenses/presentation/widgets/expense_history/history_category_filter.dart

import 'package:flutter/material.dart';

import '../category_filter_widget.dart';

class HistoryCategoryFilter extends StatelessWidget {
  final ScrollController scrollController;
  final String activeFilter;
  final ValueChanged<String> onCategorySelected;

  const HistoryCategoryFilter({
    super.key,
    required this.scrollController,
    required this.activeFilter,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryFilterWidget(
      scrollController: scrollController,
      activeFilter: activeFilter,
      onCategorySelected: onCategorySelected,
    );
  }
}