// lib/features/expenses/presentation/widgets/modern_transaction_list_widget.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';
import 'transaction_list_item.dart';
import 'transaction_empty_state.dart';

class ModernTransactionList extends StatefulWidget {
  final List<Expense> transactions;

  const ModernTransactionList({super.key, required this.transactions});

  @override
  State<ModernTransactionList> createState() => _ModernTransactionListState();
}

class _ModernTransactionListState extends State<ModernTransactionList> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
      return const TransactionEmptyState();
    }

    final visibleItems = showAll
        ? widget.transactions
        : widget.transactions.take(5).toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: visibleItems.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 72,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              return TransactionListItem(transaction: visibleItems[index]);
            },
          ),
        ),
        if (widget.transactions.length > 5) _buildShowMoreButton(),
      ],
    );
  }

  Widget _buildShowMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton.icon(
        onPressed: () => setState(() => showAll = !showAll),
        icon: Icon(
          showAll ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
          size: 18,
        ),
        label: Text(
          showAll
              ? "Show Less"
              : "Show All (${widget.transactions.length - 5} more)",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
