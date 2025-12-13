
import 'package:expenses_tracker_app/features/expenses/presentation/mock_data/mock_data.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryFilterWidget extends StatefulWidget {
  const CategoryFilterWidget({super.key});

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

class HistorySection extends StatelessWidget{
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {

    final groupTransactions = groupByDay(recentTransactions);
    final sorted = groupTransactions.keys.toList()
      ..sort((a,b) => b.compareTo(a));

    return Column(
        children: sorted.map((day){
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
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5
                  ),
                ),
                child: Column(
                  children:
                    List.generate(dayTransactions.length, (index){
                      final tx = dayTransactions[index];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: TransactionWidget(
                              icon: tx['icon'],
                              description: tx['title'],
                              date: tx['date'],
                              amount: tx['amount'],
                            ),
                          ),
                          if(index != dayTransactions.length-1)
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                            )
                        ],
                      );

                    }),
                )
              )
            ],
          );
        }).toList()
    );
  }
}

