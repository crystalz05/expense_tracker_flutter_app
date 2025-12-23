import 'package:flutter/cupertino.dart';

class SignOutDialogWidget extends StatelessWidget {
  final VoidCallback onConfirm;

  const SignOutDialogWidget({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
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
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}