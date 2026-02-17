// lib/features/expenses/presentation/widgets/home_fab.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFab extends StatelessWidget {
  final VoidCallback onTap;

  const HomeFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          CupertinoIcons.plus_circle_fill,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }
}
