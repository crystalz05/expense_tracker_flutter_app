
import 'package:expenses_tracker_app/core/navigation/app_router.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BudgetPage extends StatelessWidget {

  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Budget'),

          //add a return to previous page button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {context.go("/main-page");},
          )
      ),

      body: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(16),
            child:
            Column(
              children: [
                BalanceCardWidget(totalSpent: 200000.00),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Budges", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ElevatedButton(onPressed: (){},
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                            SizedBox(width: 8,),
                            Text("Add Budget", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                          ],
                        )
                    )
                  ],
                ),
                SizedBox(height: 16,),
                BudgetCardWidget(
                  totalSpent: 20000.00,
                  onTap: (){router.go("/budget-detail-page");
                    },
                ),
                SizedBox(height: 16,),
                BudgetCardWidget(
                  totalSpent: 20000.00,
                  onTap: (){router.go("/budget-detail-page");
                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}