import 'package:flutter/material.dart';

class MonthlyBudgetDialog extends StatefulWidget {
  final double initialBudget;
  final int month;
  final int year;

  const MonthlyBudgetDialog({
    super.key,
    required this.initialBudget,
    required this.month,
    required this.year,
  });

  @override
  State<MonthlyBudgetDialog> createState() => _MonthlyBudgetDialogState();
}

class _MonthlyBudgetDialogState extends State<MonthlyBudgetDialog> {
  late TextEditingController _controller;

  String get _monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[widget.month - 1];
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialBudget > 0 ? widget.initialBudget.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.initialBudget > 0 ? 'Edit' : 'Set'} Monthly Budget"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_monthName ${widget.year}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Budget Amount",
              prefixText: "₦",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final enteredValue = double.tryParse(_controller.text);
            if (enteredValue != null && enteredValue > 0) {
              Navigator.of(context).pop(enteredValue);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a valid amount greater than 0")),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}