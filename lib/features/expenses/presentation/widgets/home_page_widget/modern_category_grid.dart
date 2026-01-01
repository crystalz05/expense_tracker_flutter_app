// lib/features/expenses/presentation/widgets/modern_category_grid.dart

import 'package:flutter/material.dart';

import '../../../../../core/utils/expenses_categories.dart';
import 'category_list_item.dart';

class ModernCategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Map<String, double> categoryTotals;

  const ModernCategoryGrid({
    super.key,
    required this.categories,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) {
        final categoryData = ExpenseCategories.fromName(category['title']);
        final amount = categoryTotals[category['title']] ?? 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CategoryListItem(
            categoryData: categoryData,
            title: category['title'],
            amount: amount,
          ),
        );
      }).toList(),
    );
  }
}