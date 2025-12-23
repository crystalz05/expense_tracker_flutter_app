
import 'package:expenses_tracker_app/features/budget/presentation/widgets/budget_card_expanded_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/delete_budget_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BudgetDetailPage extends StatelessWidget {
  const BudgetDetailPage({super.key});

  @override
  Widget build(BuildContext context) {

    final IconData icon = Icons.no_meals_outlined;
    final Color color = Colors.green;

    final String category = "Food & Dining";
    final String description = "Food";


    return Scaffold(
      appBar: AppBar(
          title: const Text("Budget Details"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {context.go("/budget-page");},
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: color,
                            borderRadius: BorderRadius.circular(16)),
                        child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary,),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text(description, style: Theme.of(context).textTheme.bodyMedium,),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_) => DeleteBudgetDialog(onConfirm: () {}));
                      },
                      icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error,))
                ],
              ),
              SizedBox(height: 24),
              BudgetCardExpandedWidget(totalSpent: 20000.00),
              SizedBox(height: 24),
              Text("Recent Transactions", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

}