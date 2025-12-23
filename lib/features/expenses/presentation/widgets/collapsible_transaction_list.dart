
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleTransactionList extends StatefulWidget {

  final List<Expense> transactions;

  const CollapsibleTransactionList({super.key, required this.transactions});

  @override
  State<CollapsibleTransactionList> createState() => _CollapsibleTransactionListState();
}

class _CollapsibleTransactionListState extends State<CollapsibleTransactionList>{
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final visibleItems = showAll ? widget.transactions : widget.transactions.take(5).toList();

    if(widget.transactions.isEmpty){
      return Column(
        children: [
          SizedBox(height: 24,),
          Center(child: Text("No Transactions yet"),),
          SizedBox(height: 24,),
        ],
      );
    }
    return Column(
      children: [
        Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5)
          ),
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: visibleItems.length,
                  itemBuilder: (context, index) {
                    final transac = visibleItems[index];

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: TransactionWidget(
                          icon: Icons.no_food_rounded,
                          description: transac.description ?? "",
                          category: transac.category,
                          date: transac.updatedAt,
                          amount: formatter.format(transac.amount)
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
        if (widget.transactions.length > 5)
          TextButton(
            onPressed: () {
              setState(() => showAll = !showAll);
            },
            child: Text(
              showAll ? "Show Less" : "Show More",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ],
    );
  }
}