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

  void _scrollToCategory(String categoryName) {
    final key = _categoryKeys[categoryName];
    if (key?.currentContext != null) {
      final context = key!.currentContext!;
      final renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final scrollOffset = _scrollController.offset + position.dx - 16;

      _scrollController.animateTo(
        scrollOffset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
      )
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                    fontWeight: currentActive ? FontWeight.w600 : FontWeight.w500,
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

// class HistorySection extends StatefulWidget {
//   final List<Expense> expenses;
//   final ValueChanged<String> onDelete;
//   final ValueChanged<Expense>? onEdit;
//
//   const HistorySection({
//     super.key,
//     required this.expenses,
//     required this.onDelete,
//     this.onEdit,
//   });
//
//   @override
//   State<HistorySection> createState() => _HistorySectionState();
// }
//
// class _HistorySectionState extends State<HistorySection> {
//   String? _selectedIndex;
//   Timer? _clearTimer;
//
//   @override
//   void dispose() {
//     _clearTimer?.cancel();
//     super.dispose();
//   }
//
//   void _handleSelection(String id) {
//     _clearTimer?.cancel();
//
//     setState(() {
//       _selectedIndex = id;
//     });
//
//     _clearTimer = Timer(const Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           _selectedIndex = null;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final groupTransactions = groupByDayFinal(widget.expenses);
//     final sorted = groupTransactions.keys.toList()
//       ..sort((a, b) => b.compareTo(a));
//
//     if (groupTransactions.isEmpty) {
//       return SizedBox.shrink();
//     }
//
//     return Column(
//       children: sorted.asMap().entries.map((entry) {
//         final day = entry.value;
//         final dayTransactions = groupTransactions[day]!;
//         final isToday = _isToday(day);
//         final isYesterday = _isYesterday(day);
//
//         String dayLabel;
//         if (isToday) {
//           dayLabel = 'Today';
//         } else if (isYesterday) {
//           dayLabel = 'Yesterday';
//         } else {
//           dayLabel = DateFormat('dd MMM yyyy').format(day);
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 4,
//                     height: 20,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     dayLabel,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Spacer(),
//                   Text(
//                     '${dayTransactions.length} ${dayTransactions.length == 1 ? 'transaction' : 'transactions'}',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Card(
//               color: Theme.of(context).colorScheme.surface,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 side: BorderSide(
//                   color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Column(
//                   children: List.generate(dayTransactions.length, (index) {
//                     final tx = dayTransactions[index];
//                     final isSelected = _selectedIndex == tx.id;
//
//                     return Dismissible(
//
//                       key: ValueKey(tx.id),
//                       direction: DismissDirection.horizontal,
//                       confirmDismiss: (direction) async {
//                         if (direction == DismissDirection.startToEnd) {
//                           // Swipe right → Edit
//                           widget.onEdit?.call(tx);
//                           return false; // don’t dismiss
//                         } else {
//                           // Swipe left → Delete
//                           widget.onDelete(tx.id);
//                           return true; // dismiss item
//                         }
//                       },
//                       background: _SwipeAction(
//                         color: Colors.blue,
//                         icon: Icons.edit_outlined,
//                         alignment: Alignment.centerLeft,
//                       ),
//                       secondaryBackground: _SwipeAction(
//                         color: Colors.red,
//                         icon: Icons.delete_outline,
//                         alignment: Alignment.centerRight,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         child: TransactionWidget(
//                           icon: _getCategoryIcon(tx.category),
//                           description: tx.description ?? "No description",
//                           category: tx.category,
//                           date: tx.updatedAt,
//                           amount: formatter.format(tx.amount),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   bool _isToday(DateTime date) {
//     final now = DateTime.now();
//     return date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day;
//   }
//
//   bool _isYesterday(DateTime date) {
//     final yesterday = DateTime.now().subtract(Duration(days: 1));
//     return date.year == yesterday.year &&
//         date.month == yesterday.month &&
//         date.day == yesterday.day;
//   }
//
//   IconData _getCategoryIcon(String category) {
//     final categoryMap = {
//       'Food': Icons.restaurant_outlined,
//       'Transport': Icons.directions_car_outlined,
//       'Shopping': Icons.shopping_bag_outlined,
//       'Entertainment': Icons.movie_outlined,
//       'Health': Icons.local_hospital_outlined,
//       'Bills': Icons.receipt_outlined,
//       'Education': Icons.school_outlined,
//       'Other': Icons.more_horiz,
//     };
//     return categoryMap[category] ?? Icons.payment_outlined;
//   }
// }

class HistorySection extends StatelessWidget {
  final List<Expense> expenses;

  final bool selectionMode;
  final Set<String> selectedIds;

  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onDelete;
  final ValueChanged<Expense> onEdit;

  const HistorySection({
    super.key,
    required this.expenses,
    required this.selectionMode,
    required this.selectedIds,
    required this.onToggleSelect,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = groupByDayFinal(expenses);
    final sortedDays = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    if (grouped.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: sortedDays.map((day) {
        final dayTransactions = grouped[day]!;

        final isToday = _isToday(day);
        final isYesterday = _isYesterday(day);

        final dayLabel = isToday
            ? 'Today'
            : isYesterday
            ? 'Yesterday'
            : DateFormat('dd MMM yyyy').format(day);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== DAY HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dayLabel,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '${dayTransactions.length} ${dayTransactions.length == 1 ? 'transaction' : 'transactions'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // ===== TRANSACTION CARD =====
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withOpacity(0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: dayTransactions.map((tx) {
                    final isSelected = selectedIds.contains(tx.id);

                    return GestureDetector(
                      onLongPress: () => onToggleSelect(tx.id),
                      onTap: () {
                        if (selectionMode) {
                          onToggleSelect(tx.id);
                        }
                      },
                      child: Dismissible(
                        key: ValueKey(tx.id),
                        direction: selectionMode
                            ? DismissDirection.none
                            : DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            onEdit(tx);
                            return false;
                          } else {
                            onDelete(tx.id);
                            return true;
                          }
                        },
                        background: _SwipeAction(
                          color: Colors.blue,
                          icon: Icons.edit_outlined,
                          alignment: Alignment.centerLeft,
                        ),
                        secondaryBackground: _SwipeAction(
                          color: Colors.red,
                          icon: Icons.delete_outline,
                          alignment: Alignment.centerRight,
                        ),
                        child: InkWell(
                          // 👇 THIS is the fix
                          onLongPress: () => onToggleSelect(tx.id),
                          onTap: selectionMode
                              ? () => onToggleSelect(tx.id)
                              : null,

                          child: Container(
                            color: isSelected
                                ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12)
                                : null,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: TransactionWidget(
                              icon: _getCategoryIcon(tx.category),
                              description: tx.description ?? 'No description',
                              category: tx.category,
                              date: tx.updatedAt,
                              amount: formatter.format(tx.amount),
                            ),
                          ),
                        ),
                      )
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  // ===== HELPERS =====

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  IconData _getCategoryIcon(String category) {
    const map = {
      'Food': Icons.restaurant_outlined,
      'Transport': Icons.directions_car_outlined,
      'Shopping': Icons.shopping_bag_outlined,
      'Entertainment': Icons.movie_outlined,
      'Health': Icons.local_hospital_outlined,
      'Bills': Icons.receipt_outlined,
      'Education': Icons.school_outlined,
      'Other': Icons.more_horiz,
    };
    return map[category] ?? Icons.payment_outlined;
  }
}


class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to group expenses by day
Map<DateTime, List<Expense>> groupByDayFinal(List<Expense> expenses) {
  final Map<DateTime, List<Expense>> grouped = {};

  for (final expense in expenses) {
    final date = DateTime(
      expense.updatedAt.year,
      expense.updatedAt.month,
      expense.updatedAt.day,
    );

    grouped.putIfAbsent(date, () => []).add(expense);
  }

  return grouped;
}

class _SwipeAction extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Alignment alignment;

  const _SwipeAction({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.15),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
