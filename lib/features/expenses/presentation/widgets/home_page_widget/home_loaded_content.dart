// lib/features/expenses/presentation/widgets/home_loaded_content.dart

import 'package:flutter/material.dart';

import '../../bloc/expense_state.dart';
import '../modern_balance_card.dart';
import '../modern_quick_stats.dart';
import '../modern_transaction_list_widget.dart';
import 'modern_category_grid.dart';
import 'home_section_header.dart';

class HomeLoadedContent extends StatelessWidget {
  final ExpensesLoaded state;

  const HomeLoadedContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final sortedExpenses = List.of(state.expenses)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final topCategories = [
      {'title': 'Bills & Utilities'},
      {'title': 'Shopping'},
      {'title': 'Food & Dining'},
      {'title': 'Transport'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Balance Card
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: ModernBalanceCard(totalSpent: state.totalSpent),
          ),

          // Quick Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: ModernQuickStats(
              totalSpent: state.totalSpent,
              transactionCount: state.expenses.length,
            ),
          ),

          // Categories Section
          HomeSectionHeader(
            title: "Spending by Category",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ModernCategoryGrid(
                categories: topCategories,
                categoryTotals: state.categoryTotals,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Transactions Section
          HomeSectionHeader(
            title: "Recent Activity",
            child: ModernTransactionList(transactions: sortedExpenses),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}