
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatelessWidget {
  final IconData icon;
  final String description;
  final DateTime date;
  final String amount;

  const TransactionWidget({
    super.key,
    required this.icon,
    required this.description,
    required this.date,
    required this.amount
  });

  String get formattedTime {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
                      Text("${DateFormat('MMM').format(date)} ${date.day} ,${date.year} - $formattedTime", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ],
              ),
              Text(amount, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          )
        ],
      );
  }
}