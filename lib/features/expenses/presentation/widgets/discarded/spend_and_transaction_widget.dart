
import 'package:flutter/material.dart';

class SpendAndTransactionWidget extends StatelessWidget {

  final String title;
  final String subTitle;
  final IconData icon;

  const SpendAndTransactionWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5)
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18,),
                  SizedBox(width: 8),
                  Text(title)
                ],
              ),
              SizedBox(height: 32),
              Text(subTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }


}