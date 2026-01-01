import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDateField extends StatelessWidget {
  final TextEditingController controller;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ExpenseDateField({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            },
          ),
        ),
      ],
    );
  }
}
