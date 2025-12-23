
import 'package:flutter/cupertino.dart';

class DeleteBudgetDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteBudgetDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Delete Budget'),
      content: const Text('Are you sure you want to delete this budget? This action cannot be undone.'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}