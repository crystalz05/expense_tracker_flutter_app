import 'dart:async';

import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/expenses_categories.dart';

class CategoryFilterWidget extends StatefulWidget {
  final String activeFilter;
  final ValueChanged<String> onCategorySelected;
  final ScrollController? scrollController;

  const CategoryFilterWidget({
    super.key,
    required this.activeFilter,
    required this.onCategorySelected,
    this.scrollController,
  });

  @override
  State<CategoryFilterWidget> createState() => _CategoryFilterWidgetState();
}

class _CategoryFilterWidgetState extends State<CategoryFilterWidget> {
  late ScrollController _scrollController;
  final Map<String, GlobalKey> _categoryKeys = {};

  static const String allCategory = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    // Create keys for each category
    for (var category in ExpenseCategories.all) {
      _categoryKeys[category.name] = GlobalKey();
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        key: const PageStorageKey('category_filter_list'),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ExpenseCategories.all.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return CategoryCard(
              title: 'All',
              currentActive: widget.activeFilter == 'All',
              onTap: () => widget.onCategorySelected('All'),
            );
          }

          final category = ExpenseCategories.all[index - 1];

          return CategoryCard(
            key: ValueKey(category.name), // IMPORTANT
            title: category.name,
            currentActive: category.name == widget.activeFilter,
            onTap: () => widget.onCategorySelected(category.name),
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final bool currentActive;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.currentActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: currentActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: currentActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: currentActive ? 2 : 1,
              ),
              boxShadow: currentActive
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: currentActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: currentActive
                        ? FontWeight.w600
                        : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
