import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/expenses_categories.dart';
import '../misc/formatter.dart';

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
          child: _buildCategoryItem(context, categoryData, category['title'], amount),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      dynamic categoryData,
      String title,
      double amount,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: categoryData.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              categoryData.icon,
              color: categoryData.color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₦${formatter.format(amount)}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}