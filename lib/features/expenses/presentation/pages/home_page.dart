
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/spend_and_transaction_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueGrey)),
                  Text("SpendWise", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  BalanceCardWidget(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SpendAndTransactionWidget(title: "Total Spent", subTitle: "₦200,000.00", icon: Icons.trending_down),
                      SizedBox(width: 8),
                      SpendAndTransactionWidget(title: "Transactions", subTitle: "8", icon: Icons.trending_up)
                    ],
                  )
                ],
              )
          )

      ),
    );
  }
}