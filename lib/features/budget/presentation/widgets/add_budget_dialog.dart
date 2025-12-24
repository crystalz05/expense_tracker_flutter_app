import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBudgetDialog extends StatefulWidget {
  final VoidCallback onBudgetAdded;

  const AddBudgetDialog({super.key, required this.onBudgetAdded});

  @override
  State<StatefulWidget> createState() => _AddBudgetDialog();
}

class _AddBudgetDialog extends State<AddBudgetDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Add Monthly Budget'),
      content: Column(
        children: [
          const SizedBox(height: 10),
          CupertinoTextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            placeholder: 'Enter budget amount',
            prefix: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('₦'),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            final enteredValue = double.tryParse(_controller.text);
            if (enteredValue != null) {
              Navigator.of(context).pop(enteredValue);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a valid number")),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}