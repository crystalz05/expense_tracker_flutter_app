import 'package:flutter/material.dart';

class BudgetDialog extends StatefulWidget {
  final double initialBudget;

  const BudgetDialog({super.key, required this.initialBudget});

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialBudget.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Monthly Budget"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Budget Amount",
          prefixText: "₦",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // cancel
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final enteredValue = double.tryParse(_controller.text);
            if (enteredValue != null) {
              Navigator.of(context).pop(enteredValue); // return the new budget
            } else {
              // optional: show a small error
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a valid number")),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
