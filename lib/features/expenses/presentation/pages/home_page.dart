
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/mock_data/mock_data.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/collapsible_transaction_list.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/spend_and_transaction_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/top_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child:
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state){
                if(state is ExpenseLoading){
                  return const Center(child: CircularProgressIndicator());
                }else if(state is ExpenseError){
                  return Center(child: Text('Error: ${state.message}'));
                }else if(state is ExpensesLoaded){

                  return
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome Back", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                        Text("SpendWise", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        BalanceCardWidget(totalSpent: state.totalSpent),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SpendAndTransactionWidget(title: "Total Spent", subTitle: "₦${formatter.format(state.totalSpent)}", icon: Icons.trending_down),
                            SizedBox(width: 8),
                            SpendAndTransactionWidget(title: "Transactions", subTitle: "${state.expenses.length}", icon: Icons.trending_up)
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
                                  category: state.categoryTotals,
                                  title: category["title"],
                                  subTitle: category["subTitle"],
                                  icon: category["icon"]
                              );
                            }
                        ),
                        SizedBox(height: 16),
                        Text("Recent Transactions", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        CollapsibleTransactionList(transactions: state.expenses)
                      ],
                    );
                }
                return Container();
              },
            )
        )
    );
  }
}