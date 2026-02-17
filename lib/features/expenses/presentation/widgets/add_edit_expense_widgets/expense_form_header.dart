import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseFormHeader extends StatelessWidget {
  final String subtitle;

  const ExpenseFormHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}
