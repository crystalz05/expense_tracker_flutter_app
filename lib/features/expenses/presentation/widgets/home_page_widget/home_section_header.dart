// lib/features/expenses/presentation/widgets/home_section_header.dart

import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final Widget child;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}