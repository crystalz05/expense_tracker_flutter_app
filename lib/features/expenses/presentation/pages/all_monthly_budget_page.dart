import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../monthly_budget/domain/entities/monthly_budget.dart';
import '../../../monthly_budget/presentation/bloc/monthly_budget_bloc.dart';
import '../../../monthly_budget/presentation/bloc/monthly_budget_event.dart';
import '../../../monthly_budget/presentation/bloc/monthly_budget_state.dart';
import '../misc/formatter.dart';
import '../widgets/monthly_budget_dialog.dart';
import '../../../../injection_container.dart' as di;

class AllMonthlyBudgetsPage extends StatelessWidget {
  const AllMonthlyBudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<MonthlyBudgetBloc>()
        ..add(const LoadMonthlyBudgetsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monthly Budgets'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddBudgetDialog(context),
            ),
          ],
        ),
        body: BlocConsumer<MonthlyBudgetBloc, MonthlyBudgetState>(
          listener: (context, state) {
            if (state is MonthlyBudgetOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is MonthlyBudgetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MonthlyBudgetLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MonthlyBudgetsLoaded) {
              if (state.budgets.isEmpty) {
                return _buildEmptyState(context);
              }

              // Group budgets by year
              final budgetsByYear = <int, List<MonthlyBudget>>{};
              for (final budget in state.budgets) {
                budgetsByYear.putIfAbsent(budget.year, () => []).add(budget);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: budgetsByYear.length,
                itemBuilder: (context, index) {
                  final year = budgetsByYear.keys.elementAt(index);
                  final budgets = budgetsByYear[year]!;

                  return _buildYearSection(context, year, budgets);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Budgets Set',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by setting a budget for this month',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showAddBudgetDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Budget'),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSection(
      BuildContext context,
      int year,
      List<MonthlyBudget> budgets,
      ) {
    // Sort by month (descending)
    budgets.sort((a, b) => b.month.compareTo(a.month));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            year.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...budgets.map((budget) => _buildBudgetCard(context, budget)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBudgetCard(BuildContext context, MonthlyBudget budget) {
    final isCurrentMonth = budget.month == DateTime.now().month &&
        budget.year == DateTime.now().year;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrentMonth
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: isCurrentMonth ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isCurrentMonth
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.calendar_month,
            color: isCurrentMonth
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Row(
          children: [
            Text(
              budget.monthName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isCurrentMonth) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Current',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          '₦${formatter.format(budget.amount)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 12),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20),
                  SizedBox(width: 12),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditBudgetDialog(context, budget);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, budget);
            }
          },
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDialog<_BudgetDialogResult>(
      context: context,
      builder: (_) => _MonthYearBudgetDialog(
        initialMonth: now.month,
        initialYear: now.year,
      ),
    );

    if (result != null && context.mounted) {
      final newBudget = MonthlyBudget(
        id: const Uuid().v4(),
        userId: '',
        month: result.month,
        year: result.year,
        amount: result.amount,
        createdAt: DateTime.now(),
      );
      context.read<MonthlyBudgetBloc>().add(
        CreateMonthlyBudgetEvent(newBudget),
      );
    }
  }

  void _showEditBudgetDialog(BuildContext context, MonthlyBudget budget) async {
    final result = await showDialog<double>(
      context: context,
      builder: (_) => MonthlyBudgetDialog(
        initialBudget: budget.amount,
        month: budget.month,
        year: budget.year,
      ),
    );

    if (result != null && context.mounted) {
      final updatedBudget = MonthlyBudget(
        id: budget.id,
        userId: budget.userId,
        month: budget.month,
        year: budget.year,
        amount: result,
        createdAt: budget.createdAt,
        updatedAt: DateTime.now(),
      );
      context.read<MonthlyBudgetBloc>().add(
        UpdateMonthlyBudgetEvent(updatedBudget),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, MonthlyBudget budget) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Budget'),
        content: Text(
          'Are you sure you want to delete the budget for ${budget.month}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MonthlyBudgetBloc>().add(
                DeleteMonthlyBudgetEvent(budget.id),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _BudgetDialogResult {
  final int month;
  final int year;
  final double amount;

  _BudgetDialogResult({
    required this.month,
    required this.year,
    required this.amount,
  });
}

class _MonthYearBudgetDialog extends StatefulWidget {
  final int initialMonth;
  final int initialYear;

  const _MonthYearBudgetDialog({
    required this.initialMonth,
    required this.initialYear,
  });

  @override
  State<_MonthYearBudgetDialog> createState() => _MonthYearBudgetDialogState();
}

class _MonthYearBudgetDialogState extends State<_MonthYearBudgetDialog> {
  late int _selectedMonth;
  late int _selectedYear;
  late TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth;
    _selectedYear = widget.initialYear;
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - 2 + i);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Monthly Budget',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(12, (i) => i + 1)
                          .map((m) => DropdownMenuItem(
                        value: m,
                        child: Text(_months[m - 1]),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedMonth = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: years
                          .map((y) => DropdownMenuItem(
                        value: y,
                        child: Text(y.toString()),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedYear = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₦ ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          _BudgetDialogResult(
                            month: _selectedMonth,
                            year: _selectedYear,
                            amount: double.parse(_amountController.text),
                          ),
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}