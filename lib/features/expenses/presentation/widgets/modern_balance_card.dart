import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cubit/budget_cubit.dart';
import '../misc/formatter.dart';

class ModernBalanceCard extends StatelessWidget {
  final double totalSpent;

  const ModernBalanceCard({super.key, required this.totalSpent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCubit, BudgetStateSecondary>(
      builder: (context, state) {
        final double fraction = (totalSpent / state.monthlyBudget).clamp(
          0.0,
          1.0,
        );
        final String percentage = (fraction * 100).toStringAsFixed(1);
        final double remaining = state.monthlyBudget - totalSpent;
        final bool isOverBudget = totalSpent > state.monthlyBudget;
        final bool isWarning = fraction > 0.8 && !isOverBudget;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A2E5D), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: BoxBorder.all(
              color: isOverBudget
                  ? Colors.red.shade600.withValues(alpha: 0.5)
                  : isWarning
                  ? Colors.orange.shade400.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$percentage%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Monthly Budget",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₦${formatter.format(state.monthlyBudget)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    color: isOverBudget
                        ? Colors.red.shade600
                        : isWarning
                        ? Colors.orange.shade400
                        : Colors.white,
                    // valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem("Spent", "₦${formatter.format(totalSpent)}"),
                    _buildStatItem(
                      isOverBudget ? "Over Budget" : "Remaining",
                      "₦${formatter.format(remaining.abs())}",
                      isHighlight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: isHighlight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isHighlight ? 18 : 16,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
