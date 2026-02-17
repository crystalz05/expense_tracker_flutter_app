import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;

  const ExpenseDescriptionField({
    super.key,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.doc_text_fill,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "Description",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: maxLines,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: maxLines > 1
                ? "Add a description (optional)"
                : "What did you spend on?",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }
}
