import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'e.g., Monthly Groceries',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.description_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
    );
  }
}
