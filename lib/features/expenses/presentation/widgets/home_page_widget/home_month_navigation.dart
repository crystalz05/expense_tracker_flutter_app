// lib/features/expenses/presentation/widgets/home_month_navigator.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeMonthNavigator extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onMonthPickerTap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onTodayTap;

  const HomeMonthNavigator({
    super.key,
    required this.selectedMonth,
    required this.onMonthPickerTap,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth =
        selectedMonth.year == DateTime.now().year &&
        selectedMonth.month == DateTime.now().month;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: const Icon(CupertinoIcons.chevron_left),
            iconSize: 20,
          ),
          InkWell(
            onTap: onMonthPickerTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('MMM yyyy').format(selectedMonth),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    CupertinoIcons.calendar,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              if (!isCurrentMonth)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onTodayTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              IconButton(
                onPressed: isCurrentMonth ? null : onNextMonth,
                icon: Icon(
                  CupertinoIcons.chevron_right,
                  color: isCurrentMonth
                      ? Theme.of(context).colorScheme.outline.withOpacity(0.3)
                      : null,
                ),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
