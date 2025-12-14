
import 'dart:async';

import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/mock_data/mock_data.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryFilterWidget extends StatefulWidget {

  final ValueChanged<String> onCategorySelected;

  const CategoryFilterWidget({super.key, required this.onCategorySelected});

  @override
  State<StatefulWidget> createState() => _CategoryFilterWidget();

}

class _CategoryFilterWidget extends State<CategoryFilterWidget>{

  String activeFilter = "All";
  final List<String> filterCategory = ["All", "Food & Dining", "Transport", "Shopping", "Entertainment", "Bills & Utilities", "Health", "Other"];

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: List.generate(filterCategory.length, (index){
            return GestureDetector(
              onTap: () {
                setState(() {
                  activeFilter = filterCategory[index];
                  if(activeFilter == filterCategory[index]){
                    widget.onCategorySelected(filterCategory[index]);
                  }
                });
              },
              child: CategoryCard(title: filterCategory[index], currentActive: filterCategory[index] == activeFilter),
            );
          })
        ),
      );
  }
}

class CategoryCard extends StatelessWidget{

  final String title;
  final bool currentActive;
  const CategoryCard({super.key, required this.title, required this.currentActive});

  @override
  Widget build(BuildContext context) {
    return
      Card(
        color: currentActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
              side: BorderSide(color: currentActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary)),
          child:
          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(title, style: TextStyle(color: currentActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary)) ,
          )
      );
  }
}

class HistorySection extends StatefulWidget {
  final List<Expense> expenses;
  final ValueChanged<String> onDelete;
  const HistorySection({super.key, required this.expenses, required this.onDelete});

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  String? _selectedIndex;
  Timer? _clearTimer;


  @override
  Widget build(BuildContext context) {
    final groupTransactions = groupByDayFinal(widget.expenses);
    final sorted = groupTransactions.keys.toList()..sort((a,b) => b.compareTo(a));


    if(groupTransactions.isEmpty){
      return Column(
        children: [
          SizedBox(height: 24,),
          Center(child: Text("No transaction yet"),),
          SizedBox(height: 24,)
        ],
      );
    }

    return Column(
      children: sorted.map((day) {
        final dayTransactions = groupTransactions[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                DateFormat('dd MMM yyyy').format(day),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: List.generate(dayTransactions.length, (index) {
                  final tx = dayTransactions[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPress: () {
                      _clearTimer?.cancel();

                      setState(() {
                        _selectedIndex = tx.id;
                      });

                      _clearTimer = Timer(const Duration(seconds: 5), () {
                        if (mounted) {
                          setState(() {
                            _selectedIndex = null;
                          });
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          child: TransactionWidget(
                            icon: Icons.fastfood_outlined,
                            description: tx.description ?? "",
                            date: tx.updatedAt,
                            amount: formatter.format(tx.amount),
                          ),
                        ),
                        // Overlay edit/delete if this item is selected
                        if (_selectedIndex == tx.id)
                          Positioned.fill(
                            child: Container(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      // Handle edit
                                    },
                                  ),
                                  SizedBox(width: 48,),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      widget.onDelete(tx.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if(index != dayTransactions.length-1)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

