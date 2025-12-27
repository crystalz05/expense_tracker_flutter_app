import 'package:flutter/material.dart';

import '../../../../core/utils/expenses_categories.dart';

class AddBudgetCategoryGridWidget extends StatefulWidget {
  final ValueChanged<ExpenseCategory> onCategorySelected;

  const AddBudgetCategoryGridWidget({super.key, required this.onCategorySelected});

  @override
  State<AddBudgetCategoryGridWidget> createState() => _AddBudgetCategoryGridWidgetState();
}

class _AddBudgetCategoryGridWidgetState extends State<AddBudgetCategoryGridWidget> {
  ExpenseCategory? selectedCategory = ExpenseCategories.food;

  @override
  Widget build(BuildContext context) {
    final categories = ExpenseCategories.all;
    final totalItems = categories.length;
    final rows = 3;
    final columns = (totalItems / rows).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategory == category;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category;
            });
            widget.onCategorySelected(category);
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: isSelected ? 2 : 1, // thicker if selected
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, color: category.color, size: 32),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
