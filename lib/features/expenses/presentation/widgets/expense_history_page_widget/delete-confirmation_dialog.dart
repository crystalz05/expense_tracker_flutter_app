// lib/features/expenses/presentation/widgets/expense_history/delete_confirmation_dialog.dart

import 'package:flutter/material.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required int count,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Delete $count Transaction${count > 1 ? 's' : ''}'),
      content: Text(
        'Are you sure you want to delete $count transaction${count > 1 ? 's' : ''}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onConfirm();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$count transaction${count > 1 ? 's' : ''} deleted',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

void showSingleDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Delete Transaction'),
      content: Text('Are you sure you want to delete this transaction?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onCancel();
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onConfirm();
          },
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Delete'),
        ),
      ],
    ),
  );
}
