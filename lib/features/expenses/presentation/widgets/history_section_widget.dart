import 'package:expenses_tracker_app/features/expenses/presentation/widgets/transaction_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';
import '../misc/formatter.dart';
import '../mock_data/mock_data.dart';
import 'category_filter_widget.dart';

class HistorySection extends StatelessWidget {
  final List<Expense> expenses;

  final bool selectionMode;
  final ValueChanged<bool> toggleSelectionMode;
  final Set<String> selectedIds;

  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onDelete;
  final ValueChanged<Expense> onEdit;

  const HistorySection({
    super.key,
    required this.expenses,
    required this.selectionMode,
    required this.toggleSelectionMode,
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
                        onLongPress: () {
                          if(!selectionMode){
                            toggleSelectionMode(true);
                          }
                              onToggleSelect(tx.id);
                        },
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
                              return false;
                            }
                          },
                          background: SwipeAction(
                            color: Colors.blue,
                            icon: Icons.edit_outlined,
                            alignment: Alignment.centerLeft,
                          ),
                          secondaryBackground: SwipeAction(
                            color: Colors.red,
                            icon: Icons.delete_outline,
                            alignment: Alignment.centerRight,
                          ),
                          child: InkWell(
                            // 👇 THIS is the fix
                            onLongPress: () {
                              if(!selectionMode){
                                toggleSelectionMode(true);
                              }
                              onToggleSelect(tx.id);
                            },
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


Map<DateTime, List<Expense>> groupByDayFinal(
    List<Expense> recentTransactions
    ) {

  final Map<DateTime, List<Expense>> grouped = {};

  for(final tx in recentTransactions) {
    final DateTime date = tx.updatedAt;

    final day = DateTime(date.year, date.month, date.day);

    grouped.putIfAbsent(day, ()=> []);
    grouped[day]!.add(tx);
  }
  return grouped;
}


class SwipeAction extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Alignment alignment;

  const SwipeAction({super.key,
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
