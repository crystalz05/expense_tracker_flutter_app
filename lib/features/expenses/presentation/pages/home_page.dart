
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/collapsible_transaction_list.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/spend_and_transaction_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/top_categories_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> topCategories = [
      {'title': 'Bills & Utilities', 'subTitle': '₦50,000', 'icon': Icons.fastfood},
      {'title': 'Shopping', 'subTitle': '₦20,000', 'icon': Icons.directions_bus},
      {'title': 'Food & Dining', 'subTitle': '₦30,000', 'icon': Icons.shopping_bag},
      {'title': 'Transport', 'subTitle': '₦10,000', 'icon': Icons.movie},
    ];

    final List<Map<String, dynamic>> recentTransactions = [
      {'title': 'Electricity Bill', 'date': DateTime(2025, 2, 4), 'amount': '₦32,400', 'icon': Icons.lightbulb},
      {'title': 'Grocery Shopping', 'date': DateTime(2025, 2, 6), 'amount': '₦18,750', 'icon': Icons.fastfood},
      {'title': 'Movie Night', 'date': DateTime(2025, 2, 5), 'amount': '₦7,200', 'icon': Icons.movie},
      {'title': 'Transport Fare', 'date': DateTime(2025, 2, 3), 'amount': '₦3,800', 'icon': Icons.directions_bus},
      {'title': 'Online Shopping', 'date': DateTime(2025, 2, 2), 'amount': '₦45,999', 'icon': Icons.shopping_bag},
      {'title': 'Restaurant', 'date': DateTime(2025, 2, 1), 'amount': '₦12,300', 'icon': Icons.restaurant},
      {'title': 'Airtime Purchase', 'date': DateTime(2025, 2, 7), 'amount': '₦5,000', 'icon': Icons.phone_android},
      {'title': 'Gym Membership', 'date': DateTime(2025, 2, 4), 'amount': '₦20,000', 'icon': Icons.fitness_center},
      {'title': 'Pharmacy', 'date': DateTime(2025, 2, 2), 'amount': '₦9,450', 'icon': Icons.local_pharmacy},
      {'title': 'Snacks', 'date': DateTime(2025, 2, 6), 'amount': '₦2,150', 'icon': Icons.fastfood},
      {'title': 'Online Subscription', 'date': DateTime(2025, 2, 5), 'amount': '₦3,200', 'icon': Icons.subscriptions},
    ];


    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                Text("SpendWise", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                BalanceCardWidget(),
                SizedBox(height: 8),
                Row(
                  children: [
                    SpendAndTransactionWidget(title: "Total Spent", subTitle: "₦200,000.00", icon: Icons.trending_down),
                    SizedBox(width: 8),
                    SpendAndTransactionWidget(title: "Transactions", subTitle: "8", icon: Icons.trending_up)
                  ],
                ),
                SizedBox(height: 16),
                Text("Top Categories", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisExtent: 120,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8
                    ),
                    itemCount: topCategories.length,
                    itemBuilder: (context, index){
                      final category = topCategories[index];
                      return TopCategoriesWidget(
                          title: category["title"],
                          subTitle: category["subTitle"],
                          icon: category["icon"]
                      );
                    }
                ),
                SizedBox(height: 16),
                Text("Recent Transactions", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                CollapsibleTransactionList(transactions: recentTransactions)
              ],
            )
        )
    );
  }
}