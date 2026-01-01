import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/expenses_categories.dart';
import '../../../../core/utils/format_date.dart';
import '../../domain/entities/expense.dart';
import '../misc/formatter.dart';

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
      return _buildEmptyState(context);
    }

    final visibleItems = showAll ? widget.transactions : widget.transactions
        .take(5).toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .colorScheme
                .surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme
                  .of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.1),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: visibleItems.length,
            separatorBuilder: (context, index) =>
                Divider(
                  height: 1,
                  indent: 72,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1),
                ),
            itemBuilder: (context, index) {
              return _buildTransactionItem(context, visibleItems[index]);
            },
          ),
        ),
        if (widget.transactions.length > 5) _buildShowMoreButton(),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, Expense transaction) {
    final categoryData = ExpenseCategories.fromName(transaction.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(
            "/expense-detail-page", extra: transaction
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryData.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryData.icon,
                  color: categoryData.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description ?? "No description",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          " • ",
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                        Text(
                          formatDate(transaction.updatedAt),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "₦${formatter.format(transaction.amount)}",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.doc_text,
              size: 48,
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Transactions Yet",
            style: Theme
                .of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start tracking your expenses\nto see them here",
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton.icon(
        onPressed: () {
          setState(() => showAll = !showAll);
        },
        icon: Icon(
          showAll ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
          size: 18,
        ),
        label: Text(
          showAll
              ? "Show Less"
              : "Show All (${widget.transactions.length - 5} more)",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}