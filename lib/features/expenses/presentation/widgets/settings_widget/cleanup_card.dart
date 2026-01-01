import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../budget/presentation/bloc/budget_bloc.dart';
import '../../../../budget/presentation/bloc/budget_event.dart';
import '../../../../budget/presentation/bloc/budget_state.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_event.dart';
import '../../bloc/expense_state.dart';

class CleanupCard extends StatefulWidget {
  @override
  State<CleanupCard> createState() => _CleanupCardState();
}

class _CleanupCardState extends State<CleanupCard> {
  String? _lastCleanup;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCleanupInfo();
  }

  Future<void> _loadCleanupInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCleanup = prefs.getString('last_cleanup_date');

    if (mounted) {
      setState(() {
        _lastCleanup = lastCleanup;
        _isLoading = false;
      });
    }
  }

  Future<void> _performCleanup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cleanup'),
        content: const Text(
          'This will permanently delete all soft-deleted expenses and budgets. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<ExpenseBloc>().add(const PurgeSoftDeletedEvent());
      context.read<BudgetBloc>().add(const PurgeSoftDeletedBudgetsEvent());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_cleanup_date',
        DateTime.now().toIso8601String(),
      );

      _loadCleanupInfo();
    }
  }

  String _getCleanupMessage() {
    if (_lastCleanup == null) {
      return 'No cleanup performed yet';
    }

    final lastDate = DateTime.parse(_lastCleanup!);
    final daysSince = DateTime.now().difference(lastDate).inDays;

    if (daysSince == 0) {
      return 'Last cleanup: Today';
    } else if (daysSince == 1) {
      return 'Last cleanup: Yesterday';
    } else if (daysSince < 30) {
      return 'Last cleanup: $daysSince days ago';
    } else {
      return 'Last cleanup: ${(daysSince / 30).floor()} months ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseActionSuccess &&
                state.message.contains('permanently removed')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text('Cleanup completed')),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetOperationSuccess &&
                state.message.contains('purged')) {
              // Silent success for budget cleanup
            }
          },
        ),
      ],
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cleaning_services,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cleanup Deleted Items",
                          style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Permanently remove deleted data",
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!_isLoading) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getCleanupMessage(),
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _performCleanup,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Clean Up Now'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
