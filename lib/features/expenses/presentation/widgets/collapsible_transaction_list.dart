
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleTransactionList extends StatefulWidget {

  final List<Map<String, dynamic>> transactions;

  const CollapsibleTransactionList({super.key, required this.transactions});

  @override
  State<CollapsibleTransactionList> createState() => _CollapsibleTransactionListState();
}

class _CollapsibleTransactionListState extends State<CollapsibleTransactionList>{
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final visibleItems = showAll ? widget.transactions : widget.transactions.take(5).toList();

    return Column(
      children: [
        Card(
          color: Colors.white,
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
                          icon: transac['icon'],
                          description: transac['title'],
                          date: transac['date'],
                          amount: transac['amount']
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